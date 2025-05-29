import 'package:colorful_print/colorful_print.dart';
import 'package:flutter/material.dart';
import 'package:flutter_projects/api/api_post.dart';
import 'package:flutter_projects/api/api_put.dart';
import 'package:flutter_projects/language/localization_service.dart';
import 'package:flutter_projects/language/trans_enum.dart';
import 'package:flutter_projects/main.dart';
import 'package:flutter_projects/modules/owner.dart';
import 'package:flutter_projects/modules/tour.dart';
import 'package:flutter_projects/providers/owner_provider.dart';
import 'package:flutter_projects/screens/dashboard/components/date_range_picker.dart';
import 'package:flutter_projects/screens/dashboard/components/dog_tour_details_widget.dart';
import 'package:flutter_projects/screens/dashboard/components/empty_owner_notification.dart';
import 'package:flutter_projects/screens/dashboard/components/modify_owner_bottom_sheet.dart';
import 'package:flutter_projects/screens/dashboard/components/owner_search_widget.dart';
import 'package:flutter_projects/utils/helpers.dart';
import 'package:provider/provider.dart';

final ownerProvider = navigatorKey.currentContext?.read<OwnerProvider>();

class ModifyTourBottomSheet extends StatefulWidget {
  DateTime? selectedDate;
  VoidCallback? handleNewTourAdded;
  ValueChanged<Tour>? handleUpdateTour;
  Tour? tourInfo;

  ModifyTourBottomSheet({
    super.key,
    this.handleNewTourAdded,
    this.handleUpdateTour,
    this.selectedDate,
    this.tourInfo,
  });

  @override
  State<ModifyTourBottomSheet> createState() => _ModifyTourBottomSheetState();
}

class _ModifyTourBottomSheetState extends State<ModifyTourBottomSheet> {
  Owner? selectedOwner;
  bool sameCaringDateRange = true;
  bool isSaveBtnAvailable = false;

  bool _hasValidOwner = false;
  bool _isEditTour = false;
  bool _isAddingTour = false;

  List<Tour> dogTours = [];

  @override
  void initState() {
    super.initState();

    if (ownerProvider != null) {
      _hasValidOwner = ownerProvider!.owners.isNotEmpty;
    }

    setState(() => _isEditTour = widget.tourInfo != null);

    if (_isEditTour) {
      initTourInfo();
    }
  }

  void initTourInfo() {
    final tourOwner = Owner.getOwnerById(widget.tourInfo!.ownerId);
    if (tourOwner != null && tourOwner.id.isNotEmpty) {
      setState(() => selectedOwner = tourOwner);
    }
  }

  void onOwnerSelected(Owner? owner) {
    if (owner == null) {
      return;
    }

    setState(() {
      selectedOwner = owner;
      dogTours = generateDogTours();
      sameCaringDateRange = dogTours.length != 1;
    });

    checkSaveButtonAvailability();
  }

  List<Tour> generateDogTours() {
    if (selectedOwner!.dogs.isEmpty) return [];

    List<Tour> res = [];

    selectedOwner!.dogs
        .map(
          (dog) => {
            res.add(
              Tour(
                id: "",
                dogName: dog.dogName,
                dogId: dog.id,
                breedName: dog.breedName,
                dailyPrice: getDogDailyPriceByBreed(dog.breedName),
                ownerId: dog.ownerId,
                ownerName: dog.ownerName,
                startDate: widget.selectedDate ?? DateTime.now(),
                endDate: widget.selectedDate ?? DateTime.now(),
                isSelected: dog.alive,
                sex: dog.sex,
                desex: dog.desex
              ),
            ),
          },
        )
        .toList();

    return res;
  }

  void handleUpdateTours(List<Tour> tours) {
    setState(() {
      dogTours = tours;
    });
    checkSaveButtonAvailability();
  }

  void handleDatePick(Map<String, dynamic>? timeRange) {
    if (timeRange == null) {
      return;
    }

    final List<Tour> newDogTour =
        dogTours.map((Tour tour) {
          tour.updateTour(
            startDate: DateTime.parse(timeRange["fullStartDateStr"]),
            endDate: DateTime.parse(timeRange["fullEndDateStr"]),
          );
          return tour;
        }).toList();

    handleUpdateTours(newDogTour);
  }

  void checkSaveButtonAvailability() {
    if (dogTours.isEmpty || !dogTours.any((dog) => dog.alive)) {
      setState(() {
        isSaveBtnAvailable = false;
      });
    }

    final selectedTours = dogTours.where((tour) => tour.isSelected).toList();

    setState(() {
      isSaveBtnAvailable = selectedTours.isNotEmpty;
    });
  }

