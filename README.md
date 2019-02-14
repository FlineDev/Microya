<p align="center">
    <img src="https://raw.githubusercontent.com/Flinesoft/Microya/stable/Logo.png"
      width=600>
</p>

<p align="center">
    <a href="https://app.bitrise.io/app/9144757ac274834d">
        <img src="https://app.bitrise.io/app/9144757ac274834d/status.svg?token=wnogmmQA9Zy7_2u75vRKdg"
             alt="Build Status">
    </a>    
    <a href="https://codebeat.co/projects/github-com-flinesoft-microya-stable">
        <img src="https://codebeat.co/badges/a669e100-d30d-4801-b72d-3625ab7240be"
             alt="codebeat badge">
    </a>
    <img src="https://img.shields.io/badge/Swift-4.2-FFAC45.svg"
         alt="Swift: 4.2">
    <img src="https://img.shields.io/badge/Platforms-iOS%20%7C%20macOS%20%7C%20tvOS%20%7C%20watchOS-FF69B4.svg"
        alt="Platforms: iOS | macOS | tvOS | watchOS">
    <a href="https://github.com/Flinesoft/Microya/blob/stable/LICENSE.md">
        <img src="https://img.shields.io/badge/License-MIT-lightgrey.svg"
              alt="License: MIT">
    </a>
</p>

<p align="center">
    <a href="#installation">Installation</a>
  • <a href="#usage">Usage</a>
  • <a href="https://github.com/Flinesoft/Microya/issues">Issues</a>
  • <a href="#contributing">Contributing</a>
  • <a href="#license">License</a>
</p>

# Microya

A micro version of the Moya network abstraction layer written in Swift.

## Installation

Installation is supported via [CocoaPods](https://github.com/CocoaPods/CocoaPods), [Carthage](https://github.com/Carthage/Carthage), [SwiftPM](https://github.com/apple/swift-package-manager) and [Mint](https://github.com/yonaskolb/Mint).

## Usage

### Step 1: Defining your Endpoints
Create an Api `enum` with all supported endpoints as `cases` with the request parameters/data specified as parameters.

For example, when writing a client for the [Microsoft Translator API](https://docs.microsoft.com/en-us/azure/cognitive-services/translator/reference/v3-0-languages):

```Swift
enum MicrosoftTranslatorApi {
    case languages
    case translate(texts: [String], from: Language, to: [Language])
}
```

Note that the `Language` type used above does not necessarily need to be an `Encodable` type:

```Swift
enum Language: String {
    case english = "en"
    case german = "de"
    case japanese = "jp"
    case turkish = "tr"
}
```

### Step 2: Making your Api `JsonApi` compliant

Add an extension for your Api `enum` that makes it `JsonApi` compliant, which means you need to add implementations for the following protocol:

```Swift
protocol JsonApi {
    var decoder: JSONDecoder { get }
    var encoder: JSONEncoder { get }

    var baseUrl: URL { get }
    var headers: [String: String] { get }
    var path: String { get }
    var method: Method { get }
    var queryParameters: [(key: String, value: String)] { get }
    var bodyData: Data? { get }
}
```

Use `switch` statements over `self` to differentiate between the cases (if needed) and to provide the appropriate data the protocol asks for (using [Value Bindings](https://docs.swift.org/swift-book/LanguageGuide/ControlFlow.html#ID133)).

<details>
<summary>Toggle me to see an example</summary>

```Swift
extension MicrosoftTranslatorApi: JsonApi {
    var decoder: JSONDecoder {
        return JSONDecoder()
    }

    var encoder: JSONEncoder {
        return JSONEncoder()
    }

    var baseUrl: URL {
        return URL(string: "https://api.cognitive.microsofttranslator.com")!
    }

    var path: String {
        switch self {
        case .languages:
		        return "/languages"

        case .translate:
            return "/translate"
        }
    }

    var method: Method {
        switch self {
        case .languages:
		        return .get

        case .translate:
            return .post
        }
    }

    var queryParameters: [(key: String, value: String)] {
        var urlParameters: [(String, String)] = [(key: "api-version", value: "3.0")]

        switch self {
        case .languages:
            break

        case let .translate(_, sourceLanguage, targetLanguages, _):
            urlParameters.append((key: "from", value: sourceLanguage.rawValue))

            for targetLanguage in targetLanguages {
                urlParameters.append((key: "to", value: targetLanguage.rawValue))
            }              
        }

        return urlParameters
    }

    var bodyData: Data? {
        switch self {
        case .translate:
            return nil // no request data needed

        case let .translate(texts, _, _, _):
            return try! encoder.encode(texts)
        }
    }

    var headers: [String: String] {
        switch self {
        case .languages:
		        return [:]

        case .translate:
            return [
                "Ocp-Apim-Subscription-Key": "<SECRET>",
                "Content-Type": "application/json"
            ]
        }
    }
}
```

</details>

### Step 3: Calling your API endpoint with the result type

Call an API endpoint providing a `Decodable` type of the expected result (if any) by using this method pre-implemented in the `JsonApi` protocol:

```Swift
func request<ResultType: Decodable>(type: ResultType.Type) -> Result<ResultType, JsonApiError>
```

For example:

```Swift
let endpoint = MicrosoftTranslatorApi.translate(texts: ["Test"], from: .english, to: [.german, .japanese, .turkish])

switch endpoint.request(type: [String: String].self) {
case let .success(translationsByLanguage):
    // use the already decoded `[String: String]` result

case let .failure(error):
    // error handling
}
```

Note that you can also use the throwing `get()` function of Swift 5's `Result` type instead of using a `switch` statement:

```Swift
let endpoint = MicrosoftTranslatorApi.translate(texts: ["Test"], from: .english, to: [.german, .japanese, .turkish])
let translationsByLanguage = try endpoint.request(type: [String: String].self)
// use the already decoded `[String: String]` result
```

There's even useful functional methods defines on the `Results` type like `map()`, `flatMap()` or `mapError()` and `flatMapError()`. See the "Transforming Result" section in [this](https://www.hackingwithswift.com/articles/161/how-to-use-result-in-swift) article for more information.

## Contributing

See the file [CONTRIBUTING.md](https://github.com/JamitLabs/MungoHealer/blob/stable/CONTRIBUTING.md).


## License
This library is released under the [MIT License](http://opensource.org/licenses/MIT). See LICENSE for details.
