import 'dart:convert';
import 'dart:io';

import 'package:fraction_example/fraction_example.dart';

/// The application's main entrypoint.
void main() {
  stdout.encoding = utf8;

  // Welcome message
  stdout
    ..writeln('What do you want to analyze?\n')
    ..writeln(' 1) Fractions')
    ..writeln(' 2) Mixed fractions\n')
    ..write('Enter your choice (1 or 2): ');

  final input = stdin.readLineSync() ?? '';

  if (input == '1') {
    // Fraction analysis
    stdout.write('Enter the fraction: ');

    final fraction = stdin.readLineSync() ?? '';
    final analyzer = FractionAnalyzer(input: fraction);

    stdout.writeln(analyzer.analyze());
  } else if (input == '2') {
    // Mixed fraction analysis
    stdout.write('Enter the mixed fraction: ');

    final fraction = stdin.readLineSync() ?? '';
    final analyzer = MixedFractionAnalyzer(input: fraction);

    stdout.writeln(analyzer.analyze());
  } else {
    // Error
    stdout.writeln("\n - You've entered a wrong input!\n");
  }

  // To keep the console 'awake'. This is very useful on Windows!
  stdout.write('Press any key to exit...');

  // ignore: avoid-ignoring-return-values
  stdin.readLineSync();
}
