#!/bin/bash

swift test
xcodebuild test -scheme CodableSaveLoad -destination 'platform=iOS Simulator,name=iPhone SE'  | xcpretty
bundler exec slather coverage --html --show --scheme CodableSaveLoad --output-directory docs CodableSaveLoad.xcodeproj
