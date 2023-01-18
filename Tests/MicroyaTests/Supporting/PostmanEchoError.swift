import Foundation

struct PostmanEchoError: Decodable, Equatable {
   let code: Int
   let message: String
}
