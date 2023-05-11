import 'package:fraction/fraction.dart';
import 'package:test/test.dart';

void main() {
  // Tests on constructors
  group('Testing the behaviors of the constructors', () {
    test('Making sure that whole, numerator and denominator are correct', () {
      final fraction = MixedFraction(
        whole: 1,
        numerator: 5,
        denominator: 7,
      );

      expect(fraction.whole, equals(1));
      expect(fraction.numerator, equals(5));
      expect(fraction.denominator, equals(7));
      expect(fraction.isNegative, isFalse);
      expect(fraction.toString(), equals('1 5/7'));
    });

    test('Making sure that whole, numerator and denominator are correct', () {
      final fraction = MixedFraction(
        whole: 0,
        numerator: -1,
        denominator: -2,
      );

      expect(fraction.whole, equals(0));
      expect(fraction.numerator, equals(1));
      expect(fraction.denominator, equals(2));
      expect(fraction.isNegative, isFalse);
      expect(fraction.toString(), equals('1/2'));
    });

    test(
      'Making sure that an exception is thrown when the denominator is zero',
      () {
        expect(
          () => MixedFraction(whole: 1, numerator: 5, denominator: 0),
          throwsA(isA<MixedFractionException>()),
        );
      },
    );

    test(
      'Making sure that when numerator > denominator, the fraction is '
      "'normalized' so that the numerator <= denominator relation becomes true",
      () {
        final fraction1 = MixedFraction(
          whole: 1,
          numerator: 5,
          denominator: 3,
        );

        expect(fraction1.whole, equals(2));
        expect(fraction1.numerator, equals(2));
        expect(fraction1.denominator, equals(3));
        expect(fraction1.toString(), equals('2 2/3'));

        final fraction2 = MixedFraction(
          whole: 3,
          numerator: 18,
          denominator: -7,
        );

        expect(fraction2.whole, equals(-5));
        expect(fraction2.numerator, equals(4));
        expect(fraction2.denominator, equals(7));
        expect(fraction2.toString(), equals('-5 4/7'));

        final fraction3 = MixedFraction(
          whole: 2,
          numerator: -6,
          denominator: 5,
        );

        expect(fraction3.whole, equals(-3));
        expect(fraction3.numerator, equals(1));
        expect(fraction3.denominator, equals(5));
        expect(fraction3.toString(), equals('-3 1/5'));

        final fraction4 = MixedFraction(
          whole: -5,
          numerator: -1,
          denominator: 3,
        );

        expect(fraction4.whole, equals(5));
        expect(fraction4.numerator, equals(1));
        expect(fraction4.denominator, equals(3));
        expect(fraction4.toString(), equals('5 1/3'));
      },
    );

    test('Making sure that negative signs are properly handled', () {
      final fraction1 = MixedFraction(
        whole: -1,
        numerator: -4,
        denominator: 9,
      );

      expect(fraction1.whole, equals(1));
      expect(fraction1.numerator, equals(4));
      expect(fraction1.denominator, equals(9));
      expect(fraction1.toString(), equals('1 4/9'));

      final fraction2 = MixedFraction(
        whole: -2,
        numerator: -4,
        denominator: -11,
      );

      expect(fraction2.whole, equals(-2));
      expect(fraction2.numerator, equals(4));
      expect(fraction2.denominator, equals(11));
      expect(fraction2.toString(), equals('-2 4/11'));

      final fraction3 = MixedFraction(
        whole: 6,
        numerator: 2,
        denominator: -7,
      );

      expect(fraction3.whole, equals(-6));
      expect(fraction3.numerator, equals(2));
      expect(fraction3.denominator, equals(7));
      expect(fraction3.toString(), equals('-6 2/7'));

      expect(
        MixedFraction(whole: -3, numerator: 2, denominator: 5).toFraction(),
        equals(Fraction(-17, 5)),
      );
      expect(
        MixedFraction(whole: -4, numerator: 5, denominator: 6).toFraction(),
        equals(Fraction(-29, 6)),
      );
    });

    test(
      'Making sure that mixed fractions are properly constructed from '
      'fractions',
      () {
        final fraction = MixedFraction.fromFraction(
          Fraction(19, 3),
        );

        expect(fraction.whole, equals(6));
        expect(fraction.numerator, equals(1));
        expect(fraction.denominator, equals(3));
      },
    );

    test(
      'Making sure that mixed fractions are properly constructed from strings',
      () {
        // Valid conversions
        expect(
          MixedFraction.fromString('-3 6/11'),
          equals(MixedFraction(whole: -3, numerator: 6, denominator: 11)),
        );

        expect(
          MixedFraction.fromString('1 5/3'),
          equals(MixedFraction(whole: 2, numerator: 2, denominator: 3)),
        );

        expect(
          MixedFraction.fromString('2 5/1'),
          equals(MixedFraction(whole: 2, numerator: 5, denominator: 1)),
        );

        expect(
          MixedFraction.fromString('2 5'),
          equals(MixedFraction(whole: 2, numerator: 5, denominator: 1)),
        );

        expect(
          MixedFraction.fromString('3 ⅕'),
          equals(MixedFraction(whole: 3, numerator: 1, denominator: 5)),
        );

        // Invalid conversions
        expect(
          () => MixedFraction.fromString('1/2'),
          throwsA(isA<MixedFractionException>()),
        );
        expect(
          () => MixedFraction.fromString('1  3/2'),
          throwsA(isA<MixedFractionException>()),
        );
        expect(
          () => MixedFraction.fromString('2 1/-1'),
          throwsA(isA<FractionException>()),
        );
        expect(
          () => MixedFraction.fromString('2 c/0'),
          throwsA(isA<FractionException>()),
        );
        expect(
          () => MixedFraction.fromString('1 2/0'),
          throwsA(isA<FractionException>()),
        );
      },
    );

    test(
      'Making sure that mixed fractions are properly constructed from '
      'decimal values',
      () {
        expect(
          MixedFraction.fromDouble(5.46),
          equals(
            MixedFraction(whole: 5, numerator: 23, denominator: 50),
          ),
        );
        expect(
          MixedFraction.fromDouble(1.06),
          equals(
            MixedFraction(whole: 1, numerator: 3, denominator: 50),
          ),
        );
        expect(
          MixedFraction.fromDouble(0),
          equals(
            MixedFraction(whole: 0, numerator: 0, denominator: 1),
          ),
        );
      },
    );
  });

  group('Testing objects equality', () {
    test('Making sure that fractions comparison is made via cross product', () {
      final mixed1 = MixedFraction(
        whole: 1,
        numerator: 4,
        denominator: 7,
      );
      final mixed2 = MixedFraction(
        whole: 1,
        numerator: 8,
        denominator: 14,
      );

      expect(
        mixed1 ==
            MixedFraction(
              whole: 1,
              numerator: 4,
              denominator: 7,
            ),
        isTrue,
      );
      expect(mixed1 == mixed2, isTrue);

      expect(mixed1.hashCode != mixed2.hashCode, isTrue);
      expect(
        mixed1.hashCode ==
            MixedFraction(
              whole: 1,
              numerator: 4,
              denominator: 7,
            ).hashCode,
        isTrue,
      );
    });

    test(
      "Making sure that 'compareTo' works according with the natural sorting",
      () {
        final mixed1 = MixedFraction(whole: 0, numerator: -2, denominator: 4);
        final mixed2 = MixedFraction(whole: 1, numerator: 6, denominator: 4);

        expect(mixed1.compareTo(mixed2), equals(-1));
        expect(mixed2.compareTo(mixed1), equals(1));
        expect(mixed1.compareTo(mixed1), equals(0));
      },
    );
  });

  group('Testing the API of the MixedFraction class', () {
    test(
      'Making sure conversions that, if the fraction is gliph-encodeable, '
      "the 'toStringAsGliph()' method works",
      () {
        final frac1 = MixedFraction(
          whole: -2,
          numerator: 1,
          denominator: 2,
        ).toStringAsGlyph();
        final frac2 = MixedFraction(
          whole: 0,
          numerator: 1,
          denominator: 2,
        ).toStringAsGlyph();
        final frac3 = Fraction(12, 15).toMixedFraction();

        expect(frac1, equals('-2 ½'));
        expect(frac2, equals('½'));
        expect(
          frac3.toStringAsGlyph,
          throwsA(isA<FractionException>()),
        );
      },
    );

    test('Making sure conversions to egyptian fractions are correct', () {
      final mixedFraction1 = Fraction(2, 3).toMixedFraction();
      final mixedFraction2 = Fraction(3, 5).toMixedFraction();

      expect(
        mixedFraction1.toEgyptianFraction(),
        unorderedEquals([Fraction(1, 2), Fraction(1, 6)]),
      );
      expect(
        mixedFraction2.toEgyptianFraction(),
        unorderedEquals([Fraction(1, 2), Fraction(1, 10)]),
      );
    });

    test("Making sure that 'copyWith' works properly", () {
      final fraction = MixedFraction(whole: -2, numerator: 1, denominator: 2);

      final copy1 = fraction.copyWith();
      expect(
        copy1,
        equals(MixedFraction(whole: -2, numerator: 1, denominator: 2)),
      );

      final copy2 = fraction.copyWith(numerator: 4);
      expect(
        copy2,
        equals(MixedFraction(whole: -2, numerator: 4, denominator: 2)),
      );

      final copy3 = fraction.copyWith(denominator: 79);
      expect(
        copy3,
        equals(MixedFraction(whole: -2, numerator: 1, denominator: 79)),
      );

      final copy4 = fraction.copyWith(whole: 4);
      expect(
        copy4,
        equals(MixedFraction(whole: 4, numerator: 1, denominator: 2)),
      );
    });

    test('Making sure conversions to double are correct', () {
      expect(
        MixedFraction(whole: 0, numerator: -4, denominator: 1).toDouble(),
        equals(-4.0),
      );
      expect(
        MixedFraction(whole: 2, numerator: 5, denominator: 4).toDouble(),
        equals(3.25),
      );
    });

    test('Making sure conversions to fractions are correct', () {
      final fraction =
          MixedFraction(whole: 10, numerator: 7, denominator: 2).toFraction();
      expect(
        fraction,
        equals(Fraction(27, 2)),
      );
    });

    test('Making sure reduction on the fractional part properly works', () {
      final fraction1 = MixedFraction(
        whole: 1,
        numerator: 3,
        denominator: 6,
      ).reduce();

      expect(fraction1.whole, equals(1));
      expect(fraction1.numerator, equals(1));
      expect(fraction1.denominator, equals(2));
    });

    test('Making sure negation properly works', () {
      final fraction = MixedFraction(whole: -1, numerator: 5, denominator: 3);

      expect(fraction.negate().toDouble(), isPositive);
      expect(fraction.negate().isNegative, isFalse);
    });

    test('Making sure that the fractional part is properly constructed', () {
      final fraction = MixedFraction(whole: 5, numerator: 4, denominator: 7);

      expect(fraction.fractionalPart, equals(Fraction(4, 7)));
    });

    test('Making sure that the "isWhole" method correctly works', () {
      expect(
        MixedFraction(whole: 5, numerator: 4, denominator: 7).isWhole,
        isFalse,
      );
      expect(
        MixedFraction(whole: 5, numerator: 1, denominator: 1).isWhole,
        isTrue,
      );
    });
  });

  group('Testing operators overloads', () {
    final mixed1 = MixedFraction(whole: 1, numerator: 7, denominator: 10);
    final mixed2 = MixedFraction(whole: 2, numerator: 1, denominator: 4);

    test('Making sure that operators +, -, * and / do proper calculations', () {
      expect(
        mixed1 + mixed2,
        equals(MixedFraction(whole: 3, numerator: 19, denominator: 20)),
      );
      expect(
        mixed1 - mixed2,
        equals(MixedFraction(whole: 0, numerator: -11, denominator: 20)),
      );
      expect(
        mixed1 * mixed2,
        equals(MixedFraction(whole: 3, numerator: 33, denominator: 40)),
      );
      expect(
        mixed1 / mixed2,
        equals(MixedFraction(whole: 0, numerator: 34, denominator: 45)),
      );
    });

    test('Making sure that comparison operators compare values correctly', () {
      expect(mixed2 > mixed1, isTrue);
      expect(mixed2 >= mixed1, isTrue);
      expect(mixed2 >= mixed2, isTrue);
      expect(mixed1 < mixed2, isTrue);
      expect(mixed1 <= mixed2, isTrue);
      expect(mixed1 <= mixed2, isTrue);
    });

    test(
      'Making sure that the index operator returns value only when called '
      'with 0, 1 and 2',
      () {
        expect(mixed1[0], equals(1));
        expect(mixed1[1], equals(7));
        expect(mixed1[2], equals(10));
        expect(() => mixed1[3], throwsA(isA<MixedFractionException>()));
      },
    );
  });
}
