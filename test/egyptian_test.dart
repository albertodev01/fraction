import 'package:fraction/fraction.dart';
import 'package:test/test.dart';

void main() {
  group('Constructors', () {
    test('Making sure that the class can be instantiated', () {
      final egyptian = EgyptianFraction(fraction: Fraction(2, 5));
      expect(egyptian.fraction, equals(Fraction(2, 5)));
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
    final testMatrix = {
      Fraction(5, 8): [Fraction(1, 2), Fraction(1, 8)],
      Fraction(2, 3): [Fraction(1, 2), Fraction(1, 6)],
      Fraction(2, 5): [Fraction(1, 3), Fraction(1, 15)],
      Fraction(3, 4): [Fraction(1, 2), Fraction(1, 4)],
      Fraction(3, 5): [Fraction(1, 2), Fraction(1, 10)],
      Fraction(4, 5): [Fraction(1, 2), Fraction(1, 4), Fraction(1, 20)],
      Fraction(7, 15): [Fraction(1, 3), Fraction(1, 8), Fraction(1, 120)],
    };

    test("Making sure that the 'compute()' method works properly'", () {
      for (final entry in testMatrix.entries) {
        final egyptian = EgyptianFraction(fraction: entry.key);
        expect(egyptian.compute(), unorderedEquals(entry.value));
      }
    });
  });
}
