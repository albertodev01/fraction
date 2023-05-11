import 'package:fraction/fraction.dart';

/// Extension method that adds [Fraction] functionalities to [String].
extension FractionString on String {
  /// Checks whether the [String] either:
  ///
  ///  - contains a valid representation of a fraction in the 'a/b' format;
  ///  - contains a fraction glyph character.
  ///
  /// For example, this getter returns `true` if this [String] is `'1/4'` or
  /// `'⅝'`.
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

  /// Converts this [String] into a [Fraction].
  ///
  /// If you want to be sure that this method doesn't throw an exception, use
  /// the [isFraction] getter before.
  Fraction toFraction() {
    try {
      return Fraction.fromString(this);
    } on FractionException {
      return Fraction.fromGlyph(this);
    }
  }
}
