import 'package:fraction/fraction.dart';

/// Extension method that adds [Fraction] functionalities to [String].
extension FractionString on String {
  /// Checks whether this [String] is either:
  ///
  ///  - a valid fraction in the 'a/b' (or 'a') format, as accepted by
  ///    [Fraction.fromString];
  ///  - a single fraction glyph character, as accepted by [Fraction.fromGlyph].
  ///
  /// For example, this getter returns `true` if this [String] is `'1/4'` or
  /// `'⅝'`, and `false` for `'1/4 '` (surrounding whitespace is not allowed).
  bool get isFraction {
    try {
      Fraction.fromString(this);

      return true;
    } on Exception {
      try {
        Fraction.fromGlyph(this);

        return true;
      } on Exception {
        return false;
      }
    }
  }

  /// Converts this [String] into a [Fraction]. Both the 'a/b' format and
  /// fraction glyphs (such as `'½'`) are supported.
  ///
  /// Throws a [FractionException] if this [String] is not a valid fraction.
  /// Use [isFraction] to check the string beforehand, or [Rational.tryParse]
  /// to get `null` instead of an exception.
  Fraction toFraction() {
    try {
      return Fraction.fromString(this);
    } on FractionException {
      return Fraction.fromGlyph(this);
    }
  }
}
