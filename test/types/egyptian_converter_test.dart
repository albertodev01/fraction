import 'package:fraction/fraction.dart';
import 'package:fraction/src/types/egyptian_fraction_converter.dart';
import 'package:test/test.dart';

void main() {
  group('Constructors', () {
    test('can be instantiated', () {
      final egyptian = EgyptianFractionConverter(fraction: Fraction(2, 5));
      expect(egyptian.fraction, equals(Fraction(2, 5)));
    });

    test('can be instantiated from a mixed fraction', () {
      final mixed = MixedFraction(whole: 10, numerator: 7, denominator: 2);
      final egyptian = EgyptianFractionConverter.fromMixedFraction(
        mixedFraction: mixed,
      );
      expect(egyptian.fraction, equals(Fraction(27, 2)));
    });

    test(
      'the constructor throws on an invalid fraction',
      () {
        expect(
          () => EgyptianFractionConverter(fraction: Fraction(2, 0)),
          throwsA(isA<FractionException>()),
        );
      },
    );

    test('repeated calls return the same result', () {
      final egyptian = EgyptianFractionConverter(fraction: Fraction(2, 5));

      expect(
        egyptian.compute(),
        unorderedEquals([Fraction(1, 3), Fraction(1, 15)]),
      );
      expect(
        egyptian.compute(),
        unorderedEquals([Fraction(1, 3), Fraction(1, 15)]),
      );
    });
  });

  group('Testing objects equality', () {
    test('comparison works', () {
      final egyptian1 = EgyptianFractionConverter(fraction: Fraction(1, 3));
      final egyptian2 = EgyptianFractionConverter(fraction: Fraction(4, 12));

      expect(
        egyptian1 == EgyptianFractionConverter(fraction: Fraction(1, 3)),
        isTrue,
      );
      expect(egyptian1 == egyptian2, isTrue);

      expect(egyptian1.hashCode == egyptian2.hashCode, isTrue);
      expect(
        egyptian1.hashCode ==
            EgyptianFractionConverter(fraction: Fraction(1, 3)).hashCode,
        isTrue,
      );
    });
  });

  group('Testing the API', () {
    test("'compute()' works", () {
      final testMatrix = {
        Fraction(5, 8): [Fraction(1, 2), Fraction(1, 8)],
        Fraction(2, 3): [Fraction(1, 2), Fraction(1, 6)],
        Fraction(2, 5): [Fraction(1, 3), Fraction(1, 15)],
        Fraction(3, 4): [Fraction(1, 2), Fraction(1, 4)],
        Fraction(3, 5): [Fraction(1, 2), Fraction(1, 10)],
        Fraction(4, 5): [Fraction(1, 2), Fraction(1, 4), Fraction(1, 20)],
        Fraction(7, 15): [Fraction(1, 3), Fraction(1, 8), Fraction(1, 120)],
      };

      for (final entry in testMatrix.entries) {
        final egyptian = EgyptianFractionConverter(fraction: entry.key);
        expect(egyptian.compute(), unorderedEquals(entry.value));
      }
    });

    test(
      "'compute()' throws if the fraction is negative",
      () {
        final egyptian = EgyptianFractionConverter(fraction: Fraction(-2, 5));

        expect(egyptian.compute, throwsA(isA<FractionException>()));
      },
    );

    test("'toString()' works", () {
      final egyptian = EgyptianFractionConverter(fraction: Fraction(5, 8));
      expect('$egyptian', equals('1/2 + 1/8'));

      final egyptian2 = EgyptianFractionConverter(fraction: Fraction(5, 8));
      expect('$egyptian2', equals('1/2 + 1/8'));

      final egyptian3 = EgyptianFractionConverter.fromMixedFraction(
        mixedFraction: MixedFraction(whole: 2, numerator: 4, denominator: 5),
      );
      expect('$egyptian3', equals('2 + 1/2 + 1/4 + 1/20'));
    });
  });

  group('Regression: equality and hashing', () {
    test('equivalent converters work in sets', () {
      final converters = {
        EgyptianFractionConverter(fraction: Fraction(1, 2)),
        EgyptianFractionConverter(fraction: Fraction(2, 4)),
        EgyptianFractionConverter(fraction: Fraction(-3, -6)),
      };

      expect(converters, hasLength(1));
    });

    test('equivalent fractions give the same result', () {
      expect(
        Fraction(10, 16).toEgyptianFraction(),
        orderedEquals(Fraction(5, 8).toEgyptianFraction()),
      );
    });
  });

  group('Regression: Egyptian fractions', () {
    test('changing a result does not affect later calls', () {
      Fraction(5, 8).toEgyptianFraction().clear();
      Fraction(5, 8).toEgyptianFraction().add(Fraction(1, 3));

      expect(
        Fraction(5, 8).toEgyptianFraction(),
        orderedEquals([Fraction(1, 2), Fraction(1, 8)]),
      );
    });

    test('each call returns a new list', () {
      final converter = EgyptianFractionConverter(fraction: Fraction(2, 7));

      // The old cache returned the same list from the second call onwards.
      final first = converter.compute();
      final second = converter.compute();
      final third = converter.compute();

      expect(identical(first, second), isFalse);
      expect(identical(second, third), isFalse);
    });

    test('the whole part is a single term', () {
      expect(Fraction(1).toEgyptianFraction(), orderedEquals([Fraction(1)]));
      expect(Fraction(3).toEgyptianFraction(), orderedEquals([Fraction(3)]));
      expect(
        Fraction(7, 2).toEgyptianFraction(),
        orderedEquals([Fraction(3), Fraction(1, 2)]),
      );
      expect(
        MixedFraction(
          whole: 2,
          numerator: 4,
          denominator: 5,
        ).toEgyptianFraction(),
        orderedEquals([
          Fraction(2),
          Fraction(1, 2),
          Fraction(1, 4),
          Fraction(1, 20),
        ]),
      );
    });

    test(
      'large whole parts are fast',
      () {
        expect(
          Fraction(1000000000).toEgyptianFraction(),
          orderedEquals([Fraction(1000000000)]),
        );
      },
      timeout: const Timeout(Duration(seconds: 5)),
    );

    test('the documented example is correct', () {
      final result = Fraction(2014, 59).toEgyptianFraction();

      expect(
        result,
        orderedEquals([
          Fraction(34),
          Fraction(1, 8),
          Fraction(1, 95),
          Fraction(1, 14947),
          Fraction(1, 670223480),
        ]),
      );
      expect(
        EgyptianFractionConverter(fraction: Fraction(2014, 59)).toString(),
        equals('34 + 1/8 + 1/95 + 1/14947 + 1/670223480'),
      );
    });

    test('zero gives an empty result', () {
      expect(Fraction(0).toEgyptianFraction(), isEmpty);
      expect(EgyptianFractionConverter(fraction: Fraction(0)).toString(), '');
    });

    test('negative values throw', () {
      expect(
        () => Fraction(-5, 8).toEgyptianFraction(),
        throwsA(isA<FractionException>()),
      );
      expect(
        () => MixedFraction(
          whole: 0,
          numerator: -1,
          denominator: 2,
        ).toEgyptianFraction(),
        throwsA(isA<FractionException>()),
      );
    });

    test('denominators too large for an int throw instead of overflowing', () {
      // The last term of 5/121 is 1/1527612795642093418846225.
      expect(
        () => Fraction(5, 121).toEgyptianFraction(),
        throwsA(isA<FractionException>()),
      );
    });

    test(
      'results are distinct unit fractions adding up to the original value',
      () {
        for (var d = 1; d <= 30; d++) {
          for (var n = 0; n <= 2 * d; n++) {
            final fraction = Fraction(n, d);
            final result = fraction.toEgyptianFraction();

            // The sum is exact.
            final sum = result.fold(Fraction(0), (a, b) => a + b);
            expect(sum, equals(fraction), reason: '$fraction');

            // Every term after the whole part is a unit fraction, and the
            // denominators are strictly increasing.
            final unitList = n >= d ? result.skip(1).toList() : result;
            for (var i = 0; i < unitList.length; i++) {
              expect(unitList[i].numerator, equals(1), reason: '$fraction');
              if (i > 0) {
                expect(
                  unitList[i].denominator,
                  greaterThan(unitList[i - 1].denominator),
                  reason: '$fraction',
                );
              }
            }
          }
        }
      },
    );
  });
}
