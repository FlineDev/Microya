
<p align="center">
    <img src="https://raw.githubusercontent.com/Flinesoft/NewFrameworkTemplate/stable/Logo.png"
      width=600>
</p>

<p align="center">
    <a href="https://app.bitrise.io/app/3a9e984eba8c73b8">
        <img src="https://app.bitrise.io/app/3a9e984eba8c73b8/status.svg?token=0njkrtWxlHnbM9cP4Iwi7g"
             alt="Build Status">
    </a>    
    <a href="https://codebeat.co/projects/github-com-flinesoft-newframeworktemplate-stable">
        <img src="https://codebeat.co/badges/b50c9729-5b5a-4ac8-b05d-bf4ae7827ac6"
             alt="codebeat badge">
    </a>
    <a href="https://github.com/Flinesoft/NewFrameworkTemplate/releases">
        <img src="https://img.shields.io/badge/Version-0.1.0-blue.svg"
             alt="Version: 0.1.0">
    </a>
    <img src="https://img.shields.io/badge/Swift-4.2-FFAC45.svg"
         alt="Swift: 4.2">
    <img src="https://img.shields.io/badge/Platforms-iOS%20%7C%20macOS%20%7C%20tvOS%20%7C%20watchOS-FF69B4.svg"
        alt="Platforms: iOS | macOS | tvOS | watchOS">
    <a href="https://github.com/Flinesoft/NewFrameworkTemplate/blob/stable/LICENSE">
        <img src="https://img.shields.io/badge/License-MIT-lightgrey.svg"
              alt="License: MIT">
    </a>
</p>

<p align="center">
    <a href="#installation">Installation</a>
  • <a href="#usage">Usage</a>
  • <a href="https://github.com/Flinesoft/NewFrameworkTemplate/issues">Issues</a>
  • <a href="#contributing">Contributing</a>
  • <a href="#license">License</a>
</p>


# NewFrameworkTemplate

A preconfigured template for new framework projects with batteries included.

Specifically this is what "battries included" currently means:

- There's a sensible `.gitignore` for Swift projects included (based on [GitHub gitignore](https://github.com/github/gitignore/blob/master/Swift.gitignore))
- Targets are configured for iOS, macOS, tvOS & watchOS (just remove what you don't need)
- SwiftLint is preconfigured to help embrace a unified code style
- Support for [Carthage](https://github.com/Carthage/Carthage), [CocoaPods](https://github.com/CocoaPods/CocoaPods) and [Swift Package Manager](https://github.com/apple/swift-package-manager) is setup
- A `README.md` file is setup with appropriate sections
- A `LICENSE` file is setup with MIT license preconfigured

## Prerequisites

To use this framework, you need to install a few tools:

- [Homebrew](https://brew.sh): `/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"`
- [Beak](https://github.com/yonaskolb/Beak): `brew tap yonaskolb/Beak https://github.com/yonaskolb/Beak.git && brew install Beak`
- [Carthage](https://github.com/Carthage/Carthage): `brew install carthage`
- [SwiftLint](https://github.com/realm/SwiftLint): `brew install swiftlint`


## Getting Started

Here's a few simple steps on how you can use this project to kick-start your next framework project:

1. **Clone this repo** to your own Git server or **download as ZIP file** (beware)
2. Run `beak run initialize --projectName YourFrameworkName --organization "Your Organization"` to **initialize the project**
3. Set the the **Development Team** to yours (at least in the test targets)
4. Update the **author and social_media_url** entries in the .podspec file

Additional options you probably want to check:

5. **Remove the targets and schemes** you are not planning to develop for (all Apple platforms supported by default)
6. Configure the **minimum deployment target** per target (the latest major version by default)

That's it! Start coding. 🎉 😊


## Contributing

See the file [CONTRIBUTING.md](https://github.com/JamitLabs/MungoHealer/blob/stable/CONTRIBUTING.md).


## License
This library is released under the [MIT License](http://opensource.org/licenses/MIT). See LICENSE for details.
