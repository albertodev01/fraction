import 'dart:collection';

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
  /// This variable caches the result of the [compute] method.
  static final _cache = <Fraction, List<Fraction>>{};

  /// Clears the internal cache.
  static void clearCache() => _cache.clear();

  /// Determines whether in-memory caching is enabled or not. This caching
  /// strategy does **NOT** persist data on disk.
  ///
  /// This is `true` by default. If you want to purge and disable the cache, set
  /// this param to `false` and then call [EgyptianFraction.clearCache].
  static bool cachingEnabled = true;

  /// The fraction to be converted into an egyptian fraction.
  final Fraction fraction;

  /// Both proper and improper fractions are accepted.
  ///
  /// By default, the `enableCache` parameter is set to `true` allowing some
  /// performance optimizations.
  EgyptianFraction({
    required this.fraction,
  }) : assert(!fraction.isNegative, 'The fraction must be positive!');

  /// Returns a series of [Fraction] representing the egyptian fraction of the
  /// current [fraction] object.
  List<Fraction> compute() {
    // If the result is in the cache, then return it immediately
    if (cachingEnabled && _cache.containsKey(fraction)) {
      return _cache[fraction]!;
    }

    // Computing the fraction
    final results = <Fraction>[];

    var numerator = fraction.numerator;
    var denominator = fraction.denominator;

    while (numerator > 0) {
      final egyptianDen = (denominator + numerator - 1) ~/ numerator;
      results.add(Fraction(1, egyptianDen));

      numerator = _modulo(-denominator, numerator);
      denominator *= egyptianDen;
    }

    // If the result isn't in the cache, add it
    if (cachingEnabled && !_cache.containsKey(fraction)) {
      _cache[fraction] = List<Fraction>.from(results);
    }

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
    var results = <Fraction>[];

    // Trying to not compute the fraction (if possible)
    if (cachingEnabled && _cache.containsKey(fraction)) {
      results = _cache[fraction]!;
    } else {
      results = compute();

      // We can cache it if caching is enabled
      if (cachingEnabled) {
        _cache[fraction] = List<Fraction>.from(results);
      }
    }

    final buffer = StringBuffer()..writeAll(results, ' + ');
    return buffer.toString();
  }
}
