import 'package:colorful_print/colorful_print.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_projects/language/localization_service.dart';
import 'package:flutter_projects/language/trans_enum.dart';
import 'package:flutter_projects/screens/dashboard/components/date_range_picker.dart';
import "package:flutter_projects/modules/tour.dart";

class DogTourBlockWidget extends StatefulWidget {
  DogTourBlockWidget({
    super.key,
    required this.tour,
    required this.handleUpdateTour,
    this.sameDateRange = true,
    this.singleDog = true,
  });

  bool sameDateRange;
  bool singleDog;
  final Tour tour;
  final ValueChanged<Tour> handleUpdateTour;

  @override
  State<DogTourBlockWidget> createState() => _DogTourBlockWidgetState();
}

class _DogTourBlockWidgetState extends State<DogTourBlockWidget> {
  late TextEditingController _dailyPriceController;
  late Tour tourInfo;

  @override
  void initState() {
    super.initState();
    _dailyPriceController = TextEditingController();
    initTourDetails();
  }

  @override
  void dispose() {
    super.dispose();
    _dailyPriceController.dispose();
  }

  void initTourDetails() {
    tourInfo = widget.tour;
    _dailyPriceController.text = tourInfo.dailyPrice.toStringAsFixed(2);
  }

  void handleDatePick(Map<String, dynamic>? timeRange) {
    if (timeRange == null) {
      return;
    }

    tourInfo.updateTour(
      startDate: DateTime.parse(timeRange["fullStartDateStr"]),
      endDate: DateTime.parse(timeRange["fullEndDateStr"]),
    );

    widget.handleUpdateTour(tourInfo);
  }

  void onDailyPriceChange(String newValue) {
    tourInfo.updateTour(dailyPrice: double.tryParse(newValue));

    widget.handleUpdateTour(tourInfo);
  }

