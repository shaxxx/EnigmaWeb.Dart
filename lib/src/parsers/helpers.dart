class Helpers {
  /// Remove illegal XML characters from a string.
  static String sanitizeXmlString(String xml) {
    if (xml == null) {
      throw ArgumentError.notNull('xml');
    }

    var buffer = StringBuffer();
    for (var c in xml.split('')) {
      if (isLegalXmlChar(c.codeUnitAt(0))) {
        buffer.writeCharCode(c.codeUnitAt(0));
      }
    }
    return buffer.toString();
  }

  /// Whether a given character is allowed by XML 1.0.
  static bool isLegalXmlChar(int asciiCode) {
    // == '\t' == 9
    // == '\n' == 10
    // == '\r' == 13
    return (asciiCode == 9 ||
        asciiCode == 10 ||
        asciiCode == 13 ||
        (asciiCode >= 32 && asciiCode <= 55295) ||
        (asciiCode >= 57344 && asciiCode <= 65533) ||
        (asciiCode >= 65536 && asciiCode <= 1114111));
  }
}
