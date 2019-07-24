#!/bin/bash

xcodebuild test -scheme CodableSaveLoad -workspace CodableSaveLoad.xcworkspace -destination 'platform=iOS Simulator,name=iPhone SE'  | xcpretty
slather coverage -s --scheme CodableSaveLoad --workspace CodableSaveLoad.xcworkspace CodableSaveLoad.xcodeproj