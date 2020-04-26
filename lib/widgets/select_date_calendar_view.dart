import 'package:flutter/material.dart';

import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';

class SelectDateCalendarView extends StatefulWidget {
  DateTime _selectedDate;
  bool _userSelectedDate = false; // indicates whether user already chose a date
  VoidCallback onDateSelected;

  SelectDateCalendarView({this.onDateSelected});

  bool get userSelectedDate => _userSelectedDate;
  DateTime get selectedDate => _selectedDate;

  @override
  _SelectDateCalendarViewState createState() => _SelectDateCalendarViewState();
}

class _SelectDateCalendarViewState extends State<SelectDateCalendarView> {
  DateTime _targetDateTime = DateTime.now();
  CalendarCarousel _calendarCarouselNoHeader;

  @override
  Widget build(BuildContext context) {
    _calendarCarouselNoHeader = CalendarCarousel<Event>(
      daysHaveCircularBorder: true,
      thisMonthDayBorderColor: Colors.grey,
      selectedDateTime: widget._selectedDate,
      targetDateTime: _targetDateTime,
      minSelectedDate: DateTime(2000),
      onCalendarChanged: (DateTime date) {
        setState(() {
          _targetDateTime = date;
        });
      },
      onDayPressed: (DateTime date, List<Event> events) {
        setState(() => widget._selectedDate = date);
        widget._userSelectedDate = true;
        if (widget.onDateSelected != null) {
          widget.onDateSelected();
        }
      },
    );

    return Scaffold(
      body: _calendarCarouselNoHeader,
    );
  }
}
