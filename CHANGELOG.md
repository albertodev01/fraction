## 6.0.1
 - Added `toContinuedFraction()` to `Rational` (and so to `Fraction` and `MixedFraction`), which returns the terms of the simple continued fraction (for example, `Fraction(7, 9).toContinuedFraction()` is `[0, 1, 3, 2]`).

## 6.0.0
 - Updated Dart SDK constraints to `^3.14.0`
 - Dependencies update
 - Rewrote the README and improved the inline documentation
 - **BREAKING** (`Fraction`): arithmetic operators (`+`, `-`, `*`, `/`) now always return results in lowest terms (for example, `Fraction(5, 7) * Fraction(1, 5)` is now `1/7` instead of `5/35`).
 - **BREAKING** (`Fraction`): arithmetic operators throw a `FractionException` when the result does not fit in an `int`, instead of silently overflowing. Dividing by zero also throws a `FractionException`.
 - **BREAKING** (`Fraction`): `Fraction.fromString` (and `String.toFraction()`) now require the whole string to be a fraction. Strings such as `"1/2 "`, `"1/2/3"` and `"1.5"` are rejected, and every invalid input throws a `FractionException` (some used to throw a `FormatException`).
 - **BREAKING** (`Fraction`): `Fraction.fromDouble` throws a `FractionException` if `precision` is not positive, or if the value is too large (or too close to zero) to be represented with `int` values. When the requested precision can't be reached within the `int` range, the closest approximation that fits is returned.
 - **BREAKING** (`Fraction`): `isWhole` now works on unreduced fractions (`Fraction(16, 2).isWhole` is `true`).
 - **BREAKING** (`Fraction`): `isProper` and `isImproper` now ignore the sign (`Fraction(-1, 2)` is proper, `Fraction(-5, 2)` is improper).
 - **BREAKING** (`Fraction`): equivalent fractions now have the same `hashCode`, so they behave correctly in sets and maps. As a consequence, `toStringAsGlyph()` and `isFractionGlyph` also work on unreduced fractions (`Fraction(2, 4).toStringAsGlyph()` returns `½`).
 - **BREAKING** (`MixedFraction`): the sign is now stored separately and exposed by `isNegative`. The `whole`, `numerator` and `denominator` values are never negative, so negative values with no whole part (such as `-1/2`) can now be represented. Migration:

```dart
final mixed = MixedFraction(whole: -2, numerator: 1, denominator: 3);

// Old code
mixed.whole; // -2

// New code
mixed.whole; // 2
mixed.isNegative; // true
mixed.toString(); // -2 1/3 (unchanged)
```
 - **BREAKING** (`MixedFraction`): a negative sign on either the whole part or the fractional part makes the whole value negative. If both are negative, a `MixedFractionException` is thrown (previously, the two signs cancelled out).
 - **BREAKING** (`MixedFraction`): a fractional part equal to 1 is normalized (`3 4/4` becomes `4`), and `isWhole` is now `true` whenever there is no fractional part.
 - **BREAKING** (`MixedFraction`): `copyWith` keeps the sign of the original mixed fraction (copying `-2 1/2` with `whole: 4` gives `-4 1/2`).
 - **BREAKING** (`MixedFraction`): `MixedFraction.fromString` rejects a fractional part without a slash (`'1 3'`) and strings where both parts are negative (`'-1 -2/5'`). Every invalid input now throws a `MixedFractionException`. The sign can be placed on either part, and `'-0 1/2'` is parsed as `-1/2`.
 - **BREAKING** (`MixedFraction`): zero is printed as `0` instead of `0/1`.
 - Fixed `MixedFraction` subtraction, which computed `b - a` instead of `a - b`.
 - Fixed `MixedFraction.toDouble()` for negative values (`-2 4/5` returned `-1.2`).
 - Fixed `Fraction.toMixedFraction()` for negative values (`-5/4` became `-1 3/4`, and `-1/2` lost its sign).
 - Fixed `Fraction.fromDouble` and `num.toFraction()` hanging forever on very large or very small values (such as `1e300`).
 - Fixed `==` on `Fraction` and `MixedFraction`, which could overflow and report different values as equal.
 - Fixed `compareTo` and the comparison operators (`<`, `<=`, `>`, `>=`), which compared `double` approximations and could give wrong results for close or large values. Comparisons are now exact.
 - Fixed `Rational.tryParse` throwing on Unicode glyphs (such as `'½'`) instead of parsing them.
 - Fixed the Egyptian fraction cache: modifying a returned list corrupted later results. The cache has been removed, so it no longer grows without bound.
 - Fixed `MixedFraction.toFraction()` silently overflowing for large values.

## 5.0.5
 - Updated Dart SDK constraints to `^3.7.2` 
 - Dependencies update
 - Minor documentation fixes

## 5.0.4
 - Updated Dart SDK constraints to `^3.6.0` 
 - Dependencies update
 - Mixed fractions now return just the whole part when the numerator is 0

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
 - Added support to extension methods to create helpers for `num` and `string`.
