import 'package:flutter_test/flutter_test.dart';
import 'package:fraction/fraction.dart';

void main() {
  test("Numerator and denominator", () {
    var f = MixedFraction(1, 5, 7);
    expect(f.toString(), "1 5/7");

    f = MixedFraction(0, -1, 4);
    expect(f.toString(), "-0 1/4");

    expect(() => MixedFraction(3, 7, 2), throwsA(isInstanceOf<MixedFractionException>()));
    expect(() => MixedFraction(0, 0, 0), throwsA(isInstanceOf<MixedFractionException>()));
    expect(() => MixedFraction(4, 2, 0), throwsA(isInstanceOf<MixedFractionException>()));
  });

  test("Conversions", () {
    var f = MixedFraction.fromString("5 1/3");
    expect(f.toString(), "5 1/3");

    f = MixedFraction.fromString("1 -7/4");
    expect(f.toString(), "-1 7/4");

    f = MixedFraction.fromString("1 0/4");
    expect(f.toString(), "1 0/4");

    f = MixedFraction.fromFraction(Fraction(11,2));
    expect(f.toString(), "5 1/2");

    f = MixedFraction.fromFraction(Fraction(-71,-22));
    expect(f.toString(), "3 5/22");

    expect(() => MixedFraction.fromString("3 7/2"), throwsA(isInstanceOf<MixedFractionException>()));
    expect(() => MixedFraction.fromString("1 2/0"), throwsA(isInstanceOf<FractionException>()));
    expect(() => MixedFraction.fromFraction(Fraction(2, 11)), throwsA(isInstanceOf<MixedFractionException>()));
    expect(() => MixedFraction.fromFraction(Fraction(-7, 11)), throwsA(isInstanceOf<MixedFractionException>()));
  });

  test("Methods", () {
    var f = MixedFraction.fromString("5 1/4");
    expect(f.toDouble(), 5.25);

    f = MixedFraction.fromString("3 -3/4");
    expect(f.toDouble(), -3.75);
    expect(f.toFraction().toString(), "-15/4");

    f = MixedFraction.fromString("-3 3/4");
    expect(f.toDouble(), -3.75);
    expect(f.toFraction().toString(), "-15/4");

    f = MixedFraction.fromString("-3 -3/4");
    expect(f.toDouble(), 3.75);
    expect(f.toFraction().toString(), "15/4");
    expect(f.toDouble(), f.toFraction().toDouble());

    f = MixedFraction.fromString("2 8/16");
    expect(f.toString(), "2 8/16");

    f.reduce();
    expect(f.toString(), "2 1/2");

    f = MixedFraction.fromString("2 -2/6")..reduce();
    expect(f.toString(), "-2 1/3");
  });
}