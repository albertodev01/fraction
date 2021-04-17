import 'package:fraction/fraction.dart';
import 'package:test/test.dart';

void main() {
  group('Constructors', () {
    test('Making sure that the class can be instantiated', () {
      final egyptian = EgyptianFraction(fraction: Fraction(2, 5));
      expect(egyptian.fraction, equals(Fraction(2, 5)));
    });

    test('Making sure that the class can correctly be instantiated with the '
        'mixed fraction constructor', () {
      final mixed = MixedFraction(whole: 10, numerator: 7, denominator: 2);
      final egyptian = EgyptianFraction.fromMixedFraction(mixedFraction: mixed);
      expect(egyptian.fraction, equals(Fraction(27, 2)));
    });

    test('Making sure that the constructor throws in case of invalid fraction',
        () {
      expect(
        () => EgyptianFraction(fraction: Fraction(2, 0)),
        throwsA(isA<FractionException>()),
      );
    });

    test('Making sure that the constructor throws with negative fractions', () {
      expect(
        () => EgyptianFraction(fraction: Fraction(-2, 3)),
        throwsA(isA<AssertionError>()),
      );
    });

    test('Making sure that static methods can be accessed', () {
      expect(() {
        EgyptianFraction.clearCache();
        return EgyptianFraction.cachingEnabled;
      }(), isTrue);
    });

    test('Making sure that caching properly works', () {
      final egyptian = EgyptianFraction(fraction: Fraction(2, 5));

      expect(
        egyptian.compute(),
        unorderedEquals([
          Fraction(1, 3),
          Fraction(1, 15),
        ]),
      );
      expect(
        egyptian.compute(),
        unorderedEquals([
          Fraction(1, 3),
          Fraction(1, 15),
        ]),
      );
    });
  });

  group('Testing objects equality', () {
    test('Making sure that comparison works properly', () {
      final egyptian1 = EgyptianFraction(fraction: Fraction(1, 3));
      final egyptian2 = EgyptianFraction(fraction: Fraction(4, 12));

      expect(
        egyptian1 == EgyptianFraction(fraction: Fraction(1, 3)),
        isTrue,
      );
      expect(egyptian1 == egyptian2, isTrue);

      expect(egyptian1.hashCode != egyptian2.hashCode, isTrue);
      expect(
        egyptian1.hashCode ==
            EgyptianFraction(
              fraction: Fraction(1, 3),
            ).hashCode,
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
        final egyptian = EgyptianFraction(fraction: entry.key);
        expect(egyptian.compute(), unorderedEquals(entry.value));
      }
    });

    test("Making sure that 'toString' works properly", () {
      final egyptian = EgyptianFraction(fraction: Fraction(5, 8));
      expect('$egyptian', equals('1/2 + 1/8'));

      // Calling 'toString' twice to make sure that CI coverage also covers the
      // case where the instance is cached
      EgyptianFraction.clearCache();
      expect('$egyptian', equals('1/2 + 1/8'));
    });

    test("Making sure that 'compareTo' works correctly", () {
      final fraction1 = Fraction(4, 7);
      final fraction2 = Fraction(9, 2);

      final egyptian1 = EgyptianFraction(fraction: fraction1);
      final egyptian2 = EgyptianFraction(fraction: fraction2);

      expect(
        egyptian1.compareTo(egyptian2),
        equals(fraction1.compareTo(fraction2)),
      );

      expect(
        egyptian2.compareTo(egyptian1),
        equals(fraction2.compareTo(fraction1)),
      );
    });
  });
}
