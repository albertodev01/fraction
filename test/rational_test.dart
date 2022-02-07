import 'package:fraction/fraction.dart';
import 'package:test/test.dart';

void main() {
  group("Testing the 'Rational' class", () {
    test(
      'Making sure that Fraction conversions from string correctly work',
      () {
        // Valid
        expect(Rational.tryParse('-1/2'), isA<Fraction>());
        expect(Rational.tryParse('1/2'), isA<Fraction>());
        expect(Rational.tryParse('1'), isA<Fraction>());
        expect(Rational.tryParse('-1'), isA<Fraction>());
        expect(Rational.tryParse('0/1'), isA<Fraction>());
        expect(Rational.tryParse('-0/1'), isA<Fraction>());
        expect(Rational.tryParse('0'), isA<Fraction>());

        // Invalid
        expect(Rational.tryParse(''), isNull);
        expect(Rational.tryParse('1/'), isNull);
        expect(Rational.tryParse('/2'), isNull);
        expect(Rational.tryParse('1/-2'), isNull);
        expect(Rational.tryParse('1/0'), isNull);
      },
    );

    test(
      'Making sure that MixedFraction conversions from string correctly work',
      () {
        // Valid
        expect(Rational.tryParse('1 1/2'), isA<MixedFraction>());
        expect(Rational.tryParse('1 2/2'), isA<MixedFraction>());
        expect(Rational.tryParse('1 3/1'), isA<MixedFraction>());
        expect(Rational.tryParse('1 3'), isA<MixedFraction>());
        expect(Rational.tryParse('-1 2/5'), isA<MixedFraction>());
        expect(Rational.tryParse('-1 -2/5'), isA<MixedFraction>());

        // Invalid
        expect(Rational.tryParse(''), isNull);
        expect(Rational.tryParse('1 2/-3'), isNull);
        expect(Rational.tryParse('1 0/0'), isNull);
        expect(Rational.tryParse('5 -1/-0'), isNull);
      },
    );
  });
}
