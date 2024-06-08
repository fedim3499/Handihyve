import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart' as geolocator;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as location;
import 'package:http/http.dart' as http;
import 'package:location/location.dart';

enum MapPageMode { select, view }

class MapPage extends StatefulWidget {
  final MapPageMode mode;
  final double? latitude;
  final double? longitude;

  const MapPage({Key? key, required this.mode, this.latitude, this.longitude}) : super(key: key);

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  bool _isLoading = false;
  String latuser = '0';
  String longuser = '0';
  location.Location _locationController = location.Location();
  Set<Marker> _markers = {};
  bool _isLoadingButton = false;
  GoogleMapController? _googleMapController;

  static final CameraPosition _kGoogle = const CameraPosition(
    target: LatLng(37.42796133580664, -122.885749655962),
    zoom: 14.4746,
  );

  Future<bool> _requestLocationPermission() async {
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    _serviceEnabled = await _locationController.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await _locationController.requestService();
      if (!_serviceEnabled) {
        return false;
      }
    }
    _permissionGranted = await _locationController.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await _locationController.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return false;
      }
    }
    return true;
  }

  Future<geolocator.Position> _getCurrentLocation() async {
    bool serviceEnabled = await geolocator.Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Location services are disabled.');
    }

    geolocator.LocationPermission permission = await geolocator.Geolocator.checkPermission();
    if (permission == geolocator.LocationPermission.denied) {
      permission = await geolocator.Geolocator.requestPermission();
      if (permission == geolocator.LocationPermission.denied) {
        throw Exception('Location permissions are denied.');
      }
    }

    if (permission == geolocator.LocationPermission.deniedForever) {
      throw Exception('Location permissions are permanently denied, we cannot request permissions.');
    }

    return await geolocator.Geolocator.getCurrentPosition();
  }

  void _setMyLocation() async {
    try {
      geolocator.Position position = await _getCurrentLocation();
      Map<String, String> locationInfo = await getAddressAndCityFromCoordinates(position.latitude, position.longitude);

      setState(() {
        latuser = '${position.latitude}';
        longuser = '${position.longitude}';
      });
      print("Lat : $latuser");
      print("Long : $longuser");
      _addMarker(position.latitude, position.longitude);

      // Move camera to current location
      _googleMapController?.animateCamera(CameraUpdate.newLatLng(
        LatLng(double.parse(latuser), double.parse(longuser)),
      ));

      // Add marker for current location
      await Future.delayed(Duration(seconds: 1));
      // Zoom to the marker position
      _googleMapController?.animateCamera(CameraUpdate.newLatLngZoom(
        LatLng(double.parse(latuser), double.parse(longuser)),
        25, // Zoom level
      ));
    } catch (e) {
      print('Error fetching location: $e');
    }
  }

  Future<Map<String, String>> getAddressAndCityFromCoordinates(double latitude, double longitude) async {
    try {
      String apiUrl = 'https://nominatim.openstreetmap.org/reverse?format=json&lat=$latitude&lon=$longitude';
      var response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        Map<String, dynamic> data = json.decode(response.body);
        String displayName = data['display_name'] ?? '';
        List<String> addressComponents = displayName.split(', ');
        String municipalite = addressComponents.first;
        String residential = addressComponents.length > 1 ? addressComponents[1] : '';
        String city = addressComponents.length > 2 ? addressComponents[2] : '';
        String address = data['address'] != null ? data['address'].toString() : '';
        return {'address': address, 'city': city, 'municipalite': municipalite, 'residential': residential};
      } else {
        throw Exception('Failed to load address');
      }
    } catch (e) {
      print('Error fetching location: $e');
      throw Exception('Failed to load address');
    }
  }

  void _addMarker(double latitude, double longitude) {
    final marker = Marker(
      markerId: MarkerId('my_location'),
      position: LatLng(latitude, longitude),
      infoWindow: InfoWindow(title: 'My Location'),
      draggable: widget.mode == MapPageMode.select,
      onDragEnd: (LatLng newPosition) {
        _updateMarker(newPosition.latitude, newPosition.longitude);
      },
    );
    setState(() {
      _markers.clear();
      _markers.add(marker);
    });
  }

  void _updateMarker(double latitude, double longitude) {
    setState(() {
      _markers.clear();
      _markers.add(
        Marker(
          markerId: MarkerId('my_location'),
          position: LatLng(latitude, longitude),
          infoWindow: InfoWindow(title: 'My Location'),
          draggable: widget.mode == MapPageMode.select,
          onDragEnd: (LatLng newPosition) {
            _updateMarker(newPosition.latitude, newPosition.longitude);
          },
        ),
      );
    });
  }

  void _selectLocationAndPop() {
    LatLng selectedLocation = _markers.first.position;
    Navigator.pop(context, selectedLocation);
  }

  @override
  void initState() {
    super.initState();
    if (widget.mode == MapPageMode.select) {
      _requestLocationPermission().then((granted) {
        if (granted) {
          _setMyLocation();
        }
      });
    } else if (widget.mode == MapPageMode.view && widget.latitude != null && widget.longitude != null) {
      _addMarker(widget.latitude!, widget.longitude!);
      _googleMapController?.animateCamera(CameraUpdate.newLatLngZoom(
        LatLng(widget.latitude!, widget.longitude!),
        14.4746,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.mode == MapPageMode.select ? 'Pick location' : 'View location'),
      ),
      body: Stack(
        children: [
          GoogleMap(
            onMapCreated: (controller) {
              _googleMapController = controller;
              if (widget.mode == MapPageMode.view && widget.latitude != null && widget.longitude != null) {
                _googleMapController?.animateCamera(CameraUpdate.newLatLngZoom(
                  LatLng(widget.latitude!, widget.longitude!),
                  14.4746,
                ));
              }
            },
            mapType: MapType.normal,
            initialCameraPosition: CameraPosition(
              target: LatLng(47.4358055, 8.4737324),
              zoom: 10,
            ),
            markers: _markers,
            onLongPress: widget.mode == MapPageMode.select
                ? (LatLng position) {
                    _addMarker(position.latitude, position.longitude);
                  }
                : null,
          ),
          if (widget.mode == MapPageMode.select)
            Positioned(
              left: 0,
              right: 0,
              bottom: 16,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: FloatingActionButton.extended(
                  onPressed: _selectLocationAndPop,
                  label: Text('Select this location'),
                  icon: Icon(Icons.check),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
