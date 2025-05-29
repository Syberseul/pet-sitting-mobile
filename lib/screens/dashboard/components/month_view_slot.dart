import 'package:calendar_view/calendar_view.dart';
import 'package:colorful_print/colorful_print.dart';
import 'package:flutter/material.dart';
import 'package:flutter_projects/modules/tour.dart';
import 'package:flutter_projects/screens/dashboard/components/modify_tour_bottom_sheet.dart';
import 'package:flutter_projects/screens/dashboard/components/positioned_indicator.dart';
import 'package:flutter_projects/screens/dashboard/components/view_tour_list_bottom_sheet.dart';
import 'package:flutter_projects/utils/helpers.dart';

class MonthViewSlot extends StatefulWidget {
  MonthViewSlot({
    super.key,
    required this.date,
    required this.events,
    required this.isToday,
    required this.isInMonth,
    required this.hideDaysNotInMonth,
    required this.handleNewTourAdded,
  });

  final DateTime date;
  final List<CalendarEventData<Object?>> events;
  final bool isToday;
  final bool isInMonth;
  final bool hideDaysNotInMonth;
  VoidCallback handleNewTourAdded;

  @override
  State<MonthViewSlot> createState() => _MonthViewSlotState();
}

class _MonthViewSlotState extends State<MonthViewSlot> {
  bool _showOverlay = false;

  void onTapCell() {
    setState(() {
      _showOverlay = true;
    });

    final List<Tour> slotEvents =
        widget.events
            .map((calendarEvent) => calendarEvent.event as Tour)
            .toList();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder:
          (ctx) =>
              slotEvents.isEmpty
                  ? ModifyTourBottomSheet(
                    handleNewTourAdded: widget.handleNewTourAdded,
                    selectedDate: widget.date,
                  )
                  : ViewTourListBottomSheet(
                    dailyTours: slotEvents,
                    date: widget.date,
                    handleTourModified: widget.handleNewTourAdded,
                  ),
    );

    Future.delayed(Duration(milliseconds: 50), () {
      setState(() => _showOverlay = false);
    });
  }

  void onLongPresStart(LongPressStartDetails details) {
    setState(() {
      _showOverlay = true;
    });
  }

  void onLongPressEnd(LongPressEndDetails details) {
    setState(() {
      _showOverlay = false;
    });

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder:
          (ctx) => ModifyTourBottomSheet(
            handleNewTourAdded: widget.handleNewTourAdded,
            selectedDate: widget.date,
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final int startTourCount =
        widget.events.where((event) {
          final Tour tour = event.event as Tour;
          return isSameDate(tour.startDate, widget.date);
        }).length;

    final int endTourCount =
        widget.events.where((event) {
          final Tour tour = event.event as Tour;
          return isSameDate(tour.endDate, widget.date);
        }).length;

    return GestureDetector(
      onTap: onTapCell,
      onLongPressStart: onLongPresStart,
      onLongPressEnd: onLongPressEnd,
      child: Container(
        color:
            widget.events.isEmpty
                ? widget.isInMonth
                    ? Colors.white
                    : Colors.grey.shade200
                : widget.events.length > 8
                ? Colors.red.shade200
                : widget.events.length > 4
                ? Colors.orange.shade200
                : Colors.lightGreen.shade100,
        child: Stack(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(left: 5.0),
              child: Align(
                alignment: Alignment.topLeft,
                child: Text(
                  displayDateInCalendar(widget.date, widget.isInMonth),
                  style: TextStyle(
                    color: widget.isToday ? Colors.red : Colors.black,
                    fontWeight:
                        widget.isToday ? FontWeight.bold : FontWeight.normal,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
            Center(
              child: Text(
                widget.events.isNotEmpty ? "${widget.events.length}" : "",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent.shade200,
                ),
              ),
            ),
            PositionedIndicator(
              tourCount: startTourCount,
              backgroundColor: Colors.green.withValues(alpha: 0.7),
              left: 4,
            ),
            PositionedIndicator(
              tourCount: endTourCount,
              backgroundColor: Colors.red.withValues(alpha: 0.7),
              right: 4,
            ),
            if (_showOverlay)
              Positioned.fill(
                child: Container(color: Colors.black.withValues(alpha: 0.15)),
              ),
          ],
        ),
      ),
    );
  }
}
