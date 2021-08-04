import Foundation
#if canImport(FoundationNetworking)
  import FoundationNetworking
#endif

/// The API provider class to make the requests on.
open class ApiProvider<EndpointType: Endpoint> {
  /// The Result received, either the expected `Decodable` response object or a `JsonApiError` case.
  public typealias TypedResult<T: Decodable> = Result<T, ApiError<EndpointType.ClientErrorType>>

  /// The lower level Result structure received directly from the native `URLSession` data task calls.
  public typealias URLSessionResult = (data: Data?, response: URLResponse?, error: Error?)

  /// The plugins to apply per request.
  public let plugins: [Plugin<EndpointType>]

  /// The common base URL of the API endpoints.
  public let baseUrl: URL

  /// Specify `true` to turn on mocked repsonses for testing.
  public let mocked: Bool

  /// Initializes a new API provider with the given plugins applied to every request.
  public init(
    baseUrl: URL,
    plugins: [Plugin<EndpointType>] = [],
    mocked: Bool = false
  ) {
    self.baseUrl = baseUrl
    self.plugins = plugins
    self.mocked = mocked
  }

  /// Performs the asynchronous request for the chosen write-only endpoint and calls the completion closure with the result.
  /// Returns a `EmptyBodyResponse` on success.
  ///
  /// - WARNING: Do not use this if you expect a body response, use `performRequest(on:decodeBodyTo:complation:)` instead.
  public func performRequest(on endpoint: EndpointType, completion: @escaping (TypedResult<EmptyBodyResponse>) -> Void)
  {
    self.performRequest(on: endpoint, decodeBodyTo: EmptyBodyResponse.self, completion: completion)
  }

  /// Performs the request for the chosen write-only endpoint synchronously (waits for the result).
  /// Returns a `EmptyBodyResponse` on success.
  ///
  /// - WARNING: Do not use this if you expect a body response, use `performRequestAndWait(on:decodeBodyTo:)` instead.
  /// - NOTE: Calling this will block the current thread until the result is available. Use `performRequest` instead for an async call.
  public func performRequestAndWait(on endpoint: EndpointType) -> TypedResult<EmptyBodyResponse> {
    self.performRequestAndWait(on: endpoint, decodeBodyTo: EmptyBodyResponse.self)
  }

  /// Performs the asynchronous request for the chosen endpoint and calls the completion closure with the result.
  /// Specify the expected result type as the `Decodable` generic type.
  public func performRequest<ResultType: Decodable>(
    on endpoint: EndpointType,
    decodeBodyTo: ResultType.Type,
    completion: @escaping (TypedResult<ResultType>) -> Void
  ) {
    var request: URLRequest = endpoint.buildRequest(baseUrl: baseUrl)

    for plugin in plugins {
      plugin.modifyRequest(&request, endpoint: endpoint)
    }

    for plugin in plugins {
      plugin.willPerformRequest(request, endpoint: endpoint)
    }

    func handleDataTaskCompletion(data: Data?, response: URLResponse?, error: Error?) {
      let urlSessionResult: URLSessionResult = (data: data, response: response, error: error)
      let typedResult: TypedResult<ResultType> = self.decodeBody(from: urlSessionResult, endpoint: endpoint)

      for plugin in self.plugins {
        plugin.didPerformRequest(urlSessionResult: urlSessionResult, typedResult: typedResult, endpoint: endpoint)
      }

      completion(typedResult)
    }

    if mocked {
      let baseUrl = self.baseUrl

      guard let mockedResponse = endpoint.mockedResponse else {
        completion(.failure(.emptyMockedResponse))
        return
      }

      handleDataTaskCompletion(
        data: mockedResponse.bodyData,
        response: mockedResponse.httpUrlResponse(baseUrl: baseUrl),
        error: nil
      )
    }
    else {
      // this is the main logic, making the actual call
      URLSession.shared.dataTask(with: request, completionHandler: handleDataTaskCompletion).resume()
    }
  }

  /// Performs the request for the chosen endpoint synchronously (waits for the result) and returns the result.
  /// Specify the expected result type as the `Decodable` generic type.
  ///
  /// - NOTE: Calling this will block the current thread until the result is available. Use `performRequest` instead for an asyn call.
  public func performRequestAndWait<ResultType: Decodable>(
    on endpoint: EndpointType,
    decodeBodyTo bodyType: ResultType.Type
  ) -> TypedResult<ResultType> {
    let dispatchGroup = DispatchGroup()
    dispatchGroup.enter()

    var result: TypedResult<ResultType>?

    self.performRequest(on: endpoint, decodeBodyTo: bodyType) { (asyncResult: TypedResult<ResultType>) in
      result = asyncResult
      dispatchGroup.leave()
    }

    dispatchGroup.wait()

    return result!
  }

  private func decodeBody<ResultType: Decodable>(
    from urlSessionResult: URLSessionResult,
    endpoint: EndpointType
  ) -> TypedResult<ResultType> {
    if let dataTaskError = urlSessionResult.error {
      return .failure(mapToClientErrorType(error: dataTaskError))
    }

    do {
      return try .success(
        decodeBodyToResultType(data: urlSessionResult.data, response: urlSessionResult.response, endpoint: endpoint)
      )
    }
    catch {
      return .failure(error as! ApiError<EndpointType.ClientErrorType>)
    }
  }

  private func mapToClientErrorType(error: Error) -> ApiError<EndpointType.ClientErrorType> {
    .noResponseReceived(error: error)
  }

  private func decodeBodyToResultType<ResultType: Decodable>(
    data: Data?,
    response: URLResponse?,
    endpoint: EndpointType
  ) throws -> ResultType {
    guard let response = response else {
      throw ApiError<EndpointType.ClientErrorType>.noResponseReceived(error: nil)
    }

    guard let httpResponse = response as? HTTPURLResponse else {
      throw ApiError<EndpointType.ClientErrorType>.unexpectedResponseType(response: response)
    }

    switch httpResponse.statusCode {
    case 200..<300:
      if ResultType.self == EmptyBodyResponse.self {
        return EmptyBodyResponse() as! ResultType
      }

      guard let data = data else {
        throw ApiError<EndpointType.ClientErrorType>.noDataInResponse(statusCode: httpResponse.statusCode)
      }

      do {
        return try endpoint.decoder.decode(ResultType.self, from: data)
      }
      catch {
        throw ApiError<EndpointType.ClientErrorType>
          .responseDataConversionFailed(
            type: String(describing: ResultType.self),
            error: error
          )
      }

    case 400..<500:
      if ResultType.self == EmptyBodyResponse.self {
        throw ApiError<EndpointType.ClientErrorType>
          .clientError(
            statusCode: httpResponse.statusCode,
            clientError: nil
          )
      }

      guard let data = data else {
        throw ApiError<EndpointType.ClientErrorType>.noDataInResponse(statusCode: httpResponse.statusCode)
      }

      let clientError = try? endpoint.decoder.decode(EndpointType.ClientErrorType.self, from: data)
      throw ApiError<EndpointType.ClientErrorType>
        .clientError(
          statusCode: httpResponse.statusCode,
          clientError: clientError
        )

    case 500..<600:
      throw ApiError<EndpointType.ClientErrorType>.serverError(statusCode: httpResponse.statusCode)

    default:
      throw ApiError<EndpointType.ClientErrorType>.unexpectedStatusCode(statusCode: httpResponse.statusCode)
    }
  }
}
