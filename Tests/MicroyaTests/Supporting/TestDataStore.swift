import Foundation
@testable import Microya

enum TestDataStore {
    static var request: URLRequest?
    static var urlSessionResult: (data: Data?, response: URLResponse?, error: Error?)?
    static var showingProgressIndicator: Bool = false
}
