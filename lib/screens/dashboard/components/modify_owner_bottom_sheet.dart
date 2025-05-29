import 'package:colorful_print/colorful_print.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_projects/api/api_post.dart';
import 'package:flutter_projects/constants/c_breedMap.dart';
import 'package:flutter_projects/constants/enum.dart';
import 'package:flutter_projects/language/localization_service.dart';
import 'package:flutter_projects/language/trans_enum.dart';
import 'package:flutter_projects/main.dart';
import 'package:flutter_projects/modules/dog.dart';
import 'package:flutter_projects/modules/owner.dart';
import 'package:flutter_projects/providers/owner_provider.dart';
import 'package:flutter_projects/screens/dashboard/components/breed_search_widget.dart';
import 'package:flutter_projects/utils/helpers.dart';
import 'package:provider/provider.dart';
import 'package:toggle_switch/toggle_switch.dart';

final ownerProvider = navigatorKey.currentContext?.read<OwnerProvider>();

class ModifyOwnerBottomSheet extends StatefulWidget {
  final DateTime selectedDate;

  ModifyOwnerBottomSheet({super.key, DateTime? selectedDate})
    : selectedDate = selectedDate ?? DateTime.now();

  @override
  State<ModifyOwnerBottomSheet> createState() => _ModifyOwnerBottomSheetState();
}

class _ModifyOwnerBottomSheetState extends State<ModifyOwnerBottomSheet> {
  String? ownerName;
  String? contactNo;
  bool onAddDogDetails = false;
  bool onEditDogDetails = false;
  String? dogName;
  int? dogGender = 0;
  BreedInfo? selectedBreed;
  // double? dailyPrice = 0.0;
  double? dogWeight = 0.0;
  DogSize? dogSize;
  List<Dog> addedDogs = [];
  bool isCreatingOwner = false;
  int? selectEditDogIndex;
  bool dogDesex = false;

  late final TextEditingController _dogNameController;
  late final TextEditingController _dogWeightController;

  @override
  void initState() {
    super.initState();

    _dogNameController = TextEditingController();
    _dogWeightController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();

    _dogNameController.dispose();
    _dogWeightController.dispose();
  }

  void handleAddDog() {
    setState(() {
      onAddDogDetails = true;
      selectedBreed = null;
      dogWeight = null;
      dogName = null;
      _dogNameController.text = "";
      _dogWeightController.text = "0.0";
      dogGender = 0;
      dogDesex = false;
    });
  }

  void handleBreedSelected(BreedInfo? breed) {
    if (breed == null) {
      return;
    }

    setState(() {
      selectedBreed = breed;
    });

    final aveWeight = getAverageWeight(selectedBreed!.normalWeightRange);

    dogSize = getDogSize(aveWeight);
  }

  void handleAddDetail() {
    if (dogName == null || dogName!.isEmpty || selectedBreed == null) {
      return;
    }

    setState(() {
      addedDogs.add(
        Dog(
          dogName: dogName!,
          breedName: selectedBreed!.englishName,
          breedType: selectedBreed!.chineseName,
          ownerId: "",
          ownerName: ownerName ?? "",
          alive: true,
          weight: dogWeight ?? 0.0,
          sex: dogGender ?? 0,
          desex: dogDesex,
        ),
      );

      resetDogForm();
    });
  }

  void handleEditDetail() {
    if (selectEditDogIndex == null) {
      return;
    }

    setState(() {
      addedDogs =
          addedDogs
              .asMap()
              .map((index, dog) {
                return MapEntry(
                  index,
                  index == selectEditDogIndex
                      ? Dog(
                        dogName: dogName!,
                        breedName: selectedBreed!.englishName,
                        breedType: selectedBreed!.chineseName,
                        ownerId: "",
                        ownerName: ownerName ?? "",
                        alive: true,
                        weight: dogWeight ?? 0.0,
                        sex: dogGender ?? 0,
                        desex: dogDesex,
                      )
                      : dog,
                );
              })
              .values
              .toList();
    });

    resetDogForm();
  }

  void resetDogForm() {
    setState(() {
      dogName = null;
      selectedBreed = null;
      onAddDogDetails = false;
      onEditDogDetails = false;
      dogWeight = null;
      selectEditDogIndex = null;
      dogGender = 0;
      dogDesex = false;
    });
  }

  bool isAddDogBtuDisabled() =>
      selectedBreed == null || (dogName == null || dogName!.trim().isEmpty);

  bool isCreateBtnDisabled() =>
      isCreatingOwner ||
      ownerName == null ||
      ownerName!.trim().isEmpty ||
      addedDogs.isEmpty;

  Widget? get getWeightSuffixIcon {
    if (selectedBreed == null || dogWeight == null || dogWeight == 0.0) {
      return null;
    }

    final weightRange = selectedBreed!.normalWeightRange;

    if (dogWeight! >= weightRange[0] && dogWeight! <= weightRange[1]) {
      return null;
    } else if (dogWeight! < weightRange[0]) {
      return Icon(Icons.trending_down, color: Colors.orange);
    } else {
      return Icon(Icons.trending_up, color: Colors.red);
    }
  }

