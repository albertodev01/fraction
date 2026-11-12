import 'package:fraction/fraction.dart';
import 'package:test/test.dart';

void main() {
  // Tests on constructors
  group('Testing the behaviors of the constructors', () {
    test('Making sure that whole, numerator and denominator are correct', () {
      final fraction = MixedFraction(whole: 1, numerator: 5, denominator: 7);

      expect(fraction.whole, equals(1));
      expect(fraction.numerator, equals(5));
      expect(fraction.denominator, equals(7));
      expect(fraction.isNegative, isFalse);
      expect(fraction.toString(), equals('1 5/7'));
    });

    test('Making sure that whole, numerator and denominator are correct', () {
      final fraction = MixedFraction(whole: 0, numerator: -1, denominator: -2);

      expect(fraction.whole, equals(0));
      expect(fraction.numerator, equals(1));
      expect(fraction.denominator, equals(2));
      expect(fraction.isNegative, isFalse);
      expect(fraction.toString(), equals('1/2'));
    });

    test('Making sure that whole, numerator and denominator are correct', () {
      final fraction = MixedFraction(whole: 2, numerator: 0, denominator: 1);

      expect(fraction.whole, equals(2));
      expect(fraction.numerator, equals(0));
      expect(fraction.denominator, equals(1));
      expect(fraction.isNegative, isFalse);
      expect(fraction.toString(), equals('2'));
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
        final fraction1 = MixedFraction(whole: 1, numerator: 5, denominator: 3);

        expect(fraction1.whole, equals(2));
        expect(fraction1.numerator, equals(2));
        expect(fraction1.denominator, equals(3));
        expect(fraction1.toString(), equals('2 2/3'));

        final fraction2 = MixedFraction(
          whole: 3,
          numerator: 18,
          denominator: -7,
        );

        expect(fraction2.whole, equals(5));
        expect(fraction2.isNegative, isTrue);
        expect(fraction2.numerator, equals(4));
        expect(fraction2.denominator, equals(7));
        expect(fraction2.toString(), equals('-5 4/7'));

        final fraction3 = MixedFraction(
          whole: 2,
          numerator: -6,
          denominator: 5,
        );

        expect(fraction3.whole, equals(3));
        expect(fraction3.isNegative, isTrue);
        expect(fraction3.numerator, equals(1));
        expect(fraction3.denominator, equals(5));
        expect(fraction3.toString(), equals('-3 1/5'));

        // Both parts can't be negative: the intended sign is ambiguous.
        expect(
          () => MixedFraction(whole: -5, numerator: -1, denominator: 3),
          throwsA(isA<MixedFractionException>()),
        );
      },
    );

    test('Making sure that negative signs are properly handled', () {
      // Both parts can't be negative: the intended sign is ambiguous.
      expect(
        () => MixedFraction(whole: -1, numerator: -4, denominator: 9),
        throwsA(isA<MixedFractionException>()),
      );

      final fraction2 = MixedFraction(
        whole: -2,
        numerator: -4,
        denominator: -11,
      );

      expect(fraction2.whole, equals(2));
      expect(fraction2.isNegative, isTrue);
      expect(fraction2.numerator, equals(4));
      expect(fraction2.denominator, equals(11));
      expect(fraction2.toString(), equals('-2 4/11'));

      final fraction3 = MixedFraction(whole: 6, numerator: 2, denominator: -7);

      expect(fraction3.whole, equals(6));
      expect(fraction3.isNegative, isTrue);
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

    test('Making sure that mixed fractions are properly constructed from '
        'fractions', () {
      final fraction = MixedFraction.fromFraction(Fraction(19, 3));

      expect(fraction.whole, equals(6));
      expect(fraction.numerator, equals(1));
      expect(fraction.denominator, equals(3));
    });

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

        // The fractional part must contain a slash or be a glyph.
        expect(
          () => MixedFraction.fromString('2 5'),
          throwsA(isA<MixedFractionException>()),
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
          throwsA(isA<MixedFractionException>()),
        );
        expect(
          () => MixedFraction.fromString('2 c/0'),
          throwsA(isA<MixedFractionException>()),
        );
        expect(
          () => MixedFraction.fromString('1 2/0'),
          throwsA(isA<MixedFractionException>()),
        );
      },
    );

    test('Making sure that mixed fractions are properly constructed from '
        'decimal values', () {
      expect(
        MixedFraction.fromDouble(5.46),
        equals(MixedFraction(whole: 5, numerator: 23, denominator: 50)),
      );
      expect(
        MixedFraction.fromDouble(1.06),
        equals(MixedFraction(whole: 1, numerator: 3, denominator: 50)),
      );
      expect(
        MixedFraction.fromDouble(0),
        equals(MixedFraction(whole: 0, numerator: 0, denominator: 1)),
      );
    });
  });

  group('Testing objects equality', () {
    test('Making sure that equivalent mixed fractions are equal', () {
      final mixed1 = MixedFraction(whole: 1, numerator: 4, denominator: 7);
      final mixed2 = MixedFraction(whole: 1, numerator: 8, denominator: 14);

      expect(
        mixed1 == MixedFraction(whole: 1, numerator: 4, denominator: 7),
        isTrue,
      );
      expect(mixed1 == mixed2, isTrue);

      expect(mixed1.hashCode == mixed2.hashCode, isTrue);
      expect(
        mixed1.hashCode ==
            MixedFraction(whole: 1, numerator: 4, denominator: 7).hashCode,
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
    test('Making sure conversions that, if the fraction is gliph-encodeable, '
        "the 'toStringAsGliph()' method works", () {
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
      // 12/15 is equivalent to 4/5, which has a glyph.
      final frac3 = Fraction(12, 15).toMixedFraction();
      final frac4 = Fraction(12, 17).toMixedFraction();

      expect(frac1, equals('-2 ½'));
      expect(frac2, equals('½'));
      expect(frac3.toStringAsGlyph(), equals('⅘'));
      expect(frac4.toStringAsGlyph, throwsA(isA<FractionException>()));
    });

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

      // The sign of the original mixed fraction is kept.
      final copy4 = fraction.copyWith(whole: 4);
      expect(
        copy4,
        equals(MixedFraction(whole: -4, numerator: 1, denominator: 2)),
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
      final fraction = MixedFraction(
        whole: 10,
        numerator: 7,
        denominator: 2,
      ).toFraction();
      expect(fraction, equals(Fraction(27, 2)));
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

    test('Making sure that the index operator returns value only when called '
        'with 0, 1 and 2', () {
      expect(mixed1[0], equals(1));
      expect(mixed1[1], equals(7));
      expect(mixed1[2], equals(10));
      expect(() => mixed1[3], throwsA(isA<MixedFractionException>()));
    });
  });

  group('Regression: equality and hashing', () {
    test('Making sure that equal mixed fractions have the same hash code', () {
      final a = MixedFraction(whole: 1, numerator: 3, denominator: 4);
      final b = MixedFraction(whole: 1, numerator: 6, denominator: 8);
      final c = MixedFraction(whole: -2, numerator: 2, denominator: 10);
      final d = MixedFraction(whole: -2, numerator: 1, denominator: 5);

      expect(a, equals(b));
      expect(a.hashCode, equals(b.hashCode));
      expect(c, equals(d));
      expect(c.hashCode, equals(d.hashCode));
    });

    test(
      'Making sure that equivalent mixed fractions work in sets and maps',
      () {
        final set = {
          MixedFraction(whole: 1, numerator: 3, denominator: 4),
          MixedFraction(whole: 1, numerator: 6, denominator: 8),
          MixedFraction(whole: 1, numerator: 9, denominator: 12),
        };
        expect(set, hasLength(1));

        final map = {
          MixedFraction(whole: 2, numerator: 1, denominator: 2): 'x',
        };
        expect(
          map[MixedFraction(whole: 2, numerator: 2, denominator: 4)],
          equals('x'),
        );
      },
    );

    test('Making sure that equality does not overflow', () {
      // 1/2^32 and 1 1/2^32 have cross products that wrap around to the same
      // 64-bit value.
      expect(
        MixedFraction(whole: 0, numerator: 1, denominator: 4294967296) ==
            MixedFraction(whole: 1, numerator: 1, denominator: 4294967296),
        isFalse,
      );
    });

    test('Making sure that a MixedFraction is never equal to a Fraction', () {
      final mixed = MixedFraction(whole: 2, numerator: 4, denominator: 5);

      expect(mixed == Fraction(14, 5), isFalse);
      expect(Fraction(14, 5) == mixed, isFalse);
    });
  });

  group('Regression: sign handling', () {
    MixedFraction mixed(int whole, int numerator, int denominator) =>
        MixedFraction(
          whole: whole,
          numerator: numerator,
          denominator: denominator,
        );

    test('Making sure that negative values with no whole part keep their '
        'sign', () {
      for (final value in [mixed(0, -1, 2), mixed(0, 1, -2)]) {
        expect(value.isNegative, isTrue);
        expect(value.whole, equals(0));
        expect(value.numerator, equals(1));
        expect(value.denominator, equals(2));
        expect(value.toString(), equals('-1/2'));
        expect(value.toDouble(), equals(-0.5));
        expect(value.toFraction(), equals(Fraction(-1, 2)));
      }

      expect(mixed(0, -1, 2) == mixed(0, 1, 2), isFalse);
    });

    test('Making sure that a negative sign on either part negates the whole '
        'value', () {
      for (final value in [mixed(-2, 1, 3), mixed(2, -1, 3), mixed(2, 1, -3)]) {
        expect(value.isNegative, isTrue);
        expect(value.whole, equals(2));
        expect(value.toString(), equals('-2 1/3'));
        expect(value.toFraction(), equals(Fraction(-7, 3)));
      }
    });

    test('Making sure that both parts being negative throws', () {
      expect(() => mixed(-1, -1, 2), throwsA(isA<MixedFractionException>()));
      expect(() => mixed(-1, 1, -2), throwsA(isA<MixedFractionException>()));

      // Two negative signs in the fraction make it positive, so this is fine.
      expect(mixed(-1, -1, -2).toString(), equals('-1 1/2'));
    });

    test('Making sure that zero is never negative', () {
      for (final value in [mixed(0, 0, 5), mixed(0, 0, -5), mixed(-0, 0, 1)]) {
        expect(value.isNegative, isFalse);
        expect(value.toString(), equals('0'));
        expect(value.negate().isNegative, isFalse);
      }

      expect(0.toMixedFraction().toString(), equals('0'));
    });

    test("Making sure that 'toDouble' is correct for negative values", () {
      expect(mixed(-2, 4, 5).toDouble(), equals(-2.8));
      expect(mixed(2, -1, 4).toDouble(), equals(-2.25));
      expect(mixed(-3, 0, 1).toDouble(), equals(-3.0));
      expect((-1.5).toMixedFraction().toDouble(), equals(-1.5));
    });

    test("Making sure that 'negate' works when the whole part is zero", () {
      final half = mixed(0, 1, 2);

      expect(half.negate(), equals(mixed(0, -1, 2)));
      expect(half.negate().negate(), equals(half));
      expect(mixed(-2, 1, 3).negate(), equals(mixed(2, 1, 3)));
    });

    test("Making sure that 'reduce', 'copyWith' and 'toStringAsGlyph' keep the "
        'sign', () {
      final reduced = mixed(-2, 2, 4).reduce();
      expect(reduced.isNegative, isTrue);
      expect(reduced.whole, equals(2));
      expect(reduced.numerator, equals(1));
      expect(reduced.denominator, equals(2));

      expect(mixed(0, -1, 2).copyWith(denominator: 3), equals(mixed(0, -1, 3)));
      expect(mixed(-2, 1, 3).copyWith(numerator: 2), equals(mixed(-2, 2, 3)));

      expect(mixed(0, -1, 2).toStringAsGlyph(), equals('-½'));
      expect(mixed(-2, 1, 2).toStringAsGlyph(), equals('-2 ½'));
    });

    test('Making sure that the index operator returns non-negative parts', () {
      final value = mixed(-2, 1, 3);

      expect(value[0], equals(2));
      expect(value[1], equals(1));
      expect(value[2], equals(3));
    });

    test('Making sure that comparisons use the sign', () {
      expect(mixed(0, -1, 2).compareTo(Fraction(-1, 2)), isZero);
      expect(mixed(0, -1, 2) < mixed(0, 0, 1), isTrue);
      expect(mixed(0, -1, 2) < mixed(0, 1, 2), isTrue);
      expect(mixed(-1, 1, 2) < mixed(0, -1, 2), isTrue);
    });
  });

  group('Regression: arithmetic', () {
    MixedFraction mixed(int whole, int numerator, int denominator) =>
        MixedFraction(
          whole: whole,
          numerator: numerator,
          denominator: denominator,
        );

    test('Making sure that subtraction is not reversed', () {
      expect(mixed(3, 1, 2) - mixed(1, 0, 1), equals(mixed(2, 1, 2)));

      final difference = mixed(1, 7, 10) - mixed(2, 1, 4);
      expect(difference.isNegative, isTrue);
      expect(difference.toString(), equals('-11/20'));

      expect(mixed(0, 1, 2) - mixed(1, 0, 1), equals(mixed(0, -1, 2)));
    });

    test('Making sure that operators handle negative values', () {
      final a = mixed(5, 7, 8);
      final b = mixed(3, 1, 9);

      expect(a - b, equals((b - a).negate()));
      expect((a - a).isNegative, isFalse);
      expect(mixed(-2, 1, 2) + mixed(1, 1, 2), equals(mixed(-1, 0, 1)));
      expect(mixed(0, -1, 2) * mixed(0, -1, 2), equals(mixed(0, 1, 4)));
      expect(mixed(0, -1, 2) / mixed(0, 1, 4), equals(mixed(-2, 0, 1)));
    });

    test('Making sure that the documented examples are correct', () {
      final f1 = mixed(5, 7, 8);
      final f2 = mixed(3, 1, 9);

      expect((f1 + f2).toString(), equals('8 71/72'));
      expect((f1 - f2).toString(), equals('2 55/72'));
      expect((f1 * f2).toString(), equals('18 5/18'));
      expect((f1 / f2).toString(), equals('1 199/224'));
    });
  });

  group("Regression: 'isWhole' and normalization", () {
    test(
      "Making sure that 'isWhole' is true when there's no fractional part",
      () {
        expect(
          MixedFraction(whole: 3, numerator: 0, denominator: 5).isWhole,
          isTrue,
        );
        expect(
          MixedFraction(whole: -3, numerator: 0, denominator: 5).isWhole,
          isTrue,
        );
        expect(
          MixedFraction(whole: 0, numerator: 1, denominator: 2).isWhole,
          isFalse,
        );
      },
    );

    test('Making sure that a fractional part equal to 1 is normalized', () {
      final value = MixedFraction(whole: 3, numerator: 4, denominator: 4);

      expect(value.whole, equals(4));
      expect(value.numerator, equals(0));
      expect(value.isWhole, isTrue);
      expect(value.toString(), equals('4'));
    });
  });

  group('Regression: fromString', () {
    test('Making sure that the sign can be on either part', () {
      final cases = {
        '-0 1/2': '-1/2',
        '0 -1/2': '-1/2',
        '2 -2/5': '-2 2/5',
        '-2 2/5': '-2 2/5',
        '+1 1/2': '1 1/2',
        '-1 ½': '-1 1/2',
      };

      for (final MapEntry(key: input, value: output) in cases.entries) {
        expect(
          MixedFraction.fromString(input).toString(),
          equals(output),
          reason: input,
        );
      }
    });

    test('Making sure that invalid strings throw a MixedFractionException', () {
      for (final value in [
        '-1 -2/5',
        '1 3',
        'x 1/2',
        '1 x',
        '1.5 1/2',
        '1 1/2 ',
        ' 1 1/2',
        '1 1/2/3',
        '99999999999999999999 1/2',
        '1 99999999999999999999/2',
        '',
      ]) {
        expect(
          () => MixedFraction.fromString(value),
          throwsA(isA<MixedFractionException>()),
          reason: '"$value"',
        );
      }
    });

    test('Making sure that the extensions keep the sign', () {
      expect((-0.5).toMixedFraction().toString(), equals('-1/2'));
      expect('0 -1/2'.toMixedFraction().toString(), equals('-1/2'));
      expect('-1 -2/5'.isMixedFraction, isFalse);
      expect('1 3'.isMixedFraction, isFalse);
    });
  });

  group('Regression: toFraction', () {
    test('Making sure that large values do not overflow silently', () {
      // 2^40 * 2^40 + 1 doesn't fit in an int.
      expect(
        () => MixedFraction(
          whole: 1099511627776,
          numerator: 1,
          denominator: 1099511627776,
        ).toFraction(),
        throwsA(isA<FractionException>()),
      );

      // 2^40 + 2^39/2^40: the magnitude overflows, but the reduced result
      // (2^41 + 1)/2 fits.
      expect(
        MixedFraction(
          whole: 1099511627776,
          numerator: 549755813888,
          denominator: 1099511627776,
        ).toFraction(),
        equals(Fraction(2199023255553, 2)),
      );
    });
  });
}
