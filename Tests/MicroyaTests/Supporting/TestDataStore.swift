import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif
@testable import Microya

enum TestDataStore {
   static var request: URLRequest?
   static var urlSessionResult: (data: Data?, response: URLResponse?, error: Error?)?
   static var showingProgressIndicator: Bool = false
   
   static func reset() {
      request = nil
      urlSessionResult = nil
      showingProgressIndicator = false
   }
}
