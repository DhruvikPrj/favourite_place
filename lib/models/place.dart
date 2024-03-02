import 'dart:io';

import 'package:uuid/uuid.dart';
//This package can efficiently generate all the unique IDs you need in your Flutter app

const uuid = Uuid();

class PlaceLocation {
  PlaceLocation(
      {required this.latitude, required this.longitude, required this.address});

  final double latitude;
  final double longitude;
  final String address;
}

class Place {
  Place({required this.image, required this.title, required this.location})
      : id = uuid.v4();

  final String id;
  final String title;
  final File image;
  final PlaceLocation location;
}
