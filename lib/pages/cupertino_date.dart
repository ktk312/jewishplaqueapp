import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kosher_dart/kosher_dart.dart';

class CupertinoHebrewDatePicker extends StatefulWidget {
  final BuildContext context;
  final ValueChanged<DateTime> onDateChanged;
  final ValueChanged<DateTime> onConfirm;

  final DateTime initialDate;
  final String confirmText;
  final TextStyle confirmTextStyle;
  final TextStyle todaysDateTextStyle;

  CupertinoHebrewDatePicker({
    super.key,
    required this.context,
    required this.onDateChanged,
    required this.onConfirm,
    DateTime? initialDate,
    String? confirmText,
    TextStyle? confirmTextStyle,
    TextStyle? todaysDateTextStyle,
  })  : initialDate = initialDate ?? DateTime.now(),
        confirmText = confirmText ?? "Confirm",
        confirmTextStyle = confirmTextStyle ??
            const TextStyle(
              color: CupertinoColors.destructiveRed,
              fontWeight: FontWeight.w600,
            ),
        todaysDateTextStyle = todaysDateTextStyle ??
            const TextStyle(
              color: CupertinoColors.activeBlue,
              fontWeight: FontWeight.w600,
            );

  @override
  State<CupertinoHebrewDatePicker> createState() =>
      _CupertinoHebrewDatePickerState();
}

class _CupertinoHebrewDatePickerState extends State<CupertinoHebrewDatePicker> {
  final _hebrewDateFormatter = HebrewDateFormatter();
  late var jewishDate = JewishDate.fromDateTime(widget.initialDate);

  late final _dayScrollController = FixedExtentScrollController(
      initialItem: jewishDate.getJewishDayOfMonth() - 1);
  late final _monthScrollController =
      FixedExtentScrollController(initialItem: jewishDate.getJewishMonth() - 1);
  late final _yearScrollController = FixedExtentScrollController(
      initialItem:
          int.parse(jewishDate.getJewishYear().toString().substring(2, 4)));

