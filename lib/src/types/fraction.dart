import 'package:fraction/fraction.dart';
import 'package:fraction/src/types/egyptian_fraction_converter.dart';

/// {@template fraction}
/// Dart representation of a fraction having both [numerator] and [denominator]
/// as integers. If the [denominator] is zero, a [FractionException] object is
/// thrown.
///
/// To create a [Fraction] object, use one of its constructors:
///
/// ```dart
///  Fraction(-2, 5); // -2/5
///  Fraction.fromDouble(1.5); // 3/2
///  Fraction.fromString("4/5"); // 4/5
///  Fraction.fromGlyph("⅐"); // 1/7
/// ```
///
/// The [Fraction] type is **immutable**, so methods that require changing the
/// object's internal state return a new instance. For example, the [reduce]
/// method returns a new [Fraction] object that does not depend on the original
/// one. Arithmetic operators also return new objects, always in lowest terms:
///
/// ```dart
///  final f1 = Fraction(5, 7); // 5/7
///  final f2 = Fraction(1, 5); // 1/5
///
///  final sum = f1 + f2; // 32/35
///  final sub = f1 - f2; // 18/35
///  final mul = f1 * f2; // 1/7
///  final div = f1 / f2; // 25/7
/// ```
///
/// Operators always return new objects. There are extension methods on [num]
/// and [String] that allow you to build [Fraction] objects "on the fly". For
/// example:
///
/// ```dart
///  1.5.toFraction(); // 3/2
///  "4/5".toFraction(); // 4/5
/// ```
///
/// If the string doesn't represent a valid fraction, a [FractionException]
/// object is thrown.
/// {@endtemplate}
base class Fraction extends Rational {
  /// {@macro fraction}
  ///
  /// If the denominator is negative, the fraction is 'normalized' so that the
  /// minus sign only appears in front of the numerator. For example:
  ///
  /// ```dart
  ///  Fraction(3, 4)  // is interpreted as 3/4
  ///  Fraction(-3, 4) // is interpreted as -3/4
  ///  Fraction(3, -4) // is interpreted as -3/4
  ///  Fraction(3)     // is interpreted as 3/1
  /// ```
  ///
  /// A [FractionException] object is thrown when the denominator is `0`.
  factory(int numerator, [int denominator = 1]) {
    if (denominator == 0) {
      throw const FractionException('Denominator cannot be zero.');
    }

    // Fixing the sign of numerator and denominator
    if (denominator < 0) {
      return Fraction._(numerator * -1, denominator * -1);
    } else {
      return Fraction._(numerator, denominator);
    }
  }

  /// {@macro fraction}
  const new _(
    this._numerator,
    this._denominator,
  );

  /// Returns an instance of [Fraction] if [value] represents a valid fraction.
  /// Some correct examples are:
  ///
  /// ```dart
  ///  Fraction.fromString("5/2")
  ///  Fraction.fromString("-5/2")
  ///  Fraction.fromString("5")
  /// ```
  ///
  /// The denominator cannot be negative or zero:
  ///
  /// ```dart
  ///  Fraction.fromString("5/-2") // throws
  ///  Fraction.fromString("5/0") // throws
  /// ```
  ///
  /// The whole string must be a fraction: leading or trailing characters
  /// (including whitespace) are not allowed.
  ///
  /// If the given [value] doesn't represent a fraction, or if the numerator or
  /// the denominator is too large to fit in an [int], a [FractionException]
  /// object is thrown.
  factory fromString(String value) {
    final match = _fractionRegex.firstMatch(value);

    if (match == null) {
      throw FractionException('The string $value is not a valid fraction');
    }

    // The regular expression guarantees that both groups only contain digits
    // (and an optional sign for the numerator), so 'tryParse' can only fail
    // when a value doesn't fit in an int.
    final numerator = int.tryParse(match.group(1)!);
    final denominatorString = match.group(2);
    final denominator = denominatorString == null
        ? 1
        : int.tryParse(denominatorString);

    if (numerator == null || denominator == null) {
      throw FractionException(
        'The string $value contains a value that is too large',
      );
    }

    return Fraction(numerator, denominator);
  }

  /// Returns an instance of [Fraction] if [value] has a glyph that represents a
  /// fraction.
  ///
  /// A 'glyph' (or 'number form') is a Unicode character that represents a
  /// fraction. For example, the glyph for "1/7" is ⅐. Only a very small subset
  /// of fractions have a glyph representation. Some correct examples are:
  ///
  /// ```dart
  ///  Fraction.fromString("⅐") // 1/7
  ///  Fraction.fromString("⅔") // 2/3
  ///  Fraction.fromString("⅞") // 7/8
  /// ```
  ///
  /// If [value] doesn't represent a fraction glyph, a [FractionException]
  /// object is thrown.
  factory fromGlyph(String value) {
    if (_glyphsToValues.containsKey(value)) {
      return _glyphsToValues[value]!;
    }

    throw FractionException(
      'The given string ($value) does not represent a valid fraction glyph!',
    );
  }

  /// Approximates [value] with a fraction, using the continued fraction
  /// algorithm.
  ///
  /// ```dart
  ///  Fraction.fromDouble(3.8) // 19/5
  /// ```
  ///
  /// The algorithm stops as soon as the relative error of the approximation is
  /// at most [precision], which must be greater than zero. If that precision
  /// cannot be reached because the numerator or the denominator would no
  /// longer fit in an [int], the closest approximation that fits is returned.
  ///
  /// Irrational numbers can **not** be represented as fractions, so for a value
  /// like π the result is only an approximation:
  ///
  /// ```dart
  ///  Fraction.fromDouble(math.pi) // 1146408/364913
  ///  Fraction.fromDouble(math.pi, precision: 1.0e-4) // 333/106
  /// ```
  ///
  /// Throws a [FractionException] if [value] is NaN or infinite, if
  /// [precision] is not a positive finite number, or if [value] is too large
  /// (or too close to zero) to be represented with [int] values.
  factory fromDouble(double value, {double precision = 1.0e-12}) {
    _checkValue(value);
    _checkValue(precision);

    if (precision <= 0) {
      throw FractionException('The precision ($precision) must be positive.');
    }

    if (value == 0) {
      return Fraction(0);
    }

    final x = value.abs();

    // The convergents h/k of the continued fraction are computed with BigInts
    // so that an overflow can be detected (and not silently wrapped around).
    var h1 = BigInt.one;
    var h2 = BigInt.zero;
    var k1 = BigInt.zero;
    var k2 = BigInt.one;
    var y = x;

    for (var i = 0; i < _maxContinuedFractionTerms; i++) {
      // 'y' is always positive, so truncating is the same as flooring.
      // BigInt.from() is used because double.floor() clamps large values.
      final a = BigInt.from(y);
      final h = a * h1 + h2;
      final k = a * k1 + k2;

      // Stop at the last convergent that fits in an int.
      if (!h.isValidInt || !k.isValidInt) {
        break;
      }

      h2 = h1;
      h1 = h;
      k2 = k1;
      k1 = k;

      final remainder = y - a.toDouble();
      if ((x - h1 / k1).abs() <= x * precision || remainder == 0) {
        break;
      }

      y = 1 / remainder;
      if (y.isInfinite) {
        break;
      }
    }

    if (k1 == BigInt.zero || h1 == BigInt.zero) {
      throw FractionException(
        'The value ($value) cannot be represented as a fraction of integers.',
      );
    }

    final sign = value < 0 ? -1 : 1;
    return Fraction(
      sign * h1.toInt(),
      k1.toInt(),
    );
  }

  /// Converts a [MixedFraction] into a [Fraction].
  ///
  /// Throws a [FractionException] if the result does not fit in an [int].
  factory fromMixedFraction(MixedFraction mixed) {
    final magnitude =
        BigInt.from(mixed.whole) * BigInt.from(mixed.denominator) +
        BigInt.from(mixed.numerator);
    final numerator = mixed.isNegative ? -magnitude : magnitude;

    // The denominator is kept as is (the result is not reduced) unless the
    // numerator doesn't fit in an int, in which case reducing may help.
    if (numerator.isValidInt) {
      return Fraction(numerator.toInt(), mixed.denominator);
    }

    return Fraction._fromBigInts(numerator, BigInt.from(mixed.denominator));
  }

  /// Builds a reduced [Fraction] from the result of an arithmetic operation.
  ///
  /// Throws a [FractionException] if the reduced result does not fit in an
  /// [int].
  factory _fromBigInts(BigInt numerator, BigInt denominator) {
    if (denominator == BigInt.zero) {
      throw const FractionException('Cannot divide by zero.');
    }

    final gcd = numerator.gcd(denominator);
    var num = numerator ~/ gcd;
    var den = denominator ~/ gcd;

    if (den.isNegative) {
      num = -num;
      den = -den;
    }

    if (!num.isValidInt || !den.isValidInt) {
      throw const FractionException(
        'The result is too large to be represented as a fraction of ints.',
      );
    }

    return Fraction._(num.toInt(), den.toInt());
  }

  /// This regular expression matches the structure of fraction in the `a/b`
  /// format with the optional minus (-) sign at the front.
  static final _fractionRegex = RegExp(
    r'^([+-]?(?:[1-9][0-9]*|0))(?:/([1-9][0-9]*))?$',
  );

  /// The maximum number of terms computed by [Fraction.fromDouble]. Convergents
  /// grow at least as fast as the Fibonacci numbers, so this limit is never
  /// reached before the values overflow an int; it only guarantees that the
  /// loop always terminates.
  static const _maxContinuedFractionTerms = 100;

  /// Operands whose absolute value is below this limit (2^26) can be combined
  /// with plain int arithmetic: products stay below 2^52 and sums below 2^53,
  /// so there's no overflow on native platforms nor precision loss on the web.
  static const _smallOperandLimit = 67108864;

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

  /// The numerator.
  final int _numerator;

  /// The denominator.
  final int _denominator;

  @override
  int get numerator => _numerator;

  @override
  int get denominator => _denominator;

  @override
  bool get isNegative => numerator < 0;

  @override
  bool get isWhole => numerator % denominator == 0;

  /// The numerator and denominator of this fraction in lowest terms. The
  /// denominator is always positive and zero is always represented as `0/1`.
  ///
  /// This is the canonical form used by [operator ==] and [hashCode], so that
  /// equivalent fractions (such as `1/2` and `2/4`) are equal and have the same
  /// hash code.
  (int, int) get _lowestTerms {
    // gcd is always positive (or 0 only when both values are 0, which can't
    // happen because the denominator is never 0).
    final gcd = numerator.gcd(denominator);

    return (numerator ~/ gcd, denominator ~/ gcd);
  }

  /// Two fractions are equal if they represent the same value. For example,
  /// `Fraction(1, 2) == Fraction(2, 4)` is `true`.
  ///
  /// Both fractions are compared in lowest terms, so the comparison can never
  /// overflow.
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    if (other is! Fraction || runtimeType != other.runtimeType) {
      return false;
    }

    return _lowestTerms == other._lowestTerms;
  }

  /// Equivalent fractions (such as `1/2` and `2/4`) have the same hash code.
  @override
  int get hashCode => _lowestTerms.hashCode;

  @override
  String toString() {
    if (denominator == 1) {
      return '$numerator';
    }
    return '$numerator/$denominator';
  }

  @override
  double toDouble() => numerator / denominator;

  @override
  Fraction negate() => Fraction(numerator * -1, denominator);

  @override
  Fraction reduce() {
    final (num, den) = _lowestTerms;
    return Fraction._(num, den);
  }

  @override
  List<Fraction> toEgyptianFraction() => EgyptianFractionConverter(
    fraction: this,
  ).compute();

  /// If possible, this method converts this [Fraction] instance into a Unicode
  /// glyph string.
  ///
  /// A 'glyph' (or 'number form') is a Unicode character that represents a
  /// fraction. For example, the glyph for "1/7" is ⅐. Only a very small subset
  /// of fractions have a glyph representation.
  ///
  /// ```dart
  /// final fraction = Fraction(1, 7);
  /// final str = fraction.toStringAsGlyph() // "⅐"
  /// ```
  ///
  /// If the conversion is not possible, a [FractionException] object is thrown.
  /// You can use the [isFractionGlyph] getter to determine whether this
  /// fraction can be converted into a Unicode glyph or not.
  String toStringAsGlyph() {
    if (_valuesToGlyphs.containsKey(this)) {
      return _valuesToGlyphs[this]!;
    }

    throw FractionException(
      'This fraction ($this) does not have a Unicode fraction glyph!',
    );
  }

  /// Converts this object into a [MixedFraction].
  ///
  /// For example, `7/4` becomes `1 3/4` and `-5/4` becomes `-1 1/4`.
  MixedFraction toMixedFraction() {
    final whole = numerator ~/ denominator;
    final remainder = numerator.remainder(denominator);

    return MixedFraction(
      whole: whole,
      numerator: whole == 0 ? remainder : remainder.abs(),
      denominator: denominator,
    );
  }

  /// {@macro copy_with}
  Fraction copyWith({
    int? numerator,
    int? denominator,
  }) {
    return Fraction(
      numerator ?? this.numerator,
      denominator ?? this.denominator,
    );
  }

  /// Throws a [FractionException] whether [value] is infinite or [double.nan].
  static void _checkValue(num value) {
    if ((value.isNaN) || (value.isInfinite)) {
      throw const FractionException('NaN and Infinite are not allowed.');
    }
  }

  /// The numerator and the denominator of this object are swapped and returned
  /// in a new [Fraction] object.
  Fraction inverse() => Fraction(denominator, numerator);

  /// Returns `true` if the absolute value of the numerator is smaller than the
  /// denominator. For example, `1/2` and `-1/2` are proper fractions.
  bool get isProper => numerator.abs() < denominator;

  /// Returns `true` if the absolute value of the numerator is equal to or
  /// greater than the denominator. For example, `3/2` and `-3/2` are improper
  /// fractions.
  bool get isImproper => !isProper;

  /// Returns `true` if this [Fraction] object has an associated unicode glyph.
  /// For example:
  ///
  /// ```dart
  /// Fraction(1, 2).isFractionGlyph; // true
  /// ```
  ///
  /// The above returns `true` because "1/2" can be represented as ½, which is
  /// a valid 'unicode glyph'.
  bool get isFractionGlyph => _valuesToGlyphs.containsKey(this);

  /// Whether this fraction and [other] are small enough to be combined with
  /// plain int arithmetic (see [_smallOperandLimit]).
  bool _canUseIntArithmetic(Fraction other) {
    return _isSmall(numerator) &&
        _isSmall(denominator) &&
        _isSmall(other.numerator) &&
        _isSmall(other.denominator);
  }

  static bool _isSmall(int value) {
    return value > -_smallOperandLimit && value < _smallOperandLimit;
  }

  /// The sum of two fractions, in lowest terms.
  ///
  /// Throws a [FractionException] if the result does not fit in an [int].
  Fraction operator +(Fraction other) {
    if (_canUseIntArithmetic(other)) {
      return Fraction(
        numerator * other.denominator + denominator * other.numerator,
        denominator * other.denominator,
      ).reduce();
    }

    final (a, b) = (BigInt.from(numerator), BigInt.from(denominator));
    final (c, d) = (
      BigInt.from(other.numerator),
      BigInt.from(other.denominator),
    );

    return Fraction._fromBigInts(a * d + b * c, b * d);
  }

  /// The difference between two fractions, in lowest terms.
  ///
  /// Throws a [FractionException] if the result does not fit in an [int].
  Fraction operator -(Fraction other) {
    if (_canUseIntArithmetic(other)) {
      return Fraction(
        numerator * other.denominator - denominator * other.numerator,
        denominator * other.denominator,
      ).reduce();
    }

    final (a, b) = (BigInt.from(numerator), BigInt.from(denominator));
    final (c, d) = (
      BigInt.from(other.numerator),
      BigInt.from(other.denominator),
    );

    return Fraction._fromBigInts(a * d - b * c, b * d);
  }

  /// The product of two fractions, in lowest terms.
  ///
  /// Throws a [FractionException] if the result does not fit in an [int].
  Fraction operator *(Fraction other) {
    if (_canUseIntArithmetic(other)) {
      return Fraction(
        numerator * other.numerator,
        denominator * other.denominator,
      ).reduce();
    }

    final (a, b) = (BigInt.from(numerator), BigInt.from(denominator));
    final (c, d) = (
      BigInt.from(other.numerator),
      BigInt.from(other.denominator),
    );

    return Fraction._fromBigInts(a * c, b * d);
  }

  /// The quotient of two fractions, in lowest terms.
  ///
  /// Throws a [FractionException] if [other] is zero or if the result does not
  /// fit in an [int].
  Fraction operator /(Fraction other) {
    if (other.numerator == 0) {
      throw const FractionException('Cannot divide by zero.');
    }

    if (_canUseIntArithmetic(other)) {
      return Fraction(
        numerator * other.denominator,
        denominator * other.numerator,
      ).reduce();
    }

    final (a, b) = (BigInt.from(numerator), BigInt.from(denominator));
    final (c, d) = (
      BigInt.from(other.numerator),
      BigInt.from(other.denominator),
    );

    return Fraction._fromBigInts(a * d, b * c);
  }

  /// Allows retrieving numerator or denominator by index. In particular, ´0´
  /// refers to the numerator and ´1´ to the denominator.
  ///
  /// Throws a [FractionException] object if [index] is not `0` or `1`.
  int operator [](int index) {
    if (index == 0) {
      return numerator;
    }
    if (index == 1) {
      return denominator;
    }
    throw FractionException(
      'The index you gave ($index) is not valid: it must be either 0 or 1.',
    );
  }
}
