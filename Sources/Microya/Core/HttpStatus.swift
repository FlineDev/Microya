import Foundation
#if canImport(FoundationNetworking)
  import FoundationNetworking
#endif

/// A HTTP response status code.
/// Supports all the codes from http://www.iana.org/assignments/http-status-codes.
public enum HttpStatus: Equatable {
  // MARK: 1xx
  /// 100
  case `continue`

  /// 101
  case switchingProtocols

  /// 102
  case processing

  // MARK: 2xx
  /// 200
  case ok

  /// 201
  case created

  /// 202
  case accepted

  /// 203
  case nonAuthoritativeInformation

  /// 204
  case noContent

  /// 205
  case resetContent

  /// 206
  case partialContent

  /// 207
  case multiStatus

  /// 208
  case alreadyReported

  /// 226
  case imUsed

  // MARK: 3xx
  /// 300
  case multipleChoices

  /// 301
  case movedPermanently

  /// 302
  case found

  /// 303
  case seeOther

  /// 304
  case notModified

  /// 305
  case useProxy

  /// 307
  case temporaryRedirect

  /// 308
  case permanentRedirect

  // MARK: 4xx
  /// 400
  case badRequest

  /// 401
  case unauthorized

  /// 402
  case paymentRequired

  /// 403
  case forbidden

  /// 404
  case notFound

  /// 405
  case methodNotAllowed

  /// 406
  case notAcceptable

  /// 407
  case proxyAuthenticationRequired

  /// 408
  case requestTimeout

  /// 409
  case conflict

  /// 410
  case gone

  /// 411
  case lengthRequired

  /// 412
  case preconditionFailed

  /// 413
  case payloadTooLarge

  /// 414
  case uriTooLong

  /// 415
  case unsupportedMediaType

  /// 416
  case rangeNotSatisfiable

  /// 417
  case expectationFailed

  /// 418
  case imATeapot

  /// 421
  case misdirectedRequest

  /// 422
  case unprocessableEntity

  /// 423
  case locked

  /// 424
  case failedDependency

  /// 426
  case upgradeRequired

  /// 428
  case preconditionRequired

  /// 429
  case tooManyRequests

  /// 431
  case requestHeaderFieldsTooLarge

  /// 451
  case unavailableForLegalReasons

  // MARK: 5xx
  /// 500
  case internalServerError

  /// 501
  case notImplemented

  /// 502
  case badGateway

  /// 503
  case serviceUnavailable

  /// 504
  case gatewayTimeout

  /// 505
  case httpVersionNotSupported

  /// 506
  case variantAlsoNegotiates

  /// 507
  case insufficientStorage

  /// 508
  case loopDetected

  /// 510
  case notExtended

  /// 511
  case networkAuthenticationRequired

  /// Custom code.
  case custom(code: Int)

