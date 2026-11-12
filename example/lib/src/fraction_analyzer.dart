import 'package:fraction/fraction.dart';
import 'package:fraction_example/src/analyzer.dart';

/// {@template fraction_analyzer}
/// Analyzes a [Fraction], reporting its decimal value, its mixed fraction
/// form, its inverse, its negation, its reduced form, and whether it is proper.
/// {@endtemplate}
final class FractionAnalyzer extends RationalAnalyzer {
  /// {@macro fraction_analyzer}
  const new({required String input}) : super(input);

  @override
  String analyze() {
    try {
      // Parsing the fraction
      final fraction = Fraction.fromString(input);

      // Zero has no inverse (it would have a zero denominator)
      final inverse = fraction.numerator == 0
          ? 'undefined'
          : '${fraction.inverse()}';

      // Used to incrementally build the results
      final buffer = StringBuffer()
        ..writeln('\n > ==================== < \n')
        ..writeln('Fraction = $fraction')
        ..writeln('Decimal: ${fraction.toDouble()}')
        ..writeln('Mixed: ${fraction.toMixedFraction()}\n')
        ..writeln('Inverse: $inverse')
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
