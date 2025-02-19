import "bus_parser.dart";
import 'package:http/http.dart' as http;

Future<ArrivalsGroup> fetchBus(String id, String line) async {
  final response = await http
      .get(Uri.parse('https://prominfo.projekti.si/lpp_rc/api/' + id));

  if (response.statusCode == 200) {
    try {
      return parseArrivalsGroups(response.body)
          .where(
              (element) => element.busId == line || element.busId == "0" + line)
          .single;
    } catch (err) {
      print(err);
      return ArrivalsGroup(
          arrivals: [],
          busId: "err",
          busNameFrom: "",
          busNameTo: "No buses found");
    }
  } else {
    return ArrivalsGroup(
        arrivals: [],
        busId: "err",
        busNameFrom: "",
        busNameTo: "Error occurred");
  }
}

Future<List<ArrivalsGroup>> fetchArrivals(String id) async {
  final response = await http
      .get(Uri.parse('https://prominfo.projekti.si/lpp_rc/api/' + id));

  if (response.statusCode == 200) {
    try {
      return parseArrivalsGroups(response.body);
    } catch (err) {
      return List.empty();
    }
  } else {
    return List.empty();
  }
}

Future<String> fetchStationName(String id) async {
  final response = await http
      .get(Uri.parse('https://prominfo.projekti.si/lpp_rc/api/' + id));

  if (response.statusCode == 200) {
    return getStationName(response.body);
  }

  return "err2";
}
