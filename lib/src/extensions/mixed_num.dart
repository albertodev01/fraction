import 'package:fraction/fraction.dart';

/// Extension method that adds [MixedFraction] functionalities to [num].
extension MixedFractionNum on num {
  /// Builds a [MixedFraction] from this number.
  ///
  /// An [int] is converted exactly. A [double] is approximated with
  /// [Fraction.fromDouble] using its default precision:
  ///
  /// ```dart
  ///  1.5.toMixedFraction(); // 1 1/2
  ///  (-0.5).toMixedFraction(); // -1/2
  /// ```
  ///
  /// Throws a [FractionException] if this number is NaN or infinite, or if it
  /// is too large (or too close to zero) to be represented with [int] values.
  MixedFraction toMixedFraction() => MixedFraction.fromFraction(toFraction());
}
