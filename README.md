GiToon for Apple Platforms
=================

[![TestFlight Beta invite](https://img.shields.io/badge/TestFlight-Beta-blue.svg)](https://www.home-assistant.io/ios/beta/)
[![Download on the App Store](https://img.shields.io/itunes/v/1099568401.svg)](https://itunes.apple.com/app/home-assistant-open-source-home-automation/id1099568401)
[![GitHub issues](https://img.shields.io/github/issues/home-assistant/iOS.svg?style=flat)](https://github.com/home-assistant/iOS/issues)
[![License Apache 2.0](https://img.shields.io/badge/license-Apache%202.0-green.svg?style=flat)](https://github.com/home-assistant/iOS/blob/master/LICENSE)

## Getting Started

GiToon uses Bundler, Homebrew and Cocoapods to manage build dependencies. You'll need Xcode 15.3 (or later) which you can download from the [App Store](https://developer.apple.com/download/). You can get the app running using the following commands:

```bash
git clone https://github.com/Edgar-Grigoryan/gitoon-iOS.git
cd gitoon-iOS

brew install ruby@3.1
brew install fonttools
Comment “pip3 install --user fonttools” in Tools/BuildMaterialDesignIconsFont.sh
$(brew --prefix)/opt/ruby@3.1/bin/bundle install
$(brew --prefix)/opt/ruby@3.1/bin/bundle exec pod install --repo-update
```

Once this completes, you can launch  `GiToon.xcworkspace` and run the `App-Debug` scheme onto your simulator or iOS device.

## Code Signing

Although the app is set up to use Automatic provisioning for Debug builds, you'll need to customize a few of the options. This is because the app makes heavy use of entitlements that require code signing, even for simulator builds.

Edit the file `Configuration/HomeAssistant.overrides.xcconfig` (which will not exist by default and is ignored by git) and add the following:

```bash
DEVELOPMENT_TEAM = YourTeamID
BUNDLE_ID_PREFIX = some.bundle.prefix
```

Xcode should generate provisioning profiles in your Team ID and our configuration will disable features your team doesn't have like Critical Alerts. You can find your Team ID on Apple's [developer portal](https://developer.apple.com/account); it looks something like `ABCDEFG123`.
