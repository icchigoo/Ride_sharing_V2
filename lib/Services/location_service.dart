import 'dart:async';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'as convert;

class LocationService {
  final String? key=dotenv.env['GOOGLE_API_KEY'];


  Future<String> getPlaceId(String input) async{
    final String url = 'https://maps.googleapis.com/maps/api/place/findplacefromtext/json?input=$input&inputtype=textquery&key=$key';
    var response = await http.get(Uri.parse(url));
    var json = convert.jsonDecode(response.body);
    var placeId = json['candidates'][0]['place_id'] as String;
    return placeId; // actual place id
  }

  Future<Map<String,dynamic>> getPlace(String input) async{
    final placeId = await getPlaceId(input);
    final String url = 'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$key';
    var response = await http.get(Uri.parse(url));
    var json = convert.jsonDecode(response.body);
    var results = json['result'] as Map<String,dynamic>;

    print(results);
    return results;
  }

  Future<Map<String,dynamic>> getDirections(String origin, String destination) async{
    final String url =
        'https://maps.googleapis.com/maps/api/directions/json?origin=place_id:$origin&destination=place_id:$destination&key=$key';
    var response = await http.get(Uri.parse(url));
    var json = convert.jsonDecode(response.body);

    var results = {
      'bounds_ne':json['routes'][0]['bounds']['northeast'],
      'bounds_sw':json['routes'][0]['bounds']['southwest'],
      'start_location':json['routes'][0]['legs'][0]['start_location'],
      'end_location':json['routes'][0]['legs'][0]['end_location'],
      'polyline':json['routes'][0]['overview_polyline']['points'],
    };
    print(results);
    print("BENİ BUL 4352");
    return results;
  }

}