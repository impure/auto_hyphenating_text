## 0.3.1

- Cursor now has 0 width when selectable text is enabled
- Explicit newlines are now respected

## 0.3.0

- Initialization is now done all at once instead of once per widget. This shouldn’t change much unless you were passing in a custom `ResourceLoader`. It now has to be a `Hyphenator`.

## 0.2.0

- Now using the new `textScaler` introduced in Flutter 3.16 (requires Flutter 3.16)

## 0.1.3

- Now soft hyphens are taken into consideration (#12)

## 0.1.2

- Now if we have ellipsis disable hyphenation (#5)
- Moved files around

## 0.1.1

- Text can now be selectable using the new `selectable` parameter (#9)

## 0.1.0

- Now `TextOverflow.ellipsis` should work properly
- Hyphenation character can be customized (#8)

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
