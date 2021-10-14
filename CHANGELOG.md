# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/en/1.0.0/) and this project adheres to [Semantic Versioning](http://semver.org/spec/v2.0.0.html).

## [Unreleased]
### Added
- None.
### Changed
- Allowed to change the baseUrl.
### Deprecated
- None.
### Removed
- None.
### Fixed
- None.
### Security
- None.

## [0.6.0] - 2021-09-30
### Added
- New async `response` method based on the new concurrency features available in Swift 5.5.

## [0.5.0] - 2021-09-28
### Added
- New `mockingBehavior` parameter on `ApiProvider` for testing purposes. Specify one with `delay` and `scheduler`, e.g. `.seconds(0.5)` and `DispatchQueue.main.eraseToAnyScheduler()`. Provides `nil` by default to make actual requests.
- New optional `mockedResponse` computed property on `Endpoint` protocol expecting an output of type `MockedResponse`. Use this to provide mocked responses when using a `mockingBehavior` in tests. See the [PostmanEchoEndpoint](https://github.com/Flinesoft/Microya/blob/main/Tests/MicroyaTests/Supporting/PostmanEchoEndpoint.swift#L114-127) in the tests for a usage example via the `mock` convenience method.
### Changed
- Moved `baseUrl` from `Endpoint` to `ApiProvider`. This allows for specifying different `baseUrl` even when `Endpoint` is implemented in a library by passing it in the app.
- Renamed `HttpBasicAuthPlugin` to `HttpAuthPlugin` with a new `scheme` parameter that accepts one of `.basic` or `.bearer` to support multiple authentication methods.

## [0.4.0] - 2020-11-21
### Added
- Microya now supports Combine publishers, just call `publisher(on:decodeBodyTo:)` or `publisher(on:)` instead of `performRequest(on:decodeBodyTo:)` or `performRequest(on:)` and you'll get an `AnyPublisher` request stream to subscribe to. In success cases you will receive the decoded typed object, in error cases an `ApiError` object exactly like within the `performRequest` completion closure. But instead of a `Result` type you can use `sink` or `catch` from the Combine framework.
### Changed
- The `queryParameters` is no longer of type `[String: String]`, but `[String: QueryParameterValue]` now. Existing code like `["search": searchTerm]` will need to be updated to `["search": .string(searchTerm)]`. Apart from `.string` this now also allows specifying an array of strings like so: `["tags": .array(userSelectedTags)]`. String & array literals are supported directly, e.g. `["sort": "createdAt"]` or `["sort": ["createdAt", "id"]]`.

## [0.3.0] - 2020-11-03
### Added
- New `ApiProvider` type encapsulating different request methods with support for plugins.
- New asynchronous `performRequest` methods with completion callbacks. ([#2](https://github.com/Flinesoft/Microya/issues/2))
- New `Plugin` class to subclass for integrating into the networking logic via callbacks.
- New pre-implemented plugins: `HttpBasicAuth`, `ProgressIndicator`, `RequestLogger`, `ResponseLogger`.
- New `EmptyResponseBody` type to use whenever the body is expected to be empty or should be ignored.
### Changed
- Renamed `JsonApi` protocol to `Endpoint`.
- Renamed `Method` to `HttpMethod` and added `body: Data` to the cases `post` and `patch`.
- Moved the `request` method from `JsonApi` to the new `ApiProvider` & renamed to `performRequestAndWait`.
- Generally improved the cases in `JsonApiError` & renamed the type to `ApiError`.
- Moved CI from [Bitrise](https://www.bitrise.io/) to [GitHub Actions](https://github.com/Flinesoft/Microya/actions).
### Removed
- The `bodyData: Data?` requirement on `JsonApi` (bodies are not part of `HttpMethod`, see above).
- Installation is no longer possible via [CocoaPods](https://github.com/CocoaPods/CocoaPods) or [Carthage](https://github.com/Carthage/Carthage). Please use [SwiftPM](https://github.com/apple/swift-package-manager) instead.

## [0.2.0] - 2020-08-15
### Changed
- Make some fields of the `JsonApi` protocol optional by providing default implementation.

## [0.1.0] - 2019-02-14
### Added
- Add `JsonApi` type similar to `TargetType` in Moya with additional JSON `Codable` support.
- Add basic usage documentation based on the Microsoft Translator API.
