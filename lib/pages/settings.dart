import 'package:cool_alert/cool_alert.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:my_bus_new/settings_handler.dart';
import 'package:my_bus_new/stations.dart';
import 'package:my_bus_new/widgets/station_dropdown.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  Station from_home = StationLoader.stations[0];
  Station from_work = StationLoader.stations[0];
  String line = StationLoader.lines[0];

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      String home =
          await SettingsHandler.get("home") ?? StationLoader.stations[0].id;
      String work =
          await SettingsHandler.get("work") ?? StationLoader.stations[0].id;
      String l = await SettingsHandler.get("line") ?? StationLoader.lines[0];

      setState(() {
        from_home =
            StationLoader.stations.where((element) => element.id == home).first;
        from_work =
            StationLoader.stations.where((element) => element.id == work).first;
        line = l;
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey.shade900,
        title: const Text("Settings"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Padding(padding: EdgeInsets.all(20)),
            const Text(
              "From home",
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.w900),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: StationDropdown(
                  selectedItem: from_home,
                  onChanged: (e) {
                    from_home = e;
                  }),
            ),
            const Padding(padding: EdgeInsets.all(10)),
            const Text("From work",
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.w900)),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: StationDropdown(
                  selectedItem: from_work,
                  onChanged: (e) {
                    from_work = e;
                  }),
            ),
            const Text("Line",
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.w900)),
            Padding(
                padding: const EdgeInsets.all(18.0),
                child: DropdownSearch<String>(
                  selectedItem: line,
                  onChanged: (value) {
                    if (value != null) {
                      line = value;
                    }
                  },
                  popupProps: PopupProps.modalBottomSheet(
                    showSearchBox: true,
                    searchDelay: Duration.zero,
                    modalBottomSheetProps: ModalBottomSheetProps(
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(10),
                          bottom: Radius.zero,
                        ),
                      ),
                      backgroundColor: Colors.blueGrey.shade900,
                    ),
                  ),
                  items: StationLoader.lines,
                )),
            const Padding(padding: EdgeInsets.all(20)),
            TextButton(
              onPressed: () async {
                try {
                  await SettingsHandler.set("home", from_home.id);
                  await SettingsHandler.set("work", from_work.id);
                  await SettingsHandler.set("line", line);
                  if (mounted) {
                    CoolAlert.show(
                      context: context,
                      title: "Success",
                      type: CoolAlertType.success,
                      text: "Successfully saved!",
                    );
                  }
                } catch (e) {
                  if (mounted) {
                    CoolAlert.show(
                      context: context,
                      type: CoolAlertType.error,
                      text: "Error while saving data!",
                    );
                  }
                }
                print("Saved");
              },
              child: const Padding(
                padding: EdgeInsets.all(5.0),
                child: Text("Save"),
              ),
              style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.blue),
                  foregroundColor:
                      MaterialStateProperty.all<Color>(Colors.white)),
            )
          ],
        ),
      ),
    );
  }
}
