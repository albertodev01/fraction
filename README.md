<p align="center"><img src="https://raw.githubusercontent.com/albertodev01/fraction/master/assets/package_logo.png" alt="fraction package logo" /></p>
<p align="center">A package that helps you dealing with <b>fractions</b> and <b>mixed fractions</b>.</p>
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
   final frac = Fraction(3, 5); // 3/5
   final frac = Fraction(3, 1); // 3
   ```

 - **String**: pass the fraction as a string but it has to be well-formed otherwise an exception is
   thrown.

   ```dart
   final frac1 = Fraction.fromString("2/4"); // 2/4
   final frac2 = Fraction.fromString("-2/4"); // -2/4
   final frac3 = Fraction.fromString("2/-4"); // Error
   final frac4 = Fraction.fromString("-2"); // -2/1
   ```

 - **double**: represents a double as a fraction. Note that irrational numbers cannot be converted into
   a fraction by definition; the constructor has the `precision` parameter which decides how precise
   the representation has to be.

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

Note that a `Fraction` object is **immutable** so methods that require changing the internal state of the object return a new instance. For example, `reduce()` method reduces the fraction to the lowest terms but it returns a new instance:

```dart
final fraction = Fraction.fromString("12/20"); // 12/20
final reduced = fraction.reduce(); // now it's simplified to  3/5
```

Fraction strings can be converted from and to unicode glyphs when possible.

```dart
final Fraction oneOverFour = Fraction.fromGlyph("¼"); // Fraction(1, 4)
final String oneOverTwo = Fraction(1, 2).toStringAsGlyph(); // "½"
```

Two fractions are equal if their "cross product" is equal. For example `1/2` and `3/6` are said to be equivalent because `1*6 = 3*2` (and in fact `3/6` is the same as `1/2`). Be sure to check out the official documentation at [pub.dev](https://pub.dev/documentation/fraction/latest/fraction/Fraction-class.html) for a complete overview of the API.

## Working with mixed fractions

A mixed fraction is made up of a whole part and a proper fraction (a fraction in which numerator <= denominator). Building `MixedFraction` objects can't be easier:

```dart
final mixed1 = MixedFraction(
  whole: 3, 
  numerator: 4, 
  denominator: 7
);
final mixed2 = MixedFraction.fromDouble(1.5);
final mixed3 = MixedFraction.fromString("1 1/2");
```

There is also the possibility to initialize a `MixedFraction` using extension methods, as it happens with `Fraction`:

```dart
final mixed = "1 1/2".toMixedFraction();
```

Note that `MixedFraction` objects are **immutable** exactly like `Fraction` objects so you're guaranteed that the internal state of the instance won't change during its lifetime. Make sure to check out the official documentation at [pub.dev](https://pub.dev/documentation/fraction/latest/fraction/MixedFraction-class.html) for a complete overview of the API.
