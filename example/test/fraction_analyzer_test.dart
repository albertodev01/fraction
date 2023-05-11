import 'package:fraction/fraction.dart';
import 'package:fraction_example/fraction_example.dart';
import 'package:test/test.dart';

void main() {
  group("Testing the 'FractionAnalyzer' class", () {
    test('Making sure that valid fractions can be analyzed', () {
      const analyzer = FractionAnalyzer(
        input: '8/12',
      );

      // Building the expected result
      final fraction = Fraction(8, 12);
      final buffer = StringBuffer()
        ..writeln('\n > ==================== < \n')
        ..writeln('Fraction = $fraction')
        ..writeln('Decimal: ${fraction.toDouble()}')
        ..writeln('Mixed: ${fraction.toMixedFraction()}\n')
        ..writeln('Inverse: ${fraction.inverse()}')
        ..writeln('Negate: ${fraction.negate()}')
        ..writeln('Reduced: ${fraction.reduce()}\n')
        ..writeln('Is proper? ${fraction.isProper}')
        ..writeln('Is improper? ${fraction.isImproper}');

      expect(
        analyzer.analyze(),
        equals(buffer.toString()),
      );
    });

    test('Making sure that invalid fractions report an error', () {
      const analyzer = FractionAnalyzer(
        input: '',
      );

      expect(
        analyzer.analyze(),
        equals("\n - The fraction you've entered is not correct!\n"),
      );
    });
  });
}
