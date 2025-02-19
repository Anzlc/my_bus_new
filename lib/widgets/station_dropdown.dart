import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:my_bus_new/stations.dart';

// Create a new stateless widget for DropdownSearch
class StationDropdown extends StatelessWidget {
  final Station selectedItem;
  final Function onChanged;

  const StationDropdown({
    Key? key,
    required this.selectedItem,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: DropdownSearch<Station>(
        selectedItem: selectedItem,
        onChanged: (value) {
          if (value != null) {
            onChanged(value);
          }
        },
        popupProps: PopupProps.modalBottomSheet(
          showSearchBox: true,
          searchDelay: Duration.zero,
          itemBuilder: (context, item, isSelected) {
            return SizedBox(
              height: 60,
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      item.name + " (${item.id})",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                    const Padding(padding: EdgeInsets.all(6)),
                    Visibility(
                      visible: item.toCenter,
                      child: Container(
                        padding: const EdgeInsets.all(3),
                        decoration: BoxDecoration(
                          color: Colors.amber.shade700,
                          borderRadius: const BorderRadius.all(
                            Radius.circular(5),
                          ),
                        ),
                        child: const Text(
                          "To Center",
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
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
        items: StationLoader.stations,
        itemAsString: (item) => item.name + " (${item.id})",
      ),
    );
  }
}
