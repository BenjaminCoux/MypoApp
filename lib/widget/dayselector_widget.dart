import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/date_symbols.dart';
import 'package:mypo/main.dart';
import 'package:weekday_selector/weekday_selector.dart';

class daySelectorWidget extends StatefulWidget {
  @override
  _daySelectorWidgetState createState() => _daySelectorWidgetState();
}

class _daySelectorWidgetState extends State<daySelectorWidget> {
  final DateSymbols fr = dateTimeSymbolMap()['fr'];
  final values = List.filled(7, false);

  @override
  Widget build(BuildContext context) {
    return WeekdaySelector(
      weekdays: fr.STANDALONEWEEKDAYS,
      // shortWeekdays: fr.STANDALONENARROWWEEKDAYS,
      shortWeekdays: fr.STANDALONESHORTWEEKDAYS,
      firstDayOfWeek: fr.FIRSTDAYOFWEEK + 1,
      selectedFillColor: d_green,
      fillColor: Colors.grey.shade100,
      onChanged: (v) {
        setState(() {
          values[v % 7] = !values[v % 7];
        });
      },
      values: values,
    );
  }
}
