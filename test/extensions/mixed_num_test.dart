import 'package:test/test.dart';
import 'package:fraction/fraction.dart';

void main() {
  group("Testing the extension method on 'num'", () {
    test(
        "Making sure that integers are properly converted into mixed fractions",
        () {
      final integerVal = 16;
      final mixedVal = MixedFraction(whole: 0, numerator: 16, denominator: 1);

      expect(integerVal.toMixedFraction(), equals(mixedVal));
    });

    test("Making sure that doubles are properly converted into mixed fractions",
        () {
      final doubleVal = 6.74;
      final mixedVal = MixedFraction(whole: 6, numerator: 37, denominator: 50);

      expect(doubleVal.toMixedFraction(), equals(mixedVal));
    });
  });
}
