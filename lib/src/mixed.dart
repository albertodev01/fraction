import 'package:fraction/fraction.dart';

/// Dart representation of a mixed fraction which is composed by the whole part
/// and an proper fraction. An proper fraction is a fraction in which the relation
/// numerator <= denominator is true.
///
/// It's possible to create an instance of [MixedFraction] either by using
/// one of the constructors or by using the extension methods on [num] and [String].
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
/// If the string doesn't represent a valid fraction, a [MixedFractionException] is
/// thrown.
class MixedFraction implements Comparable<MixedFraction> {
  int _whole;
  int _num;
  int _den;

  /// Whole part of the mixed fraction
  int get whole => _whole;

  /// Numerator of the fraction
  int get numerator => _num;

  /// Denominator of the fraction
  int get denominator => _den;

  /// If true, when the fraction is converted into a double or a string the minus
  /// sign has to be applied.
  bool _negative = false;

  /// True or false whether the mixed fraction is positive or negative
  bool get isNegative => _negative;

  /// Creates an instance of a mixed fraction. If the numerator isn't greater than
  /// the denominator, an exception of type [MixedFractionException] is thrown.
  MixedFraction(int whole, int numerator, int denominator) {
    if (numerator > denominator) {
      throw MixedFractionException("The numerator cannot be greater than the"
          "denominator (you have $numerator > $denominator).");
    }

    if (denominator == 0) {
      throw MixedFractionException('The denominator cannot be zero');
    }

    _whole = whole;
    _num = numerator;
    _den = denominator;

    _fixSign();
  }

  /// Creates an instance of a mixed fraction. If the numerator isn't greater than
  /// the denominator, an exception of type [MixedFractionException] is thrown.
  MixedFraction.fromFraction(Fraction fraction) {
    final f = fraction.toMixedFraction();

    if (f == null) {
      throw MixedFractionException('The given fraction $fraction cannot be '
          'converted into a mixed fraction. Be sure that the numerator is greater '
          'than the denominator.');
    }

    _whole = f.whole;
    _num = f.numerator;
    _den = f.denominator;

    _fixSign();
  }

  /// Creates an instance of a mixed fraction. If the numerator is greater than
  /// the denominator, an exception of type [MixedFractionException] is thrown.
  ///
  /// The input string must be in the form 'a b/c' with exactly one space between
  /// the whole part and the fraction.
  ///
  /// The negative sign can only stay in front of 'a' or 'b'.
  MixedFraction.fromString(String value) {
    final errorObj =
        MixedFractionException("The string must be in the form 'a b/c' "
            "with exactly one space between the whole part and the fraction");

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
    final frac = Fraction.fromString(parts[1]);

    if (frac.numerator > frac.denominator) {
      throw MixedFractionException('The numerator cannot be greater than the'
          'denominator (you have ${frac.numerator} > ${frac.denominator}).');
    }

    _whole = int.parse(parts[0]);
    _num = frac.numerator;
    _den = frac.denominator;

    _fixSign();
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
    result = 31 * result + _whole.hashCode;
    result = 31 * result + _num.hashCode;
    result = 31 * result + _den.hashCode;
    return result;
  }

  @override
  String toString() {
    if (_negative) {
      return "-$_whole $_num/$_den";
    } else {
      return "$_whole $_num/$_den";
    }
  }

  /// Floating point representation of the mixed fraction
  double toDouble() {
    if (_negative) {
      return -(_whole + _num / _den);
    } else {
      return _whole + _num / _den;
    }
  }

  /// Converts this mixed fraction into a fraction
  Fraction toFraction() => Fraction.fromMixedFraction(this);

  @override
  int compareTo(other) {
    if (toDouble() < other.toDouble()) return -1;

    if (toDouble() > other.toDouble()) return 1;

    return 0;
  }

  /// Reduces the fraction to the lowest terms
  void reduce() {
    final temp = Fraction(_num, _den)..reduce();

    _num = temp.numerator;
    _den = temp.denominator;
  }

  /// Changes the sign of the fraction
  void negate() {
    _num *= -1;
    _negative = !_negative;
  }

  /// If both the whole part and the numerator are negative, then the entire
  /// fraction is positive.
  ///
  /// If the whole part **or** the numerator (not both) is negative, then the
  /// mixed fraction is negative.
  ///
  /// The absolute values are taken because, internally the sign doesn't really
  /// matter. When converted into other formats, it's sufficient to just put
  /// the sign at the front, if present.
  void _fixSign() {
    if ((_whole < 0) && (_num < 0)) {
      _negative = false;
    } else {
      if ((_whole < 0) || (_num < 0)) _negative = true;
    }

    _whole = _whole.abs();
    _num = _num.abs();
  }
}
