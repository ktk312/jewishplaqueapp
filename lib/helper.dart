import 'package:kosher_dart/kosher_dart.dart';

DateTime getNextYearGregorianDate(String timestamp) {
  // Parse input timestamp
  final inputDate = DateTime.parse(timestamp);
  final selectedJewishDate = JewishDate.fromDateTime(inputDate);

  // Extract year, month, day
  int selectedYear = selectedJewishDate.getJewishYear();
  int selectedMonth = selectedJewishDate.getJewishMonth();
  int selectedDay = selectedJewishDate.getJewishDayOfMonth();

  // Determine if the selected year is a leap year
  final isSelectedYearLeap = selectedJewishDate.isJewishLeapYear();

  // Target year = next Jewish year
  int nextJewishYear = selectedYear + 1;

  // Check leap-year condition for next year
  final nextYearCheck = JewishDate.initDate(
    jewishYear: nextJewishYear,
    jewishMonth: 1,
    jewishDayOfMonth: 1,
  );
  final isNextYearLeap = nextYearCheck.isJewishLeapYear();

  // Determine correct month handling between leap/non-leap years
  int targetMonth = selectedMonth;

  // Case 1: Selected year leap (Adar II, 13) → Next year non-leap → Adar (12)
  if (isSelectedYearLeap && selectedMonth == 13 && !isNextYearLeap) {
    targetMonth = 12;
  }
  // Case 2: Selected year non-leap (Adar 12) → Next year leap → Adar II (13)
  else if (!isSelectedYearLeap && selectedMonth == 12 && isNextYearLeap) {
    targetMonth = 13;
  }

  // Build next year's Jewish date
  final nextYearJewishDate = JewishDate.initDate(
    jewishYear: nextJewishYear,
    jewishMonth: targetMonth,
    jewishDayOfMonth: selectedDay,
  );

  // Convert to Gregorian DateTime
  final gregorian = nextYearJewishDate.getGregorianCalendar();
  return DateTime(gregorian.year, gregorian.month, gregorian.day);
}
