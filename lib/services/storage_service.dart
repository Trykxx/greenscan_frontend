import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static final FirebaseStorage _storage = FirebaseStorage.instance;
  static const String baseUrl = 'http://10.0.2.2:9005/api';

  static Future<Map<String, String>> _getHeaders() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('auth_token');

    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${token ?? ''}',
    };
  }

  // 🔥 MÉTHODE PRINCIPALE - Version simple avec File
  // 📤 Upload vers votre serveur au lieu de Firebase
  static Future<bool> addDocument({
    required int userId,
    required String documentName,
    PlatformFile? file,
  }) async {
    try {
      print('🚀 Upload direct vers Laravel API');

      // 📝 Préparer la requête multipart
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('$baseUrl/documents'),
      );

      // 🔑 Headers
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('auth_token');
      request.headers.addAll({
        'Authorization': 'Bearer ${token ?? ''}',
        'Accept': 'application/json',
      });

      // 📄 Données
      request.fields['user_id'] = userId.toString();
      request.fields['name'] = documentName;

      // 📁 Fichier si présent
      if (file != null && file.path != null) {
        request.files.add(
          await http.MultipartFile.fromPath(
            'file',
            file.path!,
            filename: file.name,
          ),
        );
        print('📁 Fichier ajouté: ${file.name}');
      }

      // 🚀 Envoyer
      var response = await request.send();
      String responseBody = await response.stream.bytesToString();

      print('📊 Statut: ${response.statusCode}');
      print('📄 Réponse: $responseBody');

      return response.statusCode == 200 || response.statusCode == 201;

    } catch (e) {
      print('❌ Erreur upload Laravel: $e');
      return false;
    }
  }


  // 🔥 Upload simple avec File
  static Future<String?> _uploadFileToFirebase({
    required File file,
    required String fileName,
    required int userId,
  }) async {
    try {
      print('📂 Upload vers Firebase...');

      // 📂 Chemin dans Firebase
      String firebasePath = 'documents/user_$userId/${DateTime.now().millisecondsSinceEpoch}_$fileName';

      // 🚀 Upload direct SANS métadonnées
      Reference ref = _storage.ref().child(firebasePath);
      UploadTask uploadTask = ref.putFile(file);

      print('⏳ Upload en cours...');

      // ⏳ Attendre la fin
      TaskSnapshot snapshot = await uploadTask;

      // 🔗 Récupérer l'URL
      String downloadUrl = await snapshot.ref.getDownloadURL();
      print('✅ Upload terminé: $downloadUrl');

      return downloadUrl;

    } catch (e) {
      print('❌ Erreur upload: $e');
      return null;
    }
  }

  // 📋 Récupérer les documents d'un utilisateur
  static Future<List<dynamic>> getUserDocuments(int userId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/users/$userId/documents'),
        headers: await _getHeaders(),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body)['data'];
      }
      return [];
    } catch (e) {
      print('❌ Erreur récupération documents: $e');
      return [];
    }
  }
}
