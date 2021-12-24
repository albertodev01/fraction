<p align="center"><img src="https://raw.githubusercontent.com/albertodev01/fraction/master/assets/package_logo.png" alt="fraction package logo" /></p>
<p align="center">A package that helps you working with <b>fractions</b> and <b>mixed fractions</b>.</p>
<p align="center">
    <a href="https://codecov.io/gh/albertodev01/fraction"><img src="https://codecov.io/gh/albertodev01/fraction/branch/master/graph/badge.svg?token=YKA1ZYUROR"/></a>
    <a href="https://github.com/albertodev01/fraction/actions"><img src="https://github.com/albertodev01/fraction/workflows/fractions_ci/badge.svg" alt="CI status" /></a>
    <a href=""><img src="https://img.shields.io/github/stars/albertodev01/fraction.svg?style=flat&logo=github&colorB=blue&label=stars" alt="Stars count on GitHub" /></a>
    <a href="https://pub.dev/packages/fraction"><img src="https://img.shields.io/pub/v/fraction.svg?style=flat&logo=github&colorB=blue" alt="Stars count on GitHub" /></a>
</p>
<p align="center"><a href="https://pub.dev/packages/fraction">https://pub.dev/packages/fraction</a></p>

---

## Working with fractions

You can create an instance of `Fraction` using one of its constructors.

 - **Basic**: it just requires the numerator and/or the denominator.

   ```dart
   final frac1 = Fraction(3, 5); // 3/5
   final frac2 = Fraction(3, 1); // 3
   ```

 - **String**: pass the fraction as a string (it has to be well-formed otherwise an exception will be thrown).

   ```dart
   final frac1 = Fraction.fromString("2/4"); // 2/4
   final frac2 = Fraction.fromString("-2/4"); // -2/4
   final frac3 = Fraction.fromString("2/-4"); // Error
   final frac4 = Fraction.fromString("-2"); // -2/1
   final frac5 = Fraction.fromString("/3"); // Error
   ```

 - **double**: represents a double as a fraction. Note that irrational numbers cannot be converted into a fraction by definition; the constructor has the `precision` parameter which decides how precise the representation has to be.

   ```dart
   final frac1 = Fraction.fromDouble(1.5); // 3/2
   final frac2 = Fraction.fromDouble(-8.5); // -17/2
   final frac3 = Fraction.fromDouble(math.pi); // 208341/66317
   final frac4 = Fraction.fromDouble(math.pi, 1.0E-4); // 333/106
   ```

   The constant `pi` cannot be represented as a fraction because it's an irrational number. The constructor considers only `precison` decimal digits to create a fraction. With rational numbers instead you don't have problems.

Thanks to extension methods you can also create a `Fraction` object "on the fly" by calling the `toFraction()` method on a number or a string.

```dart
final f1 = 5.toFraction(); // 5/1
final f2 = 1.5.toFraction(); // 3/2
final f3 = "6/5".toFraction(); // 6/5
```

Note that a `Fraction` object is **immutable** so methods that require changing the internal state of the object return a new instance. For example, the `reduce()` method reduces the fraction to the lowest terms and returns a **new** instance:

```dart
final fraction = Fraction.fromString("12/20"); // 12/20
final reduced = fraction.reduce(); // now it's simplified to  3/5
```

Fraction strings can be converted from and to unicode glyphs when possible.

```dart
final Fraction oneOverFour = Fraction.fromGlyph("¼"); // Fraction(1, 4)
final String oneOverTwo = Fraction(1, 2).toStringAsGlyph(); // "½"
```

You can easily sum, subtract, multiply and divide fractions thanks to arithmetic operators:

```dart
final f1 = Fraction(5, 7);
final f2 = Fraction(1, 5);

final sum = f1 + f2; // -> 5/7 + 1/5
final sub = f1 - f2; // -> 5/7 - 1/5
final mul = f1 * f2; // -> 5/7 * 1/5
final div = f1 / f2; // -> 5/7 / 1/5
```

The method `reduce()` reduces the fraction to the lowest terms.

```dart
final fraction = Fraction.fromString("12/20");  // 12/20
final reduced = fraction.reduce();              // 3/5
```

There are a lot of methods you can use to get info about a fraction instance:

```dart
final fraction1 = Fraction(10, 2).toDouble();  // 5.0
final fraction2 = Fraction(10, 2).inverse();   // 2/10
final fraction3 = Fraction(1, 15).isWhole;     // false
final fraction4 = Fraction(2, 3).negate();     // -2/3
final fraction5 = Fraction(1, 15).isImproper;  // false
final fraction6 = Fraction(1, 15).isProper;    // true

// Access numerator and denominator by index
final fraction = Fraction(-7, 12);

print('${fraction[0]}'); // -7
print('${fraction[1]}'); // 12
```

Any other index value different from `0` and `1` throws a `FractionException` exception. Two fractions are equal if their "cross product" is equal. For example `1/2` and `3/6` are said to be equivalent because `1*6 = 3*2` (and in fact `3/6` is the same as `1/2`).

## Working with mixed fractions

A mixed fraction is made up of a whole part and a proper fraction (a fraction in which numerator <= denominator). Building a `MixedFraction` object is very easy:

```dart
final mixed1 = MixedFraction(
  whole: 3, 
  numerator: 4, 
  denominator: 7
);
final mixed2 = MixedFraction.fromDouble(1.5);
final mixed3 = MixedFraction.fromString("1 1/2");
```

There also is the possibility to initialize a `MixedFraction` using extension methods, as it happens with `Fraction`:

```dart
final mixed = "1 1/2".toMixedFraction();
```

Note that `MixedFraction` objects are **immutable** exactly like `Fraction` objects so you're guaranteed that the internal state of the instance won't change. Make sure to check the official documentation at [pub.dev](https://pub.dev/documentation/fraction/latest/fraction/MixedFraction-class.html) for a complete overview of the API.

## Egyptian fractions

An Egyptian fraction is a finite sum of distinct fractions where the numerator is always 1 and, the denominator is a positive number and all the denominators differ from each other. For example:

  - 5/8 = 1/2 + 1/8 (where "1/2 + 1/8" is the egyptian fraction)

Basically, egyptian fractions are a sum of fractions in the form 1/x that represent a proper or an improper fraction. Here's how you can work with them:

```dart
final egyptianObject = EgyptianFraction(
  fraction: Fraction(5, 8),
);

final egyptianFraction = egyptianObject.compute();
print("$egyptianFraction"); // prints "1/2 + 1/8"
```

The `compute()` method returns an iterable of type `List<Fraction>`.