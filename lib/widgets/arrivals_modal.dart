import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_bus_new/bus.dart';
import 'package:my_bus_new/bus_parser.dart';

class ArrivalsModal extends StatefulWidget {
  final ArrivalsGroup group;
  final String id;
  final String station_name;
  const ArrivalsModal(
      {super.key,
      required this.group,
      required this.id,
      required this.station_name});
  @override
  State<ArrivalsModal> createState() => _ArrivalsModalState();
}

class _ArrivalsModalState extends State<ArrivalsModal> {
  String line = "";
  String from = "";

  String station = "";

  Future refresh() async {
    ArrivalsGroup group = await fetchBus(widget.id, widget.group.busId);
    String stationName = await fetchStationName(widget.id);
    if (!mounted) {
      return;
    }
    if (group.busId == "err") {
      // setState(() {
      //   line = "";
      //   from = "";
      //   time = "Error";
      //   minutes = "An error occurred";
      //   station = "";
      //   next = "";
      // });
    } else {
      setState(() {
        line = group.busId;
        from = "To: " + group.busNameTo;

        station = stationName;
      });
    }
  }

  @override
  void initState() {
    setState(() {
      line = widget.group.busId;
      from = "To: " + widget.group.busNameTo;
      station = widget.station_name;
    });

    refresh().then((value) => null);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.blueGrey.shade900,
          borderRadius: const BorderRadius.vertical(
              top: Radius.circular(15), bottom: Radius.zero)),
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            const Padding(padding: EdgeInsets.all(10)),
            Text(
              station,
              style: const TextStyle(fontSize: 30, fontWeight: FontWeight.w600),
            ),
            Text(
              from,
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey.shade400),
            ),
            Container(
              decoration: BoxDecoration(
                  color: Colors.amber.shade700,
                  borderRadius: BorderRadius.circular(6)),
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Text(line,
                    style: const TextStyle(
                        height: 0.85,
                        fontSize: 35,
                        color: Colors.black,
                        fontWeight: FontWeight.w900)),
              ),
            ),
            const Padding(padding: EdgeInsets.all(6)),
            const Text("Arrivals:"),
            Expanded(
              child: RefreshIndicator(
                displacement: 15,
                onRefresh: () async {
                  await refresh();
                },
                child: ListView.builder(
                    itemCount: widget.group.arrivals.length,
                    itemBuilder: (BuildContext context, int index) {
                      Arrival arrival = widget.group.arrivals[index];
                      String time = DateFormat("HH:mm").format(DateTime.now()
                          .add(Duration(minutes: arrival.minutes)));
                      String minutes =
                          "${arrival.additionalInfo == "*" ? "*" : ""}${arrival.minutes}";
                      return Column(
                        children: [
                          Text(
                            time,
                            style: const TextStyle(
                                fontSize: 42, fontWeight: FontWeight.w900),
                          ),
                          Text(
                            "Arriving in ${minutes} minutes",
                            style: const TextStyle(
                                fontSize: 12, fontWeight: FontWeight.w500),
                          ),
                          const Padding(padding: EdgeInsets.all(12))
                        ],
                      );
                    }),
              ),
            )
          ],
        ),
      ),
    );
  }
}
