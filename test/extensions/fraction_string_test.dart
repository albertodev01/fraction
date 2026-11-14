import 'package:fraction/fraction.dart';
import 'package:test/test.dart';

void main() {
  group("Testing the extension method on 'String'", () {
    test('converts strings into fractions', () {
      expect('1/3'.toFraction(), equals(Fraction(1, 3)));
      expect('-4/5'.toFraction(), equals(Fraction(-4, 5)));
      expect('5'.toFraction(), equals(Fraction(5)));
      expect('-5'.toFraction(), equals(Fraction(-5)));
      expect('0'.toFraction(), equals(Fraction(0)));
      expect('⅘'.toFraction(), equals(Fraction(4, 5)));
    });

    test(
      'invalid strings throw an exception',
      () {
        expect('1/'.toFraction, throwsA(isA<FractionException>()));
        expect('1/0'.toFraction, throwsA(isA<FractionException>()));
        expect('x'.toFraction, throwsA(isA<FractionException>()));
        expect('3/-6'.toFraction, throwsA(isA<FractionException>()));
        expect(''.toFraction, throwsA(isA<FractionException>()));
      },
    );

    test(
      'the boolean check is safe to use before converting',
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
