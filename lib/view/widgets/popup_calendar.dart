import 'package:flutter/material.dart';
import 'package:planner/external/calendarro/calendarro.dart';

class PopUpBoxCalender {
  Future<List> popUpCalender(BuildContext context, List<DateTime> dateRange,
      List<DateTime> selectedDates) async {
    List<DateTime> selectingDates = [...selectedDates];
    List<DateTime> output = [];
    return showDialog<List>(
      context: context,
      barrierDismissible: false, // user must tap button for close dialog!
      builder: (BuildContext context) {
        return AlertDialog(
            actions: <Widget>[
              FlatButton(
                child: const Text('CANCEL'),
                onPressed: () {
                  Navigator.pop(context, ["CANCEL", output]);
                },
              ),
              FlatButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.pop(context, ["OK", selectingDates]);
                },
              )
            ],
            content: Container(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Expanded(
                    child: Calendarro(
                        displayMode: DisplayMode.MONTHS,
                        selectionMode: SelectionMode.MULTI,
                        onTap: (date) {},
                        startDate: dateRange[0],
                        endDate: dateRange[1],
                        selectedDates: selectingDates),
                    flex: 1,
                  ),
                ],
              ),
            ));
      },
    );
  }
}
