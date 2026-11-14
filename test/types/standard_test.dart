import 'dart:math' as math;

import 'package:fraction/fraction.dart';
import 'package:test/test.dart';

void main() {
  group('Constructors', () {
    test('numerator and denominator are correct', () {
      final fraction = Fraction(5, 7);

      expect(fraction.numerator, equals(5));
      expect(fraction.denominator, equals(7));
      expect(fraction.toString(), '5/7');
    });

    test('the sign on the numerator persists', () {
      final fraction = Fraction(-5, 7);

      expect(fraction.numerator, equals(-5));
      expect(fraction.denominator, equals(7));
      expect(fraction.toString(), '-5/7');
    });

    test(
      'the sign on the denominator moves to the numerator',
      () {
        final fraction = Fraction(5, -7);

        expect(fraction.numerator, equals(-5));
        expect(fraction.denominator, equals(7));
        expect(fraction.toString(), '-5/7');
      },
    );

    test('whole fractions have a denominator of 1', () {
      final fraction = Fraction(10);

      expect(fraction.numerator, equals(10));
      expect(fraction.denominator, equals(1));
      expect(fraction.toString(), '10');

      final negativeFraction = Fraction(-8);

      expect(negativeFraction.numerator, equals(-8));
      expect(negativeFraction.denominator, equals(1));
      expect(negativeFraction.toString(), '-8');
    });

    test(
      'throws only when the denominator is zero',
      () {
        expect(() => Fraction(1, 0), throwsA(isA<FractionException>()));
        expect(Fraction(0), equals(Fraction(0)));
      },
    );

    test("the 'fromString()' constructor", () {
      // Valid conversions
      expect(Fraction.fromString('3/5'), equals(Fraction(3, 5)));
      expect(Fraction.fromString('-3/5'), equals(Fraction(-3, 5)));
      expect(Fraction.fromString('7'), equals(Fraction(7)));
      expect(Fraction.fromString('-6'), equals(Fraction(-6)));
      expect(() => Fraction.fromString('½'), throwsA(isA<FractionException>()));

      // Invalid conversions
      expect(
        () => Fraction.fromString('2/-5'),
        throwsA(isA<FractionException>()),
      );
      expect(
        () => Fraction.fromString('1/-0'),
        throwsA(isA<FractionException>()),
      );
      expect(
        () => Fraction.fromString('2/0'),
        throwsA(isA<FractionException>()),
      );
      expect(
        () => Fraction.fromString('0/0'),
        throwsA(isA<FractionException>()),
      );

      // Invalid formats
      expect(
        () => Fraction.fromString('2/'),
        throwsA(isA<FractionException>()),
      );
      expect(
        () => Fraction.fromString('3/a'),
        throwsA(isA<FractionException>()),
      );
      expect(
        () => Fraction.fromString('a/3'),
        throwsA(isA<FractionException>()),
      );
    });

    test(
      "the 'fromGlyph()' constructor",
      () {
        expect(Fraction.fromGlyph('½'), equals(Fraction(1, 2)));
        expect(Fraction.fromGlyph('⅓'), equals(Fraction(1, 3)));
        expect(Fraction.fromGlyph('⅔'), equals(Fraction(2, 3)));
        expect(Fraction.fromGlyph('¼'), equals(Fraction(1, 4)));
        expect(Fraction.fromGlyph('¾'), equals(Fraction(3, 4)));
        expect(Fraction.fromGlyph('⅕'), equals(Fraction(1, 5)));
        expect(Fraction.fromGlyph('⅖'), equals(Fraction(2, 5)));
        expect(Fraction.fromGlyph('⅗'), equals(Fraction(3, 5)));
        expect(Fraction.fromGlyph('⅘'), equals(Fraction(4, 5)));
        expect(Fraction.fromGlyph('⅙'), equals(Fraction(1, 6)));
        expect(Fraction.fromGlyph('⅚'), equals(Fraction(5, 6)));
        expect(Fraction.fromGlyph('⅐'), equals(Fraction(1, 7)));
        expect(Fraction.fromGlyph('⅛'), equals(Fraction(1, 8)));
        expect(Fraction.fromGlyph('⅜'), equals(Fraction(3, 8)));
        expect(Fraction.fromGlyph('⅝'), equals(Fraction(5, 8)));
        expect(Fraction.fromGlyph('⅞'), equals(Fraction(7, 8)));
        expect(Fraction.fromGlyph('⅑'), equals(Fraction(1, 9)));
        expect(Fraction.fromGlyph('⅒'), equals(Fraction(1, 10)));
      },
    );

    test("the 'fromDouble()' constructor", () {
      // Valid conversions
      expect(Fraction.fromDouble(5.6), equals(Fraction(28, 5)));
      expect(Fraction.fromDouble(0.0025), equals(Fraction(1, 400)));
      expect(Fraction.fromDouble(-3.8), equals(Fraction(-19, 5)));
      expect(Fraction.fromDouble(0), equals(Fraction(0)));

      // Invalid conversions
      expect(
        () => Fraction.fromDouble(double.nan),
        throwsA(isA<FractionException>()),
      );
      expect(
        () => Fraction.fromDouble(double.infinity),
        throwsA(isA<FractionException>()),
      );
      expect(
        () => Fraction.fromDouble(double.negativeInfinity),
        throwsA(isA<FractionException>()),
      );
    });

    test(
      'construction from mixed fractions',
      () {
        final fraction = Fraction.fromMixedFraction(
          MixedFraction(whole: 3, numerator: 5, denominator: 6),
        );

        expect(fraction, equals(Fraction(23, 6)));
        expect(fraction.isNegative, isFalse);
      },
    );

    test(
      'construction from negative mixed fractions',
      () {
        final fraction = Fraction.fromMixedFraction(
          MixedFraction(whole: -3, numerator: 5, denominator: 6),
        );

        expect(fraction, equals(Fraction(-23, 6)));
        expect(fraction.isNegative, isTrue);
      },
    );
  });

  group('Testing objects equality', () {
    test('equivalent fractions are equal', () {
      expect(Fraction(3, 12) == Fraction(1, 4), isTrue);
      expect(Fraction(6, 13) == Fraction(6, 13), isTrue);

      expect(Fraction(3, 12).hashCode == Fraction(1, 4).hashCode, isTrue);
      expect(Fraction(6, 13).hashCode == Fraction(6, 13).hashCode, isTrue);
    });

    test("'compareTo' follows the natural ordering", () {
      expect(Fraction(2).compareTo(Fraction(8)), equals(-1));
      expect(Fraction(2).compareTo(Fraction(-4)), equals(1));
      expect(Fraction(6).compareTo(Fraction(6)), equals(0));
    });
  });

  group('Testing the API of the Fraction class', () {
    test('conversion to double', () {
      expect(Fraction(10, 2).toDouble(), equals(5.0));
      expect(Fraction(-6, 8).toDouble(), equals(-0.75));
    });

    test('conversion to egyptian fractions', () {
      expect(
        Fraction(2, 3).toEgyptianFraction(),
        unorderedEquals([Fraction(1, 2), Fraction(1, 6)]),
      );
      expect(
        Fraction(3, 5).toEgyptianFraction(),
        unorderedEquals([Fraction(1, 2), Fraction(1, 10)]),
      );
    });

    test("'copyWith' works", () {
      final fraction1 = Fraction(1, 3).copyWith();
      expect(fraction1, equals(Fraction(1, 3)));

      final fraction2 = Fraction(1, 3).copyWith(numerator: 2);
      expect(fraction2, equals(Fraction(2, 3)));

      final fraction3 = Fraction(1, 3).copyWith(denominator: -3);
      expect(fraction3, equals(Fraction(1, -3)));

      final fraction4 = fraction3.copyWith(numerator: 5, denominator: 7);
      expect(fraction4, equals(Fraction(5, 7)));
    });

    test('conversion to double', () {
      final fraction = Fraction(3, 7);
      expect(fraction.isProper, equals(true));
      expect(fraction.isImproper, equals(false));

      final inverse = fraction.inverse();
      expect(inverse.isProper, equals(false));
      expect(inverse.isImproper, equals(true));
    });

    test('the glyph conversion is correct', () {
      expect(Fraction(1, 2).toStringAsGlyph(), equals('½'));
      expect(Fraction(1, 3).toStringAsGlyph(), equals('⅓'));
      expect(Fraction(2, 3).toStringAsGlyph(), equals('⅔'));
      expect(Fraction(1, 4).toStringAsGlyph(), equals('¼'));
      expect(Fraction(3, 4).toStringAsGlyph(), equals('¾'));
      expect(Fraction(1, 5).toStringAsGlyph(), equals('⅕'));
      expect(Fraction(2, 5).toStringAsGlyph(), equals('⅖'));
      expect(Fraction(3, 5).toStringAsGlyph(), equals('⅗'));
      expect(Fraction(4, 5).toStringAsGlyph(), equals('⅘'));
      expect(Fraction(1, 6).toStringAsGlyph(), equals('⅙'));
      expect(Fraction(5, 6).toStringAsGlyph(), equals('⅚'));
      expect(Fraction(1, 7).toStringAsGlyph(), equals('⅐'));
      expect(Fraction(1, 8).toStringAsGlyph(), equals('⅛'));
      expect(Fraction(3, 8).toStringAsGlyph(), equals('⅜'));
      expect(Fraction(5, 8).toStringAsGlyph(), equals('⅝'));
      expect(Fraction(7, 8).toStringAsGlyph(), equals('⅞'));
      expect(Fraction(1, 9).toStringAsGlyph(), equals('⅑'));
      expect(Fraction(1, 10).toStringAsGlyph(), equals('⅒'));
    });

    test('glyphs are recognized', () {
      expect(Fraction(1, 2).isFractionGlyph, isTrue);
      expect(Fraction(-1, 2).isFractionGlyph, isFalse);
      expect(Fraction(-1, -2).isFractionGlyph, isTrue);
      expect(Fraction(1, -2).isFractionGlyph, isFalse);
    });

    test('converting a non-glyph fraction into a glyph throws', () {
      expect(
        () => Fraction(10, 37).toStringAsGlyph(),
        throwsA(isA<FractionException>()),
      );
    });

    test('conversion to mixed fractions', () {
      final mixed = Fraction(8, 7).toMixedFraction();

      expect(mixed.whole, equals(1));
      expect(mixed.numerator, equals(1));
      expect(mixed.denominator, equals(7));
    });

    test(
      'the inverse swaps numerator and denominator',
      () {
        expect(Fraction(10, 2).inverse(), equals(Fraction(2, 10)));
        expect(Fraction(-10, 2).inverse(), equals(Fraction(-2, 10)));
      },
    );

    test('negation changes the sign', () {
      expect(Fraction(-2, 4).negate(), equals(Fraction(2, 4)));
      expect(Fraction(2, 4).negate(), equals(Fraction(-1, 2)));
    });

    test('negative fractions are detected', () {
      expect(Fraction(-1, 2).isNegative, isTrue);
      expect(Fraction(1, 2).isNegative, isFalse);
    });

    test('whole fractions are detected', () {
      expect(Fraction(15).isWhole, isTrue);
      expect(Fraction(16, 2).isWhole, isTrue);
      expect(Fraction(1, 15).isWhole, isFalse);
    });

    test(
      'reduction to the lowest terms',
      () {
        final positiveFraction = Fraction(16, 46);
        expect(positiveFraction.reduce(), equals(Fraction(8, 23)));

        final negativeFraction = Fraction(-9, 3);
        expect(negativeFraction.reduce(), equals(Fraction(-3)));
      },
    );
  });

  group('Testing operators overloads', () {
    test('operators +, -, * and / compute correctly', () {
      final fraction1 = Fraction(7, 13);
      final fraction2 = Fraction(-4, 3);

      expect(fraction1 + fraction2, equals(Fraction(-31, 39)));
      expect(fraction1 - fraction2, equals(Fraction(73, 39)));
      expect(fraction1 * fraction2, equals(Fraction(-28, 39)));
      expect(fraction1 / fraction2, equals(Fraction(-21, 52)));
    });

    test('comparison operators compare values correctly', () {
      expect(Fraction(10) > Fraction(8), isTrue);
      expect(Fraction(10) >= Fraction(8), isTrue);
      expect(Fraction(10) >= Fraction(10), isTrue);
      expect(Fraction(8) < Fraction(10), isTrue);
      expect(Fraction(8) <= Fraction(10), isTrue);
      expect(Fraction(8) <= Fraction(8), isTrue);
    });

    test(
      'the index operator only accepts 0 and 1',
      () {
        final fraction = Fraction(9, 20);

        expect(fraction[0], equals(9));
        expect(fraction[1], equals(20));
        expect(() => fraction[2], throwsA(isA<FractionException>()));
      },
    );
  });

  group('Regression: equality and hashing', () {
    test('equal fractions have the same hash code', () {
      for (var n = -6; n <= 6; n++) {
        for (var d = 1; d <= 6; d++) {
          for (var k = 1; k <= 4; k++) {
            final base = Fraction(n, d);
            final scaled = Fraction(n * k, d * k);
            final negated = Fraction(-n * k, -d * k);

            expect(scaled, equals(base), reason: '$scaled == $base');
            expect(negated, equals(base), reason: '$negated == $base');
            expect(scaled.hashCode, equals(base.hashCode), reason: '$scaled');
            expect(negated.hashCode, equals(base.hashCode), reason: '$negated');
          }
        }
      }
    });

    test('zero has a single representation', () {
      expect(Fraction(0, 5), equals(Fraction(0)));
      expect(Fraction(0, -3), equals(Fraction(0)));
      expect(Fraction(0, 5).hashCode, equals(Fraction(0).hashCode));
      expect(Fraction(0, -3).hashCode, equals(Fraction(0).hashCode));
    });

    test('equivalent fractions work in sets and maps', () {
      expect({Fraction(1, 2), Fraction(2, 4), Fraction(-3, -6)}, hasLength(1));

      final map = {Fraction(1, 3): 'one third'};
      expect(map[Fraction(2, 6)], equals('one third'));
      expect(map.containsKey(Fraction(-4, -12)), isTrue);
    });

    test('equality does not overflow', () {
      // The cross products of these pairs wrap around to the same 64-bit value
      // even though the fractions are different.
      expect(Fraction(4294967296) == Fraction(0, 4294967296), isFalse);
      expect(
        Fraction(1, 4294967296) == Fraction(4294967297, 4294967296),
        isFalse,
      );

      // Large equivalent fractions are still equal.
      expect(
        Fraction(4294967296, 4294967297) ==
            Fraction(4294967296 * 2, 4294967297 * 2),
        isTrue,
      );
    });

    test('equivalent fractions map to a glyph', () {
      expect(Fraction(2, 4).toStringAsGlyph(), equals('½'));
      expect(Fraction(-2, -4).toStringAsGlyph(), equals('½'));
      expect(Fraction(6, 8).toStringAsGlyph(), equals('¾'));
      expect(Fraction(2, 4).isFractionGlyph, isTrue);
      expect(Fraction(-1, 2).isFractionGlyph, isFalse);
      expect(
        Fraction(-1, 2).toStringAsGlyph,
        throwsA(isA<FractionException>()),
      );
    });
  });

  group('Regression: fromString', () {
    test('the whole string must be a fraction', () {
      for (final value in [
        '1/2 ',
        ' 1/2',
        '1/2\n',
        '1/2/3',
        '1 1/2',
        '1.5',
        '1/2a',
        '--1/2',
        '+-1/2',
        '1/+2',
        '01/2',
      ]) {
        expect(
          () => Fraction.fromString(value),
          throwsA(isA<FractionException>()),
          reason: '"$value"',
        );
      }
    });

    test('values too large for an int throw a FractionException', () {
      expect(
        () => Fraction.fromString('99999999999999999999/2'),
        throwsA(isA<FractionException>()),
      );
      expect(
        () => Fraction.fromString('1/99999999999999999999'),
        throwsA(isA<FractionException>()),
      );
      expect(
        () => Fraction.fromString('-99999999999999999999'),
        throwsA(isA<FractionException>()),
      );
    });

    test('valid strings are still parsed', () {
      expect(Fraction.fromString('+1/2'), equals(Fraction(1, 2)));
      expect(Fraction.fromString('-7/3'), equals(Fraction(-7, 3)));
      expect(Fraction.fromString('-0'), equals(Fraction(0)));
      expect(Fraction.fromString('0/5'), equals(Fraction(0)));
      expect(Fraction.fromString('42'), equals(Fraction(42)));
    });
  });

  group('Regression: fromDouble', () {
    test(
      'out of range values throw instead of hanging',
      () {
        for (final value in [
          1e300,
          -1e300,
          1e-300,
          -1e-300,
          1e20,
          1e-20,
          double.maxFinite,
          double.minPositive,
        ]) {
          expect(
            () => Fraction.fromDouble(value),
            throwsA(isA<FractionException>()),
            reason: '$value',
          );
        }
      },
      timeout: const Timeout(Duration(seconds: 10)),
    );

    test('the precision must be positive and finite', () {
      for (final precision in [0.0, -1e-12, double.nan, double.infinity]) {
        expect(
          () => Fraction.fromDouble(0.5, precision: precision),
          throwsA(isA<FractionException>()),
          reason: '$precision',
        );
      }
    });

    test('known results are unchanged', () {
      expect(Fraction.fromDouble(math.pi), equals(Fraction(1146408, 364913)));
      expect(
        Fraction.fromDouble(math.pi, precision: 1.0e-4),
        equals(Fraction(333, 106)),
      );
      expect(Fraction.fromDouble(0.1), equals(Fraction(1, 10)));
      expect(Fraction.fromDouble(-0.5), equals(Fraction(-1, 2)));
      expect(
        Fraction.fromDouble(1e-15).toDouble(),
        closeTo(1e-15, 1e-15 * 1e-12),
      );
    });

    test(
      'an unreachable precision returns the closest int-sized approximation',
      () {
        final fraction = Fraction.fromDouble(math.pi, precision: 1.0e-20);

        expect((fraction.toDouble() - math.pi).abs(), lessThan(1e-15));
      },
    );

    test('the num extension does not hang', () {
      expect(() => 1e300.toFraction(), throwsA(isA<FractionException>()));
      expect(() => 1e-300.toMixedFraction(), throwsA(isA<FractionException>()));
    }, timeout: const Timeout(Duration(seconds: 10)));
  });

  group('Regression: predicates', () {
    test("'isWhole' works on unreduced fractions", () {
      expect(Fraction(16, 2).isWhole, isTrue);
      expect(Fraction(-9, 3).isWhole, isTrue);
      expect(Fraction(0, 7).isWhole, isTrue);
      expect(Fraction(7, 2).isWhole, isFalse);
      expect(Fraction(-7, 2).isWhole, isFalse);
    });

    test("'isProper' and 'isImproper' ignore the sign", () {
      expect(Fraction(-1, 2).isProper, isTrue);
      expect(Fraction(-1, 2).isImproper, isFalse);
      expect(Fraction(-5, 2).isProper, isFalse);
      expect(Fraction(-5, 2).isImproper, isTrue);
      expect(Fraction(-2, 2).isImproper, isTrue);
      expect(Fraction(2, 2).isImproper, isTrue);
      expect(Fraction(0).isProper, isTrue);
    });
  });

  group('Regression: reduce and toMixedFraction', () {
    test("'reduce' returns a canonical fraction", () {
      final reduced = Fraction(-12, 20).reduce();
      expect(reduced.numerator, equals(-3));
      expect(reduced.denominator, equals(5));

      final zero = Fraction(0, 5).reduce();
      expect(zero.numerator, equals(0));
      expect(zero.denominator, equals(1));

      final flipped = Fraction(6, -4).reduce();
      expect(flipped.numerator, equals(-3));
      expect(flipped.denominator, equals(2));
    });

    test('negative fractions keep their value as mixed fractions', () {
      final cases = {
        Fraction(-5, 4): (true, 1, 1, 4),
        Fraction(-7, 2): (true, 3, 1, 2),
        Fraction(-8, 4): (true, 2, 0, 4),
        Fraction(-1, 2): (true, 0, 1, 2),
        Fraction(7, 4): (false, 1, 3, 4),
        Fraction(0, 3): (false, 0, 0, 3),
      };

      for (final MapEntry(key: fraction, value: (negative, whole, num, den))
          in cases.entries) {
        final mixed = fraction.toMixedFraction();

        expect(mixed.isNegative, equals(negative), reason: '$fraction');
        expect(mixed.whole, equals(whole), reason: '$fraction');
        expect(mixed.numerator, equals(num), reason: '$fraction');
        expect(mixed.denominator, equals(den), reason: '$fraction');
        expect(mixed.toFraction(), equals(fraction), reason: '$fraction');
      }
    });
  });

  group('Regression: arithmetic', () {
    test('results are in lowest terms', () {
      final product = Fraction(5, 7) * Fraction(1, 5);
      expect(product.numerator, equals(1));
      expect(product.denominator, equals(7));

      final sum = Fraction(1, 6) + Fraction(1, 3);
      expect(sum.numerator, equals(1));
      expect(sum.denominator, equals(2));

      final difference = Fraction(1, 2) - Fraction(1, 2);
      expect(difference.numerator, equals(0));
      expect(difference.denominator, equals(1));

      final quotient = Fraction(1, 2) / Fraction(-1, 4);
      expect(quotient.numerator, equals(-2));
      expect(quotient.denominator, equals(1));
    });

    test('long sums stay exact', () {
      // Without reduction, this sum overflowed and became negative.
      var sum = Fraction(0);
      var expected = 0.0;
      for (var i = 1; i <= 30; i++) {
        sum += Fraction(1, i);
        expected += 1 / i;
      }

      expect(sum.isNegative, isFalse);
      expect(sum.toDouble(), closeTo(expected, 1e-12));
      expect(sum, equals(Fraction(9304682830147, 2329089562800)));
    });

    test('large operands are handled exactly', () {
      // The intermediate products overflow 64-bit ints.
      final a = Fraction(4000000000000, 4000000000001);
      final b = Fraction(4000000000001, 4000000000000);

      final product = a * b;
      expect(product.numerator, equals(1));
      expect(product.denominator, equals(1));

      final quotient = a / a;
      expect(quotient.numerator, equals(1));
      expect(quotient.denominator, equals(1));

      // 4e12/(4e12 + 1) + 4e12/(4e12 + 1) = 8e12/(4e12 + 1); the unreduced
      // denominator (4e12 + 1)^2 overflows.
      final sum = a + a;
      expect(sum.numerator, equals(8000000000000));
      expect(sum.denominator, equals(4000000000001));

      final difference = sum - a;
      expect(difference, equals(a));
    });

    test('results too large for an int throw', () {
      final big = Fraction(1099511627776); // 2^40

      expect(() => big * big, throwsA(isA<FractionException>()));
      expect(
        () => Fraction(1, 1099511627776) / big,
        throwsA(isA<FractionException>()),
      );
      expect(() {
        var sum = Fraction(0);
        for (var i = 1; i <= 100; i++) {
          sum += Fraction(1, i);
        }

        return sum;
      }, throwsA(isA<FractionException>()));
    });

    test('large operands keep the sign on the numerator', () {
      // Uses the BigInt path, where the product of the denominator and the
      // negative numerator of the divisor is negative.
      final quotient = Fraction(4000000000000, 3) / Fraction(-4000000000001, 7);

      expect(quotient.numerator, equals(-28000000000000));
      expect(quotient.denominator, equals(12000000000003));
      expect(quotient.isNegative, isTrue);
    });

    test('dividing by zero throws', () {
      expect(
        () => Fraction(1, 2) / Fraction(0),
        throwsA(isA<FractionException>()),
      );
      expect(
        () => Fraction(4000000000000, 3) / Fraction(0, 4000000000000),
        throwsA(isA<FractionException>()),
      );
    });
  });
}
