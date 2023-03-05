import Foundation

/// The value of a query parameter. Supports initialization via string & array literals.
public enum QueryParameterValue {
   /// The singular string entry.
   case string(String)
   
   /// The array string entry.
   case array([String])
   
  public var values: [String] {
      switch self {
      case let .string(value):
         return [value]
         
      case let .array(values):
         return values
      }
   }
}

extension QueryParameterValue: ExpressibleByStringLiteral {
   public init(
      stringLiteral value: String
   ) {
      self = .string(value)
   }
}

extension QueryParameterValue: ExpressibleByArrayLiteral {
   public init(
      arrayLiteral elements: String...
   ) {
      self = .array(Array(elements))
   }
}
