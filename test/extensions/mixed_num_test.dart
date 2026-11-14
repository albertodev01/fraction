import 'package:fraction/fraction.dart';
import 'package:test/test.dart';

void main() {
  group("Testing the extension method on 'num'", () {
    test('converts integers into mixed fractions', () {
      final mixedVal = MixedFraction(whole: 0, numerator: 16, denominator: 1);

      expect(16.toMixedFraction(), equals(mixedVal));
    });

    test('converts doubles into mixed fractions', () {
      final mixedVal = MixedFraction(whole: 6, numerator: 37, denominator: 50);

      expect(6.74.toMixedFraction(), equals(mixedVal));
    });
  });
}
