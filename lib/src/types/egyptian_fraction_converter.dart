import 'package:fraction/fraction.dart';

/// {@template egyptian_fraction_converter}
/// This class converts a [Fraction] or a [MixedFraction] type into its Egyptian
/// fraction representation. Negative values are not allowed.
///
/// An Egyptian fraction is a finite sum of distinct unit fractions: fractions
/// whose numerator is 1 and whose denominator is a positive integer. For
/// example:
///
///  - 5/8 = 1/2 + 1/8 (where "1/2 + 1/8" is the Egyptian fraction)
///
/// Unit fractions are computed with the greedy algorithm. If the value is
/// greater than or equal to 1, its whole part is returned as the first term.
/// Here are some other examples of fractions and their Egyptian fraction
/// equivalent:
///
///  - 4/7 = 1/2 + 1/14
///  - 43/48 = 1/2 + 1/3 + 1/16
///  - 2014/59 = 34 + 1/8 + 1/95 + 1/14947 + 1/670223480
///
/// The denominators can grow very quickly: if one of them does not fit in an
/// [int], a [FractionException] is thrown.
/// {@endtemplate}
class EgyptianFractionConverter {
  /// Creates an [EgyptianFractionConverter] instance from a [Fraction] object.
  ///
  /// {@macro egyptian_fraction_converter}
  const new({required this.fraction});

  /// Creates an [EgyptianFractionConverter] instance from a [MixedFraction]
  /// object.
  ///
  /// {@macro egyptian_fraction_converter}
  factory fromMixedFraction({
    required MixedFraction mixedFraction,
  }) => EgyptianFractionConverter(
    fraction: mixedFraction.toFraction(),
  );

  /// The fraction to be converted into an Egyptian fraction.
  final Fraction fraction;

  /// Returns a series of [Fraction]s that represent the Egyptian fraction of
  /// the [fraction] object. The first term is the whole part of [fraction]
  /// (if it is at least 1), followed by unit fractions with strictly increasing
  /// denominators. The result is empty if [fraction] is zero.
  ///
  /// This method throws a [FractionException] if [fraction] is negative, or if
  /// a denominator does not fit in an [int].
  List<Fraction> compute() {
    if (fraction.isNegative) {
      throw const FractionException('The fraction must not be negative.');
    }

    final results = <Fraction>[];
    final whole = fraction.numerator ~/ fraction.denominator;

    if (whole > 0) {
      results.add(Fraction(whole));
    }

    var numerator = BigInt.from(fraction.numerator % fraction.denominator);
    var denominator = BigInt.from(fraction.denominator);

    while (numerator > BigInt.zero) {
      final unitDenominator =
          (denominator + numerator - BigInt.one) ~/ numerator;

      if (!unitDenominator.isValidInt) {
        throw FractionException(
          'The Egyptian fraction of $fraction has a denominator that is too '
          'large to fit in an int ($unitDenominator).',
        );
      }

      results.add(Fraction(1, unitDenominator.toInt()));

      numerator = numerator * unitDenominator - denominator;
      denominator *= unitDenominator;
      final gcd = numerator.gcd(denominator);

      if (gcd > BigInt.one) {
        numerator ~/= gcd;
        denominator ~/= gcd;
      }
    }

    return results;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is EgyptianFractionConverter) {
      return fraction == other.fraction;
    } else {
      return false;
    }
  }

  @override
  int get hashCode => fraction.hashCode;

  /// The Egyptian fraction as a sum, such as `1/2 + 1/8`.
  @override
  String toString() => compute().join(' + ');
}
