import 'dart:io';

/// Parses the input received via [stdin] and analyzes the fraction.
abstract class RationalAnalyzer {
  /// The raw input received via [stdin].
  final String input;

  /// Creates a [RationalAnalyzer] instance.
  const RationalAnalyzer(this.input);

  /// Parses the [input] and returns the analysis report as a [String].
  String analyze();
}
