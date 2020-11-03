import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

/// Allows to log requests the given way provided by a closure before the requests are sent.
public class RequestLoggerPlugin<EndpointType: Endpoint>: Plugin<EndpointType> {
    private let logClosure: (URLRequest) -> Void

    public init(logClosure: @escaping (URLRequest) -> Void) {
        self.logClosure = logClosure
    }

    override public func willPerformRequest(_ request: URLRequest, endpoint: EndpointType) {
        logClosure(request)
    }
}
