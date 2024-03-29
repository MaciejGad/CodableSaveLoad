# CodableSaveLoad [![Build Status](https://travis-ci.org/MaciejGad/CodableSaveLoad.svg?branch=master)](https://travis-ci.org/MaciejGad/CodableSaveLoad) [![codecov](https://codecov.io/gh/MaciejGad/CodableSaveLoad/branch/master/graph/badge.svg)](https://codecov.io/gh/MaciejGad/CodableSaveLoad)
Sample save&amp;load for Codable

# Usage 

Let assume that you have a some `Dummy` structure that is `Codable`:

```swift 
struct Dummy: Codable {
    let text: String
}
```

now you can easily save to app document directory:

```swift
let dummy = Dummy(text: "This is an example")
dummy.save()
//or if you what to know when it finished:
dummy.save().done { _ in 
   print("💾 Saved!")
}.catch { error in 
   print("💣 \(error)")
}
```

you can load this data to strucutre again:

```swift
Dummy.load().done { dummy in 
   print(dummy.text)
}.catch { error in 
   print("💣 \(error)")
}
```

or you can delete the file:

```swift 
Dummy.delete() 
//or
Dummy.delete().done { _ in 
  print("deleted")
}.catch { error in 
   print("💣 \(error)")
}
```

# Installation

Use the [CocoaPods](http://github.com/CocoaPods/CocoaPods).

Add to your Podfile
>`pod 'CodableSaveLoad'`

and then call

>`pod install`

and import 

>`import CodableSaveLoad`

# Hall Of Fame

[![](https://sourcerer.io/fame/MaciejGad/MaciejGad/CodableSaveLoad/images/0)](https://sourcerer.io/fame/MaciejGad/MaciejGad/CodableSaveLoad/links/0)[![](https://sourcerer.io/fame/MaciejGad/MaciejGad/CodableSaveLoad/images/1)](https://sourcerer.io/fame/MaciejGad/MaciejGad/CodableSaveLoad/links/1)[![](https://sourcerer.io/fame/MaciejGad/MaciejGad/CodableSaveLoad/images/2)](https://sourcerer.io/fame/MaciejGad/MaciejGad/CodableSaveLoad/links/2)[![](https://sourcerer.io/fame/MaciejGad/MaciejGad/CodableSaveLoad/images/3)](https://sourcerer.io/fame/MaciejGad/MaciejGad/CodableSaveLoad/links/3)[![](https://sourcerer.io/fame/MaciejGad/MaciejGad/CodableSaveLoad/images/4)](https://sourcerer.io/fame/MaciejGad/MaciejGad/CodableSaveLoad/links/4)[![](https://sourcerer.io/fame/MaciejGad/MaciejGad/CodableSaveLoad/images/5)](https://sourcerer.io/fame/MaciejGad/MaciejGad/CodableSaveLoad/links/5)[![](https://sourcerer.io/fame/MaciejGad/MaciejGad/CodableSaveLoad/images/6)](https://sourcerer.io/fame/MaciejGad/MaciejGad/CodableSaveLoad/links/6)[![](https://sourcerer.io/fame/MaciejGad/MaciejGad/CodableSaveLoad/images/7)](https://sourcerer.io/fame/MaciejGad/MaciejGad/CodableSaveLoad/links/7)
