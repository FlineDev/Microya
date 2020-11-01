import Foundation

/// The API provider class to make the requests on.
open class ApiProvider<EndpointType: Endpoint> {
    /// The Result received, either the expected `Decodable` response object or a `JsonApiError` case.
    public typealias TypedResult<T: Decodable> = Result<T, ApiError<EndpointType.ClientErrorType>>

    /// The lower level Result structure received directly from the native `URLSession` data task calls.
    public typealias URLSessionResult = (data: Data?, response: URLResponse?, error: Error?)

    /// The plugins to apply per request.
    public let plugins: [Plugin<EndpointType>]

    /// Initializes a new API provider with the given plugins applied to every request.
    public init(plugins: [Plugin<EndpointType>]) {
        self.plugins = plugins
    }

    /// Performs the asynchornous request for the chosen write-only endpoint and calls the completion closure with the result.
    /// Returns a `EmptyBodyResponse` on success.
    ///
    /// - WARNING: Do not use this if you expect a body response, use `performRequest(decodeBodyTo:complation:)` instead.
    public func performRequest(on endpoint: EndpointType, completion: @escaping (TypedResult<EmptyBodyResponse>) -> Void) {
        self.performRequest(on: endpoint, decodeBodyTo: EmptyBodyResponse.self, completion: completion)
    }

    /// Performs the request for the chosen write-only endpoint synchronously (waits for the result).
    /// Returns a `EmptyBodyResponse` on success.
    ///
    /// - WARNING: Do not use this if you expect a body response, use `performRequestAndWait(decodeBodyTo:)` instead.
    /// - NOTE: Calling this will block the current thread until the result is available. Use `performRequest` instead for an async call.
    public func performRequestAndWait(on endpoint: EndpointType) -> TypedResult<EmptyBodyResponse> {
        self.performRequestAndWait(on: endpoint, decodeBodyTo: EmptyBodyResponse.self)
    }

    /// Performs the asynchornous request for the chosen endpoint and calls the completion closure with the result.
    /// Specify the expected result type as the `Decodable` generic type.
    public func performRequest<ResultType: Decodable>(
        on endpoint: EndpointType,
        decodeBodyTo: ResultType.Type,
        completion: @escaping (TypedResult<ResultType>) -> Void
    ) {
        let request: URLRequest = buildRequest(endpoint: endpoint)

        for plugin in plugins {
            plugin.willPerformRequest(request, endpoint: endpoint)
        }

        let dataTask = URLSession.shared.dataTask(with: request) { data, response, error in
            let urlSessionResult: URLSessionResult = (data: data, response: response, error: error)
            let typedResult: TypedResult<ResultType> = self.typedResult(from: urlSessionResult, on: endpoint)

            for plugin in self.plugins {
                plugin.didPerformRequest(urlSessionResult: urlSessionResult, typedResult: typedResult, endpoint: endpoint)
            }

            completion(typedResult)
        }

        dataTask.resume()
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

    private func typedResult<ResultType: Decodable>(
        from urlSessionResult: URLSessionResult,
        on endpoint: EndpointType
    ) -> TypedResult<ResultType> {
        if let error = urlSessionResult.error {
            return .failure(ApiError<EndpointType.ClientErrorType>.noResponseReceived(error: error))
        }

        guard let response = urlSessionResult.response else {
            return .failure(ApiError<EndpointType.ClientErrorType>.noResponseReceived(error: nil))
        }

        guard let httpResponse = response as? HTTPURLResponse else {
            return .failure(ApiError<EndpointType.ClientErrorType>.unexpectedResponseType(response: response))
        }

        switch httpResponse.statusCode {
        case 200 ..< 300:
            if ResultType.self == EmptyBodyResponse.self {
                return .success(EmptyBodyResponse() as! ResultType)
            }

            guard let data = urlSessionResult.data else {
                return .failure(ApiError<EndpointType.ClientErrorType>.noDataInResponse(statusCode: httpResponse.statusCode))
            }

            do {
                return .success(try endpoint.decoder.decode(ResultType.self, from: data))
            } catch {
                return .failure(
                    ApiError<EndpointType.ClientErrorType>.responseDataConversionFailed(
                        type: String(describing: ResultType.self),
                        error: error
                    )
                )
            }

        case 400 ..< 500:
            guard let data = urlSessionResult.data else {
                return .failure(ApiError<EndpointType.ClientErrorType>.noDataInResponse(statusCode: httpResponse.statusCode))
            }

            do {
                let clientError = try endpoint.decoder.decode(EndpointType.ClientErrorType.self, from: data)
                return .failure(
                    ApiError<EndpointType.ClientErrorType>.clientError(
                        statusCode: httpResponse.statusCode,
                        clientError: clientError
                    )
                )
            } catch {
                return .failure(
                    ApiError<EndpointType.ClientErrorType>.responseDataConversionFailed(
                        type: String(describing: EndpointType.ClientErrorType.self),
                        error: error
                    )
                )
            }

        case 500 ..< 600:
            return .failure(
                ApiError<EndpointType.ClientErrorType>.serverError(statusCode: httpResponse.statusCode)
            )

        default:
            return .failure(
                ApiError<EndpointType.ClientErrorType>.unexpectedStatusCode(statusCode: httpResponse.statusCode)
            )
        }
    }

    private func buildRequest(endpoint: EndpointType) -> URLRequest {
        var request = URLRequest(url: endpoint.buildRequestUrl())

        switch endpoint.method {
        case .get:
            request.httpMethod = "GET"

        case let .post(body):
            request.httpMethod = "POST"
            request.httpBody = body

        case let .patch(body):
            request.httpMethod = "PATCH"
            request.httpBody = body

        case .delete:
            request.httpMethod = "DELETE"
        }

        for (field, value) in endpoint.headers {
            request.setValue(value, forHTTPHeaderField: field)
        }

        for plugin in plugins {
            request = plugin.modifyRequest(request, endpoint: endpoint)
        }

        return request
    }
}
