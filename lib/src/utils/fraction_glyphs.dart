/// Replaces any fractions of the form n/m  in the given string with unicode
/// vulgar fraction glyphs.
///
/// For example, '1/2' would be converted to '½'.
String encodeFractionGlyphs(String value) {
  final fractionValues = _valuesToGlyphs.keys.join('|');

  return value.replaceAllMapped(
    RegExp('([0-9]?)($fractionValues)(?![0-9])'),
    (match) {
      final hasPrecedingNumber = match[1]!.isNotEmpty;

      if (hasPrecedingNumber) {
        return match[0]!; // Original string
      } else {
        final matchedFractionValue = match[2]!;
        return _valuesToGlyphs[matchedFractionValue]!;
      }
    },
  );
}

/// Replaces any unicode vulgar fraction glyphs in the given string with
/// fractions of the form n/m.
///
/// For example, '½' would be converted to '1/2'.
///
/// If a number character immediately precedes a fraction glyph (e.g. '2¼") then
/// resulting value will be separated with a space ('2 1/4' rather than '21/4').
String decodeFractionGlyphs(String value) {
  final String glyphCharacters = _glyphsToValues.keys.join('|');

  return value.replaceAllMapped(
    RegExp('([0-9]?)($glyphCharacters)'),
    (match) {
      final replacement = _glyphsToValues[match[2]]!;
      return match[1]!.isEmpty ? replacement : '${match[1]} $replacement';
    },
  );
}

/// Maps vulgar fraction glyphs to fraction values for the form n/m.
const _glyphsToValues = {
  '½': '1/2',
  '⅓': '1/3',
  '⅔': '2/3',
  '¼': '1/4',
  '¾': '3/4',
  '⅕': '1/5',
  '⅖': '2/5',
  '⅗': '3/5',
  '⅘': '4/5',
  '⅙': '1/6',
  '⅚': '5/6',
  '⅐': '1/7',
  '⅛': '1/8',
  '⅜': '3/8',
  '⅝': '5/8',
  '⅞': '7/8',
  '⅑': '1/9',
  '⅒': '1/10',
};

/// Maps fraction values of the form n/m to vulgar fraction glyphs.
const _valuesToGlyphs = {
  '1/2': '½',
  '1/3': '⅓',
  '2/3': '⅔',
  '1/4': '¼',
  '3/4': '¾',
  '1/5': '⅕',
  '2/5': '⅖',
  '3/5': '⅗',
  '4/5': '⅘',
  '1/6': '⅙',
  '5/6': '⅚',
  '1/7': '⅐',
  '1/8': '⅛',
  '3/8': '⅜',
  '5/8': '⅝',
  '7/8': '⅞',
  '1/9': '⅑',
  '1/10': '⅒',
};
