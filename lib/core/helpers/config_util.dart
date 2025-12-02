class ConfigUtil {
  static Map<String, dynamic> mergeWithDefault({
    required Map<String, dynamic> source,
    required Map<String, dynamic> defaultValues,
  }) {
    return {
      for (final entry in defaultValues.entries)
        entry.key: source[entry.key] ?? entry.value,
    };
  }

  static Map<String, dynamic>? castMapOrNull(dynamic cached) {
    if (cached is Map) {
      return Map<String, dynamic>.from(cached);
    }
    return null;
  }
}
