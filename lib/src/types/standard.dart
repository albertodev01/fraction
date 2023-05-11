import 'package:fraction/fraction.dart';
import 'package:fraction/src/types/egyptian_converter.dart';

/// Dart representation of a fraction having both [numerator] and [denominator]
/// as integers. If the [denominator] is zero, a [FractionException] object is
/// thrown.
///
/// To create a [Fraction] object, use one of its constructors:
///
/// ```dart
///  Fraction(-2, 5); // 2/5
///  Fraction.fromDouble(1.5); //
///  Fraction.fromString("4/5"); // 3/2
///  Fraction.fromGlyph("⅐"); // 1/7
/// ```
///
/// The [Fraction] type is **immutable**, so methods that require changing the
/// object's internal state return a new instance. For example, the [reduce]
/// method returns a new [Fraction] object that does not depend on the original
/// one. Another example:
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
base class Fraction extends Rational {
  /// This regular expression matches the structure of fraction in the `a/b`
  /// format with the optional minus (-) sign at the front.
  static final _fractionRegex = RegExp(
    r'(^-?|^\+?)(?:[1-9][0-9]*|0)(?:/[1-9][0-9]*)?',
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

  /// The numerator.
  final int _numerator;

  /// The denominator.
  final int _denominator;

  /// If the denominator is negative, the fraction is 'normalized' so that the
  /// minus sign only appears in front of the denominator. For example:
  ///
  /// ```dart
  ///  Fraction(3, 4)  // is interpreted as 3/4
  ///  Fraction(-3, 4) // is interpreted as -3/4
  ///  Fraction(3, -4) // is interpreted as -3/4
  ///  Fraction(3)     // is interpreted as 3/1
  /// ```
  ///
  /// A [FractionException] object is thrown when the denominator is `0`.
  factory Fraction(int numerator, [int denominator = 1]) {
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

  /// The default constructor.
  const Fraction._(this._numerator, this._denominator);

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
  /// If the given [value] doesn't represent a fraction, a [FractionException]
  /// object is thrown.
  factory Fraction.fromString(String value) {
    // Check the format of the string
    if ((!_fractionRegex.hasMatch(value)) || (value.contains('/-'))) {
      throw FractionException('The string $value is not a valid fraction');
    }

    // Remove the leading + (if any)
    final fraction = value.replaceAll('+', '');

    // Look for the '/' separator
    final barPos = fraction.indexOf('/');

    if (barPos == -1) {
      return Fraction(int.parse(fraction));
    } else {
      final den = int.parse(fraction.substring(barPos + 1));

      if (den == 0) {
        throw const FractionException('Denominator cannot be zero');
      }

      // Fixing the sign of numerator and denominator
      return Fraction(int.parse(fraction.substring(0, barPos)), den);
    }
  }

  /// Returns an instance of [Fraction] if [value] has a glyph that represents a
  /// fraction.
  ///
  /// A 'glyph' (or 'number form') is an unicode character that represents a
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
  factory Fraction.fromGlyph(String value) {
    if (_glyphsToValues.containsKey(value)) {
      return _glyphsToValues[value]!;
    }

    throw FractionException(
      'The given string ($value) does not represent a valid fraction glyph!',
    );
  }

  /// Tries to give a fractional representation of a [double] according with the
  /// given precision. This implementation takes inspiration from the continued
  /// fraction algorithm.
  ///
  /// ```dart
  ///  Fraction.fromDouble(3.8) // represented as 19/5
  /// ```
  ///
  /// Note that irrational numbers can **not** be represented as fractions. If
  /// you try to use this method on π (3.1415...) for example, you won't get a
  /// valid result:
  ///
  /// ```dart
  ///  Fraction.fromDouble(math.pi)
  /// ```
  ///
  /// The above code doesn't throw. It returns a [Fraction] object because the
  /// algorithm only considers the first 10 decimal digits (since [precision]
  /// is set to 1.0e-10).
  ///
  /// ```dart
  ///  Fraction.fromDouble(math.pi, precision: 1.0e-20)
  /// ```
  ///
  /// This example will return another different value because it considers the
  /// first 20 digits. It's still not a fractional representation of π because
  /// irrational numbers cannot be expressed as fractions.
  ///
  /// You should only use this method with rational numbers.
  factory Fraction.fromDouble(double value, {double precision = 1.0e-12}) {
    _checkValue(value);
    _checkValue(precision);

    // Storing the sign
    final abs = value.abs();
    final mul = (value >= 0) ? 1 : -1;
    final x = abs;

    // How many digits is the algorithm going to consider
    final limit = precision;
    var h1 = 1;
    var h2 = 0;
    var k1 = 0;
    var k2 = 1;
    var y = abs;

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
    return Fraction(mul * h1, k1);
  }

  /// Converts a [MixedFraction] into a [Fraction].
  factory Fraction.fromMixedFraction(MixedFraction mixed) {
    var num = mixed.whole * mixed.denominator + mixed.numerator;

    if (mixed.isNegative) {
      num = mixed.whole * mixed.denominator + (mixed.numerator * -1);
    }

    return Fraction(num, mixed.denominator);
  }

  @override
  int get numerator => _numerator;

  @override
  int get denominator => _denominator;

  @override
  bool get isNegative => numerator < 0;

  @override
  bool get isWhole => denominator == 1;

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
  int get hashCode => Object.hash(numerator, denominator);

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
    // Storing the sign for later use.
    final sign = (numerator < 0) ? -1 : 1;

    // Calculating the gcd for reduction.
    final lgcd = numerator.gcd(denominator);

    final num = (numerator * sign) ~/ lgcd;
    final den = (denominator * sign) ~/ lgcd;

    return Fraction(num, den);
  }

  @override
  List<Fraction> toEgyptianFraction() =>
      EgyptianFractionConverter(fraction: this).compute();

  /// If possible, this method converts this [Fraction] instance into an unicode
  /// glyph string.
  ///
  /// A 'glyph' (or 'number form') is an unicode character that represents a
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
  /// fraction can be converted into an unicode glyph or not.
  String toStringAsGlyph() {
    if (_valuesToGlyphs.containsKey(this)) {
      return _valuesToGlyphs[this]!;
    }

    throw FractionException(
      'This fraction ($this) does not have an unicode fraction glyph!',
    );
  }

  /// Converts this object into a [MixedFraction].
  MixedFraction toMixedFraction() => MixedFraction(
        whole: numerator ~/ denominator,
        numerator: numerator % denominator,
        denominator: denominator,
      );

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
  static void _checkValue(num value) {
    if ((value.isNaN) || (value.isInfinite)) {
      throw const FractionException('NaN and Infinite are not allowed.');
    }
  }

  /// The numerator and the denominator of this object are swapped and returned
  /// in a new [Fraction] object.
  Fraction inverse() => Fraction(denominator, numerator);

  /// Returns `true` if the numerator is smaller than the denominator.
  bool get isProper => numerator < denominator;

  /// Returns `true` if the numerator is equal or greater than the denominator.
  bool get isImproper => numerator >= denominator;

  /// Returns `true` if this [Fraction] object has an associated unicode glyph.
  /// For example:
  ///
  /// ```dart
  /// Fraction(1, 2).hasUnicodeGlyph; // true
  /// ```
  ///
  /// The above returns `true` because "1/2" can be represented as ½, which is
  /// a valid 'unicode glyph'.
  bool get isFractionGlyph => _valuesToGlyphs.containsKey(this);

  /// The sum between two fractions.
  Fraction operator +(Fraction other) => Fraction(
        numerator * other.denominator + denominator * other.numerator,
        denominator * other.denominator,
      );

  /// The difference between two fractions.
  Fraction operator -(Fraction other) => Fraction(
        numerator * other.denominator - denominator * other.numerator,
        denominator * other.denominator,
      );

  /// The product of two fractions.
  Fraction operator *(Fraction other) => Fraction(
        numerator * other.numerator,
        denominator * other.denominator,
      );

  /// The division of two fractions.
  Fraction operator /(Fraction other) => Fraction(
        numerator * other.denominator,
        denominator * other.numerator,
      );

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
