# BashTomato

Simply just wrapper over ADB, to automate tasks on devices or emulators written in bash.

BashTomato is a hobby project. It is a small script that offers part of functionality of:

- https://developer.android.com/reference/androidx/test/uiautomator/UiObject2
- https://developer.android.com/reference/androidx/test/uiautomator/UiDevice
- https://developer.android.com/reference/android/view/KeyEvent
- and couple of other ADB's commands

and is created to allow to automate simple, daily repetitive work in simple (or not that simple, because of bash) way.

## Requirements

- ADB installed
- device or emulator properly configured

## Benefits

- compatibility with different Androids based on installed ADB compatibility
- works immediately after script started
- bash is on most unix-like systems, so no additional configrations and dependencies needed

## How to use it

- clone repository to your local machine
- create new shell-like file
- include ./src/bashtomato.sh or a bit minified version ./dist/bashtomato.sh. To have ./dist/bashtomato.sh it is required to execute ./clean_install_build_test.sh
- start automate

```
#!/bin/bash

source '../bashtomato/bashtomato.sh'

# your code goes here
```

for more what your code should look like you can refer to ./tests/e2e/example.sh. I used there most of functions offered by BashTomato.

## Testing

I used [shUnit2](https://github.com/kward/shunit2#shunit2) to write some unit tests, but also prepared simple apk in ./tests/e2e to be able to run most of BashTomato's functions.

Of course not all if fully tested as this is very early version.
