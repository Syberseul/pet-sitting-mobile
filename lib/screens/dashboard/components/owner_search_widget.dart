import 'package:colorful_print/colorful_print.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_projects/language/localization_service.dart';
import 'package:flutter_projects/language/trans_enum.dart';
import 'package:flutter_projects/modules/owner.dart';
import 'package:flutter_projects/providers/owner_provider.dart';
import 'package:flutter_projects/utils/helpers.dart';
import 'package:provider/provider.dart';

class OwnerSearchWidget extends StatefulWidget {
  final ValueChanged<Owner?>? onOwnerSelected;

  const OwnerSearchWidget({super.key, required this.onOwnerSelected});

  @override
  State<OwnerSearchWidget> createState() => _OwnerSearchWidgetState();
}

class _OwnerSearchWidgetState extends State<OwnerSearchWidget> {
  List<Owner> ownerList = [];
  bool isLoading = true;
  Map<String, Owner> formatOwnerMap = {};
  Owner? selectedOwner;

  @override
  void initState() {
    super.initState();
    loadOwners();
  }

  Future<void> loadOwners() async {
    try {
      final provider = context.read<OwnerProvider>();
      final owners = provider.owners;

      setState(() {
        ownerList = owners;
        formatOwnerMap = convertListToOwnerMap(ownerList);
        isLoading = false;
      });
    } catch (e) {
      printColor("Error loading owners: $e", textColor: TextColor.red);
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return DropdownSearch<String>(
      items: (_, __) => formatOwnerMap.keys.toList(),
      popupProps: PopupProps.menu(
        showSearchBox: true,
        searchDelay: Duration(milliseconds: 300),
        searchFieldProps: TextFieldProps(
          decoration: InputDecoration(
            hintText: AppLocalizations.getText(context, TranslateEnum.searchByOwner),
          ),
        ),
      ),
      filterFn: (item, filter) {
        final lowerFilter = filter.toLowerCase();
        return item.toLowerCase().contains(lowerFilter);
      },
      dropdownBuilder: (context, selectedItem) {
        if (selectedItem == null) {
          return Text(AppLocalizations.getText(context, TranslateEnum.selectOwner));
        }
        final ownerInfo = formatOwnerMap[selectedItem]!;
        return Text(ownerInfo.name);
      },
      itemAsString: (item) {
        final ownerInfo = formatOwnerMap[item]!;
        return ownerInfo.name;
      },
      onChanged: (selectedKey) {
        setState(() {
          selectedOwner = selectedKey == null ? null : formatOwnerMap[selectedKey];
          if (selectedKey != null) {
            widget.onOwnerSelected!(selectedOwner);
          }
        });
      },
    );
  }
}