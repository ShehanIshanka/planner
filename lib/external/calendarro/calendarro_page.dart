import 'package:planner/external/calendarro/calendarro.dart';
import 'package:planner/external/calendarro/date_utils.dart';
import 'package:planner/external/calendarro/default_weekday_labels_row.dart';
import 'package:flutter/material.dart';

class CalendarroPage extends StatelessWidget {
  static final MAX_ROWS_COUNT = 6;

  DateTime pageStartDate;
  DateTime pageEndDate;
  Widget weekdayLabelsRow;
  List<String> months = [
    "January",
    "February",
    "March",
    "April",
    "May",
    "June",
    "July",
    "August",
    "September",
    "October",
    "November",
    "December"
  ];
  int startDayOffset;
  List<DateTime> disabledDates;

  CalendarroPage(
      {this.pageStartDate,
      this.pageEndDate,
      this.disabledDates,
      this.weekdayLabelsRow}) {
    startDayOffset = pageStartDate.weekday - DateTime.monday;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
            children: buildRows(context), mainAxisSize: MainAxisSize.min));
  }

  List<Widget> buildRows(BuildContext context) {
    List<Widget> rows = [];

    rows.add(Row(
      children: <Widget>[
        Text(
          '${pageStartDate.year} ${months[pageStartDate.month - 1]}',
          style: TextStyle(fontWeight: FontWeight.bold),
        )
      ],
      mainAxisAlignment: MainAxisAlignment.center,
    ));

    rows.add(Row(
      children: <Widget>[Text("")],
    ));

    rows.add(weekdayLabelsRow);

    DateTime rowLastDayDate =
        DateUtils.addDaysToDate(pageStartDate, 6 - startDayOffset);

    if (pageEndDate.isAfter(rowLastDayDate)) {
      rows.add(Row(
          children: buildCalendarRow(
              context, pageStartDate, rowLastDayDate, disabledDates)));

      for (var i = 1; i < MAX_ROWS_COUNT; i++) {
        DateTime nextRowFirstDayDate =
            DateUtils.addDaysToDate(pageStartDate, 7 * i - startDayOffset);

        if (nextRowFirstDayDate.isAfter(pageEndDate)) {
          break;
        }

        DateTime nextRowLastDayDate =
            DateUtils.addDaysToDate(pageStartDate, 7 * i - startDayOffset + 6);

        if (nextRowLastDayDate.isAfter(pageEndDate)) {
          nextRowLastDayDate = pageEndDate;
        }

        rows.add(Row(
            children: buildCalendarRow(context, nextRowFirstDayDate,
                nextRowLastDayDate, disabledDates)));
      }
    } else {
      rows.add(Row(
          children: buildCalendarRow(
              context, pageStartDate, pageEndDate, disabledDates)));
    }

    return rows;
  }

  List<Widget> buildCalendarRow(
    BuildContext context,
    DateTime rowStartDate,
    DateTime rowEndDate,
    List<DateTime> disabledDates,
  ) {
    List<Widget> items = [];

    DateTime currentDate = rowStartDate;
    for (int i = 0; i < 7; i++) {
      if (i + 1 >= rowStartDate.weekday && i + 1 <= rowEndDate.weekday) {
        CalendarroState calendarroState = Calendarro.of(context);
        Widget dayTile = calendarroState.widget.dayTileBuilder.build(
            context, currentDate, disabledDates, calendarroState.widget.onTap);
        items.add(dayTile);
        currentDate = currentDate.add(Duration(days: 1));
      } else {
        items.add(Expanded(
          child: Text(""),
        ));
      }
    }

    return items;
  }
}
