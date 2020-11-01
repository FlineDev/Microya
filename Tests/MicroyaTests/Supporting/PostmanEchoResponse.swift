import Foundation

struct PostmanEchoResponse: Decodable {
    let args: [String: String]
    let headers: [String: String]
    let url: String
}
