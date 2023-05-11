import 'package:fraction/fraction.dart';
import 'package:fraction_example/src/analyzer.dart';

/// Tries to convert a [String] into a [MixedFraction].
final class MixedFractionAnalyzer extends RationalAnalyzer {
  /// Creates a [MixedFractionAnalyzer] object.
  const MixedFractionAnalyzer({required String input}) : super(input);

  @override
  String analyze() {
    try {
      // Parsing the fraction
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
