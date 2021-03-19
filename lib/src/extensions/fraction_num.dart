import 'package:fraction/fraction.dart';

/// Adds [Fraction] functionalities to [num].
extension FractionNum on num {
  /// Returns the fractional representation of an [int] or a [double].
  Fraction toFraction() {
    if (this is int) {
      return Fraction(toInt());
    } else {
      return Fraction.fromDouble(toDouble());
    }
  }
}
