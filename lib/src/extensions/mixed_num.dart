import 'package:fraction/fraction.dart';

/// Extension method that adds [MixedFraction] functionalities to [num].
extension MixedFractionNum on num {
  /// Builds a [MixedFraction] from an [int] or a [double].
  ///
  /// If the value cannot be expressed as a mixed fraction, a
  /// [MixedFractionException] exception is thrown.
  MixedFraction toMixedFraction() => MixedFraction.fromFraction(toFraction());
}