  /// Initialize a `HttpStatus` from a given status code.
  ///
  /// - Parameter statusCode: The integer value of the HTTP response status code
  public init(
    statusCode: Int
  ) {
    switch statusCode {
    case 100:
      self = .`continue`

    case 101:
      self = .switchingProtocols

    case 102:
      self = .processing

    case 200:
      self = .ok

    case 201:
      self = .created

    case 202:
      self = .accepted

    case 203:
      self = .nonAuthoritativeInformation

    case 204:
      self = .noContent

    case 205:
      self = .resetContent

    case 206:
      self = .partialContent

    case 207:
      self = .multiStatus

    case 208:
      self = .alreadyReported

    case 226:
      self = .imUsed

    case 300:
      self = .multipleChoices

    case 301:
      self = .movedPermanently

    case 302:
      self = .found

    case 303:
      self = .seeOther

    case 304:
      self = .notModified

    case 305:
      self = .useProxy

    case 307:
      self = .temporaryRedirect

    case 308:
      self = .permanentRedirect

    case 400:
      self = .badRequest

    case 401:
      self = .unauthorized

    case 402:
      self = .paymentRequired

    case 403:
      self = .forbidden

    case 404:
      self = .notFound

    case 405:
      self = .methodNotAllowed

    case 406:
      self = .notAcceptable

    case 407:
      self = .proxyAuthenticationRequired

    case 408:
      self = .requestTimeout

    case 409:
      self = .conflict

    case 410:
      self = .gone

    case 411:
      self = .lengthRequired

    case 412:
      self = .preconditionFailed

    case 413:
      self = .payloadTooLarge

    case 414:
      self = .uriTooLong

    case 415:
      self = .unsupportedMediaType

    case 416:
      self = .rangeNotSatisfiable

    case 417:
      self = .expectationFailed

    case 418:
      self = .imATeapot

    case 421:
      self = .misdirectedRequest

    case 422:
      self = .unprocessableEntity

    case 423:
      self = .locked

    case 424:
      self = .failedDependency

    case 426:
      self = .upgradeRequired

    case 428:
      self = .preconditionRequired

    case 429:
      self = .tooManyRequests

    case 431:
      self = .requestHeaderFieldsTooLarge

    case 451:
      self = .unavailableForLegalReasons

    case 500:
      self = .internalServerError

    case 501:
      self = .notImplemented

    case 502:
      self = .badGateway

    case 503:
      self = .serviceUnavailable

    case 504:
      self = .gatewayTimeout

    case 505:
      self = .httpVersionNotSupported

    case 506:
      self = .variantAlsoNegotiates

    case 507:
      self = .insufficientStorage

    case 508:
      self = .loopDetected

    case 510:
      self = .notExtended

    case 511:
      self = .networkAuthenticationRequired

    default:
      self = .custom(code: statusCode)
    }
  }
}

extension HttpStatus {
  /// The numerical status code for a given HTTP response status.
  public var code: Int {
    get {
      switch self {
      case .continue:
        return 100

      case .switchingProtocols:
        return 101

      case .processing:
        return 102

      case .ok:
        return 200

      case .created:
        return 201

      case .accepted:
        return 202

      case .nonAuthoritativeInformation:
        return 203

      case .noContent:
        return 204

      case .resetContent:
        return 205

      case .partialContent:
        return 206

      case .multiStatus:
        return 207

      case .alreadyReported:
        return 208

      case .imUsed:
        return 226

      case .multipleChoices:
        return 300

      case .movedPermanently:
        return 301

      case .found:
        return 302

      case .seeOther:
        return 303

      case .notModified:
        return 304

      case .useProxy:
        return 305

      case .temporaryRedirect:
        return 307

      case .permanentRedirect:
        return 308

      case .badRequest:
        return 400

      case .unauthorized:
        return 401

      case .paymentRequired:
        return 402

      case .forbidden:
        return 403

      case .notFound:
        return 404

      case .methodNotAllowed:
        return 405

      case .notAcceptable:
        return 406

      case .proxyAuthenticationRequired:
        return 407

      case .requestTimeout:
        return 408

      case .conflict:
        return 409

      case .gone:
        return 410

      case .lengthRequired:
        return 411

      case .preconditionFailed:
        return 412

      case .payloadTooLarge:
        return 413

      case .uriTooLong:
        return 414

      case .unsupportedMediaType:
        return 415

      case .rangeNotSatisfiable:
        return 416

      case .expectationFailed:
        return 417

      case .imATeapot:
        return 418

      case .misdirectedRequest:
        return 421

      case .unprocessableEntity:
        return 422

      case .locked:
        return 423

      case .failedDependency:
        return 424

      case .upgradeRequired:
        return 426

      case .preconditionRequired:
        return 428

      case .tooManyRequests:
        return 429

      case .requestHeaderFieldsTooLarge:
        return 431

      case .unavailableForLegalReasons:
        return 451

      case .internalServerError:
        return 500

      case .notImplemented:
        return 501

      case .badGateway:
        return 502

      case .serviceUnavailable:
        return 503

      case .gatewayTimeout:
        return 504

      case .httpVersionNotSupported:
        return 505

      case .variantAlsoNegotiates:
        return 506

      case .insufficientStorage:
        return 507

      case .loopDetected:
        return 508

      case .notExtended:
        return 510

      case .networkAuthenticationRequired:
        return 511

      case let .custom(code):
        return code
      }
    }
  }

