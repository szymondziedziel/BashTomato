# BashTomato

Simply just wrapper over ADB written in Bash to automate tasks on devices and/ or emulators.

BashTomato is a hobby project. It is a small script that offers part of functionality from:

- https://developer.android.com/reference/androidx/test/uiautomator/UiObject2
- https://developer.android.com/reference/androidx/test/uiautomator/UiDevice
- https://developer.android.com/reference/android/view/KeyEvent
- and couple of other ADB's commands

and is created to automate simple, daily repetitive work in simple (or not that simple, because of Bash) way.

## Requirements

- ADB installed
- device or emulator properly configured
- ./src/extensions.sh may require additional libs and packages like for example imagemagick for handling better screenshots and inspecting the screen hierarchy in more friendly graphical way

## Benefits

- compatibility with different Androids based on installed ADB
- works with device/ emulator immediately after script started, no code compilation
- Bash is present on most unix-like systems, so no additional configurations and dependencies needed

## Unfortunately

It uses `adb shell uiautomator dump` to get window's hierarchy, so it causes that BashTomato is not able to:

- touch on screen keyboard
- inspect webview's content

## How to use it

- clone repository to your local machine
- create new shell-like script file
- include ./src/bashtomato.sh or a bit minified version ./dist/bashtomato.sh. To have ./dist/bashtomato.sh it is required to execute ./clean_install_build_test.sh (unit and E2E test will be automatically executed. E2E will fail for sure, but BashTomato should work correctly)
- start automate

```sh
#!/bin/bash

source './dist/bashtomato.sh'

# your code goes here
```

for more what your testing code should look like you can refer to ./tests/e2e/example.sh. I used there most of functions offered by BashTomato to test them and show sample usage

## Testing

I used [shUnit2](https://github.com/kward/shunit2#shunit2) to write some unit tests, but also prepared simple apk in ./tests/e2e to be able to run most of BashTomato's functions.

Of course not everything is fully tested as this is very early version.

I run test on emulator Nexus 6 with API 27, 1440x2560 560dpi as tests strictly checks sleep, wake up, resolution, dpi etc., so running on any device will probably fail fast, because there will be nothing to uninstall, no data to clean, device may have screen locked with PIN etc. and/ or resolution may not match.
