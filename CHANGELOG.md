## 0.0.6

- Fixed a bug where max lines would not work properly if we had hyphenation
- Added an example

## 0.0.5

- Now if we hyphenate right after a punctuation character do not add another hyphen

## 0.0.4

- Fixed incorrect semantics

## 0.0.3

- Fixed `build()` modifying text which could result in weird behaviour if Flutter is forced to rebuild the widget (visible when going home and returning to the app on iOS)
- Added the `shouldHyphenate` parameter which allows for blocking hyphenation in certain scenarios

## 0.0.2

- Fixed a crash due to migrating to a custom version of hyphenator
- Now display an error if uninitialized

## 0.0.1

- Initial release
