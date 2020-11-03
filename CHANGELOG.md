# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/en/1.0.0/) and this project adheres to [Semantic Versioning](http://semver.org/spec/v2.0.0.html).

## [Unreleased]
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
### Deprecated
- None.
### Removed
- The `bodyData: Data?` requirement on `JsonApi` (bodies are not part of `HttpMethod`, see above).
- Installation is no longer possible via [CocoaPods](https://github.com/CocoaPods/CocoaPods) or [Carthage](https://github.com/Carthage/Carthage). Please use [SwiftPM](https://github.com/apple/swift-package-manager) instead.
### Fixed
- None.
### Security
- None.

## [0.2.0] - 2020-08-15
### Changed
- Make some fields of the `JsonApi` protocol optional by providing default implementation.

## [0.1.0] - 2019-02-14
### Added
- Add `JsonApi` type similar to `TargetType` in Moya with additional JSON `Codable` support.
- Add basic usage documentation based on the Microsoft Translator API.
