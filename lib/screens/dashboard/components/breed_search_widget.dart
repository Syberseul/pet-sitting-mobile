import 'package:cached_network_image/cached_network_image.dart';
import 'package:colorful_print/colorful_print.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_projects/api/api_get.dart';
import 'package:flutter_projects/constants/c_breedMap.dart';
import 'package:flutter_projects/language/localization_service.dart';
import 'package:flutter_projects/language/trans_enum.dart';

class BreedSearchWidget extends StatefulWidget {
  final ValueChanged<BreedInfo?>? onBreedSelected;
  late BreedInfo? editBreed;

  BreedSearchWidget({required this.onBreedSelected, this.editBreed});

  @override
  _BreedSearchWidgetState createState() => _BreedSearchWidgetState();
}

class _BreedSearchWidgetState extends State<BreedSearchWidget> {
  String? selectedBreedKey;
  BreedInfo? selectedBreed;

  String dogImgUrl = "";
  bool isLoadingDogImg = false;

  @override
  void initState() {
    super.initState();

    initSelectedBreed();
  }

  Future<void> initSelectedBreed() async {
    if (widget.editBreed != null) {
      selectedBreed = widget.editBreed;
      selectedBreedKey = selectedBreed!.englishName;

      await loadDogImage();
    }
  }

  Future<void> loadDogImage() async {
    if (!isLoadingDogImg && selectedBreedKey != null && selectedBreedKey!.isNotEmpty) {
      setState(() => isLoadingDogImg = true);
      try {
        final dogImgUrl = await ApiGet.getDogImage(selectedBreedKey!);
        setState(() {
          this.dogImgUrl = dogImgUrl;
        });
      } catch (e) {
        printColor("$e", textColor: TextColor.red);
      } finally {
        setState(() => isLoadingDogImg = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 10.0,
      children: [
        DropdownSearch<String>(
          selectedItem: selectedBreedKey,
          items: (_, __) => breedMap.keys.toList(),
          popupProps: PopupProps.menu(
            showSearchBox: true,
            searchDelay: Duration(milliseconds: 300),
            searchFieldProps: TextFieldProps(
              decoration: InputDecoration(
                hintText: AppLocalizations.getText(context, TranslateEnum.searchDogBreedText),
              ),
            ),
          ),
          filterFn: (item, filter) {
            final lowerFilter = filter.toLowerCase();
            return item.toLowerCase().contains(lowerFilter) ||
                breedMap[item]!.chineseName.contains(filter) ||
                breedMap[item]!.englishName.contains(filter);
          },
          onChanged: (selectedKey) async {
            setState(() {
              selectedBreedKey = selectedKey;
              selectedBreed =
                  selectedKey != null ? breedMap[selectedKey] : null;
            });

            if (selectedKey != null) {
              widget.onBreedSelected!(selectedBreed);

              await loadDogImage();
            }
          },
          dropdownBuilder: (context, selectedItem) {
            if (selectedItem == null) {
              return Text(AppLocalizations.getText(context, TranslateEnum.chooseDogBreed));
            }
            final breedInfo = breedMap[selectedItem]!;
            return Text("${breedInfo.chineseName} ($selectedItem)");
          },
          itemAsString: (item) {
            final breedInfo = breedMap[item]!;
            return "${breedInfo.chineseName} ($item)";
          },
        ),
        if (dogImgUrl.isNotEmpty)
          GestureDetector(
            onTap: () async {
              await loadDogImage();
            },
            child: CachedNetworkImage(
              imageUrl: dogImgUrl,
              width: 300.0,
              height: 300.0,
              imageBuilder:
                  (context, imageProvider) => Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: imageProvider,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
              placeholder: (context, url) => CupertinoActivityIndicator(
                radius: 12,
                animating: true,
                color: Colors.orange,
              ),
              errorWidget: (context, url, error) => Icon(Icons.error),
            ),
          ),
      ],
    );
  }
}
