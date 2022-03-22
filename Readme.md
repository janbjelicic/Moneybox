## Table of contents
* [General info](#general-info)
* [Technologies](#technologies)
* [Setup](#setup)

## General info
This is a project built as a solution to the Moneybox iOS technical challenge. More info about the challenge here https://github.com/MoneyBox/ios-technical-task/
	
## Technologies
The code is written in Swift, UI is built in Storyboards using UIKit and the functionality is tested by unit tests in the MoneyboxTests target.

Used 3rd party frameworks:
* SwiftLint, coding style enforcement https://github.com/realm/SwiftLint
* Resolver, DI helper https://github.com/hmlongco/Resolver
* RxSwift, Reactive programming paradigm https://github.com/ReactiveX/RxSwift
	
## Setup
Download the project locally and open it in Xcode. You can trust opening it even if it is downloaded from the Internet :).

#### SwiftLint
You need to have SwiftLint installed on your Mac. You can use brew to install it 

```
brew install swiftlint
```

If you don't have brew installed, here are instructions how to set it up https://brew.sh/

If you don't want to go through the hassle of setting up SwiftLint you can avoid this setup by going to the Moneybox target's "Build Phases" and remove the "Run SwiftLint" script.

#### Simulator

Make sure that the "Moneybox" scheme is set and that you select a simulator of your choice (I usually test with Iphone 11). After that you can safely run the app.