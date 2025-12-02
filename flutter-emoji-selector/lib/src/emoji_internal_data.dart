/// Unicode to String
String unicodeToString(String unified) {
  // Handle both space-separated and dash-separated unicode codes
  String separator = unified.contains(' ') ? ' ' : '-';
  return String.fromCharCodes(
    unified.split(separator).map(
      (e) {
        return int.parse(e, radix: 16);
      },
    ),
  );
}

class EmojiInternalData {
  String? id;
  String? name;
  String? unified;
  String? nonQualified;
  String? category;
  String? shortName;
  int? sortOrder;
  bool? hasApple;
  bool? hasGoogle;

  String get char => unicodeToString(unified!);

  EmojiInternalData.fromJson(Map<String, dynamic> jsonData) {
    // Handle new JSON format
    if (jsonData.containsKey('codes')) {
      // New format
      unified = jsonData['codes'].toString();
      id = unified;
      name = jsonData['name'];
      category = jsonData['group']; // Use group for category filtering
      shortName = _generateShortName(jsonData['name']);
      sortOrder = 0; // Default sort order since new format doesn't have it
      hasApple = true; // Assume all emojis have Apple support in new format
      hasGoogle = true; // Assume all emojis have Google support in new format
    } else {
      // Old format (fallback)
      id = jsonData['unified'];
      name = jsonData['name'];
      unified = jsonData['unified'];
      nonQualified = jsonData['non_qualified'];
      category = jsonData['category'];
      shortName = jsonData['short_name'];
      sortOrder = jsonData['sort_order'];
      hasApple = jsonData['has_img_apple'];
      hasGoogle = jsonData['has_img_google'];
    }
  }

  String _generateShortName(String name) {
    // Generate a short name from the full name by removing spaces and special characters
    return name
        .toLowerCase()
        .replaceAll(RegExp(r'[^a-z0-9]'), '_')
        .replaceAll(RegExp(r'_+'), '_')
        .replaceAll(RegExp(r'^_|_$'), '');
  }
}
