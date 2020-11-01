import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

/// The protocol which defines the structure of an API endpoint.
public protocol JsonApi {
    /// The error body type the server responds with for any client errors.
    associatedtype ClientErrorType: Decodable

    /// The JSON decoder to be used for decoding.
    var decoder: JSONDecoder { get }

    /// The JSON encoder to be used for encoding.
    var encoder: JSONEncoder { get }

    /// The plugins to apply per request.
    var plugins: [Plugin<Self>] { get }

    /// The common base URL of the API endpoints.
    var baseUrl: URL { get }

    /// The headers to be sent per request.
    var headers: [String: String] { get }

    /// The subpath to be added to the base URL.
    var subpath: String { get }

    /// The HTTP method to be used for the request.
    var method: HttpMethod { get }

    /// The URL query parameters to be sent (part after ? in URLs, e.g. google.com?query=Harry+Potter).
    var queryParameters: [String: String] { get }
}

extension JsonApi {
    /// The Result received, either the expected `Decodable` response object or a `JsonApiError` case.
    public typealias TypedResult<T: Decodable> = Result<T, JsonApiError<ClientErrorType>>

    /// The lower level Result structure received directly from the native `URLSession` data task calls.
    public typealias URLSessionResult = (data: Data?, response: URLResponse?, error: Error?)

    /// Performs the asynchornous request for the chosen endpoint and calls the completion closure with the result.
    /// Specify the expected result type as the `Decodable` generic type.
    public func performRequest<ResultType: Decodable>(completion: @escaping (TypedResult<ResultType>) -> Void) {
        let request: URLRequest = buildRequest()

        for plugin in plugins {
            plugin.willPerformRequest(request, endpoint: self)
        }

        let dataTask = URLSession.shared.dataTask(with: request) { data, response, error in
            let urlSessionResult: URLSessionResult = (data: data, response: response, error: error)
            let typedResult: TypedResult<ResultType> = self.typedResult(from: urlSessionResult)

            for plugin in plugins {
                plugin.didPerformRequest(urlSessionResult: urlSessionResult, typedResult: typedResult, endpoint: self)
            }

            completion(typedResult)
        }

        dataTask.resume()
    }

    /// Performs the request for the chosen endpoint synchronously (waits for the result) and returns the result.
    /// Specify the expected result type as the `Decodable` generic type.
    ///
    /// - NOTE: Calling this will block the current thread until the result is available. Use `performRequest` instead for an asynchronous call.
    public func performRequestAndWait<ResultType: Decodable>() -> TypedResult<ResultType> {
        let dispatchGroup = DispatchGroup()
        dispatchGroup.enter()

        var result: TypedResult<ResultType>?

        self.performRequest { (asyncResult: TypedResult<ResultType>) in
            result = asyncResult
            dispatchGroup.leave()
        }

        dispatchGroup.wait()

        return result!
    }

    private func typedResult<ResultType: Decodable>(from urlSessionResult: URLSessionResult) -> TypedResult<ResultType> {
        if let error = urlSessionResult.error {
            return .failure(JsonApiError<ClientErrorType>.noResponseReceived(error: error))
        }

        guard let response = urlSessionResult.response else {
            return .failure(JsonApiError<ClientErrorType>.noResponseReceived(error: nil))
        }

        guard let httpResponse = response as? HTTPURLResponse else {
            return .failure(JsonApiError<ClientErrorType>.unexpectedResponseType(response: response))
        }

        switch httpResponse.statusCode {
        case 200 ..< 300:
            guard let data = urlSessionResult.data else { return .failure(JsonApiError<ClientErrorType>.noDataInResponse) }

            do {
                return .success(try decoder.decode(ResultType.self, from: data))
            } catch {
                return .failure(
                    JsonApiError<ClientErrorType>.responseDataConversionFailed(
                        type: String(describing: ResultType.self),
                        error: error
                    )
                )
            }

        case 400 ..< 500:
            guard let data = urlSessionResult.data else { return .failure(JsonApiError<ClientErrorType>.noDataInResponse) }

            do {
                let clientError = try decoder.decode(ClientErrorType.self, from: data)
                return .failure(
                    JsonApiError<ClientErrorType>.clientError(statusCode: httpResponse.statusCode, clientError: clientError)
                )
            } catch {
                return .failure(
                    JsonApiError<ClientErrorType>.responseDataConversionFailed(
                        type: String(describing: ClientErrorType.self),
                        error: error
                    )
                )
            }

        case 500 ..< 600:
            return .failure(
                JsonApiError<ClientErrorType>.serverError(statusCode: httpResponse.statusCode)
            )

        default:
            return .failure(
                JsonApiError<ClientErrorType>.unexpectedStatusCode(statusCode: httpResponse.statusCode)
            )
        }
    }

    private func buildRequest() -> URLRequest {
        var request = URLRequest(url: buildRequestUrl())

        switch method {
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

        for (field, value) in headers {
            request.setValue(value, forHTTPHeaderField: field)
        }

        for plugin in plugins {
            request = plugin.modifyRequest(request, endpoint: self)
        }

        return request
    }

    private func buildRequestUrl() -> URL {
        var urlComponents = URLComponents(url: baseUrl.appendingPathComponent(subpath), resolvingAgainstBaseURL: false)!

        urlComponents.queryItems = []
        for (key, value) in queryParameters {
            urlComponents.queryItems?.append(URLQueryItem(name: key, value: value))
        }

        return urlComponents.url!
    }
}

// swiftlint:disable missing_docs

// Provide sensible default to effectively make some of the protocol requirements optional.
extension JsonApi {
    public var decoder: JSONDecoder {
        JSONDecoder()
    }

    public var encoder: JSONEncoder {
        JSONEncoder()
    }

    public var plugins: [Plugin<Self>] {
        []
    }

    public var headers: [String: String] {
        [
            "Content-Type": "application/json",
            "Accept": "application/json",
            "Accept-Language": Locale.current.languageCode ?? "en"
        ]
    }

    public var queryParameters: [String: String] {
        [:]
    }
}
