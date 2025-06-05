class Dog {
  late String _id;
  late final String _dogName;
  late final String _breedName;
  late final String _breedType;
  late final String _ownerId;
  late final String _ownerName;
  late double weight;
  late final bool _alive;
  late int sex;
  late bool desex;

  @override
  String toString() {
    return '''
    Dog(
      id: $_id,
      dogName: $_dogName,
      breedName: $_breedName,
      breedType: $_breedType,
      ownerId: $_ownerId,
      ownerName: $_ownerName,
      weight: $weight,
      alive: $_alive,
      sex: $sex,
      desex: $desex,
    )
    ''';
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': _id,
      'dogName': _dogName,
      'breedName': _breedName,
      'breedType': _breedType,
      'ownerId': _ownerId,
      'ownerName': _ownerName,
      'weight': weight,
      'alive': _alive,
      "sex": sex,
      "desex": desex
    };
  }

  factory Dog.fromApiResponse(Map<String, dynamic> response) {
    return Dog(
      id: response["uid"]?.toString() ?? "",
      dogName: response["dogName"]?.toString() ?? "",
      breedName: response["breedName"]?.toString() ?? "",
      breedType: response["breedType"]?.toString() ?? "",
      ownerId: response["ownerId"]?.toString() ?? "",
      ownerName: response["ownerName"]?.toString() ?? "",
      weight: (response["weight"] as num?)?.toDouble() ?? 0.0,
      alive: response["alive"] as bool? ?? true,
      sex: response["sex"] as int? ?? 0,
      desex: response["desex"] as bool? ?? false,
    );
  }

  Dog({
    String id = "",
    required String dogName,
    required String breedName,
    required String breedType,
    required String ownerId,
    required String ownerName,
    required bool alive,
    this.weight = 0.0,
    this.sex = 0,
    this.desex = false,
  }) : _id = id,
       _dogName = dogName,
       _breedName = breedName,
       _breedType = breedType,
       _ownerId = ownerId,
       _ownerName = ownerName,
       _alive = alive;

  // -----------
  // Getters
  // -----------
  String get id => _id;
  String get dogName => _dogName;
  String get breedType => _breedType;
  String get breedName => _breedName;
  String get ownerId => _ownerId;
  String get ownerName => _ownerName;
  bool get alive => _alive;

  // -----------
  // Setters
  // -----------

  set dogName(String value) {
    if (value.isEmpty) throw ArgumentError('Dog name cannot be empty');
    _dogName = value;
  }

  set breedType(String value) {
    if (value.isEmpty) throw ArgumentError('Breed type cannot be empty');
    _breedType = value;
  }

  set breedName(String value) {
    if (value.isEmpty) throw ArgumentError('Breed name cannot be empty');
    _breedName = value;
  }

  // TODO: here need pass owner info
  set owner(String value) {
    if (value.isEmpty) throw ArgumentError('Breed type cannot be empty');
    _breedType = value;
  }

  set alive(bool value) {
    _alive = value;
  }

  void updateDog({
    String? dogName,
    String? breedType,
    String? breedName,
    String? ownerId,
    String? ownerName,
    bool? alive,
    int? newSex,
    bool? newDesex
  }) {
    if (dogName != null) _dogName = dogName;
    if (breedType != null) _breedType = breedType;
    if (breedName != null) _breedName = breedName;
    if (ownerId != null) _ownerId = ownerId;
    if (ownerName != null) _ownerName = ownerName;
    if (alive != null) _alive = alive;
    if (newSex != null) sex = newSex;
    if (newDesex != null) desex = newDesex;
  }
}
