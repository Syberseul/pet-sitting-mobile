import 'package:calendar_view/calendar_view.dart';
import 'package:colorful_print/colorful_print.dart';
import 'package:flutter/material.dart';
import 'package:flutter_projects/language/localization_service.dart';
import 'package:flutter_projects/language/trans_enum.dart';
import 'package:flutter_projects/providers/owner_provider.dart';
import 'package:flutter_projects/providers/tour_provider.dart';
import 'package:flutter_projects/screens/dashboard/components/modify_owner_bottom_sheet.dart';
import 'package:flutter_projects/screens/dashboard/components/modify_tour_bottom_sheet.dart';
import 'package:flutter_projects/screens/dashboard/components/month_view_slot.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:provider/provider.dart';

class CalendarWidget extends StatefulWidget {
  const CalendarWidget({super.key});

  @override
  State<CalendarWidget> createState() => _CalendarWidgetState();
}

class _CalendarWidgetState extends State<CalendarWidget> {
  final Color speedDialIconBackgroundColor = Colors.lightBlueAccent.withValues(
    alpha: 0.8,
  );

  late EventController _eventController;

  ValueNotifier<bool> isDialOpen = ValueNotifier(false);

  @override
  void initState() {
    super.initState();

    _eventController = EventController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadTours();
      loadOwners();
    });
  }

  Future<void> loadTours({
    bool fetchFromApi = false,
    bool showLoadingIndicator = true,
  }) async {
    final provider = context.read<TourProvider>();

    if (!provider.isLoading) {
      try {
        if (fetchFromApi) {
          setState(() {
            _eventController.removeAll(provider.toursData);
          });
        }

        // TODO:
        // here check if possible not fetch from api, but update via passed in parameters
        await provider.loadTours(
          fetchFromApi: fetchFromApi,
          showLoadingIndicator: showLoadingIndicator,
        );

        setState(() {
          _eventController.addAll(provider.toursData);
        });
      } catch (e) {
        setState(() {});
      }
    }
  }

  Future<void> loadOwners({bool fetchFromApi = false}) async {
    final provider = context.read<OwnerProvider>();

    if (!provider.isLoading) {
      try {
        await provider.loadOwners(fetchFromApi: fetchFromApi);
      } catch (err) {
        printColor(
          "error while loading owners: $err",
          textColor: TextColor.red,
        );
      }
    }
  }

  void handleNewTourAdded() async {
    await loadTours(fetchFromApi: true, showLoadingIndicator: false);
  }

  Future<void> _refreshData() async {
    loadTours(fetchFromApi: true, showLoadingIndicator: false);
    loadOwners(fetchFromApi: true);
  }

  @override
  Widget build(BuildContext context) {
    return CalendarControllerProvider(
      controller: _eventController,
      child: Consumer<TourProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) {
            return Center(child: CircularProgressIndicator());
          }

          if (provider.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Error: ${provider.errorMessage}'),
                  ElevatedButton(onPressed: loadTours, child: Text('Retry')),
                ],
              ),
            );
          }

          return Scaffold(
            body: RefreshIndicator(
              onRefresh: _refreshData,
              child: CustomScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                slivers: [
                  SliverFillRemaining(
                    child: MonthView(
                      key: ValueKey(_eventController.allEvents.length),
                      cellBuilder: (
                          date,
                          events,
                          isToday,
                          isInMonth,
                          hideDaysNotInMonth,
                          ) {
                        return InkWell(
                          splashColor: Colors.red,
                          child: MonthViewSlot(
                            date: date,
                            events: events,
                            isToday: isToday,
                            isInMonth: isInMonth,
                            hideDaysNotInMonth: hideDaysNotInMonth,
                            handleNewTourAdded: handleNewTourAdded,
                          ),
                        );
                      },
                    ),
                  )
                ],
              ),
            ),
            floatingActionButton: SpeedDial(
              overlayOpacity: 0.2,
              overlayColor: Colors.lightBlueAccent,
              backgroundColor: speedDialIconBackgroundColor,
              gradientBoxShape: BoxShape.circle,
              children: <SpeedDialChild>[
                SpeedDialChild(
                  label: AppLocalizations.getText(
                    context,
                    TranslateEnum.addTour,
                  ),
                  labelStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 16.0,
                  ),
                  backgroundColor: speedDialIconBackgroundColor,
                  labelBackgroundColor: speedDialIconBackgroundColor,
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      builder:
                          (ctx) => ModifyTourBottomSheet(
                            handleNewTourAdded: handleNewTourAdded,
                          ),
                    );
                  },
                  child: Icon(Icons.tour, color: Colors.white),
                ),
                SpeedDialChild(
                  label: AppLocalizations.getText(
                    context,
                    TranslateEnum.addOwner,
                  ),
                  labelStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 16.0,
                  ),
                  backgroundColor: speedDialIconBackgroundColor,
                  labelBackgroundColor: speedDialIconBackgroundColor,
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      builder: (ctx) => ModifyOwnerBottomSheet(),
                    );
                  },
                  child: Icon(Icons.person, color: Colors.white),
                ),
              ],
              child: Icon(Icons.add_box, color: Colors.white),
            ),
          );
        },
      ),
    );
  }
}
