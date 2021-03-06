import 'package:fraction/fraction.dart';

/// Dart representation of a fraction having both the numerator and the denominator
/// as integers.
///
/// You can create a new instance of [Fraction] either by using one of the
/// constructors or by using the extension methods on [num] and [String].
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
  /// The numerator of the fraction.
  late final int numerator;

  /// The denominator of the fraction.
  late final int denominator;

  /// This regulax expression makes sure that a string represents a fraction.
  static final _fractionRegex = RegExp(
    '(^-?|^\\+?)(?:[1-9][0-9]*|0)(?:/[1-9][0-9]*)?',
  );

  /// Maps fraction glyphs to fraction values.
  static final _glyphsToValues = {
    '½': Fraction(1, 2),
    '⅓': Fraction(1, 3),
    '⅔': Fraction(2, 3),
    '¼': Fraction(1, 4),
    '¾': Fraction(3, 4),
    '⅕': Fraction(1, 5),
    '⅖': Fraction(2, 5),
    '⅗': Fraction(3, 5),
    '⅘': Fraction(4, 5),
    '⅙': Fraction(1, 6),
    '⅚': Fraction(5, 6),
    '⅐': Fraction(1, 7),
    '⅛': Fraction(1, 8),
    '⅜': Fraction(3, 8),
    '⅝': Fraction(5, 8),
    '⅞': Fraction(7, 8),
    '⅑': Fraction(1, 9),
    '⅒': Fraction(1, 10),
  };

  /// Maps fraction values to fraction glyphs.
  static final _valuesToGlyphs = {
    Fraction(1, 2): '½',
    Fraction(1, 3): '⅓',
    Fraction(2, 3): '⅔',
    Fraction(1, 4): '¼',
    Fraction(3, 4): '¾',
    Fraction(1, 5): '⅕',
    Fraction(2, 5): '⅖',
    Fraction(3, 5): '⅗',
    Fraction(4, 5): '⅘',
    Fraction(1, 6): '⅙',
    Fraction(5, 6): '⅚',
    Fraction(1, 7): '⅐',
    Fraction(1, 8): '⅛',
    Fraction(3, 8): '⅜',
    Fraction(5, 8): '⅝',
    Fraction(7, 8): '⅞',
    Fraction(1, 9): '⅑',
    Fraction(1, 10): '⅒',
  };

  /// Creates a new representation of a fraction. If the denominator is negative,
  /// the fraction is normalized so that the minus sign can only appear in front
  /// of the denominator.
  ///
  /// ```dart
  /// Fraction(3, 4)  // is interpreted as 3/4
  /// Fraction(-3, 4) // is interpreted as -3/4
  /// Fraction(3, -4) // is interpreted as -3/4
  /// Fraction(3)     // is interpreted as 3/1
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
  ///
  /// If the given string [value] doesn't represent a fraction, then an instance
  /// of [FractionException] is thrown.
  Fraction.fromString(String value) {
    // Check the format of the string
    if ((!_fractionRegex.hasMatch(value)) || (value.contains('/-'))) {
      throw FractionException('The string $value is not a valid fraction');
    }

    // Remove the leading + if present
    final fraction = value.replaceAll('+', '');

    // Look for the / separator
    final barPos = fraction.indexOf('/');

    if (barPos == -1) {
      numerator = int.parse(fraction);
      denominator = 1;
    } else {
      final den = int.parse(fraction.substring(barPos + 1));

      if (den == 0) {
        throw const FractionException('Denominator cannot be zero');
      }

      // Fixing the sign of numerator and denominator
      numerator = int.parse(fraction.substring(0, barPos));
      denominator = den;
    }
  }

  /// Returns an instance of [Fraction] if the source string is a glyph representing
  /// a fraction.  A 'glyph' (or 'number form') is an unicode character that
  /// represents a fraction. For example, the glyph for "1/7" is ⅐. Only a very
  /// small subset of fractions have a glyph representation.
  ///
  /// ```dart
  /// Fraction.fromString("⅐") // 1/7
  /// Fraction.fromString("⅔") // 2/3
  /// Fraction.fromString("⅞") // 7/8
  /// ```
  ///
  /// If the given string [value] doesn't represent a fraction glyph, then an
  /// instance of [FractionException] is thrown.
  factory Fraction.fromGlyph(String value) {
    if (_glyphsToValues.containsKey(value)) {
      return _glyphsToValues[value]!;
    }

    throw FractionException('The given string ($value) does not represent a '
        'valid fraction glyph!');
  }

  /// Tries to give a fractional representation of a double according with the
  /// given precision. This implementation takes inspiration from the
  /// (continued fraction)[https://en.wikipedia.org/wiki/Continued_fraction]
  /// algorithm.
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
  Fraction.fromDouble(double value, {double precision = 1.0E-10}) {
    _checkValue(value);
    _checkValue(precision);

    final mul = (value >= 0) ? 1 : -1;
    final x = value.abs();

    // How many digits is the algorithm going to consider
    final limit = precision;
    var h1 = 1, h2 = 0, k1 = 0, k2 = 1;
    var y = value.abs();

    do {
      final a = y.floor();
      var aux = h1;
      h1 = a * h1 + h2;
      h2 = aux;
      aux = k1;
      k1 = a * k1 + k2;
      k2 = aux;
      y = 1 / (y - a);
    } while ((x - h1 / k1).abs() > x * limit);

    // Assigning the computed values
    numerator = mul * h1.toInt();
    denominator = k1.toInt();
  }

  /// Converts a [MixedFraction] into a [Fraction].
  Fraction.fromMixedFraction(MixedFraction mixed) {
    if (mixed.isNegative) {
      numerator = (mixed.whole * mixed.denominator + mixed.numerator) * -1;
    } else {
      numerator = mixed.whole * mixed.denominator + mixed.numerator;
    }

    denominator = mixed.denominator;
  }

  @override
  bool operator ==(Object other) {
    // Two fractions are equal if their "cross product" is equal.
    //
    // ```dart
    // final one = Fraction(1, 2);
    // final two = Fraction(2, 4);
    //
    // final areEqual = (one == two); //true
    // ```
    //
    // The above example returns true because the "cross product" of `one` and
    // two` is equal (1*4 = 2*2).
    if (identical(this, other)) {
      return true;
    }

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
  int compareTo(Fraction other) {
    // I don't perform == on floating point values because it's not reliable.
    // Instead, '>' and '<' are more reliable in terms of machine precision so
    // 0 is just a fallback.
    if (toDouble() < other.toDouble()) {
      return -1;
    }

    if (toDouble() > other.toDouble()) {
      return 1;
    }

    return 0;
  }

  @override
  String toString() {
    if (denominator == 1) {
      return '$numerator';
    }

    return '$numerator/$denominator';
  }

  /// If possible, this method converts this [Fraction] instance into an unicode
  /// glyph string. A 'glyph' (or 'number form') is an unicode character that
  /// represents a fraction. For example, the glyph for "1/7" is ⅐. Only a very
  /// small subset of fractions have a glyph representation.
  ///
  /// ```dart
  /// final fraction = Fraction(1, 7);
  /// final str = fraction.toStringAsGlyph() // "⅐"
  /// ```
  ///
  /// If the conversion is not possible, a [FractionException] is thrown. You
  /// can use the [isFractionGlyph] getter to determine whether this fraction
  /// can be converted into an unicode glyph or not.
  String toStringAsGlyph() {
    if (_valuesToGlyphs.containsKey(this)) {
      return _valuesToGlyphs[this]!;
    }

    throw FractionException('This fraction ($this) does not have an unicode '
        'fraction glyph!');
  }

  /// A floating point representation of the fraction.
  double toDouble() => numerator / denominator;

  /// Converts the current object into a [MixedFraction].
  MixedFraction toMixedFraction() => MixedFraction(
      whole: numerator ~/ denominator,
      numerator: numerator % denominator,
      denominator: denominator);

  /// Represents the current fraction as an egyptian fraction.
  ///
  /// For more info, see [EgyptianFraction].
  List<Fraction> toEgyptianFraction() =>
      EgyptianFraction(fraction: this).compute();

  /// Creates a **deep** copy of this object with the given fields replaced
  /// with the new values.
  Fraction copyWith({
    int? numerator,
    int? denominator,
  }) =>
      Fraction(
        numerator ?? this.numerator,
        denominator ?? this.denominator,
      );

  /// Throws a [FractionException] whether [value] is infinite or [double.nan].
  void _checkValue(num value) {
    if ((value.isNaN) || (value.isInfinite)) {
      throw const FractionException('NaN and Infinite are not allowed.');
    }
  }

  /// Typical GCD recursive calculation.
  int _gcd(int a, int b) {
    final rem = a % b;
    return (rem == 0) ? b : _gcd(b, rem);
  }

  /// The numerator and the denominator of the current object are swapped and
  /// returned in a new [Fraction] instance.
  Fraction inverse() => Fraction(denominator, numerator);

  /// The sign of the current object is changed and the result is returned in a
  /// new [Fraction] instance.
  Fraction negate() => Fraction(numerator * -1, denominator);

  /// True or false whether the fraction is positive or negative.
  bool get isNegative => numerator < 0;

  /// True of false whether the fraction is whole (which is when the denominator
  /// is 1).
  bool get isWhole => denominator == 1;

  /// Returns `true` if the numerator is smaller than the denominator.
  ///
  /// The `numerator < denominator` relation must be satisfied in order to return
  /// `true`.
  bool get isProper => numerator < denominator;

  /// Returns `true` if the numerator is equal or greater than the denominator.
  ///
  /// The `numerator >= denominator` relation must be satisfied in order to return
  /// `true`.
  bool get isImproper => numerator >= denominator;

  /// Returns `true` if this [Fraction] instance has an unicode glyph associated.
  /// For example:
  ///
  /// ```dart
  /// final fraction = Fraction(1, 2).hasUnicodeGlyph; // true
  /// ```
  ///
  /// The above returns `true` because "1/2" can be represented as ½, which is
  /// an 'unicode glyph' or 'number form'. Only a very small subset of fractions
  /// have a glyph representing them.
  bool get isFractionGlyph => _valuesToGlyphs.containsKey(this);

  /// Reduces the current object to the lowest terms and returns the result in a
  /// new [Fraction] instance.
  Fraction reduce() {
    // Storing the sign for later use
    final sign = (numerator < 0) ? -1 : 1;

    // Calculating the gcd for reduction
    final lgcd = _gcd(numerator, denominator);

    final num = (numerator * sign) ~/ lgcd;
    final den = (denominator * sign) ~/ lgcd;

    // Building the reduced fraction
    return Fraction(num, den);
  }

  /// Sum between two fractions.
  Fraction operator +(Fraction other) => Fraction(
      numerator * other.denominator + denominator * other.numerator,
      denominator * other.denominator);

  /// Difference between two fractions.
  Fraction operator -(Fraction other) => Fraction(
      numerator * other.denominator - denominator * other.numerator,
      denominator * other.denominator);

  /// Multiplication between two fractions.
  Fraction operator *(Fraction other) =>
      Fraction(numerator * other.numerator, denominator * other.denominator);

  /// Division between two fractions.
  Fraction operator /(Fraction other) =>
      Fraction(numerator * other.denominator, denominator * other.numerator);

  /// Checks whether this fraction is greater or equal than the other.
  bool operator >=(Fraction other) => toDouble() >= other.toDouble();

  /// Checks whether this fraction is greater than the other.
  bool operator >(Fraction other) => toDouble() > other.toDouble();

  /// Checks whether this fraction is smaller or equal than the other.
  bool operator <=(Fraction other) => toDouble() <= other.toDouble();

  /// Checks whether this fraction is smaller than the other.
  bool operator <(Fraction other) => toDouble() < other.toDouble();

  /// Access numerator or denominator via index. In particular, ´0´ refers to
  /// the numerator while ´1´ to the denominator.
  int operator [](int index) {
    if (index == 0) {
      return numerator;
    }

    if (index == 1) {
      return denominator;
    }

    throw FractionException('The index you gave ($index) is not valid: it must '
        'be either 0 or 1.');
  }
}
