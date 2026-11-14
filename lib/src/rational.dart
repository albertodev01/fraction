import 'package:fraction/fraction.dart';

/// {@template rational}
/// Dart representation of a rational number.
///
/// A **rational number** is a number that can be expressed as the quotient
/// `x/y` of two integers, a numerator `x` and a non-zero denominator `y`. Any
/// rational number is also a real number.
///
/// [Rational] and all of its subtypes are **immutable**. This type is abstract,
/// so it cannot be instantiated directly.
///
/// Comparisons ([compareTo], `<`, `<=`, `>` and `>=`) are exact and work across
/// subtypes, so a [Fraction] can be compared with a [MixedFraction]. Note that
/// [compareTo] may return `0` for two objects that are not equal according to
/// `operator ==` (for example, `Fraction(14, 5)` and the mixed fraction
/// `2 4/5` represent the same value but have different types).
///
/// See also:
///  - [Fraction], to work with fractions in the form `a/b`
///  - [MixedFraction], to work with mixed fractions in the form `a b/c`
/// {@endtemplate}
abstract base class Rational implements Comparable<Rational> {
  /// {@macro rational}
  const new();

  /// Returns the exact value of this rational number as a `(numerator,
  /// denominator)` pair whose denominator is always positive. [BigInt] is used
  /// so that calculations in [compareTo] won't overflow.
  (BigInt, BigInt) _exactValue() {
    var num = BigInt.from(numerator);
    var den = BigInt.from(denominator);

    // The parts of a mixed fraction are never negative: the sign is stored
    // separately.
    if (this case final MixedFraction mixed) {
      num += BigInt.from(mixed.whole) * den;

      if (mixed.isNegative) {
        num = -num;
      }
    }

    if (den.isNegative) {
      num = -num;
      den = -den;
    }

    return (num, den);
  }

  /// Compares this rational number with [other] by value.
  ///
  /// Returns `-1` if this number is smaller than [other], `0` if they have the
  /// same value, and `1` if this number is greater. The comparison
  /// is exact: values are cross-multiplied rather than converted to [double].
  @override
  int compareTo(Rational other) {
    final (a, b) = _exactValue();
    final (c, d) = other._exactValue();
    return (a * d - c * b).sign;
  }

  /// Whether this rational number is greater than or equal to [other].
  bool operator >=(Rational other) => compareTo(other) >= 0;

  /// Whether this rational number is greater than [other].
  bool operator >(Rational other) => compareTo(other) > 0;

  /// Whether this rational number is less than or equal to [other].
  bool operator <=(Rational other) => compareTo(other) <= 0;

  /// Whether this rational number is less than [other].
  bool operator <(Rational other) => compareTo(other) < 0;

  /// The numerator of this rational number.
  ///
  /// For a [Fraction] `a/b`, this is the dividend `a`. For a [MixedFraction]
  /// `w a/b`, this is the numerator `a` of the fractional part only, not of
  /// the whole value.
  int get numerator;

  /// The denominator of this rational number.
  ///
  /// For a [Fraction] `a/b`, this is the divisor `b`. For a [MixedFraction]
  /// `w a/b`, this is the denominator `b` of the fractional part.
  int get denominator;

  /// Whether this rational number is less than zero.
  bool get isNegative;

  /// Whether this rational number is a whole number.
  bool get isWhole;

  /// A floating point representation of this rational number.
  double toDouble();

  /// Returns a new [Rational] with the opposite sign.
  Rational negate();

  /// Reduces this rational number to its lowest terms and returns the result
  /// in a new [Rational] object.
  Rational reduce();

  /// Represents this rational number as an Egyptian fraction.
  ///
  /// Throws a [FractionException] if this rational number is negative.
  List<Fraction> toEgyptianFraction();

  /// Returns the terms `[a0, a1, ..., an]` of the simple continued fraction
  /// of this rational number:
  ///
  /// ```text
  ///  a0 + 1/(a1 + 1/(a2 + ... + 1/an))
  /// ```
  ///
  /// For example, `7/9 = 0 + 1/(1 + 1/(3 + 1/2))`, so:
  ///
  /// ```dart
  ///  Fraction(7, 9).toContinuedFraction() // [0, 1, 3, 2]
  ///  Fraction(-7, 9).toContinuedFraction() // [-1, 4, 2]
  ///  MixedFraction(
  ///    whole: 2,
  ///    numerator: 1,
  ///    denominator: 3,
  ///  ).toContinuedFraction() // [2, 3]
  ///  Fraction(5).toContinuedFraction() // [5]
  /// ```
  ///
  /// The terms are computed with the Euclidean algorithm. The first term is
  /// the floor of the value (so it is negative for negative values) and every
  /// other term is positive. The expansion is the canonical (shortest) one: the
  /// last term is never `1`, unless it is the only term.
  List<int> toContinuedFraction() {
    var (num, den) = _exactValue();
    final terms = <int>[];

    while (den != BigInt.zero) {
      // The remainder of BigInt is never negative, so this is floor division.
      final remainder = num % den;
      terms.add(((num - remainder) ~/ den).toInt());

      num = den;
      den = remainder;
    }

    return terms;
  }

  /// Tries to parse [value] as a [Fraction] or a [MixedFraction], returning
  /// `null` if it is neither. Unicode glyphs (such as `½`) are also supported.
  /// For example:
  ///
  /// ```dart
  ///  Rational.tryParse('1/2') // 1/2
  ///  Rational.tryParse('½') // 1/2
  ///  Rational.tryParse('2 5/3') // 3 2/3
  ///  Rational.tryParse('') // null
  /// ```
  ///
  /// Integer values such as `'3'` are always parsed as a [Fraction].
  static Rational? tryParse(String value) {
    try {
      return value.toFraction();
    } on Exception {
      try {
        return MixedFraction.fromString(value);
      } on Exception {
        return null;
      }
    }
  }
}
