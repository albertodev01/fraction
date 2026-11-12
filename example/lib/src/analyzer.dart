import 'package:fraction/fraction.dart';

/// {@template rational_analyzer}
/// Analyzes an [input] string that represents a [Fraction] or a
/// [MixedFraction].
///
/// The [analyze] method parses [input] and returns a report with various
/// properties of the parsed value, ready to be printed to the console.
/// {@endtemplate}
abstract base class RationalAnalyzer {
  /// {@macro rational_analyzer}
  const new(this.input);

  /// The string to analyze, such as `'3/4'` for a fraction or `'1 1/2'` for a
  /// mixed fraction.
  final String input;

  /// Parses [input] and returns a report with its properties.
  ///
  /// If [input] is not valid, the returned string is an error message: this
  /// method never throws.
  String analyze();
}
