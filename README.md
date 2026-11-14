<p align="center"><img src="https://raw.githubusercontent.com/albertodev01/fraction/master/assets/package_logo.png" alt="fraction package logo" /></p>
<p align="center">A package that helps you work with <b>fractions</b> and <b>mixed fractions</b>.</p>
<p align="center">
    <a href="https://codecov.io/gh/albertodev01/fraction"><img src="https://codecov.io/gh/albertodev01/fraction/branch/master/graph/badge.svg?token=YKA1ZYUROR" alt="Code coverage" /></a>
    <a href="https://github.com/albertodev01/fraction/actions"><img src="https://github.com/albertodev01/fraction/workflows/fractions_ci/badge.svg" alt="CI status" /></a>
    <a href="https://github.com/albertodev01/fraction/stargazers"><img src="https://img.shields.io/github/stars/albertodev01/fraction.svg?style=flat&logo=github&colorB=blue&label=stars" alt="Stars count on GitHub" /></a>
    <a href="https://pub.dev/packages/fraction"><img src="https://img.shields.io/pub/v/fraction.svg?style=flat&logo=dart&colorB=blue" alt="Latest version on pub.dev" /></a>
</p>
<p align="center">🌎 <a href="https://pub.dev/packages/fraction">https://pub.dev/packages/fraction</a></p>

---

## Working with fractions

You can create new `Fraction` objects using one of its constructors:

 - **Default**: requires the numerator and, optionally, the denominator (which defaults to `1`).

   ```dart
   Fraction(3, 5); // 3/5
   Fraction(3, 1); // 3
   ```

 - **fromString**: requires a `String` that represents a fraction.

   ```dart
   Fraction.fromString("2/4"); // 2/4
   Fraction.fromString("-2/4"); // -2/4
   Fraction.fromString("2/-4"); // Throws a FractionException
   Fraction.fromString("-2"); // -2
   Fraction.fromString("/3"); // Throws a FractionException
   ```

 - **fromDouble**: creates a `Fraction` from a `double` value. Irrational numbers cannot be represented as fractions by definition, so the constructor has a `precision` parameter that controls how close the approximation must be to the original value.

   ```dart
   Fraction.fromDouble(1.5); // 3/2
   Fraction.fromDouble(-8.5); // -17/2
   Fraction.fromDouble(math.pi); // 1146408/364913
   Fraction.fromDouble(math.pi, precision: 1.0e-4); // 333/106
   ```

   For example, `pi` cannot be represented exactly as a fraction because it's an irrational number. The constructor stops as soon as the result is within `precision` of the given value.

Thanks to extension methods, you can also create a `Fraction` object "on the fly" by calling `toFraction()` on a number or a string:

```dart
5.toFraction(); // 5
1.5.toFraction(); // 3/2
"6/5".toFraction(); // 6/5
```

The `Fraction` type is **immutable**, so methods that would change the object's internal state return a new instance instead. For example, the `reduce()` method reduces the fraction to its lowest terms and returns a **new** object:

```dart
final fraction = Fraction.fromString("12/20"); // 12/20
final reduced = fraction.reduce(); // 3/5
```

Fractions can be converted to and from Unicode glyphs, when a matching glyph exists. For example:

```dart
Fraction.fromGlyph("¼"); // 1/4
Fraction(1, 2).toStringAsGlyph(); // "½"
```

You can add, subtract, multiply, and divide fractions using the arithmetic operators. Results are always in lowest terms:

```dart
final f1 = Fraction(5, 7); // 5/7
final f2 = Fraction(1, 5); // 1/5

final sum = f1 + f2; // 32/35
final sub = f1 - f2; // 18/35
final mul = f1 * f2; // 1/7
final div = f1 / f2; // 25/7
```

The `Fraction` type has a rich API that covers the most common operations you'd expect to perform on a fraction:

```dart
Fraction(10, 2).toDouble();  // 5.0
Fraction(10, 2).inverse();   // 2/10
Fraction(1, 15).isWhole;     // false
Fraction(2, 3).negate();     // -2/3
Fraction(1, 15).isImproper;  // false
Fraction(1, 15).isProper;    // true

// Access the numerator and denominator by index
final fraction = Fraction(-7, 12);

print('${fraction[0]}'); // -7
print('${fraction[1]}'); // 12
```

In the last example, any index other than `0` or `1` throws a `FractionException`. Two fractions are equal if they represent the same value. For example, `1/2` and `3/6` are equal because `3/6` reduces to `1/2`, and they also have the same `hashCode`, so they can safely be used in sets and maps.

