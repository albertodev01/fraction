import 'package:fraction/fraction.dart';

/// An Egyptian fraction is a finite sum of distinct fractions where the numerator
/// is always 1 and, the denominator is a positive number and all the denominators
/// differ from each other. For example:
///
///  - 5/8 = 1/2 + 1/8 (where "1/2 + 1/8" is the egyptian fraction)
///
/// Basically, egyptian fractions are a sum of fractions in the form 1/x that
/// represent a proper or an improper fraction. Here we have other examples of
/// fractions and their egyptian fraction equivalent:
///
///  - 4/7 = 1/2 + 1/14
///  - 43/48 = 1/2 + 1/3 + 1/16
///  - 2014/59 = 34 + 1/8 + 1/95 + 1/14947 + 1/670223480
///
/// In various cases, the value of the denominator can be so big that an overflow
/// error happens.
class EgyptianFraction implements Comparable<EgyptianFraction> {
  /// The fraction to be converted into an egyptian fraction.
  final Fraction fraction;

  /// This variable caches the result of the [compute] method.
  final List<Fraction> _cache = [];

  /// Both proper and improper fractions are accepted.
  EgyptianFraction({
    required this.fraction,
  });

  /// Returns a series of [Fraction] representing the egyptian fraction of the
  /// current [fraction] object.
  List<Fraction> compute() {
    // If the result is in the cache, then return it immediately
    if (_cache.isNotEmpty) {
      return List<Fraction>.from(_cache);
    }

    // No data in the cache so let's compute the egyptian fraction
    final results = <Fraction>[];

    // We need a new fraction object because it had to be modified
    var egFrac = fraction.copyWith();
    final one = Fraction(1);

    // Computing the egyptian fraction
    if (egFrac.compareTo(one) >= 0) {
      if (egFrac.denominator == 1) {
        results.add(egFrac);
        return results;
      }

      results.add(egFrac.copyWith());
      egFrac -= results[0];
    }

    while (egFrac.numerator != 1) {
      final q = egFrac.numerator + egFrac.denominator - 1;
      final intDen = (q / egFrac.numerator).round();

      results.add(Fraction(1, intDen));

      final newNumerator = _modulo(-egFrac.denominator, egFrac.numerator);
      egFrac = Fraction(newNumerator, egFrac.denominator * intDen);
    }

    results.add(egFrac);

    // Updating the cache
    _cache.addAll(List<Fraction>.from(results));

    return results;
  }

  int _modulo(int a, int b) => ((a % b) + b) % b;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    if (other is EgyptianFraction) {
      return fraction == other.fraction;
    } else {
      return false;
    }
  }

  @override
  int get hashCode => 31 * 83 + fraction.hashCode;

  @override
  int compareTo(EgyptianFraction other) => fraction.compareTo(other.fraction);

  @override
  String toString() {
    var egyptian = _cache;

    // If there's nothing in the cache, then compute the result and update the
    // cache too
    if (egyptian.isEmpty) {
      egyptian = compute();
      _cache.addAll(List<Fraction>.from(egyptian));
    }

    final buffer = StringBuffer()..writeAll(egyptian, ' + ');
    return buffer.toString();
  }
}
