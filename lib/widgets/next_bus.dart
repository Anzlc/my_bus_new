import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_bus_new/bus.dart';
import 'package:my_bus_new/bus_parser.dart';
import 'package:intl/intl.dart';
import 'package:my_bus_new/pages/station.dart';
import 'package:my_bus_new/settings_handler.dart';
import 'package:my_bus_new/stations.dart';
import 'package:visibility_detector/visibility_detector.dart';

class NextBus extends StatefulWidget {
  final String label;
  final String line;

  NextBus({Key? key, required this.label, required this.line})
      : super(key: key);

  static GlobalKey<_NextBusState> nextBusKey = GlobalKey<_NextBusState>();

  @override
  _NextBusState createState() => _NextBusState();
}

class _NextBusState extends State<NextBus> with AutomaticKeepAliveClientMixin {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  String line = "";
  String from = "";
  String time = "";
  String minutes = "Fetching data...";
  String station = "";
  String next = "";

  Future refresh() async {
    String line2 = await SettingsHandler.get("line") ?? StationLoader.lines[0];

    ArrivalsGroup group = await fetchBus(
        await SettingsHandler.get(widget.label) ?? StationLoader.stations[0].id,
        line2);
    String stationName = await fetchStationName(
        await SettingsHandler.get(widget.label) ??
            StationLoader.stations[0].id);
    if (!mounted) {
      return;
    }
    if (group.busId == "err") {
      setState(() {
        line = "";
        from = "";
        time = "Error";
        minutes = group.busNameTo;
        station = stationName;
        next = "";
      });
    } else {
      String star = "";
      if (group.arrivals.length >= 2) {
        if (group.arrivals[1].additionalInfo == "*") {
          star = "*";
        }
        next = "Next in $star${group.arrivals[1].minutes} minutes";
      } else {
        next = "";
      }
      star = "";
      setState(() {
        line = group.busId;
        if (group.arrivals[0].additionalInfo == "*") {
          star = "*";
        }
        from = "To: " + group.busNameTo;
        time = DateFormat("HH:mm").format(
            DateTime.now().add(Duration(minutes: group.arrivals[0].minutes)));
        minutes =
            "Arriving in $star${group.arrivals[0].minutes.toString()} minutes";
        station = stationName;
        next = next;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await refresh();
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return VisibilityDetector(
      key: Key("next${widget.label}"),
      onVisibilityChanged: (info) {
        var visiblePercentage = info.visibleFraction * 100;

        if (visiblePercentage == 100) {
          _refreshIndicatorKey.currentState?.show();
        }
      },
      child: RefreshIndicator(
          key: _refreshIndicatorKey,
          onRefresh: () async {
            return refresh();
          },
          child: Column(children: [
            Expanded(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () => {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Scaffold(
                                  appBar: AppBar(
                                    title: Text("All arrivals"),
                                    backgroundColor: Colors.blueGrey.shade900,
                                  ),
                                  body: Stations(
                                      station: StationLoader.stations
                                          .where((element) =>
                                              element.name == station)
                                          .first),
                                )))
                  },
                  child: Text(
                    station,
                    style: GoogleFonts.poppins(
                        textStyle:
                            const TextStyle(fontWeight: FontWeight.w800)),
                  ),
                ),
                Text(
                  from,
                  style: GoogleFonts.poppins(
                      textStyle: const TextStyle(fontSize: 20)),
                ),
                Text(
                  line,
                  style: GoogleFonts.poppins(
                      textStyle: const TextStyle(
                          fontSize: 32, fontWeight: FontWeight.w800)),
                ),
                Text(time,
                    style: GoogleFonts.montserrat(
                        textStyle: const TextStyle(
                            fontSize: 110, fontWeight: FontWeight.w800))),
                Text(
                  minutes,
                  style: const TextStyle(fontWeight: FontWeight.w800),
                ),
                Text(
                  next,
                  style: const TextStyle(
                      fontSize: 12, fontWeight: FontWeight.w300),
                ),
              ],
            )),
            Expanded(
                child: Container(
                    width: double.infinity,
                    child: TextButton(
                      onPressed: () =>
                          {_refreshIndicatorKey.currentState?.show()},
                      child: Text(
                        "Tap to refresh",
                        style: GoogleFonts.poppins(),
                      ),
                      style: TextButton.styleFrom(
                          shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5)))),
                    )))
          ])),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
