import 'dart:convert';
import 'dart:io';

import 'package:test/test.dart';

void main() {
  Future<Process> createProcess() {
    return Process.start(
      'dart',
      ['run', './bin/fraction_example.dart'],
    );
  }

  group("Testing the 'Console' class", () {
    test('Making sure that the console prints the welcome message', () async {
      final process = await createProcess();

      // Converting into a stream
      final stream = process.stdout.transform(Utf8Decoder());

      // Expected output
      final expectedOutput = StringBuffer()
        ..writeln('What do you want to analyze?\n')
        ..writeln(' 1) Fractions')
        ..writeln(' 2) Mixed fractions\n')
        ..write('Enter your choice (1 or 2): ');

      expectLater(
        stream,
        emitsInOrder([
          expectedOutput.toString(),
        ]),
      );
    });
  });
}