  void _showTextInputDialog(BuildContext context) {
    final TextEditingController controller = TextEditingController();
    bool addBtnAvailability = false;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(
                AppLocalizations.getText(context, TranslateEnum.enterNoteTitle),
              ),
              content: TextField(
                controller: controller,
                onChanged: (text) {
                  setState(() {
                    addBtnAvailability = text.isNotEmpty;
                  });
                },
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  style: TextButton.styleFrom(backgroundColor: Colors.grey),
                  child: Text(
                    AppLocalizations.getText(context, TranslateEnum.cancel),
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                TextButton(
                  onPressed:
                      addBtnAvailability
                          ? () {
                            final notes = tourInfo.notes;
                            tourInfo.updateTour(
                              notes: [...notes, controller.text],
                            );
                            widget.handleUpdateTour(tourInfo);
                            Navigator.pop(context);
                          }
                          : null,
                  style: TextButton.styleFrom(
                    backgroundColor:
                        addBtnAvailability ? Colors.blue : Colors.grey,
                  ),
                  child: Text(
                    AppLocalizations.getText(context, TranslateEnum.add),
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

  List<Widget> displayDogTourNotes() {
    if (tourInfo.notes.isEmpty) return [];

    return [
      SizedBox(height: 10),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalizations.getText(context, TranslateEnum.addedNotes),
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 5),
          ...tourInfo.notes.asMap().entries.map((entry) {
            final index = entry.key;
            final note = entry.value;

            return Padding(
              padding: EdgeInsets.symmetric(vertical: 4),
              child: Row(
                children: <Widget>[
                  Icon(Icons.circle, size: 8, color: Colors.grey),
                  SizedBox(width: 8),
                  Expanded(child: Text(note)),
                  IconButton(
                    icon: Icon(Icons.delete, size: 18, color: Colors.red[300]),
                    onPressed: () {
                      setState(() {
                        tourInfo.notes.removeAt(index);
                        widget.handleUpdateTour(tourInfo);
                      });
                    },
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(minHeight: 100),
      child: Stack(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color:
                          tourInfo.isSelected
                              ? Colors.lightGreen[100]!
                              : Colors.grey[300]!,
                      width: 2.0,
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    color:
                        tourInfo.isSelected
                            ? Colors.lightGreen[100]
                            : Colors.grey[300],
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: Column(
                      spacing: 5.0,
                      children: [
                        if (tourInfo.alive && !widget.singleDog)
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                AppLocalizations.getText(
                                  context,
                                  tourInfo.desex
                                      ? TranslateEnum.desexYesText
                                      : TranslateEnum.desexNoText,
                                ),
                                style: TextStyle(
                                  color:
                                      tourInfo.desex
                                          ? Colors.lightGreen
                                          : Colors.redAccent,
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                AppLocalizations.getText(
                                  context,
                                  TranslateEnum.careInThisTour,
                                ),
                              ),
                              Checkbox(
                                value: tourInfo.isSelected,
                                activeColor: Colors.lightGreen,
                                onChanged: (newValue) {
                                  setState(() {
                                    tourInfo.isSelected = !tourInfo.isSelected;
                                    widget.handleUpdateTour(tourInfo);
                                  });
                                },
                              ),
                            ],
                          )
                        else
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                AppLocalizations.getText(
                                  context,
                                  tourInfo.desex
                                      ? TranslateEnum.desexYesText
                                      : TranslateEnum.desexNoText,
                                ),
                                style: TextStyle(
                                  color:
                                      tourInfo.desex
                                          ? Colors.lightGreen
                                          : Colors.redAccent,
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        DefaultTextStyle(
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                          child: Row(
                            children: <Widget>[
                              if (tourInfo.sex == 1 || tourInfo.sex == 2)
                                Icon(
                                  tourInfo.sex == 1 ? Icons.male : Icons.female,
                                  color:
                                      tourInfo.sex == 1
                                          ? Colors.lightBlueAccent
                                          : Colors.redAccent[100],
                                ),
                              Text(
                                "${tourInfo.dogName} (${tourInfo.breedName})",
                              ),
                              Text(" - "),
                              Row(
                                children: <Widget>[
                                  Text(
                                    "${AppLocalizations.getText(context, TranslateEnum.dogWeight)}:",
                                  ),
                                  Text(
                                    tourInfo.weight == 0
                                        ? AppLocalizations.getText(
                                          context,
                                          TranslateEnum.unknown,
                                        )
                                        : "${tourInfo.weight} kg",
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        if (tourInfo.alive)
                          Column(
                            spacing: 5.0,
                            children: <Widget>[
                              if (!widget.sameDateRange)
                                Column(
                                  children: <Widget>[
                                    Row(
                                      children: [
                                        Text(
                                          "${AppLocalizations.getText(context, TranslateEnum.caringDateRange)}:",
                                        ),
                                      ],
                                    ),
                                    DateRangePicker(
                                      onDatePick: handleDatePick,
                                      startDateTime: tourInfo.startDate,
                                      endDateTime: tourInfo.endDate,
                                    ),
                                  ],
                                ),
                              Row(
                                spacing: 10.0,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SizedBox(
                                    width: 100.0,
                                    child: Text(
                                      AppLocalizations.getText(
                                        context,
                                        TranslateEnum.dailyRate,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: TextFormField(
                                      controller: _dailyPriceController,
                                      keyboardType:
                                          TextInputType.numberWithOptions(
                                            decimal: true,
                                          ),
                                      decoration: InputDecoration(
                                        prefixIcon: Icon(
                                          Icons.attach_money,
                                          color: Colors.lightBlueAccent,
                                        ),
                                        constraints: BoxConstraints(
                                          maxHeight: 40.0,
                                        ),
                                      ),
                                      textAlignVertical: TextAlignVertical(
                                        y: -1,
                                      ),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return AppLocalizations.getText(
                                            context,
                                            TranslateEnum.enterAPrice,
                                          );
                                        }
                                        if (double.tryParse(value) == null) {
                                          return AppLocalizations.getText(
                                            context,
                                            TranslateEnum.enterAValidPrice,
                                          );
                                        }
                                        return null;
                                      },
                                      inputFormatters: [
                                        FilteringTextInputFormatter.allow(
                                          RegExp(r'^\d*\.?\d{0,2}'),
                                        ),
                                      ],
                                      onChanged: onDailyPriceChange,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                spacing: 10.0,
                                children: [
                                  SizedBox(
                                    width: 100.0,
                                    child: Text(
                                      "${AppLocalizations.getText(context, TranslateEnum.notes)}:",
                                    ),
                                  ),
                                  ElevatedButton(
                                    onPressed:
                                        () => _showTextInputDialog(context),
                                    child: Text(
                                      AppLocalizations.getText(
                                        context,
                                        TranslateEnum.addNewNote,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              ...displayDogTourNotes(),
                            ],
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          if (!widget.tour.alive)
            Positioned.fill(
              child: AbsorbPointer(
                absorbing: true,
                child: Container(
                  color: Colors.black.withValues(alpha: 0.4),
                  child: Center(
                    child: Text(
                      AppLocalizations.getText(
                        context,
                        TranslateEnum.dogPassedAway,
                      ),
                      style: TextStyle(
                        color: Colors.red[300],
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
