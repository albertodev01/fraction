import 'package:fraction/fraction.dart';
import 'package:test/test.dart';

void main() {
  group("Testing the extension method on 'num'", () {
    test('Making sure that integers are properly converted into fractions', () {
      expect(13.toFraction(), equals(Fraction(13)));
      expect((-3).toFraction(), equals(Fraction(-3)));
      expect(0.toFraction(), equals(Fraction(0)));
    });

    test('Making sure that doubles are properly converted into fractions', () {
      expect(8.46.toFraction(), equals(Fraction(423, 50)));
      expect((-3.9).toFraction(), equals(Fraction(-39, 10)));
      expect(0.toFraction(), equals(Fraction(0)));
      expect(double.nan.toFraction, throwsA(isA<FractionException>()));
      expect(double.infinity.toFraction, throwsA(isA<FractionException>()));
      expect(
        double.negativeInfinity.toFraction,
        throwsA(isA<FractionException>()),
      );
    });
  });
}
