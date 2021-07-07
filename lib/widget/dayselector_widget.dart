import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/date_symbols.dart';
import 'package:mypo/main.dart';
import 'package:weekday_selector/weekday_selector.dart';

// ignore: must_be_immutable
class daySelectorWidget extends StatefulWidget {
  late List<dynamic> values = [];

  daySelectorWidget({
    Key? key,
    required this.values,
  }) : super(key: key);
  @override
  _daySelectorWidgetState createState() => _daySelectorWidgetState();
}

class _daySelectorWidgetState extends State<daySelectorWidget> {
  final DateSymbols fr = dateTimeSymbolMap()['fr'];

  @override
  Widget build(BuildContext context) {
    var valuesToBool = List<bool>.from(widget.values);
    return WeekdaySelector(
      weekdays: fr.STANDALONEWEEKDAYS,
      // shortWeekdays: fr.STANDALONENARROWWEEKDAYS,
      shortWeekdays: fr.STANDALONESHORTWEEKDAYS,
      firstDayOfWeek: fr.FIRSTDAYOFWEEK + 1,
      selectedFillColor: d_green,
      fillColor: Colors.grey.shade100,
      onChanged: (v) {
        setState(() {
          valuesToBool[v % 7] = !valuesToBool[v % 7];
          widget.values = List<dynamic>.from(valuesToBool);
          //print(valuesToBool);
          //print(widget.values);
        });
      },
      values: valuesToBool,
    );
  }
}
