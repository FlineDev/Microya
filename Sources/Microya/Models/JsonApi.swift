import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

/// Collection of all possible exception that can be thrown when using `JsonApi`.
public enum JsonApiError<ClientErrorType: Decodable>: Error {
    /// The request was sent, but the server response was not received. Typically an issue with the internet connection.
    case noResponseReceived(error: Error?)

    /// The request was sent and the server responded, but the response did not include any body although a body was requested.
    case noDataInResponse

    /// The request was sent and the server responded with a body, but the conversion of the body to the given type failed.
    case responseDataConversionFailed(type: String, error: Error)

    /// The request was sent and the server responded, but the server reports that something is wrong with the request.
    case clientError(statusCode: Int, clientError: ClientErrorType)

    /// The request was sent and the server responded, but there seems to be an error which needs to be fixed on the server.
    case serverError(statusCode: Int)

    /// The request was sent and the server responded, but with an unexpected status code.
    case unexpectedStatusCode(statusCode: Int)

    /// Server responded with a non HTTP response, although an HTTP request was made. Either a bug in `JsonApi` or on the server side.
    case unexpectedResponseType(response: URLResponse)
}

/// The protocol which defines the structure of an API endpoint.
public protocol JsonApi {
    /// The error body type the server responds with for any client errors.
    associatedtype ClientErrorType: Decodable

    /// The JSON decoder to be used for decoding.
    var decoder: JSONDecoder { get }

    /// The JSNO encoder to be used for encoding.
    var encoder: JSONEncoder { get }

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
    /// Performs the request for the chosen endpoint.
    public func performRequest<ResultType: Decodable>(completion: @escaping (Result<ResultType, JsonApiError<ClientErrorType>>) -> Void) {
        URLSession.shared.dataTask(with: buildRequest()) { data, response, error in
            completion(result(data: data, response: response, error: error))
        }
    }

    private func result<ResultType: Decodable>(data: Data?, response: URLResponse?, error: Error?) -> Result<ResultType, JsonApiError<ClientErrorType>> {
        if let error = error {
            return .failure(JsonApiError<ClientErrorType>.noResponseReceived(error: error))
        }

        guard let response = response else {
            return .failure(JsonApiError<ClientErrorType>.noResponseReceived(error: nil))
        }

        guard let httpResponse = response as? HTTPURLResponse else {
            return .failure(JsonApiError<ClientErrorType>.unexpectedResponseType(response: response))
        }

        switch httpResponse.statusCode {
        case 200 ..< 300:
            guard let data = data else { return .failure(JsonApiError<ClientErrorType>.noDataInResponse) }

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
            guard let data = data else { return .failure(JsonApiError<ClientErrorType>.noDataInResponse) }

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

/// Extension to provide default contents for optional fields.
extension JsonApi {
    /// The Decoder to use per request.
    public var decoder: JSONDecoder {
        JSONDecoder()
    }

    /// The Encoder to use per request.
    public var encoder: JSONEncoder {
        JSONEncoder()
    }

    /// The headers to send per request.
    public var headers: [String: String] {
        [
            "Content-Type": "application/json",
            "Accept": "application/json",
            "Accept-Language": Locale.current.identifier
        ]
    }

    /// The query parameters to send per request.
    public var queryParameters: [String: String] {
        [:]
    }
}
