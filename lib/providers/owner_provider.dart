import 'package:colorful_print/colorful_print.dart';
import 'package:flutter/material.dart';
import 'package:flutter_projects/api/api_get.dart';
import 'package:flutter_projects/modules/owner.dart';

class OwnerProvider with ChangeNotifier {
  List<Owner> _owners = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<Owner> get owners => List.unmodifiable(_owners);
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<List<Owner>> loadOwners({bool fetchFromApi = false}) async {
    try {
      if (_owners.isNotEmpty && !fetchFromApi) {
        return _owners;
      }

      _startLoading();

      final List<Map<String, dynamic>> response = await ApiGet.getOwners();

      _owners = response.map((owner) => Owner.fromApiResponse(owner)).toList();

      _finishLoading();

      return _owners;
    } catch (err) {
      _handleError("Failed to load owners: ${err.toString()}");
      return [];
    }
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

  void addOwner(Owner newOwner) {
    _owners = [..._owners, newOwner];
    notifyListeners();
  }

  void updateOwner(Owner targetOwner) {
    printColor("total owners before edit: ${_owners.length}", textColor: TextColor.orange);
    _owners = _owners.map((owner) => {
      owner.id == targetOwner.id ? targetOwner : owner
    }).cast<Owner>().toList();
    notifyListeners();
    printColor("total owners after edit: ${_owners.length}", textColor: TextColor.orange);
  }

  void removeOwner(Owner archivedOwner) {
    printColor("total owners before remove: ${_owners.length}", textColor: TextColor.orange);
    _owners.removeWhere((owner) => owner.id == archivedOwner.id);
    notifyListeners();
    printColor("total owners after remove: ${_owners.length}", textColor: TextColor.orange);
  }

  void resetOwner() {
    _owners = [];
    notifyListeners();
  }
}
