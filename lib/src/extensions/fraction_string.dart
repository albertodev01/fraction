import 'package:fraction/fraction.dart';

/// Adds [Fraction] functionalities to [String]
extension FractionString on String {
  /// Checks whether a string contains a valid representation of a fraction in
  /// the format 'a/b'.
  ///
  ///  * 'a' and 'b' must be integers;
  ///  * there can be the minus sign only in front of a;
  bool isFraction() {
    try {
      Fraction.fromString(this);
      return true;
    } on FractionException {
      return false;
    }
  }

  /// Converts the given string into a [Fraction] object.
  ///
  /// If you want to be sure that this method doesn't throw a [FractionException],
  /// use `isFraction()`.
  Fraction toFraction() => Fraction.fromString(this);
}
