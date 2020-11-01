import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

/// Collection of all possible exception that can be thrown when using `JsonApi`.
public enum ApiError<ClientErrorType: Decodable>: Error {
    /// The request was sent, but the server response was not received. Typically an issue with the internet connection.
    case noResponseReceived(error: Error?)

    /// The request was sent and the server responded, but the response did not include any body although a body was requested.
    case noDataInResponse(statusCode: Int)

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
