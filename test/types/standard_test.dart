import 'package:fraction/fraction.dart';
import 'package:test/test.dart';

void main() {
  group('Constructors', () {
    test('Making sure that numerator and denominator are correct', () {
      final fraction = Fraction(5, 7);

      expect(fraction.numerator, equals(5));
      expect(fraction.denominator, equals(7));
      expect(fraction.toString(), '5/7');
    });

    test('Making sure that the sign on the numerator persists', () {
      final fraction = Fraction(-5, 7);

      expect(fraction.numerator, equals(-5));
      expect(fraction.denominator, equals(7));
      expect(fraction.toString(), '-5/7');
    });

    test(
      'Making sure that the sign on the denominator is moved to the numerator',
      () {
        final fraction = Fraction(5, -7);

        expect(fraction.numerator, equals(-5));
        expect(fraction.denominator, equals(7));
        expect(fraction.toString(), '-5/7');
      },
    );

    test('Making sure that whole fractions have the denominator = 1', () {
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
      'Making sure an exception is thrown ONLY when the denominator is zero',
      () {
        expect(() => Fraction(1, 0), throwsA(isA<FractionException>()));
        expect(Fraction(0), equals(Fraction(0)));
      },
    );

    test(
      "Making sure that the 'fromString()' constructor handles strings"
      ' properly',
      () {
        // Valid conversions
        expect(Fraction.fromString('3/5'), equals(Fraction(3, 5)));
        expect(Fraction.fromString('-3/5'), equals(Fraction(-3, 5)));
        expect(Fraction.fromString('7'), equals(Fraction(7)));
        expect(Fraction.fromString('-6'), equals(Fraction(-6)));
        expect(
          () => Fraction.fromString('½'),
          throwsA(isA<FractionException>()),
        );

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
          throwsA(isA<FormatException>()),
        );
        expect(
          () => Fraction.fromString('3/a'),
          throwsA(isA<FormatException>()),
        );
        expect(
          () => Fraction.fromString('a/3'),
          throwsA(isA<FractionException>()),
        );
      },
    );

    test(
      "Making sure that the 'fromGlyph()' constructor handles strings properly",
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

    test(
      "Making sure that the 'fromDouble()' constructor handles strings "
      'properly',
      () {
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
      },
    );

    test(
      'Making sure that fractions are properly built from mixed fractions',
      () {
        final fraction = Fraction.fromMixedFraction(
          MixedFraction(
            whole: 3,
            numerator: 5,
            denominator: 6,
          ),
        );

        expect(fraction, equals(Fraction(23, 6)));
        expect(fraction.isNegative, isFalse);
      },
    );

    test(
      'Making sure that fractions are properly built from neg. mixed fractions',
      () {
        final fraction = Fraction.fromMixedFraction(
          MixedFraction(
            whole: -3,
            numerator: 5,
            denominator: 6,
          ),
        );

        expect(fraction, equals(Fraction(-23, 6)));
        expect(fraction.isNegative, isTrue);
      },
    );
  });

  group('Testing objects equality', () {
    test('Making sure that fractions comparison is made via cross product', () {
      expect(Fraction(3, 12) == Fraction(1, 4), isTrue);
      expect(Fraction(6, 13) == Fraction(6, 13), isTrue);

      expect(Fraction(3, 12).hashCode != Fraction(1, 4).hashCode, isTrue);
      expect(Fraction(6, 13).hashCode == Fraction(6, 13).hashCode, isTrue);
    });

    test(
      "Making sure that 'compareTo' returns 1, -1 or 0 according with the "
      'natural sorting',
      () {
        expect(Fraction(2).compareTo(Fraction(8)), equals(-1));
        expect(Fraction(2).compareTo(Fraction(-4)), equals(1));
        expect(Fraction(6).compareTo(Fraction(6)), equals(0));
      },
    );
  });

  group('Testing the API of the Fraction class', () {
    test('Making sure conversions to double are correct', () {
      expect(Fraction(10, 2).toDouble(), equals(5.0));
      expect(Fraction(-6, 8).toDouble(), equals(-0.75));
    });

    test('Making sure conversions to egyptian fractions are correct', () {
      expect(
        Fraction(2, 3).toEgyptianFraction(),
        unorderedEquals([Fraction(1, 2), Fraction(1, 6)]),
      );
      expect(
        Fraction(3, 5).toEgyptianFraction(),
        unorderedEquals([Fraction(1, 2), Fraction(1, 10)]),
      );
    });

    test("Making sure that 'copyWith' works properly", () {
      final fraction1 = Fraction(1, 3).copyWith();
      expect(fraction1, equals(Fraction(1, 3)));

      final fraction2 = Fraction(1, 3).copyWith(numerator: 2);
      expect(fraction2, equals(Fraction(2, 3)));

      final fraction3 = Fraction(1, 3).copyWith(denominator: -3);
      expect(fraction3, equals(Fraction(1, -3)));

      final fraction4 = fraction3.copyWith(numerator: 5, denominator: 7);
      expect(fraction4, equals(Fraction(5, 7)));
    });

    test('Making sure conversions to double are correct', () {
      final fraction = Fraction(3, 7);
      expect(fraction.isProper, equals(true));
      expect(fraction.isImproper, equals(false));

      final inverse = fraction.inverse();
      expect(inverse.isProper, equals(false));
      expect(inverse.isImproper, equals(true));
    });

    test('Making sure that the glyph conversion is correct', () {
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

    test('Making sure that glyphs are recognized', () {
      expect(Fraction(1, 2).isFractionGlyph, isTrue);
      expect(Fraction(-1, 2).isFractionGlyph, isFalse);
      expect(Fraction(-1, -2).isFractionGlyph, isTrue);
      expect(Fraction(1, -2).isFractionGlyph, isFalse);
    });

    test(
      'Making sure that a non-glyph encodeable fraction throws when trying '
      'to convert it into a glyph',
      () {
        expect(
          () => Fraction(10, 37).toStringAsGlyph(),
          throwsA(isA<FractionException>()),
        );
      },
    );

    test('Making sure conversions to mixed fractions are correct', () {
      final mixed = Fraction(8, 7).toMixedFraction();

      expect(mixed.whole, equals(1));
      expect(mixed.numerator, equals(1));
      expect(mixed.denominator, equals(7));
    });

    test(
      'Making sure that the inverse is another fraction with swapped values',
      () {
        expect(Fraction(10, 2).inverse(), equals(Fraction(2, 10)));
        expect(Fraction(-10, 2).inverse(), equals(Fraction(-2, 10)));
      },
    );

    test('Making sure that negation changes the sign', () {
      expect(Fraction(-2, 4).negate(), equals(Fraction(2, 4)));
      expect(Fraction(2, 4).negate(), equals(Fraction(-1, 2)));
    });

    test('Making sure that negation is properly detected', () {
      expect(Fraction(-1, 2).isNegative, isTrue);
      expect(Fraction(1, 2).isNegative, isFalse);
    });

    test('Making sure that whole fraction detection works', () {
      expect(Fraction(15).isWhole, isTrue);
      expect(Fraction(16, 2).isWhole, isFalse);
      expect(Fraction(1, 15).isWhole, isFalse);
    });

    test('Making sure that whole fraction detection works', () {
      expect(Fraction(15).isWhole, isTrue);
      expect(Fraction(16, 2).isWhole, isFalse);
      expect(Fraction(1, 15).isWhole, isFalse);
    });

    test(
      'Making sure that reduction to the lowest terms works as expected',
      () {
        final positiveFraction = Fraction(16, 46);
        expect(positiveFraction.reduce(), equals(Fraction(8, 23)));

        final negativeFraction = Fraction(-9, 3);
        expect(negativeFraction.reduce(), equals(Fraction(-3)));
      },
    );
  });

  group('Testing operators overloads', () {
    test('Making sure that operators +, -, * and / do proper calculations', () {
      final fraction1 = Fraction(7, 13);
      final fraction2 = Fraction(-4, 3);

      expect(fraction1 + fraction2, equals(Fraction(-31, 39)));
      expect(fraction1 - fraction2, equals(Fraction(73, 39)));
      expect(fraction1 * fraction2, equals(Fraction(-28, 39)));
      expect(fraction1 / fraction2, equals(Fraction(-21, 52)));
    });

    test('Making sure that comparison operators compare values correctly', () {
      expect(Fraction(10) > Fraction(8), isTrue);
      expect(Fraction(10) >= Fraction(8), isTrue);
      expect(Fraction(10) >= Fraction(10), isTrue);
      expect(Fraction(8) < Fraction(10), isTrue);
      expect(Fraction(8) <= Fraction(10), isTrue);
      expect(Fraction(8) <= Fraction(8), isTrue);
    });

    test(
      'Making sure that the index operator returns value only when called with '
      '0 and 1',
      () {
        final fraction = Fraction(9, 20);

        expect(fraction[0], equals(9));
        expect(fraction[1], equals(20));
        expect(() => fraction[2], throwsA(isA<FractionException>()));
      },
    );
  });
}
