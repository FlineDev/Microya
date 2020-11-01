import Foundation

/// Allows to show & hide a progress indicator in a given way provided by a closure whenever there are any ongoing requests.
///
/// An object of this type can be used for multiple endpoints to show a global progress indicator as long as at least one of them is still ongoing.
/// Or separate objects could be used for each endpoint to show a different and independent progress indicator per endpoint.
public class ProgressIndicatorPlugin<JsonApiType: JsonApi>: Plugin<JsonApiType> {
    private var ongoingRequests: Int = 0

    private let showIndicator: () -> Void
    private let hideIndicator: () -> Void

    public init(showIndicator: @escaping () -> Void, hideIndicator: @escaping () -> Void) {
        self.showIndicator = showIndicator
        self.hideIndicator = hideIndicator
    }

    override public func willPerformRequest(_ request: URLRequest, endpoint: JsonApiType) {
        ongoingRequests += 1

        if ongoingRequests == 1 {
            showIndicator()
        }
    }

    override public func didPerformRequest<ResultType: Decodable>(
        urlSessionResult: JsonApiType.URLSessionResult,
        typedResult: JsonApiType.TypedResult<ResultType>,
        endpoint: JsonApiType
    ) {
        ongoingRequests -= 1

        if ongoingRequests == 0 {
            hideIndicator()
        }
    }
}
