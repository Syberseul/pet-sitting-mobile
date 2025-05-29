class Tour {
  late final String _id;
  late final String _dogName;
  late final String _dogId;
  late String breedType;
  late final String _breedName;
  late double _weight;
  late double _dailyPrice;
  late bool alive;
  late final String _ownerId;
  late final String _ownerName;
  late List<String> _notes;
  late DateTime _startDate;
  late DateTime _endDate;
  late bool isSelected;
  late int sex;
  late bool desex;

  @override
  String toString() {
    return '''
    Tour(
      id: $_id,
      dogName: $_dogName,
      breedType: $breedType,
      startDate: $_startDate,
      endDate: $_endDate,
      notes: $_notes,
      dogId: $_dogId,
      breedName: $_breedName,
      weight: $_weight,
      dailyPrice: $dailyPrice,
      ownerId: $_ownerId,
      ownerName: $_ownerName,
      alive: $alive, 
      isSelected: $isSelected, 
      sex: $sex, 
      desex: $desex, 
    )
    ''';
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'dogName': dogName,
      'dogId': dogId,
      'breedType': breedType,
      'breedName': breedName,
      'weight': weight,
      'dailyPrice': dailyPrice,
      'alive': alive,
      'ownerId': ownerId,
      'ownerName': ownerName,
      'notes': notes,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      "sex": sex,
      "desex": desex,
    };
  }

  factory Tour.fromApiResponse(Map<String, dynamic> response) {
    final data = response['data'] as Map<String, dynamic>? ?? response;

    return Tour(
      id: data['uid']?.toString() ?? data['id']?.toString() ?? "",
      dogName: data['dogName']?.toString() ?? "",
      dogId: data['dogId']?.toString() ?? "",
      breedName: data['breedName']?.toString() ?? "",
      dailyPrice: (data['dailyPrice'] as num?)?.toDouble() ?? 0.0,
      ownerId: data['ownerId']?.toString() ?? "",
      ownerName: data['ownerName']?.toString() ?? "",
      startDate: DateTime.parse(
        data['startDate']?.toString() ?? DateTime.now().toString(),
      ),
      endDate: DateTime.parse(
        data['endDate']?.toString() ?? DateTime.now().toString(),
      ),
      breedType: data['breedType']?.toString() ?? '',
      weight: (data['weight'] as num?)?.toDouble() ?? 0.0,
      alive: data['alive'] as bool? ?? true,
      notes: (data['notes'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList() ??
          const [],
      sex: data["sex"] as int? ?? 0,
      desex: data["desex"] as bool? ?? false,
    );
  }

  Tour({
    required String id,
    required String dogName,
    required String dogId,
    required String breedName,
    required double dailyPrice,
    required String ownerId,
    required String ownerName,
    required DateTime startDate,
    required DateTime endDate,
    double weight = 0.0,
    List<String> notes = const [],
    this.breedType = "",
    this.alive = true,
    this.isSelected = true,
    this.sex = 0,
    this.desex = false,
  }) : _id = id,
       _dogName = dogName,
       _dogId = dogId,
       _breedName = breedName,
       _dailyPrice = dailyPrice,
       _ownerId = ownerId,
       _ownerName = ownerName,
       _startDate = startDate,
       _endDate = endDate,
       _weight = weight,
       _notes = notes;

  // -----------
  // Getters
  // -----------
  String get id => _id;
  String get dogName => _dogName;
  String get dogId => _dogId;
  String get breedName => _breedName;
  double get weight => _weight;
  double get dailyPrice => _dailyPrice;
  String get ownerId => _ownerId;
  String get ownerName => _ownerName;
  List<String> get notes => _notes;
  DateTime get startDate => _startDate;
  DateTime get endDate => _endDate;

  Map<String, dynamic> get tourInfo => {
    'id': _id,
    'dogName': _dogName,
    'dogId': _dogId,
    'breedType': breedType,
    'breedName': _breedName,
    'weight': _weight,
    'dailyPrice': _dailyPrice,
    'alive': alive,
    'ownerId': _ownerId,
    'ownerName': _ownerName,
    'notes': _notes,
    'startDate': _startDate.toIso8601String(),
    'endDate': _endDate.toIso8601String(),
    "sex": sex,
    "desex": desex
  };

  String get tourInfoString => '''
    Tour Information:
    - ID: $_id
    - Dog Name: $_dogName (ID: $_dogId)
    - Breed: $_breedName${breedType.isNotEmpty ? ' ($breedType)' : ''}
    - sex: $sex
    - desex: $desex
    - Weight: ${_weight}kg
    - Daily Price: \$$_dailyPrice
    - Status: ${alive ? 'Alive' : 'Deceased'}
    - Owner: $_ownerName (ID: $_ownerId)
    - Dates: ${_startDate.toLocal().toString().split(' ')[0]} to ${_endDate.toLocal().toString().split(' ')[0]}
    - Notes: ${_notes.isEmpty ? 'None' : _notes.join(', ')}
  ''';

  // -----------
  // Setters
  // -----------
  set dogName(String value) {
    if (value.isEmpty) throw ArgumentError('Dog name cannot be empty');
    _dogName = value;
  }

  set breedName(String value) {
    if (value.isEmpty) throw ArgumentError('Breed name cannot be empty');
    _breedName = value;
  }

  set weight(double value) {
    if (value < 0) throw ArgumentError('Weight cannot be negative');
    _weight = value;
  }

  set dailyPrice(double value) {
    if (value < 0) throw ArgumentError('Daily price cannot be negative');
    _dailyPrice = value;
  }

  set ownerId(String value) {
    if (value.isEmpty) throw ArgumentError('Owner ID cannot be empty');
    _ownerId = value;
  }

  set ownerName(String value) {
    if (value.isEmpty) throw ArgumentError('Owner name cannot be empty');
    _ownerName = value;
  }

  set notes(List<String> value) => _notes = List.unmodifiable(value);

  set startDate(DateTime value) {
    if (value.isAfter(_endDate)) {
      throw ArgumentError('Start date must be before end date');
    }
    _startDate = value;
  }

  set endDate(DateTime value) {
    if (value.isBefore(_startDate)) {
      throw ArgumentError('End date must be after start date');
    }
    _endDate = value;
  }

  void updateTour({
    String? dogName,
    String? breedType,
    String? breedName,
    double? weight,
    bool? alive,
    List<String>? notes,
    DateTime? startDate,
    DateTime? endDate,
    double? dailyPrice,
    String? ownerId,
    String? ownerName,
    int? newSex,
    bool? newDesex
  }) {
    if (dogName != null) _dogName = dogName;
    if (breedType != null) this.breedType = breedType;
    if (breedName != null) _breedName = breedName;
    if (weight != null) _weight = weight;
    if (alive != null) this.alive = alive;
    if (notes != null) _notes = List.from(notes);
    if (startDate != null) _startDate = startDate;
    if (endDate != null) _endDate = endDate;
    if (dailyPrice != null && dailyPrice >= 0) _dailyPrice = dailyPrice;
    if (ownerId != null) _ownerId = ownerId;
    if (ownerName != null) _ownerName = ownerName;

    if (startDate != null || endDate != null) {
      if (_startDate.isAfter(_endDate)) {
        throw ArgumentError('Start date must be before end date');
      }
    }
    if (newSex != null) sex = newSex;
    if (newDesex != null) desex = newDesex;
  }
}
