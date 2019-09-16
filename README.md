# App Center Github Action

This action uploads artefacts (.apk or .ipa) to Visual Studio App Center.

## Inputs

### `appName`

**Required** App name followed by username e.g. `wzieba/Sample-App`

### `token`

**Required** Upload token - you can get one from appcenter.ms/settings

### `group`

**Required** Distribution group

### `file`

**Required** Artefact to upload (.apk or .ipa)

### `releaseNotes`

Release notes visible on release page



## Example usage

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
      uses: wzieba/App-Center-action@v1.0.0
      with:
        appName: wzieba/Sample-App
        token: ${{secrets.APP_CENTER_TOKEN}}
        group: Testers
        file: app/build/outputs/apk/release/app-release-unsigned.apk
```
