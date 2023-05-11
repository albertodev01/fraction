import 'package:fraction/fraction.dart';
import 'package:fraction_example/fraction_example.dart';
import 'package:test/test.dart';

void main() {
  group("Testing the 'MixedFractionAnalyzer' class", () {
    test('Making sure that valid fractions can be analyzed', () {
      const analyzer = MixedFractionAnalyzer(
        input: '6 7/3',
      );

      // Building the expected result
      final mixedFraction = MixedFraction(
        whole: 6,
        numerator: 7,
        denominator: 3,
      );
      final buffer = StringBuffer()
        ..writeln('\n > ==================== < \n')
        ..writeln('Mixed fraction = $mixedFraction')
        ..writeln('Decimal: ${mixedFraction.toDouble()}')
        ..writeln('Fraction: ${mixedFraction.toFraction()}\n')
        ..writeln('Negate: ${mixedFraction.negate()}')
        ..writeln('Reduced: ${mixedFraction.reduce()}');

      expect(
        analyzer.analyze(),
        equals(buffer.toString()),
      );
    });

    test('Making sure that invalid fractions report an error', () {
      const analyzer = MixedFractionAnalyzer(
        input: '',
      );

      expect(
        analyzer.analyze(),
        equals("\n - The mixed fraction you've entered is not correct!\n"),
      );
    });
  });
}
