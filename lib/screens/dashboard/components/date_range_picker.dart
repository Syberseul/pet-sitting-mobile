import 'package:colorful_print/colorful_print.dart';
import 'package:flutter/material.dart';
import 'package:flutter_projects/language/localization_service.dart';
import 'package:flutter_projects/language/trans_enum.dart';
import "package:flutter_projects/utils/helpers.dart";

class DateRangePicker extends StatefulWidget {
  DateRangePicker({
    super.key,
    required this.onDatePick,
    this.startDateTime,
    this.endDateTime,
    this.displayTimeText,
  });

  final ValueChanged<Map<String, dynamic>?>? onDatePick;
  late DateTime? startDateTime;
  late DateTime? endDateTime;
  final String? displayTimeText;

  @override
  State<DateRangePicker> createState() => _DateRangePickerState();
}

class _DateRangePickerState extends State<DateRangePicker> {
  DateTimeRange? selectedRange;

  @override
  void initState() {
    super.initState();
    syncDateRange();
  }

  void syncDateRange() {
    if (widget.startDateTime == null || widget.endDateTime == null) return;

    selectedRange = DateTimeRange(
      start: widget.startDateTime!,
      end: widget.endDateTime!,
    );
  }

  Future<void> _selectDateRange(BuildContext context) async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      initialDateRange:
          selectedRange ??
          DateTimeRange(
            start: DateTime.now(),
            end: DateTime.now().add(Duration(days: 7)),
          ),
    );

    if (picked != null) {
      setState(() {
        selectedRange = picked;
      });

      widget.onDatePick!(parseDateTimeRange(context, selectedRange!));
    }
  }

  Widget showSelectedDateRange() {
    if (selectedRange == null) {
      return Text("");
    }

    final Map<String, dynamic> dateRangeMap = parseDateTimeRange(
      context,
      selectedRange!,
    );

    return Text(
      style: TextStyle(fontSize: 16.0),
      widget.displayTimeText ?? "${dateRangeMap["start"]} - ${dateRangeMap["end"]} (${dateRangeMap["days"]} ${AppLocalizations.getText(context, TranslateEnum.days)})",
    );
  }

  @override
  Widget build(BuildContext context) {
    return selectedRange == null
        ? ElevatedButton(
          onPressed: () => _selectDateRange(context),
          child: Text(
            AppLocalizations.getText(context, TranslateEnum.selectDateRange),
          ),
        )
        : Row(
      spacing: 10.0,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            showSelectedDateRange(),
            GestureDetector(
              onTap: () => _selectDateRange(context),
              child: Icon(
                Icons.edit,
                size: 24.0,
                color: Colors.lightBlueAccent,
              ),
            ),
          ],
        );
  }
}
