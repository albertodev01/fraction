import 'package:fraction/fraction.dart';
import 'package:test/test.dart';

void main() {
  group("Testing the extension method on 'String'", () {
    test('Making sure that strings are properly converted into fractions', () {
      expect('1/3'.toFraction(), equals(Fraction(1, 3)));
      expect('-4/5'.toFraction(), equals(Fraction(-4, 5)));
      expect('5'.toFraction(), equals(Fraction(5)));
      expect('-5'.toFraction(), equals(Fraction(-5)));
      expect('0'.toFraction(), equals(Fraction(0)));
      expect('⅘'.toFraction(), equals(Fraction(4, 5)));
    });

    test(
      'Making sure that invalid strings conversions throw and exception',
      () {
        expect('1/'.toFraction, throwsA(isA<FormatException>()));
        expect('1/0'.toFraction, throwsA(isA<FractionException>()));
        expect('x'.toFraction, throwsA(isA<FractionException>()));
        expect('3/-6'.toFraction, throwsA(isA<FractionException>()));
        expect(''.toFraction, throwsA(isA<FractionException>()));
      },
    );

    test(
      'Making sure that the boolean check is safe to be used before converting',
      () {
        expect('3/5'.isFraction, isTrue);
        expect('-3/5'.isFraction, isTrue);
        expect('6'.isFraction, isTrue);
        expect('-2'.isFraction, isTrue);
        expect('⅜'.isFraction, isTrue);
        expect(''.isFraction, isFalse);
        expect('/2'.isFraction, isFalse);
      },
    );
  });
}
