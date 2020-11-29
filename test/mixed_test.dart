import 'package:fraction/fraction.dart';
import 'package:test/test.dart';

void main() {
  // Tests on constructors
  group("Testing the behaviors of the constructors", () {
    test("Making sure that whole, numerator and denominator are correct", () {
      final fraction = MixedFraction(whole: 1, numerator: 5, denominator: 7);

      expect(fraction.whole, equals(1));
      expect(fraction.numerator, equals(5));
      expect(fraction.denominator, equals(7));
      expect(fraction.toString(), equals("1 5/7"));
    });

    test("Making sure that when numerator > denominator, the fraction is 'normalized' "
        "so that the numerator <= denominator relation becomes true", () {
      final fraction1 = MixedFraction(whole: 1, numerator: 5, denominator: 3);

      expect(fraction1.whole, equals(2));
      expect(fraction1.numerator, equals(2));
      expect(fraction1.denominator, equals(3));
      expect(fraction1.toString(), equals("2 2/3"));

      final fraction2 = MixedFraction(whole: 3, numerator: 18, denominator: -7);

      expect(fraction2.whole, equals(-5));
      expect(fraction2.numerator, equals(4));
      expect(fraction2.denominator, equals(7));
      expect(fraction2.toString(), equals("-5 4/7"));

      final fraction3 = MixedFraction(whole: 2, numerator: -6, denominator: 5);

      expect(fraction3.whole, equals(-3));
      expect(fraction3.numerator, equals(1));
      expect(fraction3.denominator, equals(5));
      expect(fraction3.toString(), equals("-3 1/5"));

      final fraction4 = MixedFraction(whole: -5, numerator: -1, denominator: 3);

      expect(fraction4.whole, equals(5));
      expect(fraction4.numerator, equals(1));
      expect(fraction4.denominator, equals(3));
      expect(fraction4.toString(), equals("5 1/3"));
    });

    test("Making sure that negative signs are properly handled", () {
      final fraction1 = MixedFraction(whole: -1, numerator: -4, denominator: 9);

      expect(fraction1.whole, equals(1));
      expect(fraction1.numerator, equals(4));
      expect(fraction1.denominator, equals(9));
      expect(fraction1.toString(), equals("1 4/9"));

      final fraction2 = MixedFraction(whole: -2, numerator: -4, denominator: -11);

      expect(fraction2.whole, equals(-2));
      expect(fraction2.numerator, equals(4));
      expect(fraction2.denominator, equals(11));
      expect(fraction2.toString(), equals("-2 4/11"));

      final fraction3 = MixedFraction(whole: 6, numerator: 2, denominator: -7);

      expect(fraction3.whole, equals(-6));
      expect(fraction3.numerator, equals(2));
      expect(fraction3.denominator, equals(7));
      expect(fraction3.toString(), equals("-6 2/7"));
    });

    test("Making sure that mixed fractions are properly constructed from fractions", () {

    });
  });
}
