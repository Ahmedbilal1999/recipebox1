class Helper {
  static DateTime DateUtcTOLocal(DateTime utcDate) {
    var date = DateTime.utc(utcDate.year, utcDate.month, utcDate.day,
        utcDate.hour, utcDate.minute, utcDate.second, utcDate.microsecond);

    var local = date.toLocal();
    return local;
  }
}
