import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_bus_new/bus.dart';
import 'package:my_bus_new/bus_parser.dart';
import 'package:my_bus_new/stations.dart';
import 'package:my_bus_new/widgets/arrivals_modal.dart';
import 'package:my_bus_new/widgets/station_dropdown.dart';
import 'package:visibility_detector/visibility_detector.dart';

class Stations extends StatefulWidget {
  final Station station;
  Stations({Key? key, required this.station}) : super(key: key);

  @override
  _StationsState createState() => _StationsState();
}

class _StationsState extends State<Stations>
    with AutomaticKeepAliveClientMixin {
  List<ArrivalsGroup> arrivalGroups = List.empty();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  late Station station;
  Future refresh() async {
    if (!mounted) {
      return;
    }
    print(station.id);
    arrivalGroups = await fetchArrivals(station.id);
    arrivalGroups.sort((a, b) => a.compareTo(b));
    setState(() {
      arrivalGroups = arrivalGroups;
    });
  }

  @override
  void initState() {
    station = widget.station;

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await refresh();
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return VisibilityDetector(
      key: const Key("stations"),
      onVisibilityChanged: (info) {
        var visiblePercentage = info.visibleFraction * 100;

        if (visiblePercentage == 100) {
          _refreshIndicatorKey.currentState?.show();
        }
      },
      child: Column(
        children: [
          const Padding(padding: EdgeInsets.all(4)),
          const Text(
            "Select station",
            style: TextStyle(fontSize: 16),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: StationDropdown(
              selectedItem: widget.station,
              onChanged: (value) {
                setState(() {
                  station = value;
                });
                _refreshIndicatorKey.currentState?.show();
              },
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              key: _refreshIndicatorKey,
              child: ListView.builder(
                itemCount: arrivalGroups.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    onTap: () {
                      showModalBottomSheet(
                          context: context,
                          builder: (BuildContext context) {
                            return ArrivalsModal(
                                group: arrivalGroups[index],
                                id: station.id,
                                station_name: station.name);
                          });
                    },
                    title: Text(arrivalGroups[index].busNameTo),
                    leading: Container(
                      decoration: BoxDecoration(
                          color: Colors.amber.shade700,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(5))),
                      child: Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: Text(
                          arrivalGroups[index]
                              .busId
                              .replaceFirst(RegExp("0"), ""),
                          style: GoogleFonts.geologica(
                              textStyle: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700)),
                        ),
                      ),
                    ),
                    trailing: Text(arrivalGroups[index].gen_minutes_string()),
                  );
                },
              ),
              onRefresh: () async {
                return refresh();
              },
            ),
          )
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
