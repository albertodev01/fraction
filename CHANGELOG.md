## [3.0.0]

 - **BREAKING**: the extension method for `Fraction` on `String` now has `bool get isFraction` instead of `bool isFraction()`
 - **BREAKING**: the extension method for `MixedFraction` on `String` now has `bool get isMixedFraction` instead of `bool isMixedFraction()`
 - Added support for egyptian fractions
 - Added support for encoding/decoding unicode fraction glyphs
 - Added the `percentage` property on `Fraction` and `MixedFraction` to express the percentage represented by the fraction
 - Added the `primeFactorization()` method on `Fraction` to find which prime numbers multiply together to make the numerator and denominator

## [2.0.1]

 - Improved static analysis with a more elaborated `analysis_options.yaml` file
 - Dependencies versions update

## [2.0.0]

 - Migration to stable null safety
 - Dependencies versions update

## [2.0.0-nullsafety.2]

 - Minor updates in the README.md file.
 - Minor fixes in the documentation
 - Added `isProper` and `isImproper` getters on `Fraction`

## [2.0.0-nullsafety.1]

 - Minor updates in the README.md file.

## [2.0.0-nullsafety.0]

 - Package migrated to null safety (Dart 2.12).
 - Minor bug fixes on `Fraction`.
 - Fixed various issues in the `MixedFraction`.
 - Added operators overloads for `MixedFraction`.
 - **BREAKING CHANGE**: Now `Fraction` and `MixedFraction` are immutable.
 - **BREAKING CHANGE**: Now `MixedFraction` accepts any kind of fractional value (even improper factions, which will be internally converted).

## [1.2.1]

 - Fixed some health suggestions.

## [1.2.0]

 - Removed Flutter dependencies.
 - Fixes on documentation and examples.
 - Now when calling `toString()` on a fraction whose denominator is 1, only the numerator is printed.
   For example, `Fraction(3, 1).toString()` returns `3` and not `3/1`.

## [1.1.0]

 - Added support for `operator [](int index)`.

## [1.0.1]

 - Fixed some health suggestions.
 - Added a few examples in the repository.

## [1.0.0]

 - `Fraction` and `MixedFraction` have been released.
 - added support to extension methods to create helpers for `num` and `string`.