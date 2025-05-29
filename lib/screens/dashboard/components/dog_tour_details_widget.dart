import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_projects/modules/tour.dart';
import 'package:flutter_projects/screens/dashboard/components/dog_tour_block_widget.dart';

class DogTourDetailsWidget extends StatefulWidget {
  DogTourDetailsWidget({
    super.key,
    required this.dogTours,
    required this.handleUpdateTours,
    this.sameDateRange = true
  });

  final List<Tour> dogTours;
  final ValueChanged<List<Tour>> handleUpdateTours;
  bool sameDateRange;

  @override
  State<DogTourDetailsWidget> createState() => _DogTourDetailsWidgetState();
}

class _DogTourDetailsWidgetState extends State<DogTourDetailsWidget> {
  void handleUpdateTour(int index, Tour tourInfo) {
    final updatedTours = [...widget.dogTours];
    updatedTours[index] = tourInfo;
    widget.handleUpdateTours(updatedTours);
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.6,
      ),
      child: ListView.builder(
        shrinkWrap: true,
        physics: ClampingScrollPhysics(),
        itemCount: widget.dogTours.length,
        itemBuilder: (ctx, index) {
          final tour = widget.dogTours[index];
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
            child: DogTourBlockWidget(
              tour: tour,
              sameDateRange: widget.sameDateRange,
              singleDog: widget.dogTours.where((dog) => dog.alive).length == 1,
              handleUpdateTour:
                  (tourInfo) => handleUpdateTour(index, tourInfo),
            ),
          );
        },
      )
    );
  }
}
