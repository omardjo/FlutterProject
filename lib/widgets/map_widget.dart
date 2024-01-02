import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../model/ZoneDeDanger.dart';
import '../model/Catastrophe.dart';

class MapWidget extends StatelessWidget {
  final List<ZoneDeDanger> zoneDeDangerList;
  final List<Catastrophe> catastropheList;
  final LatLng? chosenLocation;
  final MapController mapController;
  final bool buttonState;
  final Function(LatLng) onMapTap;
  final Function() toggleButtonState;

  const MapWidget({
    Key? key,
    required this.zoneDeDangerList,
    required this.catastropheList,
    required this.chosenLocation,
    required this.mapController,
    required this.buttonState,
    required this.onMapTap,
    required this.toggleButtonState,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      mapController: mapController,
      options: MapOptions(
        onTap: (_, point) => onMapTap(point),
        initialCenter: LatLng(51.509364, -0.128928),
        initialZoom: 2.2,
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.example.app',
        ),
        MarkerLayer(
          markers: [
            if (chosenLocation != null)
              Marker(
                point: chosenLocation!,
                width: 80,
                height: 80,
                child: Icon(Icons.location_on, size: 40, color: Colors.blue),
              ),
          ],
        ),
        MarkerLayer(
          markers: zoneDeDangerList.map((zone) {
            return Marker(
              point: LatLng(
                zone.latitudeDeZoneDanger,
                zone.longitudeDeZoneDanger,
              ),
              width: 80,
              height: 80,
              child: Icon(
                Icons.location_pin,
                color: Color.fromARGB(255, 217, 112, 0),
                size: 40,
              ),
            );
          }).toList(),
        ),
        CircleLayer(
          circles: catastropheList.map((catastrophe) {
            double radius = catastrophe.radius * 1000;
            LatLng center = LatLng(
              catastrophe.latitudeDeCatastrophe,
              catastrophe.longitudeDeCatastrophe,
            );

            return CircleMarker(
              point: center,
              color: const Color.fromARGB(255, 229, 15, 0).withOpacity(0.4),
              useRadiusInMeter: true,
              radius: radius,
            );
          }).toList(),
        ),
        Align(
          alignment: Alignment.topRight,
          child: Column(
            children: [
              FloatingActionButton(
                heroTag: "btn1",
                mini: true,
                child: Icon(Icons.add),
                onPressed: () {
                  mapController.move(
                    mapController.center,
                    mapController.zoom + 1,
                  );
                },
              ),
              SizedBox(height: 10),
              FloatingActionButton(
                heroTag: "btn2",
                mini: true,
                child: Icon(Icons.remove),
                onPressed: () {
                  mapController.move(
                    mapController.center,
                    mapController.zoom - 1,
                  );
                },
              ),
            ],
          ),
        ),
        Align(
          alignment: Alignment.bottomRight,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.0),
              ),
              primary: buttonState ? Colors.green : Colors.grey,
              onPrimary: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              textStyle: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              elevation: 10,
            ),
            onPressed: toggleButtonState,
            child: Text(buttonState ? 'Button is ON' : 'Button is OFF'),
          ),
        ),
      ],
    );
  }
}
