import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

class Station {
  final String name;
  final bool toCenter;
  final String id;

  Station({required this.name, required this.toCenter, required this.id});

  factory Station.fromJson(Map<String, dynamic> json) {
    return Station(
      name: json['name'],
      toCenter: json['to_center'],
      id: json['id'],
    );
  }
}

class StationLoader {
  static List<Station> _stations = [];
  static Map<String, Station> _stationMap = {};
  static List<String> lines = [
    "1",
    "1B",
    "N1",
    "2",
    "3",
    "3B",
    "3G",
    "N3",
    "N3B",
    "5",
    "N5",
    "6",
    "6B",
    "7",
    "7L",
    "8",
    "9",
    "10",
    "11",
    "11B",
    "12",
    "12D",
    "13",
    "14",
    "15",
    "16",
    "18",
    "18L",
    "19",
    "19I",
    "19Z",
    "20",
    "20Z",
    "21",
    "21Z",
    "22",
    "23",
    "24",
    "25",
    "26",
    "27",
    "30",
    "51",
    "52",
    "53",
    "56",
    "60",
    "61"
  ];

  static List<Station> get stations => _stations;
  static Map<String, Station> get stationMap => _stationMap;

  static Future<void> loadStations() async {
    try {
      // Load the JSON file
      String jsonString = await rootBundle.loadString('assets/stations.json');

      // Parse the JSON data
      List<dynamic> jsonData = json.decode(jsonString)['stations'];

      // Create stations list and station map
      _stations = jsonData.map((json) => Station.fromJson(json)).toList();
      _stationMap = Map.fromIterable(
        _stations,
        key: (station) => station.id,
        value: (station) => station,
      );
    } catch (e) {
      print('Error loading stations: $e');
    }
  }
}
