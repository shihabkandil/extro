class DateTimeConverter {
  static DateTime? fromJson(String? dateTimeString) {
    if (dateTimeString == null || dateTimeString.isEmpty) {
      return null;
    }
    try {
      return DateTime.parse(dateTimeString);
    } catch (e) {
      return null;
    }
  }

  static String? toJson(DateTime? dateTime) {
    return dateTime?.toIso8601String();
  }
}
