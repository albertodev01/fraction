import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:fraction/fraction.dart';

void main() {
  group("Constructors", () {
    test("Numerator and denominator", () {
      var f = Fraction(5, 7);
      expect(f.toString(), "5/7");

      f = Fraction(1, -4);
      expect(f.toString(), "-1/4");

      f = Fraction(6);
      expect(f.toString(), "6/1");

      f = Fraction(-8);
      expect(f.toString(), "-8/1");

      f = 1.5.toFraction();
      expect(f.toString(), "3/2");

      f = (-1.5).toFraction();
      expect(f.toString(), "-3/2");

      expect(() => Fraction(1, 0), throwsA(isInstanceOf<FractionException>()));
    });

    test("Conversion from string", () {
      var f = Fraction.fromString("4/3");
      expect(f.toString(), "4/3");

      f = Fraction.fromString("-7/25");
      expect(f.toString(), "-7/25");

      f = Fraction.fromString("12");
      expect(f.toString(), "12/1");

      f = Fraction.fromString("-12");
      expect(f.toString(), "-12/1");

      expect(() => Fraction.fromString("1/-2"), throwsA(isInstanceOf<FractionException>()));
      expect(() => Fraction.fromString("1/2-4"), throwsA(isInstanceOf<Exception>()));
      expect(() => Fraction.fromString("4/"), throwsA(isInstanceOf<Exception>()));
      expect(() => Fraction.fromString("5/0"), throwsA(isInstanceOf<Exception>()));
    });

    test("Conversion from double", () {
      var f = Fraction.fromDouble(2.5);
      expect(f.toString(), "5/2");

      f = Fraction.fromDouble(-1);
      expect(f.toString(), "-1/1");

      expect(() => Fraction.fromDouble(double.nan), throwsA(isInstanceOf<FractionException>()));
      expect(() => Fraction.fromDouble(double.infinity), throwsA(isInstanceOf<FractionException>()));
    });

    test("Conversion from a mixed fraction", () {
      final mixed = MixedFraction(1, 8 ,9);
      final f = Fraction.fromMixedFraction(mixed);

      expect(f.toString(), "17/9");
      expect(() => Fraction.fromDouble(double.nan), throwsA(isInstanceOf<FractionException>()));
    });
  });

  group("Operators", () {
    test("Sum", () {
      final sum1 = Fraction(3, 7) + Fraction(6, 13);
      expect(sum1.toString(), "81/91");

      final sum2 = Fraction(4, 9) + Fraction(8, 9);
      expect(sum2.toString(), "108/81");

      sum2.reduce();
      expect(sum2.toString(), "4/3");
    });

    test("Subtract", () {
      final sum1 = Fraction(3, 7) - Fraction(6, 13);
      expect(sum1.toString(), "-3/91");

      final sum2 = Fraction(4, 9) - Fraction(8, 9);
      expect(sum2.toString(), "-36/81");

      sum2.reduce();
      expect(sum2.toString(), "-4/9");
    });

    test("Multiply", () {
      final mul = Fraction(2, 5) * Fraction(-1, -6);
      expect(mul.toString(), "2/30");

      mul..reduce()..negate()..reduce();
      expect(mul.toString(), "-1/15");
    });

    test("Divide", () {
      final div = Fraction(-1, 7) / Fraction(9, 8);
      expect(div.toString(), "-8/63");

      div.reduce();
      expect(div.toString(), "-8/63");
    });

    test("Equality", () {
      expect(Fraction(1, 2) == Fraction(6, 12), true);
      expect(Fraction(6) == Fraction(-6, -1), true);
      expect(Fraction(-2, 6) == Fraction(1, -3), true);

      expect(Fraction(1, 2) == Fraction(1, 2), true);
      expect(Fraction(1) == Fraction(1, 1), true);
      expect(Fraction(0) == Fraction(-0, 3), true);
    });
  });

  group("Methods", () {
    test("Convert to double", () {
      expect(Fraction(1, 2).toDouble(), 0.5);
      expect(Fraction(-5, 8).toDouble(), -0.625);
    });

    test("Inverse", () {
      final frac = Fraction(3, 4)..inverse();
      expect(frac.toString(), "4/3");

      final fracNegative = Fraction(-3, 4)..inverse();
      expect(fracNegative.toString(), "-4/3");
    });

    test("Negate", () {
      final f1 = Fraction(-4, 6)..negate();
      expect(f1.toString(), "4/6");

      final f2 = Fraction(4, -6)..negate();
      expect(f2.toString(), "4/6");
    });

    test("Reduce", () {
      final f1 = Fraction(12, 62);
      expect(f1.toString(), "12/62");

      f1.reduce();
      expect(f1.toString(), "6/31");

      final f2 = Fraction(-8, 44);
      expect(f2.toString(), "-8/44");

      f2.reduce();
      expect(f2.toString(), "-2/11");
    });
  });
}
