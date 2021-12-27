import 'dart:convert';
import 'dart:io';

import 'package:fraction_example/src/analyzer/fraction_analyzer.dart';
import 'package:fraction_example/src/analyzer/mixed_fraction_analyzer.dart';

/// This class uses standard I/O to process user inputs and print results to
/// the console.
class Console {
  /// Creates a new [Console] instance.
  const Console();

  /// Initializes the [Console] app and always waits for an input.
  ///
  /// Exits when the user enters 'quit'.
  void run() {
    stdout.encoding = utf8;

    // Welcome message
    stdout
      ..writeln('What do you want to analyze?\n')
      ..writeln(' 1) Fractions')
      ..writeln(' 2) Mixed fractions\n')
      ..write('Enter your choice (1 or 2): ');

    // The choice between fraction and mixed fraction
    final input = stdin.readLineSync() ?? '';

    if (input == '1') {
      stdout.write('Enter the fraction: ');

      final fraction = stdin.readLineSync() ?? '';
      final analyzer = FractionAnalyzer(input: fraction);

      print(analyzer.analyze());
    } else if (input == '2') {
      stdout.write('Enter the mixed fraction: ');

      final fraction = stdin.readLineSync() ?? '';
      final analyzer = MixedFractionAnalyzer(input: fraction);

      print(analyzer.analyze());
    } else {
      stdout.writeln("\n - You've entered a wrong input!\n");
    }

    // To keep the console 'awake'. This is very useful on Windows
    stdout.write('Press return to exit...');
    stdin.readLineSync();
  }
}
