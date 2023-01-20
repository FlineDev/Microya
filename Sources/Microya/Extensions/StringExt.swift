import Foundation

extension String {
   var urlEncoded: String {
      var charset: CharacterSet = .urlQueryAllowed
      charset.remove(charactersIn: "\n:#/?@!$&'()*+,;=")
      return self.addingPercentEncoding(withAllowedCharacters: charset)!
   }
}

