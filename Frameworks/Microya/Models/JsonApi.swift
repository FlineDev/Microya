//
//  Created by Cihat Gündüz on 14.02.19.
//  Copyright © 2019 Flinesoft. All rights reserved.
//

//  Created by Cihat Gündüz on 14.01.19.

import Foundation

enum JsonApiError: Error {
    case noResponseReceived
    case noDataReceived
    case responseDataConversionFailed(type: String, error: Error)
    case unexpectedStatusCode(Int)
    case unknownError(Error)
}

protocol JsonApi {
    var decoder: JSONDecoder { get }
    var encoder: JSONEncoder { get }

    var baseUrl: URL { get }
    var headers: [String: String] { get }
    var path: String { get }
    var method: Method { get }
    var queryParameters: [(key: String, value: String)] { get }
    var bodyData: Data? { get }
}

extension JsonApi {
    func request<ResultType: Decodable>(type: ResultType.Type) -> Result<ResultType, JsonApiError> {
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
