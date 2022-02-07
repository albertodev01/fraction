import 'package:fraction/fraction.dart';
import 'package:fraction/src/types/egyptian.dart';

/// Dart representation of a 'mixed fraction', which is made up by the whole part
/// and a proper fraction. A proper fraction is a fraction in which the relation
/// `numerator <= denominator` is true.
///
/// There's the possibility to create an instance of [MixedFraction] either by
/// using one of the constructors or the extension methods on [num] and [String].
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
/// There also are extension methods to quickly build [Fraction] objects from
/// primitive types:
///
/// ```dart
/// 1.5.toMixedFraction();
/// "1 1/2".toMixedFraction();
/// ```
///
/// If the string doesn't represent a valid fraction, a [MixedFractionException]
/// is thrown.
class MixedFraction extends Rational {
  /// Whole part of the mixed fraction.
  final int whole;

  /// Numerator of the fraction.
  final int numerator;

  /// Denominator of the fraction.
  final int denominator;

  /// Creates an instance of a mixed fraction.
  ///
  /// If the numerator isn't greater than the denominator, values are
  /// transformed so that a valid mixed fraction is created. For example, in...
  ///
  /// ```dart
  /// MixedFraction(1, 7, 3);
  /// ```
  ///
  /// ... the object is built as '3 1/3' since '1 7/3' would be invalid.
  factory MixedFraction({
    required int whole,
    required int numerator,
    required int denominator,
  }) {
    // Denominator cannot be zero
    if (denominator == 0) {
      throw const MixedFractionException('The denominator cannot be zero');
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
        whole: (absNumerator ~/ absDenominator + whole) * sign,
        numerator: absNumerator % absDenominator,
        denominator: absDenominator,
      );
    } else {
      return MixedFraction._(
        whole: whole * sign,
        numerator: absNumerator,
        denominator: absDenominator,
      );
    }
  }

  /// The default constructor.
  const MixedFraction._({
    required this.whole,
    required this.numerator,
    required this.denominator,
  });

  /// Creates an instance of a mixed fraction.
  factory MixedFraction.fromFraction(Fraction fraction) =>
      fraction.toMixedFraction();

  /// Creates an instance of a mixed fraction. The input string must be in the
  /// form 'a b/c' with exactly one space between the whole part and the
  /// fraction.
  ///
  /// The fraction can also be a glyph.
  ///
  /// The negative sign can only stay in front of 'a' or 'b'. Some valid examples
  /// are:
  ///
  /// ```dart
  /// MixedFraction.fromString('-2 2/5');
  /// MixedFraction.fromString('1 1/3');
  /// MixedFraction.fromString('3 ⅐');
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
  int get hashCode {
    var result = 83;

    result = result * 31 + whole.hashCode;
    result = result * 31 + numerator.hashCode;
    result = result * 31 + denominator.hashCode;

    return result;
  }

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
  MixedFraction negate() {
    return MixedFraction(
      whole: whole * -1,
      numerator: numerator,
      denominator: denominator,
    );
  }

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
  List<Fraction> toEgyptianFraction() {
    return EgyptianFractionConverter(
      fraction: toFraction(),
    ).compute();
  }

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
  /// If the conversion is not possible, a [FractionException] is thrown.
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
  }) {
    return MixedFraction(
      whole: whole ?? this.whole,
      numerator: numerator ?? this.numerator,
      denominator: denominator ?? this.denominator,
    );
  }

  /// True or false whether the mixed fraction is positive or negative.
  bool get isNegative => whole < 0;

  /// Returns the fractional part of the mixed fraction as [Fraction] object.
  Fraction get fractionalPart => Fraction(numerator, denominator);

  /// Sum between two mixed fractions.
  MixedFraction operator +(MixedFraction other) {
    final result = toFraction() + other.toFraction();

    return result.toMixedFraction();
  }

  /// Difference between two mixed fractions.
  MixedFraction operator -(MixedFraction other) {
    final result = other.toFraction() - toFraction();

    return result.toMixedFraction();
  }

  /// Product between two mixed fractions.
  MixedFraction operator *(MixedFraction other) {
    final result = toFraction() * other.toFraction();

    return result.toMixedFraction();
  }

  /// Division between two mixed fractions.
  MixedFraction operator /(MixedFraction other) {
    final result = toFraction() / other.toFraction();

    return result.toMixedFraction();
  }

  /// Access the whole part, the numerator or the denominator of the fraction
  /// via index. In particular:
  ///
  ///  - `0` refers to the whole part
  ///  - `1` refers to the numerator
  ///  - `2` refers to the denominator
  ///
  /// Any other value which is not `0`, `1` or `2` will throw an exception of
  /// type [MixedFractionException].
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
