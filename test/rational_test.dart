import 'package:fraction/fraction.dart';
import 'package:test/test.dart';

/// A [Rational] subclass defined outside of the package, which (unlike
/// [Fraction] and [MixedFraction]) doesn't normalize a negative denominator.
final class _UnnormalizedRational extends Rational {
  const new(this.numerator, this.denominator);

  @override
  final int numerator;

  @override
  final int denominator;

  @override
  bool get isNegative => toDouble() < 0;

  @override
  bool get isWhole => numerator % denominator == 0;

  @override
  double toDouble() => numerator / denominator;

  @override
  Rational negate() => _UnnormalizedRational(-numerator, denominator);

  @override
  Rational reduce() => this;

  @override
  List<Fraction> toEgyptianFraction() => const [];
}

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
        expect(Rational.tryParse('-1 2/5'), isA<MixedFraction>());

        // Invalid
        expect(Rational.tryParse(''), isNull);
        expect(Rational.tryParse('1 2/-3'), isNull);
        expect(Rational.tryParse('1 0/0'), isNull);
        expect(Rational.tryParse('5 -1/-0'), isNull);
        expect(Rational.tryParse('1 3'), isNull);
        expect(Rational.tryParse('-1 -2/5'), isNull);
      },
    );

    test(
      'Making sure that glyphs are parsed instead of throwing',
      () {
        expect(Rational.tryParse('½'), equals(Fraction(1, 2)));
        expect(Rational.tryParse('⅐'), equals(Fraction(1, 7)));
        expect(
          Rational.tryParse('3 ⅐'),
          equals(MixedFraction(whole: 3, numerator: 1, denominator: 7)),
        );
        expect(Rational.tryParse('¬'), isNull);
      },
    );

    test(
      'Making sure that parsed values are normalized as documented',
      () {
        expect(
          Rational.tryParse('2 5/3'),
          equals(MixedFraction(whole: 3, numerator: 2, denominator: 3)),
        );
        expect(Rational.tryParse('3'), isA<Fraction>());
      },
    );
  });

  group("Testing comparisons on the 'Rational' class", () {
    test(
      'Making sure that values closer than double precision are not equal',
      () {
        // Both values convert to the same double.
        final third = Fraction(1, 3);
        final almostThird = Fraction(3333333333333333, 10000000000000000);
        expect(third.toDouble(), equals(almostThird.toDouble()));

        expect(almostThird.compareTo(third), isNegative);
        expect(third.compareTo(almostThird), isPositive);
        expect(almostThird < third, isTrue);
        expect(almostThird <= third, isTrue);
        expect(third > almostThird, isTrue);
        expect(third >= almostThird, isTrue);
        expect(third < almostThird, isFalse);
        expect(almostThird > third, isFalse);
      },
    );

    test(
      'Making sure that integers beyond 2^53 are compared exactly',
      () {
        // 2^53 + 1 and 2^53 convert to the same double. This test needs
        // 64-bit integers, so it only runs on the VM.
        // ignore: avoid_js_rounded_ints
        final bigger = Fraction(9007199254740993);
        final smaller = Fraction(9007199254740992);

        expect(bigger.compareTo(smaller), isPositive);
        expect(smaller.compareTo(bigger), isNegative);
        expect(bigger > smaller, isTrue);
        expect(smaller < bigger, isTrue);
        expect(bigger <= smaller, isFalse);
        expect(smaller >= bigger, isFalse);
      },
      testOn: 'vm',
    );

    test(
      'Making sure that cross-multiplication does not overflow',
      () {
        // These products exceed the 64-bit integer range.
        const max = 9223372036854775807;
        final a = Fraction(max - 1, max);
        final b = Fraction(max - 2, max - 1);

        expect(a.compareTo(b), isPositive);
        expect(b.compareTo(a), isNegative);
        expect(a > b, isTrue);
      },
      testOn: 'vm',
    );

    test(
      'Making sure that equivalent fractions compare as equal',
      () {
        expect(Fraction(1, 2).compareTo(Fraction(3, 6)), isZero);
        expect(Fraction(-1, 2).compareTo(Fraction(2, -4)), isZero);
        expect(Fraction(1, 2) <= Fraction(2, 4), isTrue);
        expect(Fraction(1, 2) >= Fraction(2, 4), isTrue);
        expect(Fraction(1, 2) < Fraction(2, 4), isFalse);
        expect(Fraction(1, 2) > Fraction(2, 4), isFalse);
      },
    );

    test(
      'Making sure that signs are handled correctly',
      () {
        expect(Fraction(-1, 2).compareTo(Fraction(1, 3)), isNegative);
        expect(Fraction(-1, 2).compareTo(Fraction(-1, 3)), isNegative);
        expect(Fraction(0).compareTo(Fraction(-1, 1000)), isPositive);
        expect(Fraction(0).compareTo(Fraction(0, 5)), isZero);
      },
    );

    test(
      'Making sure that mixed fractions are compared by their whole value',
      () {
        final mixed = MixedFraction(whole: 2, numerator: 4, denominator: 5);

        // 2 4/5 == 14/5
        expect(mixed.compareTo(Fraction(14, 5)), isZero);
        expect(Fraction(14, 5).compareTo(mixed), isZero);

        // 2 4/5 > 13/5 and 2 4/5 < 3
        expect(mixed > Fraction(13, 5), isTrue);
        expect(mixed < Fraction(3), isTrue);

        // 2 1/5 < 2 4/5
        expect(
          MixedFraction(whole: 2, numerator: 1, denominator: 5) < mixed,
          isTrue,
        );
      },
    );

    test(
      'Making sure that negative mixed fractions are compared correctly',
      () {
        final negative = MixedFraction(whole: -2, numerator: 4, denominator: 5);

        // -2 4/5 == -14/5
        expect(negative.compareTo(Fraction(-14, 5)), isZero);

        // -2 4/5 < -2 1/5 < 0
        expect(
          negative < MixedFraction(whole: -2, numerator: 1, denominator: 5),
          isTrue,
        );
        expect(negative < Fraction(0), isTrue);
        expect(
          negative < MixedFraction(whole: 1, numerator: 1, denominator: 5),
          isTrue,
        );
      },
    );

    test(
      'Making sure that sorting uses exact comparisons',
      () {
        final values = <Rational>[
          Fraction(1, 3),
          MixedFraction(whole: 1, numerator: 1, denominator: 2),
          Fraction(3333333333333333, 10000000000000000),
          Fraction(-1, 2),
        ]..sort();

        expect(
          values,
          orderedEquals(<Rational>[
            Fraction(-1, 2),
            Fraction(3333333333333333, 10000000000000000),
            Fraction(1, 3),
            MixedFraction(whole: 1, numerator: 1, denominator: 2),
          ]),
        );
      },
    );

    test(
      'Making sure that subclasses with a negative denominator are compared '
      'correctly',
      () {
        // 1/-2 is -1/2 and -3/-4 is 3/4.
        const negativeHalf = _UnnormalizedRational(1, -2);
        const threeQuarters = _UnnormalizedRational(-3, -4);

        expect(negativeHalf.compareTo(Fraction(-1, 2)), isZero);
        expect(negativeHalf < Fraction(0), isTrue);
        expect(threeQuarters.compareTo(Fraction(3, 4)), isZero);
        expect(threeQuarters > negativeHalf, isTrue);
        expect(Fraction(1, 2) > negativeHalf, isTrue);
      },
    );
  });
}
