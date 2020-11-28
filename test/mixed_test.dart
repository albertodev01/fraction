import 'package:fraction/fraction.dart';
import 'package:test/test.dart';

void main() {
  // Tests on constructors
  group("Testing the behaviors of the constructors", () {
    test("Making sure that whole, numerator and denominator are correct", () {
      final fraction = MixedFraction(whole: 1, numerator: 5, denominator: 7);

      expect(fraction.whole, equals(1));
      expect(fraction.numerator, equals(5));
      expect(fraction.denominator, equals(7));
      expect(fraction.toString(), equals("1 5/7"));
    });

    test("Making sure that an exception is thrown when the denominator is 0",
        () {
      expect(() => MixedFraction(whole: 1, numerator: 5, denominator: 0),
          throwsA(isA<MixedFractionException>()));
    });
  });
}
