import 'package:fraction/fraction.dart';
import 'package:test/test.dart';

void main() {
  group("Testing the extension method on 'num'", () {
    test(
      'Making sure that integers are properly converted into '
      'mixed fractions',
      () {
        final mixedVal = MixedFraction(
          whole: 0,
          numerator: 16,
          denominator: 1,
        );

        expect(16.toMixedFraction(), equals(mixedVal));
      },
    );

    test(
      'Making sure that doubles are properly converted into '
      'mixed fractions',
      () {
        final mixedVal = MixedFraction(
          whole: 6,
          numerator: 37,
          denominator: 50,
        );

        expect(6.74.toMixedFraction(), equals(mixedVal));
      },
    );
  });
}
