import 'package:fraction/fraction.dart';
import 'package:test/test.dart';

void main() {
  group("Constructors", () {
    test("Numerator and denominator", () {
      var f = Fraction(5, 7);
      expect(f.toString(), "5/7");

      f = Fraction(1, -4);
      expect(f.toString(), "-1/4");

      f = Fraction(6);
      expect(f.toString(), "6");

      f = Fraction(-8);
      expect(f.toString(), "-8");

      f = 1.5.toFraction();
      expect(f.toString(), "3/2");

      f = (-1.5).toFraction();
      expect(f.toString(), "-3/2");

      expect(() => Fraction(1, 0), throwsA(isA<FractionException>()));
    });
  });
}
