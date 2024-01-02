import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:safeguard/pages/widgets/card_stat.dart';
import 'package:safeguard/model/ZoneDeDanger.dart';
import 'package:safeguard/services/ApiZoneDeDanger.dart';
import 'package:safeguard/services/ApiCatastrophe.dart';
import 'package:safeguard/model/Catastrophe.dart';
import 'map_widget.dart';
import 'table_map.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  List<ZoneDeDanger> zoneDeDangerList = [];
  List<Catastrophe> catastropheList = [];
  MapController mapController = MapController();
  bool showMap = true; // Flag to toggle between map and TableMap

  bool _buttonState = false;
  LatLng? chosenLocation;

  @override
  void initState() {
    super.initState();
    // Fetch zone de danger data when the page loads
    _fetchZoneDeDangerData();
    _fetchCatastropheData();
  }

  Future<void> _fetchCatastropheData() async {
    try {
      List<Catastrophe> ca = await ApiCatastrophe.getCatastrophe();
      setState(() {
        catastropheList = ca;
        print(catastropheList.length);
      });
    } catch (e) {
      // Handle errors (e.g., display an error message)
      print('Error fetching catastrophe data: $e');
    }
  }

  Future<void> _fetchZoneDeDangerData() async {
    // Fetch zone de danger data from API
    List<ZoneDeDanger> zones = await ApiZoneDeDanger.getZoneDeDanger();
    // Update the state with the fetched data
    setState(() {
      zoneDeDangerList = zones;
    });
  }

  // Function to toggle the boolean variable
  void _toggleButtonState() {
    setState(() {
      _buttonState = !_buttonState;
    });
  }

  void _toggleMap() {
    setState(() {
      showMap = !showMap;
    });
  }

  void _refreshZoneDeDangerList() {
    _fetchZoneDeDangerData(); // Refetch the data
  }

  void _onMapTap(LatLng point) {
    if (_buttonState == true) {
      double latitude = point.latitude;
      double longitude = point.longitude;
      zoneDeDangerList = [
        ...zoneDeDangerList,
        ZoneDeDanger.forPost(
          // Use the new constructor for POST request
          idUser: "655e4c47650e78450f573b6a",
          latitudeDeZoneDanger: latitude,
          longitudeDeZoneDanger: longitude,
        ),
      ];

      chosenLocation = LatLng(latitude, longitude);
      ApiZoneDeDanger.createZoneDeDanger(
          "655e4c47650e78450f573b6a", latitude, longitude);

      setState(() {});
    } else {
      setState(() {
        chosenLocation = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Map')),
      body: Row(
        children: [
          Expanded(
            child: Container(
              width: MediaQuery.of(context).size.width / 2.5,
              height: MediaQuery.of(context).size.height,
              color: const Color(0xFFf2f6fe),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CardStat(
                    title: 'Nombre Zone de Danger',
                    randomNumber: zoneDeDangerList.length,
                  ),
                  ElevatedButton(
                    onPressed: _toggleMap,
                    child: Text(showMap ? 'Show Table Map' : 'Show Map'),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: showMap
                ? MapWidget(
                    catastropheList: catastropheList,
                    zoneDeDangerList: zoneDeDangerList,
                    chosenLocation: chosenLocation,
                    mapController: mapController,
                    buttonState: _buttonState,
                    onMapTap: _onMapTap,
                    toggleButtonState: _toggleButtonState,
                  )
                : TableMap(
                    zoneDeDangerList: zoneDeDangerList,
                    catastropheList: catastropheList,
                    onZoneDeDangerDeleted: _refreshZoneDeDangerList,
                  ),
          ),
        ],
      ),
    );
  }
}
