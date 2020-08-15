//
//  Created by Cihat Gündüz on 14.02.19.
//  Copyright © 2019 Flinesoft. All rights reserved.
//

//  Created by Cihat Gündüz on 14.01.19.

import Foundation

public enum JsonApiError: Error {
    case noResponseReceived
    case noDataReceived
    case responseDataConversionFailed(type: String, error: Error)
    case unexpectedStatusCode(Int)
    case unknownError(Error)
}

/// The protocol which defines the structure of an API endpoint.
public protocol JsonApi {
    /// The JSON decoder to be used for decoding.
    var decoder: JSONDecoder { get }

    /// The JSNO encoder to be used for encoding.
    var encoder: JSONEncoder { get }

    /// The common base URL of the API endpoints.
    var baseUrl: URL { get }

    /// The headers to be sent per request.
    var headers: [String: String] { get }

    /// The subpath to be added to the base URL.
    var path: String { get }

    /// The HTTP method to be used for the request.
    var method: Method { get }

    /// The URL query parameters to be sent (part after ? in URLs, e.g. google.com?query=Harry+Potter).
    var queryParameters: [(key: String, value: String)] { get }

    /// The body data to be sent along the request (e.g. JSON contents in a POST request).
    var bodyData: Data? { get }
}

extension JsonApi {
    /// Performs the request. Make sure to specify the correct return type (e.g. let result: MyType = api.request...).
    public func request<ResultType: Decodable>(type: ResultType.Type) -> Result<ResultType, JsonApiError> {
        let dispatchGroup = DispatchGroup()
        dispatchGroup.enter()

        var result: Result<ResultType, JsonApiError>?

        var request = URLRequest(url: requestUrl())
        for (field, value) in headers {
            request.setValue(value, forHTTPHeaderField: field)
        }

        if let bodyData = bodyData {
            request.httpBody = bodyData
        }

        request.httpMethod = method.rawValue

        let dataTask = URLSession.shared.dataTask(with: request) { data, urlResponse, error in
            result = {
                guard error == nil else { return .failure(JsonApiError.unknownError(error!)) }
                guard let httpUrlResponse = urlResponse as? HTTPURLResponse else {
                    return .failure(JsonApiError.noResponseReceived)
                }

                switch httpUrlResponse.statusCode {
                case 200 ..< 300:
                    guard let data = data else { return .failure(JsonApiError.noDataReceived) }
                    do {
                        let typedResult = try self.decoder.decode(type, from: data)
                        return .success(typedResult)
                    } catch {
                        return .failure(JsonApiError.responseDataConversionFailed(type: String(describing: type), error: error))
                    }

                case 400 ..< 500:
                    return .failure(JsonApiError.unexpectedStatusCode(httpUrlResponse.statusCode))

                case 500 ..< 600:
                    return .failure(JsonApiError.unexpectedStatusCode(httpUrlResponse.statusCode))

                default:
                    return .failure(JsonApiError.unexpectedStatusCode(httpUrlResponse.statusCode))
                }
            }()

            dispatchGroup.leave()
        }

        dataTask.resume()
        dispatchGroup.wait()

        return result!
    }

    private func requestUrl() -> URL {
        var urlComponents = URLComponents(url: baseUrl.appendingPathComponent(path), resolvingAgainstBaseURL: false)!

        urlComponents.queryItems = []
        for (key, value) in queryParameters {
            urlComponents.queryItems?.append(URLQueryItem(name: key, value: value))
        }

        return urlComponents.url!
    }
}

/// Extension to provide default contents for optional fields.
extension JsonApi {
    public var decoder: JSONDecoder {
        JSONDecoder()
    }

    public var encoder: JSONEncoder {
        JSONEncoder()
    }

    public var headers: [String: String] {
        [:]
    }

    public var queryParameters: [(key: String, value: String)] {
        []
    }

    public var bodyData: Data? {
        nil
    }
}