  Future<void> handleAddTour(BuildContext context) async {
    try {
      setState(() {
        _isAddingTour = true;
      });

      final createdResponse = await ApiPost.createTours(toursInfo: dogTours);

      if (createdResponse["totalSuccess"] > 0 &&
          widget.handleNewTourAdded != null) {
        widget.handleNewTourAdded!();
      }
    } catch (err) {
      debugPrint("ERROR on create new tour: $err");
    } finally {
      setState(() {
        _isAddingTour = false;
      });
      Navigator.pop(context);
    }
  }

  Future<void> handleUpdateTour(BuildContext context) async {
    try {
      setState(() {
        _isAddingTour = true;
      });

      final updateResponse = await ApiPut.updateTour(tourInfo: dogTours[0]);

      if (updateResponse["data"] != null && widget.handleUpdateTour != null) {
        final updatedTour = Tour.fromApiResponse(updateResponse);
        widget.handleUpdateTour!(updatedTour);
      }
    } catch (err) {
      debugPrint("ERROR on update tour: $err");
    } finally {
      setState(() {
        _isAddingTour = false;
      });
      Navigator.pop(context);
    }
  }

  List<Widget> createNewTourWidget() {
    return <Widget>[
      Text(
        AppLocalizations.getText(context, TranslateEnum.addNewTour),
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),

      if (_hasValidOwner) ...[
        OwnerSearchWidget(onOwnerSelected: onOwnerSelected),

        if (selectedOwner != null &&
            dogTours.isNotEmpty &&
            dogTours.any((dog) => dog.alive))
          Column(
            children: <Widget>[
              if (dogTours.length != 1) ...[
                Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            Checkbox(
                              value: sameCaringDateRange,
                              activeColor: Colors.lightGreen,
                              onChanged: (newValue) {
                                setState(() {
                                  sameCaringDateRange = !sameCaringDateRange;
                                });
                              },
                            ),
                            Text(
                              style: TextStyle(fontSize: 16.0),
                              AppLocalizations.getText(
                                context,
                                TranslateEnum.sameDeliveryDate,
                              ),
                            ),

                            SizedBox(width: 23.0),
                          ],
                        ),
                        if (sameCaringDateRange)
                          DateRangePicker(
                            onDatePick: handleDatePick,
                            startDateTime: DateTime.now(),
                            endDateTime: DateTime.now(),
                            displayTimeText: AppLocalizations.getText(
                              context,
                              TranslateEnum.selectDateRange,
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ],

              DogTourDetailsWidget(
                key: ValueKey(selectedOwner!.id),
                dogTours: dogTours,
                handleUpdateTours: handleUpdateTours,
                sameDateRange: sameCaringDateRange,
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
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
                        !isSaveBtnAvailable || _isAddingTour
                            ? null
                            : () => handleAddTour(context),
                    style: TextButton.styleFrom(
                      backgroundColor:
                          !isSaveBtnAvailable || _isAddingTour
                              ? Colors.grey
                              : Colors.lightBlueAccent,
                    ),
                    child: Text(
                      _isAddingTour
                          ? AppLocalizations.getText(
                            context,
                            TranslateEnum.adding,
                          )
                          : AppLocalizations.getText(
                            context,
                            TranslateEnum.addTour,
                          ),
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ],
          )
        else
          SizedBox(height: 250),
      ] else
        ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: 250,
            maxHeight: MediaQuery.of(context).size.height * 0.5,
          ),
          child: EmptyOwnerNotification(
            onPressed: () {
              Navigator.pop(context);
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                builder: (ctx) => ModifyOwnerBottomSheet(),
              );
            },
          ),
        ),
    ];
  }

  List<Widget> updateTourWidget() {
    return <Widget>[
      Text(
        AppLocalizations.getText(context, TranslateEnum.editTour),
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),

      DogTourDetailsWidget(
        key: ValueKey(selectedOwner!.id),
        dogTours: [widget.tourInfo!],
        handleUpdateTours: handleUpdateTours,
        sameDateRange: false,
      ),

      Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context),
            style: TextButton.styleFrom(backgroundColor: Colors.grey),
            child: Text(
              AppLocalizations.getText(context, TranslateEnum.cancel),
              style: TextStyle(color: Colors.white),
            ),
          ),
          TextButton(
            onPressed: () => handleUpdateTour(context),
            style: TextButton.styleFrom(
              backgroundColor:
                  _isAddingTour ? Colors.grey : Colors.lightBlueAccent,
            ),
            child: Text(
              _isAddingTour
                  ? AppLocalizations.getText(context, TranslateEnum.updating)
                  : AppLocalizations.getText(context, TranslateEnum.update),
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(10.0),
        child: Column(
          spacing: 15.0,
          mainAxisSize: MainAxisSize.min,
          children: _isEditTour ? updateTourWidget() : createNewTourWidget(),
        ),
      ),
    );
  }
}
