import 'dart:convert';

class Arrival {
  final bool isLowfloored;
  final DateTime time;
  final int minutes;
  final int type;
  final String additionalInfo;

  Arrival({
    required this.isLowfloored,
    required this.time,
    required this.minutes,
    required this.type,
    required this.additionalInfo,
  });

  @override
  String toString() {
    if (additionalInfo == "") {
      return minutes.toString();
    } else if (additionalInfo == "*") {
      return "*$minutes";
    } else if (additionalInfo == "PRIHOD") {
      return "ARRIVING";
    } else {
      return minutes.toString();
    }
  }

  factory Arrival.fromJson(Map<String, dynamic> json) {
    return Arrival(
      isLowfloored: json['isLowfloored'],
      time: DateTime.parse(json['time']),
      minutes: json['minutes'],
      type: json['type'],
      additionalInfo: json['additionalInfo'] ?? '',
    );
  }
}

class ArrivalsGroup {
  final List<Arrival> arrivals;
  final String busId;
  final String? busNameFrom;
  final String busNameTo;

  ArrivalsGroup({
    required this.arrivals,
    required this.busId,
    required this.busNameFrom,
    required this.busNameTo,
  });

  factory ArrivalsGroup.fromJson(Map<String, dynamic> json) {
    final List<dynamic> arrivalsList = json['arrivals'];
    final List<Arrival> arrivals = arrivalsList
        .map((arrivalJson) => Arrival.fromJson(arrivalJson))
        .toList();

    return ArrivalsGroup(
      arrivals: arrivals,
      busId: json['busId'],
      busNameFrom: json['busNameFrom'],
      busNameTo: json['busNameTo'],
    );
  }

  String gen_minutes_string() {
    if (arrivals.length >= 2) {
      return "${arrivals[0]} ${arrivals[1]}";
    } else if (arrivals.length == 1) {
      return arrivals[0].toString();
    } else {
      // Should never happen because the api does not return empty arrivals
      return "";
    }
  }

  int compareTo(ArrivalsGroup other) {
    // Check if the arrivals list is not empty

    return arrivals[0].minutes.compareTo(other.arrivals[0].minutes);
  }
}

List<ArrivalsGroup> parseArrivalsGroups(String jsonString) {
  final Map<String, dynamic> jsonData = json.decode(jsonString);
  final List<dynamic> arrivalsList = jsonData['arrivals'];

  return arrivalsList
      .map((groupJson) => ArrivalsGroup.fromJson(groupJson))
      .toList();
}

String getStationName(String jsonString) {
  final Map<String, dynamic> jsonData = json.decode(jsonString);
  if (jsonData.containsKey("busStationName")) {
    return jsonData["busStationName"];
  }
  return "err";
}
