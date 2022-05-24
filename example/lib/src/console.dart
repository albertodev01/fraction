import 'dart:convert';
import 'dart:io';

import 'package:fraction_example/src/analyzer/fraction_analyzer.dart';
import 'package:fraction_example/src/analyzer/mixed_fraction_analyzer.dart';

/// This class uses standard I/O to process user inputs and prints results to
/// the console.
class Console {
  /// Creates a new [Console] instance.
  const Console();

  /// Reads the input and analyzes a fraction or a mixed fraction.
  void run() {
    stdout.encoding = utf8;

    // Welcome message
    stdout
      ..writeln('What do you want to analyze?\n')
      ..writeln(' 1) Fractions')
      ..writeln(' 2) Mixed fractions\n')
      ..write('Enter your choice (1 or 2): ');

    final input = stdin.readLineSync() ?? '';

    if (input == '1') {
      stdout.write('Enter the fraction: ');

      final fraction = stdin.readLineSync() ?? '';
      final analyzer = FractionAnalyzer(input: fraction);

      stdout.writeln(analyzer.analyze());
    } else if (input == '2') {
      stdout.write('Enter the mixed fraction: ');

      final fraction = stdin.readLineSync() ?? '';
      final analyzer = MixedFractionAnalyzer(input: fraction);

      stdout.writeln(analyzer.analyze());
    } else {
      stdout.writeln("\n - You've entered a wrong input!\n");
    }

    // To keep the console 'awake'. This is very useful on Windows!
    stdout.write('Press return to exit...');
    // ignore: avoid-ignoring-return-values
    stdin.readLineSync();
  }
}
