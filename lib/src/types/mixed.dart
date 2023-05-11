import 'package:fraction/fraction.dart';
import 'package:fraction/src/types/egyptian_converter.dart';

/// Dart representation of a 'mixed fraction', which is made up by the whole
/// part and a proper fraction. A proper fraction is a fraction in which the
/// relation `numerator <= denominator` is true.
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
///  final sub = f1 - f2; // -2 17/72
///  final mul = f1 * f2; // 18 20/72
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
/// If the string doesn't represent a valid fraction, a [MixedFractionException]
/// object is thrown.
base class MixedFraction extends Rational {
  /// Whole part of the mixed fraction.
  final int whole;

  /// The numerator of the fractional part.
  final int _numerator;

  /// The denominator of the fractional part.
  final int _denominator;

  /// If the numerator isn't greater than the denominator, values are
  /// transformed so that a valid mixed fraction is created. For example:
  ///
  /// ```dart
  ///  MixedFraction(1, 7, 3);
  /// ```
  ///
  /// This constructor builds the string as '3 1/3' because '1 7/3' is not a
  /// valid input ('7/3' is not a proper fraction).
  factory MixedFraction({
    required int whole,
    required int numerator,
    required int denominator,
  }) {
    // Denominator cannot be zero
    if (denominator == 0) {
      throw const MixedFractionException('The denominator cannot be zero.');
    }

    // The sign of the fractional part doesn't persist on the fraction itself;
    // the negative sign only applies (by convention) to the whole part
    final sign = Fraction(numerator, denominator).isNegative ? -1 : 1;
    final absNumerator = numerator.abs();
    final absDenominator = denominator.abs();

    // In case the numerator was greater than the denominator, there'd the need
    // to transform the fraction and make it proper. The sign of the whole part
    // may change depending on the sign of the fractional part.
    if (absNumerator > absDenominator) {
      return MixedFraction._(
        (absNumerator ~/ absDenominator + whole) * sign,
        absNumerator % absDenominator,
        absDenominator,
      );
    } else {
      return MixedFraction._(
        whole * sign,
        absNumerator,
        absDenominator,
      );
    }
  }

  /// The default constructor.
  const MixedFraction._(this.whole, this._numerator, this._denominator);

  /// Creates an instance of a mixed fraction.
  factory MixedFraction.fromFraction(Fraction fraction) =>
      fraction.toMixedFraction();

  /// Creates a [MixedFraction] object from [value]. The input string must be in
  /// the form 'a b/c' with exactly one space between the whole part and the
  /// fraction.
  ///
  /// The fractional part can also be a glyph.
  ///
  /// The negative sign can only stay in front of 'a' or 'b'. Some valid
  /// examples are:
  ///
  /// ```dart
  ///  MixedFraction.fromString('-2 2/5');
  ///  MixedFraction.fromString('1 1/3');
  ///  MixedFraction.fromString('3 ⅐');
  /// ```
  factory MixedFraction.fromString(String value) {
    const errorObj = MixedFractionException(
      "The string must be in the form 'a b/c' with exactly one space between "
      'the whole part and the fraction',
    );

    // Check for the space
    if (!value.contains(' ')) {
      throw errorObj;
    }

    /*
     * The 'parts' array must contain exactly 2 pieces:
     *  - parts[0]: the whole part (an integer)
     *  - parts[1]: the fraction (a string)
     * */
    final parts = value.split(' ');

    // Throw because this is not in the form 'a b/c'
    if (parts.length != 2) {
      throw errorObj;
    }

    /*
     * At this point the string is made up of 2 "parts" separated by a space. An
     * exception can occur only if the second part is a malformed string (not a
     * fraction)
     * */
    Fraction fraction;

    // The string must be either a fraction with numbers and a slash or a glyph.
    // If that's not the case, then a 'FractionException' is thrown.
    try {
      fraction = Fraction.fromString(parts[1]);
    } on FractionException {
      fraction = Fraction.fromGlyph(parts[1]);
    }

    // Fixing the potential negative signs
    return MixedFraction(
      whole: int.parse(parts.first),
      numerator: fraction.numerator,
      denominator: fraction.denominator,
    );
  }

  /// Tries to give a fractional representation of a double according with the
  /// given precision. This implementation takes inspiration from the continued
  /// fraction algorithm.
  ///
  /// ```dart
  ///  MixedFraction.fromDouble(5.46) // represented as 5 + 23/50
  /// ```
  ///
  /// Note that irrational numbers can **not** be represented as fractions. If
  /// you try to use this method on π (3.1415...) for example, you won't get a
  /// valid result:
  ///
  /// ```dart
  ///  MixedFraction.fromDouble(math.pi)
  /// ```
  ///
  /// The above code doesn't throw. It returns a [MixedFraction] object because
  /// the algorithm only considers the first 10 decimal digits (since
  /// [precision] is set to 1.0e-10).
  ///
  /// ```dart
  ///  MixedFraction.fromDouble(math.pi, precision: 1.0e-20)
  /// ```
  ///
  /// This example will return another different value because it considers the
  /// first 20 digits. It's still not a fractional representation of π because
  /// irrational numbers cannot be expressed as fractions.
  ///
  /// You should only use this method with rational numbers.
  factory MixedFraction.fromDouble(double value, {double precision = 1.0e-12}) {
    // In this way we can reuse the continued fraction algorithm.
    final fraction = Fraction.fromDouble(value, precision: precision);

    return fraction.toMixedFraction();
  }

  @override
  int get numerator => _numerator;

  @override
  int get denominator => _denominator;

  @override
  bool get isNegative => whole < 0;

  @override
  bool get isWhole => fractionalPart == Fraction(1);

  @override
  bool operator ==(Object other) {
    // Two mixed fractions are equal if the whole part and the "cross product"
    // of the fractional part is equal.
    //
    // ```dart
    // final one = MixedFraction(whole: 1, numerator: 3, denominator: 4);
    // final two = MixedFraction(whole: 1, numerator: 6, denominator: 8);
    //
    // print(one == two); //true
    // ```
    //
    // The above example returns true because the whole part is equal (1 = 1)
    // and the "cross product" of `one` and two` is equal (3 * 8 = 6 * 4).
    if (identical(this, other)) {
      return true;
    }

    if (other is MixedFraction) {
      return toFraction() == other.toFraction();
    } else {
      return false;
    }
  }

  @override
  int get hashCode => Object.hash(whole, numerator, denominator);

  @override
  String toString() {
    if (whole == 0) {
      return '$numerator/$denominator';
    }

    return '$whole $numerator/$denominator';
  }

  @override
  double toDouble() => whole + numerator / denominator;

  @override
  MixedFraction negate() => MixedFraction(
        whole: whole * -1,
        numerator: numerator,
        denominator: denominator,
      );

  @override
  MixedFraction reduce() {
    final fractionalPart = Fraction(numerator, denominator).reduce();

    return MixedFraction(
      whole: whole,
      numerator: fractionalPart.numerator,
      denominator: fractionalPart.denominator,
    );
  }

  @override
  List<Fraction> toEgyptianFraction() =>
      EgyptianFractionConverter.fromMixedFraction(
        mixedFraction: this,
      ).compute();

  /// If possible, this method converts this [MixedFraction] instance into an
  /// unicode glyph string. For example:
  ///
  /// ```dart
  /// MixedFraction(
  ///   whole: 3,
  ///   numerator: 1,
  ///   denominator: 7,
  /// ).toStringAsGlyph() // "⅐"
  /// ```
  ///
  /// If the conversion is not possible, a [FractionException] object is thrown.
  String toStringAsGlyph() {
    final glyph = Fraction(numerator, denominator).toStringAsGlyph();

    if (whole == 0) {
      return glyph;
    } else {
      return '$whole $glyph';
    }
  }

  /// Converts this mixed fraction into a fraction.
  Fraction toFraction() => Fraction.fromMixedFraction(this);

  /// Creates a **deep** copy of this object with the given fields replaced
  /// with the new values.
  MixedFraction copyWith({
    int? whole,
    int? numerator,
    int? denominator,
  }) =>
      MixedFraction(
        whole: whole ?? this.whole,
        numerator: numerator ?? this.numerator,
        denominator: denominator ?? this.denominator,
      );

  /// Returns the fractional part of the mixed fraction as [Fraction] object.
  Fraction get fractionalPart => Fraction(numerator, denominator);

  /// The sum between two mixed fractions.
  MixedFraction operator +(MixedFraction other) {
    final result = toFraction() + other.toFraction();

    return result.toMixedFraction();
  }

  /// The difference between two mixed fractions.
  MixedFraction operator -(MixedFraction other) {
    final result = other.toFraction() - toFraction();

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
  ///  - `0` refers to the whole part;
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
