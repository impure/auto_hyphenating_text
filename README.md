`AutoHyphenatingText` is a drop in replacement for the default `Text` that supports autohyphenating text.

![Demo](https://media4.giphy.com/media/iAfRO9amZZNe8MwFG1/giphy.gif)

## Usage

This package needs to be initialized using the following:

```dart
await initHyphenation();
```

This will load the hyphenation algorithm. You can skip this step if you manually initialized the hyphenation algorithm yourself.

Then it can be used as a drop in replacement for normal text. So

```dart
Text("abc");
```

becomes

```dart
AutoHyphenatingText("abc");
```
