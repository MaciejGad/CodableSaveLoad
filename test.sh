#!/bin/bash

xcodebuild test -scheme CodableSaveLoad -workspace CodableSaveLoad.xcworkspace -destination 'platform=iOS Simulator,name=iPhone SE'  | xcpretty
slather coverage --html --show --scheme CodableSaveLoad --workspace CodableSaveLoad.xcworkspace --output-directory docs CodableSaveLoad.xcodeproj