# AppDevWithSwiftLibrary

This package is a collection of API's that allow students of CECSE's App Dev with Swift course to add additional capability to their apps easily, all in SwiftUI. 
To gain access to this library easily just add this package as a dependency to your project.

Click on `File -> Swift Packages -> Add Package Dependency`

In the `Choose Package Repository` dialog at the top, enter this url:

`https://github.com/Northwestern-CECSE/AppDevWithSwiftLibrary.git`

and click `Next`

A new dialog will present the latest version number.  As of this writing it is `1.9.1` but your number may be greater.

It should default to `Up to Next Major` for the rules it will use to update this package as new capabilities are added.  Just keep everything as the default and click `Next`

After a few seconds you will be presented with a final confirmation with a blue checkmark next to the library. Click `Finish`

Thats it, you now have the package availabe to you in your project. Your file list on the left should now look like the image below. Notice that the library is listed at the bottom under `Swift Package Dependencies`

<img width="272" alt="Screen Shot 2021-05-27 at 7 41 08 AM" src="https://user-images.githubusercontent.com/640155/119827638-fc3f4280-bebe-11eb-9206-7a0c785a5c80.png">

## Making this library visible to your code

To access this library in your code you will need to add this one line at the top of any Swift file that needs it.
```
import AppDevWithSwiftLibrary
```
> UserDefaults extension for saving `structs`
`https://www.notion.so/Saving-and-Retrieving-with-UserDefaults-17132aefa78345adb9ce1f5ecc1e3b29`



