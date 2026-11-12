import 'package:fraction/fraction.dart';
import 'package:fraction_example/src/analyzer.dart';

/// {@template mixed_fraction_analyzer}
/// Analyzes a [MixedFraction], reporting its decimal value, its fraction
/// form, its negation, and its reduced form.
/// {@endtemplate}
final class MixedFractionAnalyzer extends RationalAnalyzer {
  /// {@macro mixed_fraction_analyzer}
  const new({
    required String input,
  }) : super(input);

  @override
  String analyze() {
    try {
      // Parsing the mixed fraction
      final mixedFraction = MixedFraction.fromString(input);

      // Used to incrementally build the results
      final buffer = StringBuffer()
        ..writeln('\n > ==================== < \n')
        ..writeln('Mixed fraction = $mixedFraction')
        ..writeln('Decimal: ${mixedFraction.toDouble()}')
        ..writeln('Fraction: ${mixedFraction.toFraction()}\n')
        ..writeln('Negate: ${mixedFraction.negate()}')
        ..writeln('Reduced: ${mixedFraction.reduce()}');

      return buffer.toString();
    } on Exception {
      return "\n - The mixed fraction you've entered is not correct!\n";
    }
  }
}
