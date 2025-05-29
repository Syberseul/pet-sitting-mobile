import 'dart:convert';

import 'package:colorful_print/colorful_print.dart';
import 'package:flutter_projects/main.dart';
import 'package:flutter_projects/modules/dog.dart';
import 'package:flutter_projects/providers/owner_provider.dart';
import 'package:provider/provider.dart';

class Owner {
  late final String _id;
  late final String _name;
  late final String _contactNo;
  late final String _userId;
  late final List<Dog> _dogs;
  late int sex;
  late bool desex;

  @override
  String toString() {
    return '''
    Owner(
      id: $_id,
      name: $_name,
      contactNo: $_contactNo,
      userId: $_userId,
      dogs: $_dogs, 
    )
    ''';
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': _id,
      'name': _name,
      'contactNo': _contactNo,
      'userId': _userId,
      'dogs': _dogs.map((dog) => dog.toJson()).toList(),
    };
  }

  factory Owner.fromApiResponse(Map<String, dynamic> response) {
    final data = response['data'] as Map<String, dynamic>? ?? response;

    return Owner(
      id: data['uid']?.toString() ?? data['id']?.toString() ?? "",
      name: data["name"]?.toString() ?? "",
      contactNo: data["contactNo"]?.toString() ?? "",
      userId: data["userId"]?.toString() ?? "",
      dogs:
          (data["dogs"] as List<dynamic>?)
              ?.map((dog) => Dog.fromApiResponse(dog))
              .toList() ??
          [],
    );
  }

  Owner({
    required String id,
    required String name,
    String contactNo = "",
    String userId = "",
    required List<Dog> dogs,
  }) : _id = id,
       _name = name,
       _dogs = dogs,
       _contactNo = contactNo,
       _userId = userId;

  // -----------
  // Getters
  // -----------
  String get id => _id;
  String get name => _name;
  String get contactNo => _contactNo;
  String get userId => _userId;
  List<Dog> get dogs => _dogs;

  // -----------
  // Setters
  // -----------
  set name(String value) {
    if (value.isEmpty) throw ArgumentError('Name cannot be empty');
    _name = value;
  }

  set contactNo(String value) {
    _contactNo = value;
  }

  set userId(String value) {
    _userId = value;
  }

  set dogs(List<Dog> dogs) {
    _dogs = dogs;
  }

  void setOwner({
    String? name,
    String? contactNo,
    String? userId,
    List<Dog>? dogs,
  }) {
    if (name != null) _name = name;
    if (contactNo != null) _contactNo = contactNo;
    if (userId != null) _userId = userId;
    if (dogs != null) _dogs = dogs;
  }

  static Owner? getOwnerById(String ownerId) {
    final List<Owner>? owners =
        navigatorKey.currentContext?.read<OwnerProvider>().owners.toList();

    if (owners == null || owners.isEmpty) return null;

    return owners.firstWhere((owner) => owner.id == ownerId);
  }
}
