/// Contains functions that are used all over the project and are not specific
/// any part of the app.

DateTime convertTimeStampToDate(DateTime timeStamp) {
  int year = timeStamp.year;
  int month = timeStamp.month;
  int day = timeStamp.day;
  return DateTime(year, month, day);
}

double sum(List<double> numbers) {
  return numbers.reduce((value, element) => value + element);
}