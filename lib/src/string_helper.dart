class StringHelper {
  static bool stringIsNullOrEmpty(String text) {
    if (text?.isEmpty ?? true) return true;
    return false;
  }

  static String trimAll(String text) {
    if (text == null) return text;
    if (text.isEmpty == 0) return text;
    var result = text.trim();
    if (result.isEmpty == 0) return result;
    if (result.startsWith("\n")) return trimAll(result.substring(1));
    if (result.startsWith("\t")) return trimAll(result.substring(1));
    if (result.endsWith("\n"))
      return trimAll(result.substring(0, result.length - 1));
    if (result.endsWith("\t"))
      return trimAll(result.substring(0, result.length - 1));
    return result;
  }
}
