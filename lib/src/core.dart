import 'package:fraction/fraction.dart';

/// Dart representation of a fraction having both the numerator and the denominator
/// as integers.
///
/// It's possible to create an instance of [Fraction] either by using
/// one of the constructors or by using the extension methods on [num] and [String].
///
/// ```dart
/// final f = Fraction.fromDouble(1.5);
/// final f = Fraction.fromString("4/5");
/// ```
///
/// is equivalent to
///
/// ```dart
/// final f = 1.5.toFraction();
/// final f = "4/5".toFraction();
/// ```
///
/// If the string doesn't represent a valid fraction, a [FractionException] is
/// thrown.
class Fraction implements Comparable<Fraction> {
  /// The numerator of the fraction
  late final int numerator;

  /// The denominator of the fraction
  late final int denominator;

  // Tested at https://regex101.com
  static final _fractionRegex = RegExp(
    '(^-?|^\\+?)(?:[1-9][0-9]*|0)(?:/[1-9][0-9]*)?',
  );

  /// Creates a new representation of a fraction. If the denominator is negative,
  /// the fraction is normalized so that only the numerator is treated as not
  /// positive.
  ///
  /// ```dart
  /// Fraction(3, 4) // is interpreted as 3/4
  /// Fraction(-3, 4) // is interpreted as -3/4
  /// Fraction(3, -4) // is interpreted as -3/4
  /// Fraction(3) // is interpreted as 3/1
  /// ```
  Fraction(int numerator, [int denominator = 1]) {
    if (denominator == 0) {
      throw const FractionException('Denominator cannot be zero.');
    }

    // Making sure that both numerator and denominator valid
    _checkValue(numerator);
    _checkValue(denominator);

    // Fixing the sign of numerator and denominator
    if (denominator < 0) {
      this.numerator = numerator * -1;
      this.denominator = denominator * -1;
    } else {
      this.numerator = numerator;
      this.denominator = denominator;
    }
  }

  /// Returns an instance of [Fraction] if the source string is a valid representation
  /// of a fraction. Some valid examples are:
  ///
  /// ```dart
  /// Fraction.fromString("5/2")
  /// Fraction.fromString("-5/2")
  /// Fraction.fromString("5")
  /// ```
  ///
  /// The denominator cannot be negative.
  ///
  /// ```dart
  /// Fraction.fromString("5/-2") // throws FractionException
  /// ```
  Fraction.fromString(String value) {
    // Checking the format of the string
    if ((!_fractionRegex.hasMatch(value)) || (value.contains('/-'))) {
      throw FractionException('The string $value is not a valid fraction');
    }

    // Remove the leading + if present
    var fraction = value.replaceAll('+', '');

    // Look for the / separator
    var barPos = fraction.indexOf('/');

    if (barPos == -1) {
      numerator = int.parse(fraction);
      denominator = 1;
    } else {
      final den = int.parse(fraction.substring(barPos + 1));

      if (den == 0) throw const FractionException('Denominator cannot be zero');

      // Fixing the sign of numerator and denominator
      if (den < 0) {
        numerator = int.parse(fraction.substring(0, barPos)) * -1;
        denominator = den * -1;
      } else {
        numerator = int.parse(fraction.substring(0, barPos));
        denominator = den;
      }
    }
  }

  /// Tries to give a fractional representation of a double according with the
  /// given precision. This implementation takes inspiration from the [continued fraction]
  /// [https://en.wikipedia.org/wiki/Continued_fraction] algorithm.
  ///
  /// ```dart
  /// Fraction.fromDouble(3.8) // represented as 19/5
  /// ```
  ///
  /// Note that irrational numbers can **not** be represented as fractions, so
  /// if you try to use this method on π (3.1415...) you won't get a valid result.
  ///
  /// ```dart
  /// Fraction.fromDouble(math.pi)
  /// ```
  ///
  /// The above returns a fraction because it considers only the first 10 decimal
  /// places since `precision` is set to 1.0E-10.
  ///
  /// ```dart
  /// Fraction.fromDouble(math.pi, 1.0E-20)
  /// ```
  ///
  /// This example will return another different value because it considers the
  /// first 20 digits. It's still not a fractional representation of pi because
  /// irrational numbers cannot be expressed as fractions.
  ///
  /// This method is good with rational numbers.
  Fraction.fromDouble(double value, [double precision = 1.0E-10]) {
    _checkValue(value);
    _checkValue(precision);

    var mul = (value >= 0) ? 1 : -1;
    var x = value.abs();

    // How many digits is the algorithm going to consider
    var limit = precision;
    var h1 = 1, h2 = 0, k1 = 0, k2 = 1;
    var y = value.abs();

    do {
      var a = y.floor();
      var aux = h1;
      h1 = a * h1 + h2;
      h2 = aux;
      aux = k1;
      k1 = a * k1 + k2;
      k2 = aux;
      y = 1 / (y - a);
    } while ((x - h1 / k1).abs() > x * limit);

    numerator = mul * h1.toInt();
    denominator = k1.toInt();
  }

