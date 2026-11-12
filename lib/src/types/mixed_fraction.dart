import 'package:fraction/fraction.dart';
import 'package:fraction/src/types/egyptian_fraction_converter.dart';

/// {@template mixed_fraction}
/// Dart representation of a 'mixed fraction', which is made up of a whole part
/// and a proper fraction (a fraction whose numerator is smaller than its
/// denominator).
///
/// To create a [MixedFraction] object, use one of its constructors:
///
/// ```dart
/// MixedFraction(
///   whole: 5,
///   numerator: 2,
///   denominator: 3,
/// );
/// MixedFraction.fromDouble(1.5);
/// MixedFraction.fromString("1 1/2");
/// ```
///
/// The [whole], [numerator] and [denominator] values are never negative: the
/// sign of a mixed fraction is stored separately and exposed by [isNegative].
/// This makes it possible to represent negative values whose whole part is
/// zero, such as `-1/2`.
///
/// The [MixedFraction] type is **immutable**, so methods that require changing
/// the object's internal state return a new instance. For example, the [reduce]
/// method returns a new [MixedFraction] object that does not depend on the
/// original one. Another example:
///
/// ```dart
///  final f1 = MixedFraction(whole: 5, numerator: 7, denominator: 8); // 5 7/8
///  final f2 = MixedFraction(whole: 3, numerator: 1, denominator: 9); // 3 1/9
///
///  final sum = f1 + f2; // 8 71/72
///  final sub = f1 - f2; // 2 55/72
///  final mul = f1 * f2; // 18 5/18
///  final div = f1 / f2; // 1 199/224
/// ```
///
/// Operators always return new objects. There are extension methods on [num]
/// and [String] that allow you to build [MixedFraction] objects "on the fly".
/// For example:
///
/// ```dart
///  1.5.toMixedFraction();
///  "1 1/2".toMixedFraction();
/// ```
///
/// If the string doesn't represent a valid mixed fraction, a
/// [MixedFractionException] object is thrown.
/// {@endtemplate}
base class MixedFraction extends Rational {
  /// {@macro mixed_fraction}
  ///
  /// A negative sign on either the whole part or the fractional part makes the
  /// whole value negative. For example, these all represent `-2 1/3`:
  ///
  /// ```dart
  ///  MixedFraction(whole: -2, numerator: 1, denominator: 3);
  ///  MixedFraction(whole: 2, numerator: -1, denominator: 3);
  ///  MixedFraction(whole: 2, numerator: 1, denominator: -3);
  /// ```
  ///
  /// Use a negative numerator to create a negative value with no whole part:
  ///
  /// ```dart
  ///  MixedFraction(whole: 0, numerator: -1, denominator: 2); // -1/2
  /// ```
  ///
  /// If the fractional part is improper, the values are normalized so that a
  /// valid mixed fraction is created. For example,
  /// `MixedFraction(whole: 1, numerator: 7, denominator: 3)` is `3 1/3`.
  ///
  /// Throws a [MixedFractionException] if [denominator] is zero, or if both the
  /// whole part and the fractional part are negative (in which case the
  /// intended sign is ambiguous).
  factory({
    required int whole,
    required int numerator,
    required int denominator,
  }) {
    if (denominator == 0) {
      throw const MixedFractionException('The denominator cannot be zero.');
    }

    final isFractionNegative =
        numerator != 0 && (numerator < 0) != (denominator < 0);

    if (whole < 0 && isFractionNegative) {
      throw MixedFractionException(
        'The whole part ($whole) and the fractional part '
        '($numerator/$denominator) cannot both be negative.',
      );
    }

    // Moving the integer part of an improper fraction into the whole part.
    final absNumerator = numerator.abs();
    final absDenominator = denominator.abs();
    final absWhole = whole.abs() + absNumerator ~/ absDenominator;
    final remainder = absNumerator % absDenominator;
    final isZero = absWhole == 0 && remainder == 0;

    return MixedFraction._(
      absWhole,
      remainder,
      absDenominator,
      !isZero && (whole < 0 || isFractionNegative),
    );
  }

  /// {@macro mixed_fraction}
  const new _(
    this.whole,
    this._numerator,
    this._denominator,
    this._isNegative,
  );

  /// Creates an instance of a mixed fraction from a [fraction] fraction.
  factory fromFraction(Fraction fraction) => fraction.toMixedFraction();

  /// Creates a [MixedFraction] object from [value]. The input string must be in
  /// the form 'a b/c' with exactly one space between the whole part and the
  /// fraction. The fractional part can also be a glyph.
  ///
  /// A negative sign can be placed in front of either 'a' or 'b' (but not both)
  /// and makes the whole value negative. Some valid examples are:
  ///
  /// ```dart
  ///  MixedFraction.fromString('-2 2/5'); // -2 2/5
  ///  MixedFraction.fromString('2 -2/5'); // -2 2/5
  ///  MixedFraction.fromString('-0 1/2'); // -1/2
  ///  MixedFraction.fromString('1 1/3'); // 1 1/3
  ///  MixedFraction.fromString('3 ⅐'); // 3 1/7
  /// ```
  ///
  /// Throws a [MixedFractionException] if [value] is not a valid mixed
  /// fraction.
  factory fromString(String value) {
    const formatError = MixedFractionException(
      "The string must be in the form 'a b/c' with exactly one space between "
      'the whole part and the fraction',
    );

    final parts = value.split(' ');
    if (parts.length != 2) {
      throw formatError;
    }

    final wholeMatch = _wholeRegex.firstMatch(parts.first);
    if (wholeMatch == null) {
      throw formatError;
    }

    final whole = int.tryParse(wholeMatch.group(2)!);
    if (whole == null) {
      throw MixedFractionException(
        'The whole part of $value is too large to fit in an int.',
      );
    }

    // The fractional part must be either 'b/c' or a glyph.
    final fractionString = parts.last;
    final Fraction fraction;

    try {
      fraction = fractionString.contains('/')
          ? Fraction.fromString(fractionString)
          : Fraction.fromGlyph(fractionString);
    } on FractionException catch (e) {
      throw MixedFractionException(
        'The fractional part of $value is not valid: ${e.message}',
      );
    }

    // The sign is checked on the string so that '-0 1/2' is negative.
    final isWholeNegative = wholeMatch.group(1) == '-';
    if (isWholeNegative && fraction.isNegative) {
      throw MixedFractionException(
        'The whole part and the fractional part of $value cannot both be '
        'negative.',
      );
    }

    final result = MixedFraction(
      whole: whole,
      numerator: fraction.numerator,
      denominator: fraction.denominator,
    );
    return isWholeNegative ? result.negate() : result;
  }

  /// Approximates [value] with a mixed fraction. See [Fraction.fromDouble] for
  /// details about the algorithm and the [precision] parameter.
  ///
  /// ```dart
  ///  MixedFraction.fromDouble(5.46) // 5 23/50
  /// ```
  ///
  /// Throws a [FractionException] if [value] is NaN, infinite, or cannot be
  /// represented with [int] values, or if [precision] is not positive.
  factory fromDouble(double value, {double precision = 1.0e-12}) {
    return Fraction.fromDouble(
      value,
      precision: precision,
    ).toMixedFraction();
  }

  /// Matches the whole part of a mixed fraction string: an optional sign
  /// followed by digits.
  static final _wholeRegex = RegExp(r'^([+-]?)([0-9]+)$');

  /// The whole part of the mixed fraction. It is never negative: use
  /// [isNegative] to get the sign.
  final int whole;

  /// Whether this mixed fraction is negative.
  final bool _isNegative;

  /// The numerator of the fractional part. It is never negative.
  final int _numerator;

  /// The denominator of the fractional part. It is always positive.
  final int _denominator;

  @override
  int get numerator => _numerator;

  @override
  int get denominator => _denominator;

  @override
  bool get isNegative => _isNegative;

  @override
  bool get isWhole => numerator == 0;

  /// Two mixed fractions are equal if they represent the same value. For
  /// example, `1 3/4` and `1 6/8` are equal.
  ///
  /// A [MixedFraction] is never equal to a [Fraction], even if both represent
  /// the same value.
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    if (other is MixedFraction) {
      return toFraction() == other.toFraction();
    } else {
      return false;
    }
  }

  /// Equivalent mixed fractions (such as `1 3/4` and `1 6/8`) have the same
  /// hash code.
  @override
  int get hashCode => toFraction().hashCode;

  @override
  String toString() {
    final sign = isNegative ? '-' : '';

    if (numerator == 0) {
      return '$sign$whole';
    }

    if (whole == 0) {
      return '$sign$numerator/$denominator';
    }

    return '$sign$whole $numerator/$denominator';
  }

  @override
  double toDouble() {
    final magnitude = whole + numerator / denominator;

    return isNegative ? -magnitude : magnitude;
  }

  @override
  MixedFraction negate() {
    // Zero is never negative.
    if (whole == 0 && numerator == 0) {
      return this;
    }

    return MixedFraction._(
      whole,
      numerator,
      denominator,
      !isNegative,
    );
  }

  @override
  MixedFraction reduce() {
    final gcd = numerator.gcd(denominator);

    return MixedFraction._(
      whole,
      numerator ~/ gcd,
      denominator ~/ gcd,
      isNegative,
    );
  }

  @override
  List<Fraction> toEgyptianFraction() =>
      EgyptianFractionConverter.fromMixedFraction(
        mixedFraction: this,
      ).compute();

  /// If possible, this method converts this [MixedFraction] instance into a
  /// string where the fractional part is a Unicode glyph. For example:
  ///
  /// ```dart
  /// MixedFraction(
  ///   whole: 3,
  ///   numerator: 1,
  ///   denominator: 7,
  /// ).toStringAsGlyph() // "3 ⅐"
  /// ```
  ///
  /// If the conversion is not possible, a [FractionException] object is thrown.
  String toStringAsGlyph() {
    final glyph = fractionalPart.toStringAsGlyph();
    final sign = isNegative ? '-' : '';

    if (whole == 0) {
      return '$sign$glyph';
    }

    return '$sign$whole $glyph';
  }

  /// Converts this mixed fraction into a fraction.
  Fraction toFraction() => Fraction.fromMixedFraction(this);

  /// {@template copy_with}
  /// Creates a **deep** copy of this object with the given fields replaced
  /// with the new values.
  /// {@endtemplate}
  ///
  /// The new values are combined as in the default constructor, and then the
  /// sign of this mixed fraction is applied to the result. For example,
  /// copying `-2 1/3` with `whole: 5` gives `-5 1/3`.
  MixedFraction copyWith({int? whole, int? numerator, int? denominator}) {
    final result = MixedFraction(
      whole: whole ?? this.whole,
      numerator: numerator ?? this.numerator,
      denominator: denominator ?? this.denominator,
    );

    return isNegative ? result.negate() : result;
  }

  /// Returns the fractional part of the mixed fraction as a [Fraction] object.
  /// It is never negative: use [isNegative] to get the sign.
  Fraction get fractionalPart => Fraction(numerator, denominator);

  /// The sum between two mixed fractions.
  MixedFraction operator +(MixedFraction other) {
    final result = toFraction() + other.toFraction();

    return result.toMixedFraction();
  }

  /// The difference between two mixed fractions.
  MixedFraction operator -(MixedFraction other) {
    final result = toFraction() - other.toFraction();

    return result.toMixedFraction();
  }

  /// The product of two mixed fractions.
  MixedFraction operator *(MixedFraction other) {
    final result = toFraction() * other.toFraction();

    return result.toMixedFraction();
  }

  /// The division of two mixed fractions.
  MixedFraction operator /(MixedFraction other) {
    final result = toFraction() / other.toFraction();

    return result.toMixedFraction();
  }

  /// Access the whole part, the numerator or the denominator of the fraction
  /// via index. In particular:
  ///
  ///  - `0` refers to the whole part (which is never negative);
  ///  - `1` refers to the numerator;
  ///  - `2` refers to the denominator.
  ///
  /// Any other value which is not `0`, `1` or `2` will throw an exception of
  /// [MixedFractionException] type.
  int operator [](int index) {
    switch (index) {
      case 0:
        return whole;
      case 1:
        return numerator;
      case 2:
        return denominator;
      default:
        throw MixedFractionException(
          'The index ($index) is not valid: it must either be 0, 1 or 2.',
        );
    }
  }
}
