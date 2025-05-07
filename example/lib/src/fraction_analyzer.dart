import 'package:fraction/fraction.dart';
import 'package:fraction_example/src/analyzer.dart';

/// {@template FractionAnalyzer}
/// Tries to convert a [String] into a [Fraction].
/// {@endtemplate}
final class FractionAnalyzer extends RationalAnalyzer {
  /// {@macro FractionAnalyzer}
  const FractionAnalyzer({required String input}) : super(input);

  @override
  String analyze() {
    try {
      // Parsing the fraction
      final fraction = Fraction.fromString(input);

      // Used to incrementally build the results
      final buffer =
          StringBuffer()
            ..writeln('\n > ==================== < \n')
            ..writeln('Fraction = $fraction')
            ..writeln('Decimal: ${fraction.toDouble()}')
            ..writeln('Mixed: ${fraction.toMixedFraction()}\n')
            ..writeln('Inverse: ${fraction.inverse()}')
            ..writeln('Negate: ${fraction.negate()}')
            ..writeln('Reduced: ${fraction.reduce()}\n')
            ..writeln('Is proper? ${fraction.isProper}')
            ..writeln('Is improper? ${fraction.isImproper}');

      return buffer.toString();
    } on Exception {
      return "\n - The fraction you've entered is not correct!\n";
    }
  }
}
