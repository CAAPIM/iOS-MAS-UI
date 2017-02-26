MASUI is the core iOS UI framework of the Mobile SDK, which is part of [CA Mobile App Services][mas.ca.com]. MASUI brings pre-defined UIs and assets for developers to quick build prototyping apps without the need of any design. 

## Features

The MASUI framework comes with the following features:

- Default log-in dialog
    + Built-in QR Code registration/authentication
    + Built-in BLE registration/authentication
    + Built-in social network (Google, Facebook, Salesforce, and LinkedIn) registration/authentication

## Get Started

- [Download MASUI][download] 
- Read the ["Getting Started" guide][get-started] or watch some [video tutorials][videos]
- Check out our [documentation][docs] for more details and sample codes


## Communication

- *Have general questions or need help?*, use [Stack Overflow][StackOverflow]. (Tag 'massdk')
- *Find a bug?*, open an issue with the steps to reproduce it.
- *Request a feature or have an idea?*, open an issue.

## How You Can Contribute

Contributions are welcome and much appreciated. To learn more, see the [Contribution Guidelines][contributing].

## Installation

MASUI supports multiple methods for installing the library in a project.

### Cocoapods (Podfile) Install

To integrate MASUI into your Xcode project using CocoaPods, specify it in your **Podfile:**

```
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '9.0'

pod 'MASUI'
```
Then, run the following command using the command prompt from the folder of your project:

```
$ pod install
```

### Manual Install

For manual install, you add the Mobile SDK to your Xcode project. Note that you must add the MASFoundation library. For complete MAS functionality, install all of the MAS libraries as shown.

1. Open your project in Xcode.
2. Drag the SDK library files, and drop them into your project in the left navigator panel in Xcode. Select the option, `Copy items if needed`.
3. Select `File->Add files to 'project name'` and add the msso_config.json file from your project folder.
4. In Xcode "Build Setting” of your Project Target, add `-ObjC` for `Other Linker Flags`.
5. Import the following Mobile SDK library header file to the classes or to the .pch file if your project has one.

```
#import <MASFoundation/MASFoundation.h>
#import <MASUI/MASUI.h>
```


## License

Copyright (c) 2016 CA. All rights reserved.

This software may be modified and distributed under the terms
of the MIT license. See the [LICENSE][license-link] file for details.

 [mag]: https://docops.ca.com/mag
 [mas.ca.com]: http://mas.ca.com/
 [get-started]: http://mas.ca.com/get-started/
 [docs]: http://mas.ca.com/docs/
 [blog]: http://mas.ca.com/blog/
 [videos]: https://www.ca.com/us/developers/mas/videos.html
 [StackOverflow]: http://stackoverflow.com/questions/tagged/massdk
 [download]: https://github.com/CAAPIM/iOS-MAS-UI/archive/master.zip
 [contributing]: https://github.com/CAAPIM/iOS-MAS-UI/blob/develop/CONTRIBUTING.md
 [license-link]: /LICENSE

