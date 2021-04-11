import 'package:fraction/src/utils/fraction_glyphs.dart';
import 'package:test/test.dart';

void main() {
  group('Encoding glyphs', () {
    test(
      'Replaces fractions in strings with no other text',
      () => expect(encodeFractionGlyphs('1/2'), '½'),
    );

    test(
      'Replaces fractions in strings with other text',
      () => expect(encodeFractionGlyphs('some 1/4 text'), 'some ¼ text'),
    );

    test(
      'Does not replace fractions with preceding numbers',
      () => expect(encodeFractionGlyphs('21/2'), '21/2'),
    );
  });

  group('Decoding glyphs', () {
    test(
      'Replaces fraction glyphs in strings with no other text',
      () => expect(decodeFractionGlyphs('½'), '1/2'),
    );

    test(
      'Replaces fraction glyphs in strings with other text',
      () => expect(decodeFractionGlyphs('some ¼ text'), 'some 1/4 text'),
    );

    test(
      'Correctly replaces fraction glyphs in mixed fractions',
      () => expect(decodeFractionGlyphs('2½'), '2 1/2'),
    );
  });
}