  late var todaysDay = JewishDate().getJewishDayOfMonth();
  late var todaysMonth = JewishDate().getJewishMonth();
  late var todaysYear = JewishDate().getJewishYear();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _scroll());
  }

  var selectedDayIndex = 0;
  var selectedMonthIndex = 0;
  var selectedYearIndex = 0;
  final _days = [
    "א",
    "ב",
    "ג",
    "ד",
    "ה",
    "ו",
    "ז",
    "ח",
    "ט",
    "י",
    "יא",
    "יב",
    "יג",
    "יד",
    "טו",
    "טז",
    "יז",
    "יח",
    "יט",
    "כ",
    "כא",
    "כב",
    "כג",
    "כד",
    "כה",
    "כו",
    "כז",
    "כח",
    "כט",
    "ל"
  ];
  final _months = [
    "ניסן",
    "אייר",
    "סיוון",
    "תמוז",
    "אב",
    "אלול",
    "תשרי",
    "חשוון",
    "כסלו",
    "טבת",
    "שבט",
    "אדר א",
    "אדר ב",
  ];
  final _years = [for (var i = 5600; i < 7000; i++) i];

  _handleOnChange() {
    print(selectedDayIndex);
    print(selectedMonthIndex);
    print(selectedYearIndex);

    var day = selectedDayIndex == 0
        ? jewishDate.getJewishDayOfMonth()
        : selectedDayIndex + 1;
    var month = selectedMonthIndex == 0
        ? jewishDate.getJewishMonth()
        : selectedMonthIndex + 1;
    var year = selectedYearIndex == 0
        ? jewishDate.getJewishYear()
        : _years[selectedYearIndex];

    print('day: $day month: $month year: $year');

    try {
      print('try part');
      jewishDate = JewishDate.initDate(
          jewishYear: year, jewishMonth: month, jewishDayOfMonth: day);
    } catch (e) {
      // Leap year
      print('catch part');
      jewishDate = JewishDate.initDate(
          jewishYear: year, jewishMonth: 12, jewishDayOfMonth: day);
    }

    print(jewishDate.getGregorianCalendar());
    print(jewishDate.getJewishYear());
    print(jewishDate.getJewishMonth());

    widget.onDateChanged(jewishDate.getGregorianCalendar());
  }

  _handleOnConfirm() {
    print(jewishDate.getGregorianCalendar());
    print(jewishDate.getJewishYear());
    print(jewishDate.getJewishMonth());
    print(jewishDate.getJewishDayOfMonth());
    widget.onConfirm(jewishDate.getGregorianCalendar());
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return _buildLayout();
  }

  final textStyle = const TextStyle(
    fontSize: 16,
  );

  Widget _buildDayPicker() {
    return Expanded(
      child: ScrollConfiguration(
        behavior: ScrollConfiguration.of(context).copyWith(dragDevices: {
          PointerDeviceKind.touch,
          PointerDeviceKind.mouse,
        }),
        child: CupertinoPicker(
          scrollController: _dayScrollController,
          itemExtent: 30,
          onSelectedItemChanged: (index) {
            setState(() {
              selectedDayIndex = index;
              _handleOnChange();
            });
          },
          children: _days.map((day) {
            return Center(
                child: Text(
              day,
              style: textStyle,
            ));
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildMonthPicker() {
    return Expanded(
      child: ScrollConfiguration(
        behavior: ScrollConfiguration.of(context).copyWith(dragDevices: {
          PointerDeviceKind.touch,
          PointerDeviceKind.mouse,
        }),
        child: CupertinoPicker(
          scrollController: _monthScrollController,
          itemExtent: 30,
          onSelectedItemChanged: (index) {
            setState(() {
              selectedMonthIndex = index;
              _handleOnChange();
            });
          },
          children: _months.map((month) {
            return Center(
                child: Text(
              month,
              style: textStyle,
            ));
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildYearPicker() {
    return Expanded(
      child: ScrollConfiguration(
        behavior: ScrollConfiguration.of(context).copyWith(dragDevices: {
          PointerDeviceKind.touch,
          PointerDeviceKind.mouse,
        }),
        child: CupertinoPicker(
          scrollController: _yearScrollController,
          itemExtent: 30,
          onSelectedItemChanged: (index) {
            setState(() {
              selectedYearIndex = index;
              _handleOnChange();
            });
          },
          children: _years.map((year) {
            return Center(
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _hebrewDateFormatter.formatHebrewNumber(year),
                    style: textStyle,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    year.toString(),
                    style: textStyle,
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  _buildLayout() {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: Column(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: CupertinoButton(
              onPressed: _handleOnConfirm,
              child: Text(
                widget.confirmText,
                style: widget.confirmTextStyle,
              ),
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: CupertinoButton(
              child: Text(
                "Todays date",
                style: widget.todaysDateTextStyle,
              ),
              onPressed: () {
                _scroll();
              },
            ),
          ),
          SizedBox(
            height: 320,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                _buildYearPicker(),
                _buildMonthPicker(),
                _buildDayPicker(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _scroll() {
    _yearScrollController.animateToItem(_years.indexOf(todaysYear),
        duration: const Duration(milliseconds: 200), curve: Curves.ease);
    _dayScrollController.animateToItem(todaysDay - 1,
        duration: const Duration(milliseconds: 200), curve: Curves.ease);
    _monthScrollController.animateToItem(todaysMonth - 1,
        duration: const Duration(milliseconds: 200), curve: Curves.ease);
  }

  @override
  void dispose() {
    _dayScrollController.dispose();
    _monthScrollController.dispose();
    _yearScrollController.dispose();

    super.dispose();
  }
}

void showHebrewCupertinoDatePicker({
  required BuildContext context,
  required ValueChanged<DateTime> onDateChanged,
  required ValueChanged<DateTime> onConfirm,
  DateTime? initialDate,
  String? confirmText,
  TextStyle? confirmTextStyle,
  TextStyle? todaysDateTextStyle,
}) {
  showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        child: SizedBox(
          height: MediaQuery.of(context).size.height / 1.6,
          child: CupertinoHebrewDatePicker(
            initialDate: initialDate,
            context: context,
            onConfirm: onConfirm,
            onDateChanged: onDateChanged,
            confirmText: confirmText,
            confirmTextStyle: confirmTextStyle,
            todaysDateTextStyle: todaysDateTextStyle,
          ),
        ),
      );
    },
  );
}
