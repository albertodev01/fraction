import 'package:fraction/fraction.dart';
import 'package:test/test.dart';

void main() {
  group("Testing the extension method on 'String'", () {
    test('Making sure that strings are properly converted into fractions', () {
      expect(
        '1 2/3'.toMixedFraction(),
        equals(MixedFraction(whole: 1, numerator: 2, denominator: 3)),
      );
      expect(
        '3 -4/5'.toMixedFraction(),
        equals(MixedFraction(whole: -3, numerator: 4, denominator: 5)),
      );
      expect(
        '0 5/1'.toMixedFraction(),
        equals(MixedFraction(whole: 0, numerator: 5, denominator: 1)),
      );
      expect(
        '-5 3/3'.toMixedFraction(),
        equals(MixedFraction(whole: -5, numerator: 1, denominator: 1)),
      );
      expect(
        '2 ⅔'.toMixedFraction(),
        equals(MixedFraction(whole: 2, numerator: 2, denominator: 3)),
      );
    });

    test(
      'Making sure that invalid strings conversions throw and exception',
      () {
        expect(
          '1/'.toMixedFraction,
          throwsA(isA<MixedFractionException>()),
        );
        expect(
          '1/0'.toMixedFraction,
          throwsA(isA<MixedFractionException>()),
        );
        expect(
          'x'.toMixedFraction,
          throwsA(isA<MixedFractionException>()),
        );
        expect(
          '3/-6'.toMixedFraction,
          throwsA(isA<MixedFractionException>()),
        );
        expect(
          ''.toMixedFraction,
          throwsA(isA<MixedFractionException>()),
        );
        expect(
          '2 2/'.toMixedFraction,
          throwsA(isA<FormatException>()),
        );
        expect(
          '1  1/2'.toMixedFraction,
          throwsA(isA<MixedFractionException>()),
        );
        expect(
          '-1 1/-2'.toMixedFraction,
          throwsA(isA<FractionException>()),
        );
      },
    );

    test(
      'Making sure that the boolean check is safe to be used before converting',
      () {
        expect('1 3/5'.isMixedFraction, isTrue);
        expect('3 ¾'.isMixedFraction, isTrue);
        expect('0 -3/5'.isMixedFraction, isTrue);
        expect(''.isMixedFraction, isFalse);
        expect('7/4'.isMixedFraction, isFalse);
      },
    );
  });
}
