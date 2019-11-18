# 100DaysOfSwift

This is my repository for the [100DaysOfSwift](https://www.hackingwithswift.com/100/) challenge created by [Paul Hudson](https://twitter.com/twostraws).

All projects were either inspired by him or at least heavily influenced and instructed.

If you want to learn more about Swift I highly recommend his wonderful site 
[Hacking with Swift](https://www.hackingwithswift.com/) with tons of well-written 
and educative articles and learning materials.

Also if you enjoy his work he has written a lot of books on Swift which you can 
find [here](https://www.hackingwithswift.com/store) (this is not sponsored in any
way, I just think it's highly recommendable).

Below you can find the list of projects:

## 1. 🌪 [Storm Viewer](https://github.com/DaemonLoki/100DaysOfSwift/tree/master/Storm%20Viewer) (Days 16 - 18)

_Creating a simple image viewer with a detail page._

* Working with `FileManager`
* Loading resources from Storage (`Bundle`)
* Creating `TableView`s and `TableViewCell`s in Storyboards
* Simple Navigation

## 2. 🇩🇪 [Guess the Flag](https://github.com/DaemonLoki/100DaysOfSwift/tree/master/Guess%20the%20Flag) (Days 19 - 22)

_Developing a flag guessing game which asks the user to guess contries of different flags._

* Auto Layout in Interface Builder
* `UIButton`s and `Layer`s
* Handling user input for `UIButton`s
* `UIAlertController`

## 3. 🎌 [Fun with Flags](https://github.com/DaemonLoki/100DaysOfSwift/tree/master/Fun%20with%20Flags) (Milestone - Day 23)

_Allowing user to browse flags and show details for the country in a detail page._

* Custom `UITableView` and `UITableViewCell`s
* `UIActivityViewController` and sharing data
* dequeuing `TableViewCell`s
* repetition of navigation

## 4. 🖥 [Easy Browser](https://github.com/DaemonLoki/100DaysOfSwift/tree/master/Easy%20Browser) (Days 24 - 26)

_Creating a basic browser rendering custom websites that the user can select._

* Intro to `WebKit` and `WKWebView`
* Using `.actionSheet` presentation style of `UIAlertController`
* showing progress using `UIToolbar` and `UIProgressView`

## 5. 🤔 [Word Scramble](https://github.com/DaemonLoki/100DaysOfSwift/tree/master/Word%20Scramble) (Days 27 - 29)

_Word game implemented in `UIKit` making the user create own words from given strings._

* Capture lists: `weak` vs. `unowned` vs. `strong`
* Reading `contentsOf` from disk
* Receiving text input in `UIAlertController`
* Checking text with `UITextChecker` and `String` manipulations

## 6. 🚗 [Auto Layout](https://github.com/DaemonLoki/100DaysOfSwift/tree/master/Awesome%20Auto%20Layout) (Days 30 - 31)

_Playing around with Auto Layout in code with anchors and visual format language._

* Advanced Auto Layout (e.g. `aspectRatio`, `anchors`)
* `Visual Format Language` (VFL) 

## 🛍 [Shopping List](https://github.com/DaemonLoki/100DaysOfSwift/tree/master/ShoppingList) (Milestone - Day 32)

_Building up a shopping list app with option to share the list._

* more `String` manipulations and slicing
* inserting and deleting rows in `UITableView`s
* sharing lists with `UIActivityViewController`

## 7. 🇺🇸 [Whitehouse Petitions](https://github.com/DaemonLoki/100DaysOfSwift/tree/master/Whitehouse%20Petitions) (Days 33 - 35)

_Loading data for current petitions at the White House and displaying statistics about it._

* `UITabBarController`
* parsing JSON with `Codable`
* rendering HTML with `loadHTMLString`
* using `didFinishLaunchingWithOptions` in `AppDelegate`

## 8. 🤓 [Swifty Words](https://github.com/DaemonLoki/100DaysOfSwift/tree/master/Swifty%20Words) (Days 36 - 38)

_Little game creating different words and allowing the user to combine different words together._

* creating UI in programmatically with Auto Layout
* Array and `String` manipulations like `components(separatedBy:)` and `joined(separator:)`
* using property observers like `didSet`

## 9. 🤖 [Grand Central Dispatch](https://github.com/DaemonLoki/100DaysOfSwift/tree/master/Grand%20Central%20Dispatch) (Days 39 - 40)

_Introduction to background processing and taking computation away from the main thread._

* `GCD` basics and relieving the main thread 
* asynchronous code execution
* updating UI from other thread using `performSelector(onMainThread:)`

## 👮 [Hangman](https://github.com/DaemonLoki/100DaysOfSwift/tree/master/Hangman) (Milestone - Day 41)

_Hangman clone created with `UIKit`._

* `Character` as elements of `String`
* loading data in backgorund using `GCD`
* creating a game in `UIKit`

## 10. 😁 [Names to Faces](https://github.com/DaemonLoki/100DaysOfSwift/tree/master/Names%20to%20Faces) (Days 42 - 44)

_Load people's images and assign names to them that get saved._

* using `UICollectionView` with `UICollectionViewCell`s
* importing photos with `UIImagePickerController`
* sublassing `NSObject`

## 11. 🏀 [Pachinko](https://github.com/DaemonLoki/100DaysOfSwift/tree/master/Pachinko) (Days 45 - 47)

_SpriteKit game challenging users to collect points and destroy objects._

* intro to `SpriteKit`
* learning about elements like `SKSpriteNode`, `SKLabelNode`, `SKPhysicsBody` and `SKEmitterNode`
* creating `SKAction`s and chaining them
* catching collisions with `SKPhysicsContactDelegate`

## 💾 UserDefaults (Days 48 - 49)

_How to save and load data from `UserDefaults`._

* saving data in `UserDefaults`
* using `NSCoding` in combination with `NSKeyedArchiver` and `NSKeyedUnarchiver`
* using `JSONEncoder` and `JSONDecoder` with `Codable`

## 📸 [Capture Images](https://github.com/DaemonLoki/100DaysOfSwift/tree/master/Capture%20Images) (Milestone - Day 50)

_Capturing images and storing them using `Codable`._

* capturing images from the camera
* storing user data in `UserDefaults`
* repetition of `Codable`, `UITableView` and navigation

## 📹 Watching talks (Day 51)

* [Elements of Functional Programming](https://www.youtube.com/watch?v=OgU8d_E1K14)
* [Teaching Swift at Scale](https://vimeo.com/291590798)

## 13. 🔮 [Instafilter](https://github.com/DaemonLoki/100DaysOfSwift/tree/master/Instafilter) (Days 52 - 54)

_Image manipulation app that makes use of iOS built-in filters with `CoreImage`._

* using `UISlider` in the UI
* applying filters using `CoreImage` and `CIFilter`/`CIContext`
* writing images to the library using `UIImageWriteToSavedPhotosAlbum()`

## 14. 🐧 [Whack-a-Penguin](https://github.com/DaemonLoki/100DaysOfSwift/tree/master/Whack-A-Penguin) (Days 55 - 56)

_SpriteKit game were users need to be fast to hit disappearing penguins._

* more `SpriteKit` with `SKCropNode` and custom `SKNode`s with `maskNode`s
* action sequences with `SKAction`
* using `zPosition` for stacking `SKNode`s

## 15. 💫 [Animation](https://github.com/DaemonLoki/100DaysOfSwift/tree/master/Animation) (Days 57 - 58)

_Introduction to different animation types in `UIKit`._

* using simple animations with `UIView.animate(withDuration:)`
* applying `CGAffineTransform` with scaling, rotating and translating views
* using spring, velocity and damping for more lively animations

## 🇲🇻 [Country Info](https://github.com/DaemonLoki/100DaysOfSwift/tree/master/Country%20Info) (Milestone - Day 59)

_Showing infos of different countries and allowing users to share facts about them._

* showing JSON encoded information with `Codable`
* providing cool UI with navigation
* sharing country facts with `UIActivityViewController`

## 16. 🏙 [Capital Cities](https://github.com/DaemonLoki/100DaysOfSwift/tree/master/Capital%20Cities) (Days 60 - 61)

_Creating a map with interesting events pinned that show more information on click._

* intro to `MapKit` with `MKMapView`, `MKAnnotation` and `CLLocationCoordinate2D`
* using `MKPinAnnotationView`s
* changing map types with e.g. `.satellite`

## 17. 🛰 [Space Race](https://github.com/DaemonLoki/100DaysOfSwift/tree/master/Space%20Race) (Days 62 - 63)

_SpriteKit game that shows spaceship and needs to avoid hitting space objects._

* using more of `SKPhysicsBody` and `SKPhysicsContactDelegate` to detect and show collisions between nodes
* combine `Timer`, `linearDamping` and `angularDamping` to animate nodes 

## 🛠 Debugging (Days 64 - 65)

_Introduction to debugging iOS apps with Xcode._

* debugging with `print()` vs. `assert()` vs. breakpoints
* view debugging of the UI with *Capture View Hierarchy*

## 18. 🔪 [Shooting Gallery](https://github.com/DaemonLoki/100DaysOfSwift/tree/master/Shooting%20Gallery) (Milestone - Day 66)

_Creating a SpriteKit game similar to a shooting gallery._

* auto-creating differently colored and typed `SKNode`s
* moving nodes and handling click targets

## 19. 💉 [JavaScript Injection](https://github.com/DaemonLoki/100DaysOfSwift/tree/master/JavaScript%20Injection) (Days 67 - 69)

_Creating a Safari Extension with the option to run custom JavaScript._

* how to make a shell app and using `NSExtensionItem`
* registering as a Safari extension
* editing multi-line text with `UITextView`

## 20. 🎇 [Fireworks Night](https://github.com/DaemonLoki/100DaysOfSwift/tree/master/Fireworks%20Night) (Days 70 - 71)

_SpriteKit game showing fireworks that the user needs to destroy._

* using `colorBlendFactor` on `SKNode`s
* creating paths using `UIBezierPath`s and `orientToPath`
* detecting swipe gestures to destroy multiple `SKNode`s at once

## 21. 🛑 [Local Notifications](https://github.com/DaemonLoki/100DaysOfSwift/tree/master/Local%20Notifications) (Days 72 - 73)

_Using local notifications in an app._

* getting started with `UNUserNotificationCenter` and `UNNotificationRequest`
* requesting authorization from the user for notifications
* acting on responses in notifications with `UNNotificationCategory` and `UNNotificationAction`s

## ✏️ [Notes clone](https://github.com/DaemonLoki/100DaysOfSwift/tree/master/Notes%20Clone) (Milestone Day 74)

_Cloning the iOS Notes app as closely as possible._

* use `Codable` to save notes to a file
* allow sharing with `UIActivityViewController`
* keep editing history

## 22. 📍 [Detect-a-Beacon](https://github.com/DaemonLoki/100DaysOfSwift/tree/master/Detect-A-Beacon) (Days 75 - 76)

_Use iBeacons to detect how far away objects are from the user._

* using `CoreLocation` and `CLLocationManager` to ask for and detect the user location
* detecting iBeacons using `CLBeaconRegion` 
* measuring proximity with `CLProximity`

## 23. 🐼 [Swifty Ninja](https://github.com/DaemonLoki/100DaysOfSwift/tree/master/SwiftyNinja) (Days 77 - 79)

_Fruit Ninja clone with SpriteKit._

* using `SKShapeNode` and `SKTexture`
* creating action with `CGPath` and `UIBezierPath`s
* playing sound with `SKAction` and `AVAudioPlayer`

## 24. ✨ [Swift Strings](https://github.com/DaemonLoki/100DaysOfSwift/tree/master/SwiftStrings.playground) (Days 80 - 81)

_How to use `NSAttributedString` with labels and text views._

* how to work with `String`s in Swift as they are not arrays
* formatting `String`s with `NSAttributedString`

## 🤩 [Swift language extensions](https://github.com/DaemonLoki/100DaysOfSwift/tree/master/Extensions_Milestone_Challenges.playground) (Milestone - Day 82)

_Creating different language extensions that make it easier to use the features they implement._

* extension of `UIView` to have a `bounceOut(duration:)` method
* adding a `times()` method to `Int` that runs a closure as many times
* provide a `remove(item:)` method for `Array`s with the `Comparable` constraint

## 25. 🤳 [Selfie Share](https://github.com/DaemonLoki/100DaysOfSwift/tree/master/Selfie%20Share) (Days 83 - 84)

_Sharing selfies with multipeer connectivity._

* getting started with `MultipeerConnectivity` and `MCSession`
* identifying users with `MCPeerID` and looking for others with `MCAdvertiserAssistant` and `MCBrowserViewController`
* sending data over the peer network and showing it in a `UICollectionView`

## 26. 🤷 [Marble Maze](https://github.com/DaemonLoki/100DaysOfSwift/tree/master/Marble%20Maze) (Days 85 - 87)

_Creating a rolling ball game for iPad with use of accelerometer._

* working with `categoryBitMask`, `collisionBitMask` and `contactTestBitMask`
* using `CMMotionManager` to access the accelerometer data from the device
* runnign code only in simulator with `#if targetEnvironment(simulator)`
* detecting contacting with collisions

## 27. 📈 [Core Graphics](https://github.com/DaemonLoki/100DaysOfSwift/tree/master/Core%20Graphics) (Days 88 - 89)

_Using `CoreGraphics` to draw directly to the screen._

* drawing in `CoreGraphics` with `UIGraphicsImageRenderer`
* using `setFillColor()`, `setStrokeColor()` and `setLineWidth()` for custom drawing
* drawing rectangles, ellipses, checkerboards, transforms and lines
* drawing images and text directly on the screen

## 🤬 [Meme Generator](https://github.com/DaemonLoki/100DaysOfSwift/tree/master/Meme%20Generator) (Milestone - Day 90)

_Creating a meme generating app that draws user created text on user selected images._

* importing images
* drawing text in different places of the image using `CoreGraphics`
* saving the manipulated image to user's photos library

## 🤯 Core Graphics redux (Day 91)

_Working through a custom CoreGraphics playground from Paul to practice drawing._

* getting more practice in drawing different shapes
* creating flags and checkerboards and icons from scratch with `CoreGraphics`

## 28. 🤫 [Secret Swift](https://github.com/DaemonLoki/100DaysOfSwift/tree/master/Secret%20Swift) (Days 92 - 93)

_Save data using the keychain and limiting access with biometric authentication._

* writing and reading from the iOS Keychain with `KeychainWrapper`
* using `NotificationCenter` to get notified when app enters the background
* using biometric authentication using Touch ID or Face ID with the `LocalAuthentication` framework

## 29. 🐒 [Exploding Monkeys](https://github.com/DaemonLoki/100DaysOfSwift/tree/master/Exploding%20Monkeys) (Days 94 - 96)

_SpriteKit game using `CoreGraphics` and dynamic level creation and physics effects._

* filling paths with `SKTexture`s and using texture atlasses in `SpriteKit`
* drawing randomized nodes in certain bounds as building objects
* adding `UIKit` elements in the `SpriteKit` game
* using `presentScene()` to switch between scenes

## 30. 🪕 Instruments (Days 97 - 98)

_Using Instruments in Xcode to detect slow running code, incorrect usage of main thread and memory allocations._

* using *Time Profiler* to detect length of execution of different code portions
* how to effectively draw shadows by adding a `shadowPath` with `UIBezierPath`
* analyzing and fixing object allocations (by dequeuing `UITableViewCell`s with *Allocations* tool

## 🃏 [Pairs](https://github.com/DaemonLoki/100DaysOfSwift/tree/master/Pairs) (Milestone - Day 99)

_Creating a memory game in UIKit with fancy animations and different topics and content._

* creating matching pairs and loading them
* using a `UICollectionView` to show different cards (with delayed reveal animation)
* animating flipping of cards and drawing patterns on back of the cards (using `CoreGraphics`)

## 🎓 Final test (Day 100)

_Completed the final test with *Certificate of distinction* (> 95% correct answers)._

![Certificate for Stefan Blos](/certificate_stefan_blos.jpg)