  /// The string reason phrase for a given HTTP response status.
  public var reasonPhrase: String {
    get {
      switch self {
      case .continue:
        return "Continue"

      case .switchingProtocols:
        return "Switching Protocols"

      case .processing:
        return "Processing"

      case .ok:
        return "OK"

      case .created:
        return "Created"

      case .accepted:
        return "Accepted"

      case .nonAuthoritativeInformation:
        return "Non-Authoritative Information"

      case .noContent:
        return "No Content"

      case .resetContent:
        return "Reset Content"

      case .partialContent:
        return "Partial Content"

      case .multiStatus:
        return "Multi-Status"

      case .alreadyReported:
        return "Already Reported"

      case .imUsed:
        return "IM Used"

      case .multipleChoices:
        return "Multiple Choices"

      case .movedPermanently:
        return "Moved Permanently"

      case .found:
        return "Found"

      case .seeOther:
        return "See Other"

      case .notModified:
        return "Not Modified"

      case .useProxy:
        return "Use Proxy"

      case .temporaryRedirect:
        return "Temporary Redirect"

      case .permanentRedirect:
        return "Permanent Redirect"

      case .badRequest:
        return "Bad Request"

      case .unauthorized:
        return "Unauthorized"

      case .paymentRequired:
        return "Payment Required"

      case .forbidden:
        return "Forbidden"

      case .notFound:
        return "Not Found"

      case .methodNotAllowed:
        return "Method Not Allowed"

      case .notAcceptable:
        return "Not Acceptable"

      case .proxyAuthenticationRequired:
        return "Proxy Authentication Required"

      case .requestTimeout:
        return "Request Timeout"

      case .conflict:
        return "Conflict"

      case .gone:
        return "Gone"

      case .lengthRequired:
        return "Length Required"

      case .preconditionFailed:
        return "Precondition Failed"

      case .payloadTooLarge:
        return "Payload Too Large"

      case .uriTooLong:
        return "URI Too Long"

      case .unsupportedMediaType:
        return "Unsupported Media Type"

      case .rangeNotSatisfiable:
        return "Range Not Satisfiable"

      case .expectationFailed:
        return "Expectation Failed"

      case .imATeapot:
        return "I'm a teapot"

      case .misdirectedRequest:
        return "Misdirected Request"

      case .unprocessableEntity:
        return "Unprocessable Entity"

      case .locked:
        return "Locked"

      case .failedDependency:
        return "Failed Dependency"

      case .upgradeRequired:
        return "Upgrade Required"

      case .preconditionRequired:
        return "Precondition Required"

      case .tooManyRequests:
        return "Too Many Requests"

      case .requestHeaderFieldsTooLarge:
        return "Request Header Fields Too Large"

      case .unavailableForLegalReasons:
        return "Unavailable For Legal Reasons"

      case .internalServerError:
        return "Internal Server Error"

      case .notImplemented:
        return "Not Implemented"

      case .badGateway:
        return "Bad Gateway"

      case .serviceUnavailable:
        return "Service Unavailable"

      case .gatewayTimeout:
        return "Gateway Timeout"

      case .httpVersionNotSupported:
        return "HTTP Version Not Supported"

      case .variantAlsoNegotiates:
        return "Variant Also Negotiates"

      case .insufficientStorage:
        return "Insufficient Storage"

      case .loopDetected:
        return "Loop Detected"

      case .notExtended:
        return "Not Extended"

      case .networkAuthenticationRequired:
        return "Network Authentication Required"

      case let .custom(code):
        return "Custom Code: \(code)"
      }
    }
  }
}
