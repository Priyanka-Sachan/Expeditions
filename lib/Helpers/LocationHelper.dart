import 'package:http/http.dart' as http;
import 'dart:convert';

const GOOGLE_API_KEY = 'AIzaSyBg9yn5JtQgKRFbg6FCTy4ewbF24kRuAYI';

class LocationHelper {
  static String generateLocationPreview({double? latitude, double? longitude}) {
    // Since i don't have valid API key
    // return 'https://maps.googleapis.com/maps/api/staticmap?center=&$latitude,$longitude&zoom=13&size=600x300&maptype=roadmap &markers=color:red%7Clabel:C%7C$latitude,$longitude &key=$GOOGLE_API_KEY';
    return 'https://staticmapmaker.com/img/google@2x.png';
  }

  static Future<String> getAddress(double latitude, double longitude) async {
    // final url = Uri.parse(
    // 'https://maps.googleapis.com/maps/api/geocode/json?latlng=$latitude,$longitude&key=$GOOGLE_API_KEY');
    // final response = await http.get(url);
    // return jsonDecode(response.body)['results'][0]['formatted_address'];
    return '28, Sitapur Rd, Sector M, Vikas Nagar, Lucknow, Uttar Pradesh 226024';
  }
}
