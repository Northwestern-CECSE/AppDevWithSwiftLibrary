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
### UserDefaults extension for saving `structs`
(https://www.notion.so/Saving-and-Retrieving-with-UserDefaults-17132aefa78345adb9ce1f5ecc1e3b29)

### Camera and Photo picker
Here we provide a `CameraPicker` that presents a screen that is either the camera or the photo library.  Once a photo is selected or taken SwiftUI Image is returned.<br>
(https://www.notion.so/Working-with-the-Camera-a39011c460f04a399ef55f25cb7cefa0)

### Audio plaback
Want to play, pause and stop audio files easily.  You can use this `AudioPlayer`<br>
(https://www.notion.so/Playing-Audio-Files-e0df0afd44ee4b9896cd400a7f63a13d)

### Reading Bar and QRCodes
Yes, we can easily scan for these two types of codes and get back the string they represent <br>
(https://www.notion.so/Reading-Bar-and-QR-Codes-8a4c1d34f02b4c87b0aff81487f42a85)

### Displaying a WebView in your app<br>
(https://www.notion.so/Displaying-a-WebView-in-your-app-6aab8375cf774dd2af44be5e5871e994)

### Displaying a map and adding annotations<br>
(https://www.notion.so/Display-a-Map-and-adding-Annotations-34e10a58832e483d89509d80f5ec539f)

### Getting your current location on your iPhone<br>
(https://www.notion.so/Getting-your-Current-Location-837e9fcc49004e09b914a6fb026b280b)

### Generating a Pie Chart
(https://www.notion.so/Generating-a-Pie-Chart-c12e5663c96441eaaadeaf81829e9c5b)

### Saving and retrieving data to the cloud
Normally you would need a developer license to access Apple's CloudKit framework. To avoid this complexity we have built a simple mechanism for saving and retrieving data to and from the cloud. It does not require any special credentials from the developer or user.  Note that this mechanism is not super secure so you should use this *only* for educational purposes in your class.<br><br>
(https://www.notion.so/Saving-and-Retrieving-Data-to-the-Cloud-308deff2d91947d99d38b969ba2f3381)