  Future<void> handleCreateOwner() async {
    setState(() {
      isCreatingOwner = true;
    });

    try {
      final Owner createOwnerData = Owner(
        id: "",
        name: ownerName!,
        dogs: addedDogs,
        contactNo: contactNo ?? "",
      );

      final response = await ApiPost.createDogOwner(ownerInfo: createOwnerData);

      final newOwner = Owner.fromApiResponse(response);

      if (newOwner.id.isNotEmpty) {
        ownerProvider!.addOwner(newOwner);
      }
      Navigator.pop(context);
    } catch (err) {
      printColor("error: $err", textColor: TextColor.orange);
    } finally {
      setState(() {
        isCreatingOwner = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(10.0),
        child: SizedBox(
          width: double.infinity,
          child: Column(
            mainAxisSize:
                onAddDogDetails || onEditDogDetails
                    ? MainAxisSize.max
                    : MainAxisSize.min,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    AppLocalizations.getText(
                      context,
                      TranslateEnum.addNewOwner,
                    ),
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.all(12.0),
                child: Column(
                  spacing: 10.0,
                  children: <Widget>[
                    TextField(
                      decoration: InputDecoration(
                        labelText: AppLocalizations.getText(
                          context,
                          TranslateEnum.ownerName,
                        ),
                      ),
                      onChanged: (newOwnerName) {
                        setState(() {
                          ownerName = newOwnerName;
                        });
                      },
                    ),
                    TextField(
                      decoration: InputDecoration(
                        labelText: AppLocalizations.getText(
                          context,
                          TranslateEnum.contactNo,
                        ),
                      ),
                      onChanged: (newContactNo) {
                        setState(() {
                          contactNo = newContactNo;
                        });
                      },
                    ),
                    Row(
                      spacing: 5.0,
                      children: <Widget>[
                        Expanded(
                          child: Divider(
                            color: Colors.lightBlueAccent,
                            thickness: 2.0,
                          ),
                        ),
                        onAddDogDetails || onEditDogDetails
                            ? Text(
                              AppLocalizations.getText(
                                context,
                                TranslateEnum.dogDetailsDivider,
                              ),
                              style: TextStyle(
                                color: Colors.lightBlueAccent,
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                              ),
                            )
                            : TextButton(
                              onPressed: handleAddDog,
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 5.0),
                                child: Text(
                                  AppLocalizations.getText(
                                    context,
                                    TranslateEnum.addDog,
                                  ),
                                  style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 16.0,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                        Expanded(
                          child: Divider(
                            color: Colors.lightBlueAccent,
                            thickness: 2.0,
                          ),
                        ),
                      ],
                    ),
                    if (onAddDogDetails || onEditDogDetails)
                      Column(
                        spacing: 10.0,
                        children: <Widget>[
                          BreedSearchWidget(
                            onBreedSelected: handleBreedSelected,
                            editBreed: selectedBreed,
                          ),
                          if (selectedBreed != null)
                            Column(
                              spacing: 10.0,
                              children: <Widget>[
                                TextField(
                                  controller: _dogNameController,
                                  decoration: InputDecoration(
                                    labelText: AppLocalizations.getText(
                                      context,
                                      TranslateEnum.dogName,
                                    ),
                                  ),
                                  onChanged: (newDogName) {
                                    setState(() {
                                      dogName = newDogName;
                                    });
                                  },
                                ),
                                TextFormField(
                                  controller: _dogWeightController,
                                  keyboardType: TextInputType.numberWithOptions(
                                    decimal: true,
                                  ),
                                  decoration: InputDecoration(
                                    labelText: AppLocalizations.getText(
                                      context,
                                      TranslateEnum.dogWeight,
                                    ),
                                    prefixIcon: Icon(
                                      Icons.scale_outlined,
                                      color: Colors.lightBlueAccent,
                                    ),
                                    suffixIcon: getWeightSuffixIcon,
                                  ),
                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(
                                      RegExp(r'^\d*\.?\d{0,2}'),
                                    ),
                                  ],
                                  onChanged: (newWeight) {
                                    setState(() {
                                      dogWeight =
                                          double.tryParse(newWeight) ?? 0;
                                    });
                                  },
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text(
                                      AppLocalizations.getText(
                                        context,
                                        TranslateEnum.gender,
                                      ),
                                      style: TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    ToggleSwitch(
                                      initialLabelIndex: dogGender,
                                      totalSwitches: 3,
                                      labels: [
                                        AppLocalizations.getText(
                                          context,
                                          TranslateEnum.unknown,
                                        ),
                                        AppLocalizations.getText(
                                          context,
                                          TranslateEnum.male,
                                        ),
                                        AppLocalizations.getText(
                                          context,
                                          TranslateEnum.female,
                                        ),
                                      ],
                                      activeBgColors: [
                                        [Colors.grey[400]!],
                                        [
                                          Colors.lightBlueAccent,
                                          Colors.blue,
                                          Colors.lightBlueAccent,
                                        ],
                                        [
                                          Colors.redAccent[100]!,
                                          Colors.redAccent[400]!,
                                          Colors.redAccent[100]!,
                                        ],
                                      ],
                                      customWidths: [100, 100, 100],
                                      inactiveBgColor: Colors.grey,
                                      customTextStyles: [
                                        TextStyle(fontWeight: FontWeight.bold),
                                      ],
                                      onToggle: (index) {
                                        setState(() {
                                          dogGender = index;
                                        });
                                      },
                                    ),
                                  ],
                                ),
                                Row(
                                  spacing: 10.0,
                                  children: <Widget>[
                                    Text(AppLocalizations.getText(context, TranslateEnum.desex), style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold,
                                    )),
                                    Checkbox(value: dogDesex, onChanged: (newDesex) {
                                      setState(() {
                                        dogDesex = !dogDesex;
                                      });
                                    })
                                  ],
                                )
                              ],
                            ),
                        ],
                      ),
                    onAddDogDetails || onEditDogDetails
                        ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          spacing: 10.0,
                          children: <Widget>[
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  onAddDogDetails = false;
                                  onEditDogDetails = false;
                                  selectEditDogIndex = null;
                                  dogGender = 0;
                                  dogDesex = false;
                                });
                              },
                              style: TextButton.styleFrom(
                                backgroundColor: Colors.transparent,
                              ),
                              child: Text(
                                AppLocalizations.getText(
                                  context,
                                  TranslateEnum.cancel,
                                ),
                                style: TextStyle(color: Colors.redAccent),
                              ),
                            ),
                            TextButton(
                              onPressed:
                                  isAddDogBtuDisabled()
                                      ? null
                                      : onAddDogDetails
                                      ? handleAddDetail
                                      : handleEditDetail,
                              style: TextButton.styleFrom(
                                backgroundColor: Colors.transparent,
                              ),
                              child: Text(
                                onAddDogDetails
                                    ? AppLocalizations.getText(
                                      context,
                                      TranslateEnum.add,
                                    )
                                    : AppLocalizations.getText(
                                      context,
                                      TranslateEnum.update,
                                    ),
                                style: TextStyle(
                                  color:
                                      isAddDogBtuDisabled()
                                          ? Colors.grey
                                          : Colors.lightBlueAccent,
                                ),
                              ),
                            ),
                          ],
                        )
                        : addedDogs.isNotEmpty
                        ? ListView.builder(
                          shrinkWrap: true,
                          itemCount: addedDogs.length,
                          itemBuilder:
                              (ctx, index) => Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Row(
                                    spacing: 5.0,
                                    children: <Widget>[
                                      Text(
                                        "${addedDogs[index].dogName} (${addedDogs[index].breedName})",
                                      ),
                                      if (addedDogs[index].sex == 1 ||
                                          addedDogs[index].sex == 2)
                                        Icon(
                                          addedDogs[index].sex == 1
                                              ? Icons.male
                                              : Icons.female,
                                          color:
                                              addedDogs[index].sex == 1
                                                  ? Colors.lightBlueAccent
                                                  : Colors.redAccent[100],
                                        ),
                                    ],
                                  ),
                                  Row(
                                    spacing: 10.0,
                                    children: <Widget>[
                                      GestureDetector(
                                        onTap: () {
                                          final editDog = addedDogs[index];
                                          setState(() {
                                            selectedBreed =
                                                BreedInfo.getBreedInfo(
                                                  editDog.breedName,
                                                );
                                            onEditDogDetails = true;
                                            selectEditDogIndex = index;
                                            dogName = editDog.dogName;
                                            dogWeight = editDog.weight;
                                            _dogNameController.text =
                                                editDog.dogName;
                                            _dogWeightController.text = editDog
                                                .weight
                                                .toStringAsFixed(2);
                                            dogGender = editDog.sex ?? 0;
                                            dogDesex = editDog.desex ?? false;
                                          });
                                        },
                                        child: Icon(
                                          Icons.edit,
                                          color: Colors.lightBlueAccent[100],
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            addedDogs.removeAt(index);
                                          });
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
                        )
                        : SizedBox(),
                    if (!onAddDogDetails && !onEditDogDetails)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Expanded(
                            child: TextButton(
                              onPressed:
                                  isCreateBtnDisabled()
                                      ? null
                                      : handleCreateOwner,
                              style: TextButton.styleFrom(
                                backgroundColor:
                                    isCreateBtnDisabled()
                                        ? Colors.grey
                                        : Colors.lightBlueAccent,
                              ),
                              child: Text(
                                AppLocalizations.getText(
                                  context,
                                  TranslateEnum.create,
                                ),
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
