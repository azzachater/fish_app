import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class ApiPictureService {
  final String baseUrl = 'http://192.168.1.13:5000'; // Remplace <IP> par l'adresse IP locale de ton serveur
  

  Future<String?> predictFishSpecies(File imageFile) async {
    try {
      var request = http.MultipartRequest('POST', Uri.parse('$baseUrl/predict'));
      request.files.add(await http.MultipartFile.fromPath('image', imageFile.path));

      var response = await request.send();
      if (response.statusCode == 200) {
        final responseData = await http.Response.fromStream(response);
        final data = json.decode(responseData.body);
        return data['prediction'];
      } else {
        print("Erreur: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      print("Erreur lors de la requête: $e");
      return null;
    }
  }
}
