import 'package:fraction/fraction.dart';

/// Extension method that adds [MixedFraction] functionalities to [String].
extension MixedFractionString on String {
  /// Checks whether this [String] is a valid mixed fraction, as accepted by
  /// [MixedFraction.fromString]. In particular:
  ///
  ///  - it must be in the 'a b/c' format, where 'a', 'b' and 'c' are integers,
  ///    or in the 'a ⅐' format, where the fractional part is a glyph;
  ///  - there must be exactly one space between the whole part and the
  ///    fractional part, and no surrounding whitespace;
  ///  - a minus sign can be placed in front of either 'a' or 'b', but not both.
  ///
  /// For example, this getter returns `true` for `'1 1/2'`, `'-2 3/4'`,
  /// `'2 -3/4'` and `'3 ⅐'`, and `false` for `'1 3'` and `'-1 -1/2'`.
  bool get isMixedFraction {
    try {
      MixedFraction.fromString(this);
      return true;
    } on Exception {
      return false;
    }
  }

  /// Converts this [String] into a [MixedFraction].
  ///
  /// Throws a [MixedFractionException] if this [String] is not a valid mixed
  /// fraction. Use [isMixedFraction] to check the string beforehand, or
  /// [Rational.tryParse] to get `null` instead of an exception.
  MixedFraction toMixedFraction() => MixedFraction.fromString(this);
}
