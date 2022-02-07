import 'package:fraction/fraction.dart';

/// Dart representation of a rational number.
///
/// A **rational number** is a number that can be expressed as the quotient
/// `x/y` of two integers, a numerator `x` and a non-zero denominator `y`. Any
/// rational number is also a real number.
///
/// [Rational] and all of its sub-types are **immutable**.
///
/// See also:
///
///  - [Fraction], to work with fractions in the form `a/b`
///  - [MixedFraction], to work with mixed fractions in the form `a b/c`
abstract class Rational implements Comparable<Rational> {
  /// Creates a [Rational] object.
  const Rational();

  @override
  int compareTo(Rational other) {
    // Using operator== on floating point values isn't reliable due to potential
    // machine precision losses. Comparisons with operator> and operator< are
    // safer.
    if (toDouble() < other.toDouble()) {
      return -1;
    }

    if (toDouble() > other.toDouble()) {
      return 1;
    }

    return 0;
  }

  /// Checks whether this rational number is greater or equal than the other.
  bool operator >=(Rational other) => toDouble() >= other.toDouble();

  /// Checks whether this rational number is greater than the other.
  bool operator >(Rational other) => toDouble() > other.toDouble();

  /// Checks whether this rational number is smaller or equal than the other.
  bool operator <=(Rational other) => toDouble() <= other.toDouble();

  /// Checks whether this rational number is smaller than the other.
  bool operator <(Rational other) => toDouble() < other.toDouble();

  /// The dividend `a` of the `a/b` division, which also is the numerator of the
  /// associated fraction.
  int get numerator;

  /// The divisor `b` of the `a/b` division, which also is the denominator of
  /// the associated fraction.
  int get denominator;

  /// True or false whether the fraction is positive or negative.
  bool get isNegative;

  /// True or false whether the fraction is whole or not.
  bool get isWhole;

  /// A floating point representation of the rational number.
  double toDouble();

  /// The sign is changed and the result is returned in new instance.
  Rational negate();

  /// Reduces the rational number to the lowest terms and returns the result in
  /// a new instance.
  Rational reduce();

  /// Represents the current rational number as an egyptian fraction.
  List<Fraction> toEgyptianFraction();

  /// Parses a string containing a fraction or a mixed fraction into a number.
  ///
  /// If the parsing fails, this method returns `null`. For example:
  ///
  /// ```dart
  /// Rational.tryParse('1/2') // Fraction(1, 2);
  /// Rational.tryParse('2 5/3') // MixedFraction(2, 5, 3);
  /// Rational.tryParse('') // null
  /// ```
  static Rational? tryParse(String value) {
    if (value.isFraction) {
      return Fraction.fromString(value);
    }

    if (value.isMixedFraction) {
      return MixedFraction.fromString(value);
    }

    return null;
  }
}
