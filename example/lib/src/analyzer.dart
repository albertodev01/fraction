import 'package:fraction/fraction.dart';

/// This base class is used to analyze an [input] string.
///
/// The [analyze] method tries to convert [input] into a [Fraction] or
/// [MixedFraction] object and prints various properties to the console.
abstract base class RationalAnalyzer {
  /// The fraction or mixed fraction input.
  final String input;

  /// Creates a [RationalAnalyzer] object.
  const RationalAnalyzer(this.input);

  /// Tries to convert [input] into a [Fraction] or [MixedFraction] object and
  /// returns an analysis report.
  String analyze();
}
