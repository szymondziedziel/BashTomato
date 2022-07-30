# Licensing of the project

## Generally all files uses MIT License:

[MIT](https://github.com/szymondziedziel/BashTomato/blob/main/LICENSE)

## Except:

### Appium better dumper extension

[Apache License](https://github.com/appium/appium/blob/master/LICENSE)

File:
`./src/uidevice.sh`

Function:
`uid_dump_window_hierarchy_with_appium`

Just do not `export BASHTOMATO_HIERARCHY_DUMPER='appium'` and it will not be used.

This is probably not the license problem as Appium is used/ listed as required depencency, but still be aware and careful with licenses

Feel free to write to me/ correct me if I understand it wrong
