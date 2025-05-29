import 'package:calendar_view/calendar_view.dart';
import 'package:colorful_print/colorful_print.dart';
import 'package:flutter/material.dart';
import 'package:flutter_projects/api/api_delete.dart';
import 'package:flutter_projects/language/localization_service.dart';
import 'package:flutter_projects/language/trans_enum.dart';
import 'package:flutter_projects/modules/tour.dart';
import 'package:flutter_projects/screens/dashboard/components/modify_tour_bottom_sheet.dart';
import 'package:flutter_projects/utils/helpers.dart';

class ViewTourListBottomSheet extends StatefulWidget {
  const ViewTourListBottomSheet({
    super.key,
    required this.dailyTours,
    required this.date,
    required this.handleTourModified,
  });

  final List<Tour> dailyTours;
  final DateTime date;
  final VoidCallback handleTourModified;

  @override
  State<ViewTourListBottomSheet> createState() =>
      _ViewTourListBottomSheetState();
}

class _ViewTourListBottomSheetState extends State<ViewTourListBottomSheet> {
  late List<Tour> displayDailyTours;

  bool reloadingTours = false;

  @override
  void initState() {
    super.initState();
    displayDailyTours = widget.dailyTours;

    if (displayDailyTours.isEmpty) {
      Navigator.pop(context);
    }
  }

  String getSelectedDate() {
    final year = widget.date.year;
    final month = widget.date.month.toString().padLeft(2, "0");
    final day = widget.date.day.toString().padLeft(2, "0");

    return "$day/$month/$year";
  }

  void handleEditTour(Tour tourInfo) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder:
          (ctx) => ModifyTourBottomSheet(
            handleUpdateTour: (Tour newTourInfo) {
              handleUpdateTour(newTourInfo);
            },
            tourInfo: tourInfo,
          ),
    );
  }

  void handleRemoveTour(String tourId) {
    showDialog(
      context: context,
      builder: (context) {
        bool dialogIsModifying = false;

        return StatefulBuilder(
          builder: (context, dialogSetState) {
            return AlertDialog(
              title: Text(
                AppLocalizations.getText(
                  context,
                  TranslateEnum.deleteTourTitle,
                ),
              ),
              content: Text(
                "${AppLocalizations.getText(context, TranslateEnum.areYouSure)}?",
              ),
              actions: [
                TextButton(
                  onPressed:
                      dialogIsModifying ? null : () => Navigator.pop(context),
                  style: TextButton.styleFrom(backgroundColor: Colors.grey),
                  child: Text(
                    AppLocalizations.getText(context, TranslateEnum.cancel),
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                TextButton(
                  onPressed:
                      dialogIsModifying
                          ? null
                          : () async {
                            dialogSetState(() => dialogIsModifying = true);
                            await removeTour(tourId);
                            dialogSetState(() => dialogIsModifying = false);
                          },
                  style: TextButton.styleFrom(
                    backgroundColor:
                        dialogIsModifying ? Colors.grey : Colors.redAccent[100],
                  ),
                  child: Text(
                    dialogIsModifying
                        ? "${AppLocalizations.getText(context, TranslateEnum.removing)}..."
                        : AppLocalizations.getText(
                          context,
                          TranslateEnum.remove,
                        ),
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void handleUpdateTour(Tour tourInfo) {
    final selectedDate = DateTime(
      widget.date.year,
      widget.date.month,
      widget.date.day,
    );
    final startDate = DateTime(
      tourInfo.startDate.year,
      tourInfo.startDate.month,
      tourInfo.startDate.day,
    );
    final endDate = DateTime(
      tourInfo.endDate.year,
      tourInfo.endDate.month,
      tourInfo.endDate.day,
    );

    final isTourStillOnSelectedDate =
        !selectedDate.isBefore(startDate) && !selectedDate.isAfter(endDate);

    setState(() {
      displayDailyTours =
          isTourStillOnSelectedDate
              ? displayDailyTours
                  .map((tour) => tour.id == tourInfo.id ? tourInfo : tour)
                  .toList()
              : displayDailyTours
                  .where((tour) => tour.id != tourInfo.id)
                  .toList();
    });

    widget.handleTourModified();

    if (displayDailyTours.isEmpty && mounted) {
      Navigator.pop(context);
    }
  }

  Future<void> removeTour(String tourId) async {
    try {
      final response = await ApiDelete.removeTour(tourId);
      if (response["data"]?["uid"] == tourId) {
        widget.handleTourModified();
        setState(() {
          displayDailyTours =
              displayDailyTours.where((t) => t.id != tourId).toList();
        });
        if (displayDailyTours.isEmpty) {
          Navigator.of(context, rootNavigator: true).pop();
          Navigator.pop(context);
        } else {
          if (mounted) Navigator.pop(context);
        }
      }
    } catch (err) {
      debugPrint("Error on remove tour: $err");
    }
  }

  List<Widget> displayTours(List<Tour> tours) {
    if (tours.isEmpty) return [];
    return [
      Padding(
        padding: EdgeInsets.all(16.0),
        child:
            reloadingTours
                ? CircularProgressIndicator()
                : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 5.0,
                  children: [
                    Text(
                      "${AppLocalizations.getText(context, TranslateEnum.onSiteTours)} (${getSelectedDate()}):",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 24.0,
                      ),
                    ),
                    ...tours.asMap().entries.map((entry) {
                      final tour = entry.value;
                      final isNewTour = isSameDate(tour.startDate, widget.date);
                      final isLastDayTour = isSameDate(
                        tour.endDate,
                        widget.date,
                      );
                      final isSameDayTour = isNewTour && isLastDayTour;

                      return Padding(
                        padding: EdgeInsets.symmetric(vertical: 4),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Row(
                              spacing: 5.0,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                if (isSameDayTour)
                                  Icon(
                                    Icons.wifi_protected_setup,
                                    size: 24.0,
                                    color: Colors.orange.withValues(alpha: 0.7),
                                  )
                                else if (isNewTour)
                                  Icon(
                                    Icons.flight_takeoff,
                                    size: 24.0,
                                    color: Colors.green.withValues(alpha: 0.7),
                                  )
                                else if (isLastDayTour)
                                  Icon(
                                    Icons.flight_land,
                                    size: 24.0,
                                    color: Colors.red.withValues(alpha: 0.7),
                                  ),

                                Text(
                                  tour.dogName,
                                  style: TextStyle(fontSize: 24.0),
                                ),

                                if (tour.sex == 1 || tour.sex == 2)
                                  Icon(
                                    tour.sex == 1 ? Icons.male : Icons.female,
                                    color:
                                        tour.sex == 1
                                            ? Colors.lightBlueAccent
                                            : Colors.redAccent[100],
                                  ),
                              ],
                            ),
                            Row(
                              spacing: 10.0,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                GestureDetector(
                                  onTap: () {
                                    handleEditTour(tour);
                                  },
                                  child: Icon(
                                    Icons.edit,
                                    color: Colors.lightBlueAccent[100],
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    handleRemoveTour(tour.id);
                                  },
                                  child: Icon(
                                    Icons.delete,
                                    color: Colors.redAccent[100],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    }),
                  ],
                ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        minHeight: MediaQuery.of(context).size.height * 0.5,
        maxHeight: MediaQuery.of(context).size.height * 0.8,
      ),
      child: SingleChildScrollView(
        child: Column(children: <Widget>[...displayTours(displayDailyTours)]),
      ),
    );
  }
}
