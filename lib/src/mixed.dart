import 'package:fraction/fraction.dart';

/// Dart representation of a mixed fraction which is composed by the whole part
/// and a proper fraction. A proper fraction is a fraction in which the relation
/// `numerator <= denominator` is true.
///
/// There's the possibility to create an instance of [MixedFraction] either by
/// using one of the constructors or by using the extension methods on [num] and
/// [String].
///
/// ```dart
/// final f = MixedFraction.fromDouble(1.5);
/// final f = MixedFraction.fromString("1 1/2");
/// ```
///
/// is equivalent to
///
/// ```dart
/// final f = 1.5.toMixedFraction();
/// final f = "1 1/2".toMixedFraction();
/// ```
///
/// If the string doesn't represent a valid fraction, a [MixedFractionException]
/// is thrown.
class MixedFraction implements Comparable<MixedFraction> {
  /// Whole part of the mixed fraction
  late final int whole;

  /// Numerator of the fraction
  late final int numerator;

  /// Denominator of the fraction
  late final int denominator;

  /// Creates an instance of a mixed fraction. If the numerator isn't greater than
  /// the denominator, an exception of type [MixedFractionException] is thrown.
  MixedFraction(
      {required int whole, required int numerator, required int denominator}) {
    // Making sure the fraction is proper
    if (numerator > denominator) {
      throw MixedFractionException('The numerator cannot be greater than the'
          'denominator (you have $numerator > $denominator).');
    }

    // Denominator cannot be zero
    if (denominator == 0) {
      throw MixedFractionException('The denominator cannot be zero');
    }

    // Fixing the potential negative signs
    _fixSign(whole, numerator, denominator);
  }

  /// Creates an instance of a mixed fraction. If the numerator isn't greater than
  /// the denominator, an exception of type [MixedFractionException] is thrown.
  MixedFraction.fromFraction(Fraction fraction) {
    final f = fraction.toMixedFraction();

    // The 'toMixedFraction()' method returns a nullable value
    if (f == null) {
      throw MixedFractionException('The given fraction $fraction cannot be '
          'converted into a mixed fraction. Be sure that the numerator is greater '
          'than the denominator.');
    }

    // Fixing the potential negative signs
    _fixSign(whole, numerator, denominator);
  }

  /// Creates an instance of a mixed fraction. If the numerator is greater than
  /// the denominator, an exception of type [MixedFractionException] is thrown.
  ///
  /// The input string must be in the form 'a b/c' with exactly one space between
  /// the whole part and the fraction.
  ///
  /// The negative sign can only stay in front of 'a' or 'b'.
  MixedFraction.fromString(String value) {
    const errorObj = MixedFractionException("The string must be in the form 'a "
        "b/c' with exactly one space between the whole part and the fraction");

    // Check for the space
    if (!value.contains(' ')) throw errorObj;

    /*
     * The 'parts' array must contain exactly 2 pieces:
     *  > parts[0]: the whole part (an integer)
     *  > parts[1]: the fraction (a string)
     * */
    final parts = value.split(" ");

    if (parts.length != 2) throw errorObj;

    /*
     * At this point the string is made up of 2 "parts" separated by a space. An
     * exception can occur only if the second part is a malformed string (not a
     * fraction)
     * */
    final fraction = Fraction.fromString(parts[1]);

    // Checking whether the fractional part is a proper fraction
    if (fraction.numerator > fraction.denominator) {
      throw MixedFractionException('The numerator cannot be greater than the '
          'denominator. In this case, the numerator (${fraction.numerator}) is '
          'greater than the denominator (${fraction.denominator}).');
    }

    // Fixing the potential negative signs
    _fixSign(int.parse(parts[0]), fraction.numerator, fraction.denominator);
  }

  @override

  /// Two mixed fractions are equal if their "cross product" is equal.
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

    if (other is MixedFraction) {
      final mixedFraction = other;

      return runtimeType == mixedFraction.runtimeType &&
          whole == mixedFraction.whole &&
          toFraction() == mixedFraction.toFraction();
    } else {
      return false;
    }
  }

  @override
  int get hashCode {
    var result = 83;

    result = 31 * result + whole.hashCode;
    result = 31 * result + numerator.hashCode;
    result = 31 * result + denominator.hashCode;

    return result;
  }

  @override
  int compareTo(other) {
    if (toDouble() < other.toDouble()) return -1;

    if (toDouble() > other.toDouble()) return 1;

    return 0;
  }

  @override
  String toString() {
    if (_negative) {
      return "-$whole $numerator/$denominator";
    } else {
      return "$whole $numerator/$denominator";
    }
  }

  /// Floating point representation of the mixed fraction.
  double toDouble() {
    if (_negative) {
      return -(whole + numerator / denominator);
    } else {
      return whole + numerator / denominator;
    }
  }

  /// Converts this mixed fraction into a fraction.
  Fraction toFraction() => Fraction.fromMixedFraction(this);

  /// If true, when the fraction is converted into a double or a string the minus
  /// sign has to be applied.
  var _negative = false;

  /// True or false whether the mixed fraction is positive or negative.
  bool get isNegative => _negative;

  /// Reduces this mixed fraction to the lowest terms and returns the results in
  /// a new [MixedFraction] instance.
  MixedFraction reduce() {
    final fractionalPart = Fraction(numerator, denominator).reduce();

    return MixedFraction(
      whole: whole,
      numerator: fractionalPart.numerator,
      denominator: fractionalPart.denominator,
    );
  }

  /// Changes the sign of this mixed fraction and returns the results in a new
  /// [MixedFraction] instance.
  MixedFraction negate() => MixedFraction(
      whole: whole, numerator: numerator * -1, denominator: denominator);

  /// If both the whole part and the numerator are negative, then the entire
  /// fraction is positive.
  ///
  /// If the whole part **or** the numerator (not both) is negative, then the
  /// mixed fraction is negative.
  ///
  /// The absolute values are taken because, internally the sign doesn't really
  /// matter. When converted into other formats, it's sufficient to just put
  /// the sign at the front, if present.
  void _fixSign(int whole, int numerator, int denominator) {
    if ((whole < 0) && (numerator < 0)) {
      _negative = false;
    } else {
      if ((whole < 0) || (numerator < 0)) _negative = true;
    }

    this.whole = whole.abs();
    this.numerator = numerator.abs();
    this.denominator = denominator;
  }
}
