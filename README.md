# xmpp-ios-obj-c
This is a wrapper project for XMPPFramework to easily integrate xmpp methods.

## Getting Started

For demo example, change only host name in AppDelegate.h file and you are good to go. Otherwise create your own project by performing following steps.

### Requirement:

The minimum deployment target is iOS 8.0 / macOS 10.9 / tvOS 9.0

### Features:

* Connect/Disconnect with jabber server.
* Get Online/Offline
* User registration
* User authentication.
* Receive presence 
* Send/Receive message (Set users as roster from jabber server to receive presence and send/receive message)

### Installation and Usage:

Step - 1: Create an objective c project and a initialise podfile.

Step - 2: Add following in your ```Podfile```
```
pod ‘XMPPFramework’, ‘~>3.7’
```
(Version is important) 
	
Step - 3: Drag and Drop "AppDelegateXMPP" folder in your project.

Step - 4: Navigate to project through terminal and fire command ```pod install```

Step - 5: Copy/Paste content from ```AppDelegate.h``` file. (See example)

Step - 6: Add following code snippet in ```didFinishLaunchingWithOptions``` method
```
[DDLog addLogger:[[DDTTYLogger alloc] init];
[self setupStream];
```

We have integrated methods with AppDelegate file. Utilise it according to your requirement. See example to understand how to use this library.

### Author
- Vimal Rughani

### Contact Us
- info@virtaulrealitysystems.net

### WebSite
[Virtual Reality Systems](http://www.virtualrealitysystems.net/site/)

