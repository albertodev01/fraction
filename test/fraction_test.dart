import 'dart:math' as math;

import 'package:fraction/fraction.dart';
import 'package:test/test.dart';

void main() {

  group("Constructors", () {
    test("Making sure that numerator and denominator are correct", () {
      final fraction = Fraction(5, 7);

      expect(fraction.numerator, equals(5));
      expect(fraction.denominator, equals(7));
      expect(fraction.toString(), "5/7");
    });

    test("Making sure that the sign on the numerator persists", () {
      final fraction = Fraction(-5, 7);

      expect(fraction.numerator, equals(-5));
      expect(fraction.denominator, equals(7));
      expect(fraction.toString(), "-5/7");
    });

    test("Making sure that the sign on the denominator is moved to the numerator", () {
      final fraction = Fraction(5, -7);

      expect(fraction.numerator, equals(-5));
      expect(fraction.denominator, equals(7));
      expect(fraction.toString(), "-5/7");
    });

    test("Making sure that whole fractions have the denominator = 1", () {
      final fraction = Fraction(10);

      expect(fraction.numerator, equals(10));
      expect(fraction.denominator, equals(1));
      expect(fraction.toString(), "10");

      final negativeFraction = Fraction(-8);

      expect(negativeFraction.numerator, equals(-8));
      expect(negativeFraction.denominator, equals(1));
      expect(negativeFraction.toString(), "-8");
    });

    test("Making sure an exception is thrown ONLY when the denominator is zero", () {
      expect(() => Fraction(1, 0), throwsA(isA<FractionException>()));
      expect(Fraction(0), equals(Fraction(0, 1)));
    });

    test("Making sure that the 'fromString()' constructor handles strings properly", () {
      // Valid conversions
      expect(Fraction.fromString("3/5"), equals(Fraction(3, 5)));
      expect(Fraction.fromString("-3/5"), equals(Fraction(-3, 5)));
      expect(Fraction.fromString("7"), equals(Fraction(7, 1)));
      expect(Fraction.fromString("-6"), equals(Fraction(-6, 1)));

      // Invalid conversions
      expect(() => Fraction.fromString("2/-5"), throwsA(isA<FractionException>()));
      expect(() => Fraction.fromString("1/-0"), throwsA(isA<FractionException>()));
      expect(() => Fraction.fromString("2/0"), throwsA(isA<FractionException>()));
      expect(() => Fraction.fromString("0/0"), throwsA(isA<FractionException>()));

      // Invalid formats
      expect(() => Fraction.fromString("2/"), throwsA(isA<FormatException>()));
      expect(() => Fraction.fromString("3/a"), throwsA(isA<FormatException>()));
    });

    test("Making sure that the 'fromDouble()' constructor handles strings properly", () {
      // Valid conversions
      expect(Fraction.fromDouble(5.6), equals(Fraction(28, 5)));
      expect(Fraction.fromDouble(0.0025), equals(Fraction(1, 400)));
      expect(Fraction.fromDouble(-3.8), equals(Fraction(-19, 5)));
      expect(Fraction.fromDouble(0), equals(Fraction(0, 1)));

      // Invalid conversions
      expect(() => Fraction.fromDouble(double.nan), throwsA(isA<FractionException>()));
      expect(() => Fraction.fromDouble(double.infinity), throwsA(isA<FractionException>()));
    });
  });

  group("Testing objects equality", () {
    test("Making sure that fractions comparison is made via cross product", () {
      // 3/12 == 1/4 because 3*4 == 12*1
      expect(Fraction(3, 12), equals(Fraction(1, 4)));

      // 3/12 == 3/12 because 3*12 == 12*3
      expect(Fraction(3, 12), equals(Fraction(3, 12)));

      // 0/2 == 0/1 because 0*1 == 2*0
      expect(Fraction(0, 2), equals(Fraction(0, 1)));
    });

    test("Making sure that 'compareTo' returns 1, -1 or 0 according with the natural sorting", () {
      expect(Fraction(2).compareTo(Fraction(8)), equals(-1));
      expect(Fraction(2).compareTo(Fraction(-4)), equals(1));
      expect(Fraction(6).compareTo(Fraction(6)), equals(0));
    });
  });

  group("Testing the API of the Fraction class", () {
    test("Making sure conversions to double are correct", () {
      expect(Fraction(10, 2).toDouble(), equals(5.0));
      expect(Fraction(-6, 8).toDouble(), equals(-0.75));
    });

    test("Making sure that the inverse is another fraction with swapped values", () {
      expect(Fraction(10, 2).inverse(), equals(Fraction(2, 10)));
      expect(Fraction(-10, 2).inverse(), equals(Fraction(-2, 10)));
    });

    test("Making sure that negation changes the sign", () {
      expect(Fraction(-2, 4).negate(), equals(Fraction(2, 4)));
      expect(Fraction(2, 4).negate(), equals(Fraction(-1, 2)));
    });

    test("Making sure that negation is properly detected", () {
      expect(Fraction(-1, 2).isNegative, isTrue);
    });

    test("Making sure that whole fraction detection works", () {
      expect(Fraction(15).isWhole, isTrue);
      expect(Fraction(15, 1).isWhole, isTrue);
      expect(Fraction(1, 15).isWhole, isFalse);
    });

    test("Making sure that reduction to the lowest terms works as expected", () {
      final positiveFraction = Fraction(16, 46);
      expect(positiveFraction.reduce(), equals(Fraction(8, 23)));

      final negativeFraction = Fraction(-9, 3);
      expect(negativeFraction.reduce(), equals(Fraction(-3, 1)));
    });
  });

  group("Testing operators overloads", () {
    test("Making sure that operators +, -, * and / do proper calculations", () {
      final fraction1 = Fraction(7, 13);
      final fraction2 = Fraction(-4, 3);

      expect(fraction1 + fraction2, equals(Fraction(-31, 39)));
      expect(fraction1 - fraction2, equals(Fraction(73, 39)));
      expect(fraction1 * fraction2, equals(Fraction(-28, 39)));
      expect(fraction1 / fraction2, equals(Fraction(-21, 52)));
    });

    test("Making sure that comparison operators compare values correctly", () {
      expect(Fraction(10) > Fraction(8), isTrue);
      expect(Fraction(10) >= Fraction(8), isTrue);
      expect(Fraction(10) >= Fraction(10), isTrue);
      expect(Fraction(8) < Fraction(10), isTrue);
      expect(Fraction(8) <= Fraction(10), isTrue);
      expect(Fraction(8) <= Fraction(8), isTrue);
    });

    test("Making sure that the index operator returns value only when called with 0 and 1", () {
      final fraction = Fraction(9, 20);

      expect(fraction[0], equals(9));
      expect(fraction[1], equals(20));
      expect(() => fraction[2], throwsA(isA<FractionException>()));
    });
  });
}
