# App Center Github Action

![Sample workflow for App Center action](https://github.com/wzieba/AppCenter-Github-Action/workflows/Sample%20workflow%20for%20App%20Center%20action/badge.svg?branch=master)
<a href="https://github.com/wzieba/AppCenter-Github-Action/releases">![](https://img.shields.io/github/v/release/wzieba/AppCenter-Github-Action)</a>

This action uploads artifacts (.apk or .ipa) to Visual Studio App Center.

## Inputs

### `appName`

**Required** username followed by App name e.g. `wzieba/Sample-App`

### `token`

**Required** Upload token - you can get one from appcenter.ms/settings

### `group`

**Required** Distribution group (or multiple groups split by **;** delimiter)

### `file`

**Required** Artifact to upload (.apk or .ipa)

### `buildVersion`

Build version parameter required for .zip, .msi, .pkg and .dmg files

### `buildNumber`

Build number parameter required for macOS .pkg and .dmg files

### `mappings`

Android mappings.txt file location. See [the documentation](https://developer.android.com/studio/build/shrink-code) for details

### `symbols`

iOS debug symbol file (.dSYM) location. See [the documentation](https://docs.microsoft.com/en-us/appcenter/diagnostics/ios-symbolication) for details

### `releaseNotes`

Release notes visible on App Center's Release page

### `gitReleaseNotes`

Generate release notes based on the latest git commit

### `notifyTesters`

If set to true, an email notification is sent to the distribution group

### `debug`

If set to true, shows useful debug information from the action execution.

## Requirements

This action is Docker-based. It means **it can only execute on runners with a Linux operating system**.
See Github Actions [documentation](https://docs.github.com/en/actions/creating-actions/about-actions#docker-container-actions) for details.

## Sample usage

Android:
```
name: Build, code quality, tests

on: [push]

jobs:
  build:

    runs-on: ubuntu-latest

    steps:
    - uses: actions/checkout@v1
    - name: set up JDK 1.8
      uses: actions/setup-java@v1
      with:
        java-version: 1.8
    - name: build release
      run: ./gradlew assembleRelease
    - name: upload artefact to App Center
      uses: wzieba/AppCenter-Github-Action@v1
      with:
        appName: wzieba/Sample-App
        token: ${{secrets.APP_CENTER_TOKEN}}
        group: Testers
        file: app/build/outputs/apk/release/app-release-unsigned.apk
        mappings: app/build/outputs/mappings/release/mappings.txt
        notifyTesters: true
        debug: false
```

iOS
```
name: Build, code quality, tests

on: [push]

jobs:
  build:

    runs-on: ubuntu-latest

    steps:
    - uses: actions/checkout@v1
    - name: set up JDK 1.8
      uses: actions/setup-java@v1
      with:
        java-version: 1.8
    - name: build release
      run: ./gradlew assembleRelease
    - name: upload artefact to App Center
      uses: wzieba/AppCenter-Github-Action@v1
      with:
        appName: wzieba/Sample-App
        token: ${{secrets.APP_CENTER_TOKEN}}
        group: Testers
        file: path/to/iOS.ipa
        symbols: path/to/crash_symbols.dSYM
        notifyTesters: true
```
