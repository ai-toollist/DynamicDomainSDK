import 'dart:convert';

class Utils {
  static List<T> toList<T>(String value, T f(Map<String, dynamic> map)) {
    // Handle empty or invalid JSON strings
    if (value.isEmpty || value == '""' || value == "''") {
      return <T>[];
    }

    try {
      final decoded = formatJson(value);
      // Check if decoded value is actually a List
      if (decoded is List) {
        return decoded.map((e) => f(e)).toList();
      }
      // If not a List, return empty list
      return <T>[];
    } catch (e) {
      // If JSON decode fails, return empty list
      return <T>[];
    }
  }

  static T toObj<T>(String value, T f(Map<String, dynamic> map)) =>
      f(formatJson(value));

  static List<dynamic> toListMap(String value) {
    // Handle empty or invalid JSON strings
    if (value.isEmpty || value == '""' || value == "''") {
      return [];
    }

    try {
      final decoded = formatJson(value);
      return decoded is List ? decoded : [];
    } catch (e) {
      return [];
    }
  }

  static dynamic formatJson(String value) => jsonDecode(value);

  static String checkOperationID(String? obj) =>
      obj ?? DateTime.now().millisecondsSinceEpoch.toString();

  static Map<String, dynamic> cleanMap(Map<String, dynamic> map) {
    map.removeWhere((key, value) {
      if (value is Map<String, dynamic>) {
        cleanMap(value);
      }
      return value == null;
    });
    return map;
  }
}
