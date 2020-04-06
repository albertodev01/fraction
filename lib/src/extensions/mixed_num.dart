import 'package:fraction/fraction.dart';

/// Adds [MixedFraction] functionalities to [num]
extension MixedFractionNum on num {

  /// Returns a mixed fraction representation the given value.
  ///
  /// If the number cannot be expressed as a mixed fraction, an exception of type
  /// [MixedFractionException] is thrown.
  MixedFraction toMixedFraction() {
    return MixedFraction.fromFraction(
      toFraction()
    );
  }

}