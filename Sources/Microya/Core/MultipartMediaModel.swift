import Foundation

public struct MultipartMediaModel {
  let key: String
  let fileName: String
  let data: Data
  let mimeType: String
  
  public init(withFilePath fileURL: URL, forKey key: String) {
    self.key = key
    self.mimeType = fileURL.pathExtension
    self.fileName = "\(arc4random()).jpeg"
    do {
      let data = try Data(contentsOf: fileURL)
      self.data = data
    } catch {
      print(error)
      self.data = Data()
    }
  }
  
  public init(withData data: Data, forKey key: String) {
    self.key = key
    self.mimeType = data.mimeType
    self.fileName = "\(arc4random()).jpeg"
    self.data = data
  }
}
