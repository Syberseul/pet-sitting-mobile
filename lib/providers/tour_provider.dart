import 'package:calendar_view/calendar_view.dart';
import 'package:colorful_print/colorful_print.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_projects/api/api_get.dart';
import 'package:flutter_projects/modules/tour.dart';

class TourProvider with ChangeNotifier {
  List<Tour> _tours = [];
  List<CalendarEventData> _toursData = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<Tour> get tours => List.unmodifiable(_tours);
  List<CalendarEventData> get toursData => List.unmodifiable(_toursData);
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get hasError => _errorMessage != null;

  Future<List<Tour>> loadTours({bool fetchFromApi = false, bool showLoadingIndicator = true}) async {
    try {
      if (_tours.isNotEmpty && !fetchFromApi) {
        return _tours;
      }

      if (showLoadingIndicator) {
        _startLoading();
      }

      _tours = [];

      final List<Map<String, dynamic>> response = await ApiGet.getTours();

      _tours = response.map((tour) => Tour.fromApiResponse(tour)).toList();
      _toursData = _generateToursData(_tours);

      _finishLoading();

      return _tours;
    } catch (e) {
      _handleError("Failed to load tours: ${e.toString()}");
      return [];
    }
  }

  void updateTours(List<Tour> newTours) {
    _tours = newTours;
    _toursData = _generateToursData(_tours);
    notifyListeners();
  }

  void _startLoading() {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
  }

  void _finishLoading() {
    _isLoading = false;
    _errorMessage = null;
    notifyListeners();
  }

  void _handleError(String message) {
    _isLoading = false;
    _errorMessage = message;
    notifyListeners();
    debugPrint(message);
  }

  List<CalendarEventData> _generateToursData(List<Tour> tours) {
    return tours.expand((tour) {
      final days = _generateDateRange(tour.startDate, tour.endDate);
      return days.map((date) => CalendarEventData(
          title: tour.dogName,
          date: date,
          event: tour
      ));
    }).toList();
  }

  List<DateTime> _generateDateRange(DateTime startDate, DateTime endDate) {
    final List<DateTime> days = [];

    DateTime currentDate = startDate;
    while (!currentDate.isAfter(endDate)) {
      days.add(currentDate);
      currentDate = currentDate.add(Duration(days: 1));
    }

    return days;
  }
}
