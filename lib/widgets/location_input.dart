import 'dart:convert';

import 'package:favourite_place/models/place.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:http/http.dart' as http;

class LocationInput extends StatefulWidget {
  const LocationInput({super.key});

  @override
  State<LocationInput> createState() => _LocationInputState();
}

class _LocationInputState extends State<LocationInput> {
  PlaceLocation? _pickedLocation;
  var _isGettingLocation = false;

  String get locationName {
    if (_pickedLocation == null) {
      return " ";
    }

    final lat = _pickedLocation.latitude;
    final lng = _pickedLocation.longitude;
  }

  void _getCurrentLocation() async {
    setState(() {
      _isGettingLocation = true;
    });
    Location location = Location();

    bool serviceEnabled;
    PermissionStatus permissionGranted;
    LocationData locationData;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    setState(() {
      _pickedLocation =
          PlaceLocation(latitude: lat!, longitude: lng, address: address);
      _isGettingLocation = true;
    });

    locationData = await location.getLocation();
    final lat = locationData.latitude;
    final lng = locationData.longitude;

    if (lng == null || lat == null) {
      return;
    }

    final url = Uri.parse(
        'https://geocode.maps.co/reverse?lat=$lat&lon=$lng&api_key=65e318feb4656620262839amj2feb56');
    final response = await http.get(url);
    final resData = json.decode(response.body);
    final address = resData['adress']['display_name'];

    setState(() {
      _pickedLocation =
          PlaceLocation(latitude: lat, longitude: lng, address: address);
      _isGettingLocation = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget previewContent = Text(
      "No location chosen",
      textAlign: TextAlign.center,
      style: Theme.of(context)
          .textTheme
          .bodyLarge!
          .copyWith(color: Theme.of(context).colorScheme.onBackground),
    );

    if (_isGettingLocation) {
      previewContent = LoadingAnimationWidget.fallingDot(
        color: const Color.fromARGB(255, 133, 243, 48),
        size: 50,
      );
    }

    return Column(
      children: [
        Container(
          height: 170,
          width: double.infinity,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            border: Border.all(
              width: 1,
              color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
            ),
          ),
          child: previewContent,
        ),
        const SizedBox(
          height: 16,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextButton.icon(
              onPressed: _getCurrentLocation,
              icon: const Icon(Icons.location_on),
              label: const Text("Get Current Location"),
            ),
            TextButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.map),
              label: const Text("Select on Map"),
            )
          ],
        )
      ],
    );
  }
}

//{
//     "place_id": 183436571,
//     "licence": "Data © OpenStreetMap contributors, ODbL 1.0. https://osm.org/copyright",
//     "osm_type": "relation",
//     "osm_id": 15678030,
//     "lat": "40.649996",
//     "lon": "61.14000778104385",
//     "display_name": "Darganata District, Lebap Region, 746240, Turkmenistan",
//     "address": {
//         "county": "Darganata District",
//         "state": "Lebap Region",
//         "ISO3166-2-lvl4": "TM-L",
//         "postcode": "746240",
//         "country": "Turkmenistan",
//         "country_code": "tm"
//     },
//     "boundingbox": [
//         "39.9978125",
//         "41.2908946",
//         "60.1855573",
//         "62.3931646"
//     ]
// }