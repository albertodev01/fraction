import 'package:fraction/fraction.dart';

/// Extension method that adds [MixedFraction] functionalities to [String].
extension MixedFractionString on String {
  /// Checks whether this [String] contains a valid representation of a mixed
  /// fraction in the 'a b/c' format. In particular:
  ///
  ///  - 'a', 'b', and 'c' must be integers;
  ///  - there can be the minus sign only in front of 'a';
  ///  - there must be exactly one space between the whole part and the
  ///  fractional part.
  bool get isMixedFraction {
    try {
      MixedFraction.fromString(this);

      return true;
    } on Exception {
      return false;
    }
  }

  /// Converts the string into a [MixedFraction].
  ///
  /// If you want to be sure that this method doesn't throw an exception, use
  /// the [isMixedFraction] getter before.
  MixedFraction toMixedFraction() => MixedFraction.fromString(this);
}
