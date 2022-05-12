import 'package:fraction/fraction.dart';

/// Extension method that adds [Fraction] functionalities to [String].
extension FractionString on String {
  /// Checks whether the string contains a valid representation of a fraction in
  /// the format 'a/b'.
  ///
  /// Note that 'a' and 'b' must be integers.
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

  /// Converts the string into a [Fraction].
  ///
  /// If you want to be sure that this method doesn't throw a [FractionException],
  /// use `isFraction` before.
  Fraction toFraction() {
    try {
      return Fraction.fromString(this);
    } on FractionException {
      return Fraction.fromGlyph(this);
    }
  }
}
