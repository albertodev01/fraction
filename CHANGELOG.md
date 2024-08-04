## 5.0.3
 - Updated Dart SDK constraints to `^3.4.0` 
 - Dependencies update
 - Minor documentation improvements

## 5.0.2
 - Updated Dart SDK constraints to `^3.1.0` 
 - Dependencies update

## 5.0.1
 - Dependencies update

## 5.0.0 
 - **BREAKING**: `Rational`, `Fraction` and `MixedFraction` types have the `base` modifier.
 - Updated Dart SDK constraints to `^3.0.0`
 - Improved documentation and added more linter rules
 - Dependencies update

## 4.1.4
 - Increased pubspec description length to raise the score at `pub.dev`

## 4.1.3
 - Updated Dart SDK constraints to `">=2.18.0 <3.0.0"`
 - Added more inline documentation
 - Dependencies update

## 4.1.2
 - Added the `MixedFraction.fromDouble` method
 - Dependencies update

## 4.1.1
 - Added more linter rules
 - Dependencies updates

## 4.1.0
 - Updated Dart SDK constraints to `">=2.17.0 <3.0.0"`
 - CHANGELOG.md updates
 - Dependencies updates
 
## 4.0.1
 - Fixed a typo in the CHANGELOG.md file

## 4.0.0
 - **BREAKING**: the `EgyptianFraction` class is not public anymore, it's been hidden in the internals of the package. The reason is that an egyptian fraction is not a **kind** of fraction but it's a **way of representing** a fraction: the `EgyptianFraction` type may be misleading (and it should have been called `EgyptianFractionConverter` since the beginning). The migration is very easy:
```dart
// Old code
EgyptianFraction(
  fraction: Fraction(5, 8),
).compute(); // [1/2 + 1/8]

EgyptianFraction.fromMixedFraction(
  mixedFraction: MixedFraction(2, 4, 5),
).compute(); // [1 + 1 + 1/2 + 1/4 + 1/20]

// New code
Fraction(5, 8).toEgyptianFraction(); // [1/2 + 1/8]
MixedFraction(2, 4, 5).toEgyptianFraction(); // [1 + 1 + 1/2 + 1/4 + 1/20]
```
 - Added the `Rational` abstract supertype of `Fraction` and `MixedFraction`, which also adds the `tryParse` method:
```dart
// If the string is valid, it either returns a 'Fraction' or a 'MixedFraction'
Rational.tryParse('2/5');   // 2/5;
Rational.tryParse('2 4/5'); // 2 4/5;

// If the string is invalid, it returns 'null'
Rational.tryParse('/5');    // null
Rational.tryParse('');      // null
```
 - CHANGELOG.md updates
 - Dependencies updates

## 3.2.2
 - **BREAKING**: removed `EgyptianFraction.clearCache()` and `EgyptianFraction.cachingEnabled`. Caching is now always enabled by default and the cache cannot be purged.
 - Increased Dart SDK constraints (`>=2.14.0 <3.0.0`)
 - Minor fixes in the `example/` folder
 - Dependencies updates

## 3.2.1
 - Added some more rules in `analysis_options.yaml`
 - Dependencies updates

## 3.2.0
 - Added a small Dart CLI application in the `example/` folder
 - Minor fixes on the `MixedFraction` type
 - Dependencies updates

## 3.1.1
 - Added some more `dart_code_metrics` rules and minor README fixes
 - Code polish
 - Dependencies updates

## 3.1.0
 - Added stricter linter rules with `lints` and `dart_code_metrics` packages
 - Dependencies updates

## 3.0.2
 - Dependencies updates
 - Fixed formatting to increase pub score

## 3.0.1
 - Added the `toEgyptianFraction()` method on `Fraction` and `MixedFraction`
 - Added a the new named constructor `EgyptianFraction.fromMixedFraction()`
 - Minor documentation fixes

## 3.0.0

 - **BREAKING**: the extension method for `Fraction` on `String` now has `bool get isFraction` instead of `bool isFraction()`
 - **BREAKING**: the extension method for `MixedFraction` on `String` now has `bool get isMixedFraction` instead of `bool isMixedFraction()`
 - Added support for egyptian fractions
 - Added support for encoding/decoding unicode fraction glyphs
 - Added the `percentage` property on `Fraction` and `MixedFraction` to express the percentage represented by the fraction
 - Added the `primeFactorization()` method on `Fraction` to find which prime numbers multiply together to make the numerator and denominator

## 2.0.1

 - Improved static analysis with a more elaborated `analysis_options.yaml` file
 - Dependencies versions update

## 2.0.0

 - Migration to stable null safety
 - Dependencies versions update

## 2.0.0-nullsafety.2

 - Minor updates in the README.md file.
 - Minor fixes in the documentation
 - Added `isProper` and `isImproper` getters on `Fraction`

## 2.0.0-nullsafety.1

 - Minor updates in the README.md file.

## 2.0.0-nullsafety.0

 - Package migrated to null safety (Dart 2.12).
 - Minor bug fixes on `Fraction`.
 - Fixed various issues in the `MixedFraction`.
 - Added operators overloads for `MixedFraction`.
 - **BREAKING CHANGE**: Now `Fraction` and `MixedFraction` are immutable.
 - **BREAKING CHANGE**: Now `MixedFraction` accepts any kind of fractional value (even improper factions, which will be internally converted).

## 1.2.1

 - Fixed some health suggestions.

## 1.2.0

 - Removed Flutter dependencies.
 - Fixes on documentation and examples.
 - Now when calling `toString()` on a fraction whose denominator is 1, only the numerator is printed.
   For example, `Fraction(3, 1).toString()` returns `3` and not `3/1`.

## 1.1.0

 - Added support for `operator [](int index)`.

## 1.0.1

 - Fixed some health suggestions.
 - Added a few examples in the repository.

## 1.0.0

 - `Fraction` and `MixedFraction` have been released.
 - added support to extension methods to create helpers for `num` and `string`.