## Working with mixed fractions

A mixed fraction is made up of a whole part and a proper fraction (a fraction whose numerator is smaller than its denominator). Building a `MixedFraction` object is straightforward:

```dart
MixedFraction(
  whole: 3,
  numerator: 4,
  denominator: 7,
);
```

As with the `Fraction` type, you can use various named constructors:

```dart
MixedFraction.fromDouble(1.5);
MixedFraction.fromString("1 1/2");
```

You can also create new `MixedFraction` objects using extension methods:

```dart
final mixed = "1 1/2".toMixedFraction();
```

The `whole`, `numerator` and `denominator` values of a mixed fraction are never negative: the sign is stored separately and exposed by `isNegative`. A minus sign on either the whole part or the fractional part makes the whole value negative:

```dart
final a = MixedFraction(whole: -2, numerator: 1, denominator: 3); // -2 1/3
final b = MixedFraction(whole: 2, numerator: -1, denominator: 3); // -2 1/3
final c = MixedFraction(whole: 0, numerator: -1, denominator: 2); // -1/2

a.whole;      // 2
a.isNegative; // true
a.toDouble(); // -2.3333333333333335

MixedFraction.fromString("-2 1/3"); // -2 1/3
MixedFraction.fromString("-0 1/2"); // -1/2
```

If both parts are negative (for example, `MixedFraction(whole: -2, numerator: -1, denominator: 3)` or `"-2 -1/3"`), a `MixedFractionException` is thrown because the intended sign is ambiguous.

Mixed fractions support the same arithmetic operators as fractions:

```dart
final m1 = MixedFraction(whole: 5, numerator: 7, denominator: 8); // 5 7/8
final m2 = MixedFraction(whole: 3, numerator: 1, denominator: 9); // 3 1/9

final sum = m1 + m2; // 8 71/72
final sub = m1 - m2; // 2 55/72
final mul = m1 * m2; // 18 5/18
final div = m1 / m2; // 1 199/224
```

Like `Fraction`, the `MixedFraction` type is **immutable**, so its internal state is guaranteed never to change. Check out the official [API documentation](https://pub.dev/documentation/fraction/latest/fraction/MixedFraction-class.html) on pub.dev for a complete overview.

## Egyptian fractions

An Egyptian fraction is a finite sum of distinct unit fractions: fractions whose numerator is 1 and whose denominator is a positive integer. For example:

  - 5/8 = 1/2 + 1/8 (where "1/2 + 1/8" is the Egyptian fraction)

In other words, an Egyptian fraction represents a fraction as a sum of fractions of the form 1/x. If the value is 1 or greater, its whole part comes first as a single term. Here's how to compute one:

```dart
final egyptianFraction1 = Fraction(5, 8).toEgyptianFraction();
print(egyptianFraction1.join(" + ")); // prints "1/2 + 1/8"

final egyptianFraction2 = MixedFraction(
  whole: 2,
  numerator: 4,
  denominator: 5,
).toEgyptianFraction();
print(egyptianFraction2.join(" + ")); // prints "2 + 1/2 + 1/4 + 1/20"
```

The `toEgyptianFraction()` method returns a `List<Fraction>`. It throws a `FractionException` if the value is negative, or if a denominator is too large to fit in an `int`.

## Continued fractions

A (simple) continued fraction writes a number as a whole part plus a nested chain of reciprocals:

  - 7/9 = 0 + 1/(1 + 1/(3 + 1/2)), usually written as the list of terms [0; 1, 3, 2]

Here's how to compute the terms:

```dart
Fraction(7, 9).toContinuedFraction(); // [0, 1, 3, 2]
Fraction(-7, 9).toContinuedFraction(); // [-1, 4, 2]
MixedFraction(whole: 2, numerator: 1, denominator: 3).toContinuedFraction(); // [2, 3]
```

The `toContinuedFraction()` method returns a `List<int>`. The first term is the floor of the value (so it's negative for negative values) and all the other terms are positive.

## Notes

`Fraction` and `MixedFraction` are both subtypes of `Rational`, which lets you parse either kind of fraction with a single method call. For example:

```dart
// Returns a 'Fraction' object
Rational.tryParse('1/5'); // 1/5

// Returns a 'MixedFraction' object
Rational.tryParse('2 4/7'); // 2 4/7

// Returns 'null' because the string isn't a valid fraction or mixed fraction
Rational.tryParse(''); // null
```

Parsing an integer value, such as `Rational.tryParse('3')`, always returns a `Fraction`.
