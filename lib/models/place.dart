import 'package:uuid/uuid.dart';
//This package can efficiently generate all the unique IDs you need in your Flutter app

const uuid = Uuid();

class Place {
  Place({required this.title}) : id = uuid.v4();

  final String id;
  final String title;
}