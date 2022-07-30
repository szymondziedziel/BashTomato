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

## Unfortunately (Update: I added appium as better dumper)

It uses `adb shell uiautomator dump` to get window's hierarchy, so it causes that BashTomato is not able to:

- touch on screen keyboard
- inspect webview's content

## Appium as better dumper

Better until it starts server, creates session on the device, install all additional APKs (may require to user-click-agree), and then will no crash

### Additional requirements:

- Install NodeJS
- Install Appium through NodeJS to make it available globally (I will consider to make it possible to use local Appium installation)
- Install `jq` program. It is for easier Appium server responses handling
- Appium asked me to install Android SDK, so I did just by installing Android Studio (I also have adb thanks to Android Studio)
- And there were problems with lack of exported variables (I have macOS and use ZSH), so:

I added:

```
export ANDROID_HOME="/Users/$USER/Library/Android/sdk"
export ANDROID_SDK_ROOT="/Users/$USER/Library/Android/sdk"
```

to my `~/.zshrc`

To force BashTomato to use Appium export everytime `export BASHTOMATO_HIERARCHY_DUMPER='appium'` (for example in each test before sourcing ./dist/bashtomato.sh) or also add this to your shell file (my is ~/.zshrc)

And that's it. You should not care about starting appium server or preparing annoying capabilities. BashTomato will do the rest for you

### Simple speed test

So I used some old devices. My macOS is simple MacBook Air (13-inch, 2017) and used real device/ smartphone is some huawei with sdk 27; android 8.1.0. So the test says you probably nothing and has nothing to says about your hardrware.

For test I used `utils_wait_to_see` function that fetches whole hierarchy from the device and checks if proper element is visible (by default `utils_wait_to_see` tries 30 times, I searched for non-existing element):

```
#!/bin/bash

device_id="$1"

export BASHTOMATO_HIERARCHY_DUMPER='appium'

source ./BashTomato/dist/bashtomato.sh

date
utils_wait_to_see "$device_id" 'Jetsurvey2'
date
```

And results I got are:
For ADB uiautomator dump:
```
start Sat Jul 30 11:14:34 CEST 2022
null
stop Sat Jul 30 11:15:54 CEST 2022
```
For Appium when server is down (I have put 10 second sleep to give server chance to be fully ready !that should be done better!):
```
start Sat Jul 30 11:42:20 CEST 2022
null
stop Sat Jul 30 11:42:51 CEST 2022
```
For Appium when server is up:
```
start Sat Jul 30 11:42:58 CEST 2022
null
stop Sat Jul 30 11:43:17 CEST 2022
```

It about 300% of previous speed. It is better?
- Yes because tests can be more accurate
- No because functions like `utils_wait_to_see` that are attempts count based works faster so waits shorter
- Yes because it's faster
- No because it adds more dependencies that can complicated the process, crash, block ports etc.

### Appium as better dumper troubleshooting

As this is only test of such extension, so it runs on default 0.0.0.0:4723 (I will consider to make it configurable if it will work stable enough)
In case of any error try to kill all appium services, but before you will restart everything, please try to investigate problem with:

`pgrep appium`, `ps | grep appium` and/ or `lsof -i :4723` and/ or `kill $PID` where $PID can be taken from two first commands

### Appium as better dumper LICENSE

Please see NOTICE.md

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
