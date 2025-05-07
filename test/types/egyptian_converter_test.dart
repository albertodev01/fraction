import 'package:fraction/fraction.dart';
import 'package:fraction/src/types/egyptian_converter.dart';
import 'package:test/test.dart';

void main() {
  group('Constructors', () {
    test('Making sure that the class can be instantiated', () {
      final egyptian = EgyptianFractionConverter(fraction: Fraction(2, 5));
      expect(egyptian.fraction, equals(Fraction(2, 5)));
    });

    test('Making sure that the class can correctly be instantiated with the '
        'mixed fraction constructor', () {
      final mixed = MixedFraction(whole: 10, numerator: 7, denominator: 2);
      final egyptian = EgyptianFractionConverter.fromMixedFraction(
        mixedFraction: mixed,
      );
      expect(egyptian.fraction, equals(Fraction(27, 2)));
    });

    test(
      'Making sure that the constructor throws in case of invalid fraction',
      () {
        expect(
          () => EgyptianFractionConverter(fraction: Fraction(2, 0)),
          throwsA(isA<FractionException>()),
        );
      },
    );

    test('Making sure that caching properly works', () {
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
    test('Making sure that comparison works properly', () {
      final egyptian1 = EgyptianFractionConverter(fraction: Fraction(1, 3));
      final egyptian2 = EgyptianFractionConverter(fraction: Fraction(4, 12));

      expect(
        egyptian1 == EgyptianFractionConverter(fraction: Fraction(1, 3)),
        isTrue,
      );
      expect(egyptian1 == egyptian2, isTrue);

      expect(egyptian1.hashCode != egyptian2.hashCode, isTrue);
      expect(
        egyptian1.hashCode ==
            EgyptianFractionConverter(fraction: Fraction(1, 3)).hashCode,
        isTrue,
      );
    });
  });

  group('Testing the API', () {
    test("Making sure that the 'compute()' method works properly'", () {
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
      "Making sure that the 'compute()' throws is the fraction is negative'",
      () {
        final egyptian = EgyptianFractionConverter(fraction: Fraction(-2, 5));

        expect(egyptian.compute, throwsA(isA<FractionException>()));
      },
    );

    test("Making sure that 'toString' works properly", () {
      final egyptian = EgyptianFractionConverter(fraction: Fraction(5, 8));
      expect('$egyptian', equals('1/2 + 1/8'));

      // Calling 'toString' twice to make sure that CI coverage also covers the
      // case where the instance is cached
      final egyptian2 = EgyptianFractionConverter(fraction: Fraction(5, 8));
      expect('$egyptian2', equals('1/2 + 1/8'));

      final egyptian3 = EgyptianFractionConverter.fromMixedFraction(
        mixedFraction: MixedFraction(whole: 2, numerator: 4, denominator: 5),
      );
      expect('$egyptian3', equals('1 + 1 + 1/2 + 1/4 + 1/20'));
    });
  });
}
