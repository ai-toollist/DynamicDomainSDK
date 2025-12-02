import 'package:flutter/services.dart';
import 'package:characters/characters.dart';

/// Custom TextInputFormatter that limits text by actual character count (grapheme clusters)
/// instead of code units. This correctly handles emojis, combining characters, etc.
///
/// Example:
/// - "Hello" = 5 characters
/// - "👨‍👩‍👧‍👦" (family emoji) = 1 character (not 11 code units)
/// - "🇻🇳" (Vietnam flag) = 1 character (not 4 code units)
class CharacterLengthLimitingFormatter extends TextInputFormatter {
  final int maxLength;

  CharacterLengthLimitingFormatter(this.maxLength);

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // Get the actual character count using grapheme clusters
    final newCharacters = newValue.text.characters;
    final newCharacterCount = newCharacters.length;

    // If within limit, allow the change
    if (newCharacterCount <= maxLength) {
      // Always return a new TextEditingValue to ensure Flutter processes the change
      return TextEditingValue(
        text: newValue.text,
        selection: newValue.selection,
        composing: newValue.composing,
      );
    }

    // Exceeded limit - truncate to maxLength characters
    final truncated = newCharacters.take(maxLength).toString();
    final truncatedLength = truncated.length; // code units length

    // Keep cursor at the end of truncated text
    return TextEditingValue(
      text: truncated,
      selection: TextSelection.collapsed(offset: truncatedLength),
      composing: TextRange.empty,
    );
  }
}
