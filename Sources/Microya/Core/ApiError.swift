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
  case clientError(statusCode: Int, clientError: ClientErrorType?)

  /// The request was sent and the server responded, but there seems to be an error which needs to be fixed on the server.
  case serverError(statusCode: Int)

  /// The request was sent and the server responded, but with an unexpected status code.
  case unexpectedStatusCode(statusCode: Int)

  /// Server responded with a non HTTP response, although an HTTP request was made. Either a bug in `JsonApi` or on the server side.
  case unexpectedResponseType(response: URLResponse)
}

extension ApiError: Equatable where ClientErrorType: Equatable {
  public static func == (lhs: ApiError<ClientErrorType>, rhs: ApiError<ClientErrorType>) -> Bool {
    switch (lhs, rhs) {
    case (.noResponseReceived, .noResponseReceived), (.unexpectedResponseType, .unexpectedResponseType):
      return true

    case let (.noDataInResponse(leftStatusCode), .noDataInResponse(rightStatusCode)),
      let (.unexpectedStatusCode(leftStatusCode), .unexpectedStatusCode(rightStatusCode)),
      let (.serverError(leftStatusCode), .serverError(rightStatusCode)):
      return leftStatusCode == rightStatusCode

    case let (.clientError(leftStatusCode, leftClientError), .clientError(rightStatusCode, rightClientError)):
      return leftStatusCode == rightStatusCode && leftClientError == rightClientError

    case let (.responseDataConversionFailed(leftType, _), .responseDataConversionFailed(rightType, _)):
      return leftType == rightType

    default:
      return false
    }
  }
}