  /// Converts a [MixedFraction] into a [Fraction].
  Fraction.fromMixedFraction(MixedFraction mixed) {
    if (mixed.isNegative) {
      numerator = (mixed.whole * mixed.denominator + mixed.numerator) * -1;
      denominator = mixed.denominator;
    } else {
      numerator = mixed.whole * mixed.denominator + mixed.numerator;
      denominator = mixed.denominator;
    }
  }

  @override

  /// Two fractions are equal if their "cross product" is equal.
  ///
  /// ```dart
  /// final one = Fraction(1, 2);
  /// final two = Fraction(2, 4);
  ///
  /// final areEqual = (one == two); //true
  /// ```
  ///
  /// The above example returns true because the "cross product" of `one` and
  /// two` is equal (1*4 = 2*2).
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    if (other is Fraction) {
      final fraction = other;

      return runtimeType == fraction.runtimeType &&
          (numerator * fraction.denominator ==
              denominator * fraction.numerator);
    } else {
      return false;
    }
  }

  @override
  int get hashCode {
    var result = 83;
    result = 31 * result + numerator.hashCode;
    result = 31 * result + denominator.hashCode;
    return result;
  }

  @override
  String toString() {
    if (denominator == 1) return "$numerator";

    return "$numerator/$denominator";
  }

  /// A floating point representation of the fraction
  double toDouble() => numerator / denominator;

  /// Tries to convert this fraction into a [MixedFraction]. The process fails
  /// if the numerator is greater than the denominator.
  ///
  /// If the conversion fails, `null` is returned.
  MixedFraction? toMixedFraction() {
    if (numerator > denominator) {
      return MixedFraction(
          whole: numerator ~/ denominator,
          numerator: numerator % denominator,
          denominator: denominator);
    }

    return null;
  }

  @override
  int compareTo(Fraction other) {
    if (toDouble() < other.toDouble()) return -1;

    if (toDouble() > other.toDouble()) return 1;

    return 0;
  }

  /// Throws a [FractionException] whether [value] is infinite or NaN.
  void _checkValue(num value) {
    if ((value.isNaN) || (value.isInfinite)) {
      throw const FractionException('NaN and Infinite are not allowed.');
    }
  }

  /// Typical GCD recursive calculation
  int _gcd(int a, int b) {
    var rem = a % b;
    return (rem == 0) ? b : _gcd(b, rem);
  }

  /// Returns a new instance of [Fraction] whose numerator and denominator have
  /// been swapped.
  Fraction inverse() => Fraction(denominator, numerator);

  /// Returns a new instance of [Fraction] with an opposite sign.
  Fraction negate() => Fraction(numerator * -1, denominator);

  /// True or false whether the fraction is positive or negative.
  bool get isNegative => numerator < 0;

  /// True of false whether the fraction is whole (which is when the denominator
  /// is 1).
  bool get isWhole => denominator == 1;

  /// Returns a new instance of [Fraction] reduced to the lowest terms.
  Fraction reduce() {
    // Storing the sign for later use
    final sign = (numerator < 0) ? -1 : 1;

    // Calculating the gcd for reduction
    var lgcd = _gcd(numerator, denominator);

    final num = (numerator * sign) ~/ lgcd;
    final den = (denominator * sign) ~/ lgcd;

    // Building the reduced fraction
    return Fraction(num, den);
  }

  /// Sum between two fractions
  Fraction operator +(Fraction other) {
    return Fraction(
        numerator * other.denominator + denominator * other.numerator,
        denominator * other.denominator);
  }

  /// Difference between two fractions
  Fraction operator -(Fraction other) {
    return Fraction(
        numerator * other.denominator - denominator * other.numerator,
        denominator * other.denominator);
  }

  /// Multiplication between two fractions
  Fraction operator *(Fraction other) {
    return Fraction(
        numerator * other.numerator, denominator * other.denominator);
  }

  /// Division between two fractions
  Fraction operator /(Fraction other) {
    return Fraction(
        numerator * other.denominator, denominator * other.numerator);
  }

  /// Check if this fraction is equal or greater than the other
  bool operator >=(Fraction other) => toDouble() >= other.toDouble();

  /// Check if this fraction is greater than the other
  bool operator >(Fraction other) => toDouble() > other.toDouble();

  /// Check if this fraction is equal or smaller than the other
  bool operator <=(Fraction other) => toDouble() <= other.toDouble();

  /// Check if this fraction is smaller than the other
  bool operator <(Fraction other) => toDouble() >= other.toDouble();

  /// Access numerator or denominator by giving an index. In particular, ´0´
  /// refers to the numerator while ´1´ to the denominator.
  int operator [](int index) {
    if (index == 0) {
      return numerator;
    }

    if (index == 1) {
      return denominator;
    }

    throw FractionException("The index you gave ($index) is not valid: it must "
        "be either 0 or 1.");
  }
}
