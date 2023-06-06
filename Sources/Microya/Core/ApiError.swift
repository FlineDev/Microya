import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

/// Collection of all possible exception that can be thrown when using `JsonApi`.
public enum ApiError<ClientErrorType: Decodable>: Error, Sendable {
   /// The request was sent, but the server response was not received. Typically an issue with the internet connection.
   case noResponseReceived(error: (any Error)?)
   
   /// The request was sent and the server responded, but the response did not include any body although a body was requested.
   case noDataInResponse(statusCode: Int)
   
   /// The request was sent and the server responded with a body, but the conversion of the body to the given type failed.
   case responseDataConversionFailed(type: String, error: any Error)
   
   /// The request was sent and the server responded, but the server reports that something is wrong with the request.
   case clientError(statusCode: Int, clientError: ClientErrorType?)
   
   /// The request was sent and the server responded, but there seems to be an error which needs to be fixed on the server.
   case serverError(statusCode: Int)
   
   /// The request was sent and the server responded, but with an unexpected status code.
   case unexpectedStatusCode(statusCode: Int)
   
   /// Server responded with a non HTTP response, although an HTTP request was made. Either a bug in `JsonApi` or on the server side.
   case unexpectedResponseType(response: URLResponse)
   
   /// The `mockingBehavior` was set to non-nil (for testing) but no `mockedResponse` was provided for the requested endpoint.
   case emptyMockedResponse
}

extension ApiError: Equatable where ClientErrorType: Equatable {
   public static func == (lhs: ApiError<ClientErrorType>, rhs: ApiError<ClientErrorType>) -> Bool {
      switch (lhs, rhs) {
      case (.noResponseReceived, .noResponseReceived),
         (.unexpectedResponseType, .unexpectedResponseType),
         (.emptyMockedResponse, .emptyMockedResponse):
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

extension ApiError {
   public var errorDescription: String {
      switch self {
      case .noResponseReceived(let error):
         if let error {
            return "The request was sent, but the server response was not received. Please check your internet connection. System error: \(error.localizedDescription)"
         } else {
            return "The request was sent, but the server response was not received. Please check your internet connection."
         }
         
      case .noDataInResponse(let statusCode):
         return "The request was sent and the server responded with status code \(statusCode), but the response did not include any body although a body was requested."
         
      case .responseDataConversionFailed(let type, let error):
         return "The request was sent and the server responded with a body, but the conversion of the body to the expected type \(type.description) failed. System error: \(error.localizedDescription)"
         
      case .clientError(let statusCode, _):
         return "The request was sent but the server responded with status code \(statusCode), which means that something is wrong with the request."
         
      case .serverError(let statusCode):
         return "The request was sent but the server responded with status code \(statusCode), which means an internal issue occurred on the server."
         
      case .unexpectedStatusCode(let statusCode):
         return "The request was sent but the server responded with the unexpected status code \(statusCode)."
         
      case .unexpectedResponseType(let response):
         return "Server responded with a non HTTP response, although an HTTP request was made. Either a bug in `JsonApi` or on the server side. Response: \(response)"
         
      case .emptyMockedResponse:
         return "The `mockingBehavior` was set to non-nil (for testing) but no `mockedResponse` was provided for the requested endpoint."
      }
   }
}
