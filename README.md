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

### Carthage

Place the following line to your Cartfile:

``` Swift
github "Flinesoft/Microya" ~> 0.1
```

Now run `carthage update`. Then drag & drop the Microya.framework in the Carthage/Build folder to your project. Now you can `import Microya` in each class you want to use its features. Refer to the [Carthage README](https://github.com/Carthage/Carthage#adding-frameworks-to-an-application) for detailed / updated instructions.

### CocoaPods

Add the line `pod 'Microya'` to your target in your `Podfile` and make sure to include `use_frameworks!`
at the top. The result might look similar to this:

``` Ruby
platform :ios, '8.0'
use_frameworks!

target 'MyAppTarget' do
    pod 'Microya', '~> 0.1'
end
```

Now close your project and run `pod install` from the command line. Then open the `.xcworkspace` from within your project folder.
Build your project once (with `Cmd+B`) to update the frameworks known to Xcode. Now you can `import Microya` in each class you want to use its features.
Refer to [CocoaPods.org](https://cocoapods.org) for detailed / updates instructions.

## Usage

Please have a look at the UsageExamples.playground for a complete list of features provided.
Open the Playground from within the `.xcworkspace` in order for it to work.

---
#### Features Overview

- [Short Section](#short-section)
- Sections Group
  - [SubSection1](#subsection1)
  - [SubSection2](#subsection2)

---

### Short Section

TODO: Add some usage information here.

### Sections Group

TODO: Summarize the section here.

#### SubSection1

TODO: Add some usage information here.

#### SubSection2

TODO: Add some usage information here.


## Contributing

See the file [CONTRIBUTING.md](https://github.com/JamitLabs/MungoHealer/blob/stable/CONTRIBUTING.md).


## License
This library is released under the [MIT License](http://opensource.org/licenses/MIT). See LICENSE for details.
