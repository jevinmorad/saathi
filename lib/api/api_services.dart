import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:saathi/utils/utility.dart';

class ApiService {
  static const baseUrl = 'https://67cd3aaddd7651e464edb8b7.mockapi.io/';

  static const CLOUD_NAME = 'dtzmeoxdz';
  static const API_KEY = '631918355494553';
  static const API_SECRET = 'r3AODVHtaWbUpymaL_h6UAPyqeI';

  Future<List<Map<String, dynamic>>?> getUsers(context) async {
    if (await Utils().isInternetAvailable(context)) {
      http.Response res = await http.get(Uri.parse('${baseUrl}users'));
      return convertJSONToData(res);
    }
    Navigator.pop(context);
    return null;
  }

  Future<List<Map<String, dynamic>>?> addUser({context, map}) async {
    http.Response res = await http.post(Uri.parse('${baseUrl}users'), body: map);
    return convertJSONToData(res);
  }

  Future<List<Map<String, dynamic>>?> updateUser({context, id, map}) async {
    http.Response res =
        await http.put(Uri.parse('${baseUrl}users/$id'), body: map);
    return convertJSONToData(res);
  }

  Future<List<Map<String, dynamic>>?> deleteUser({context, id}) async {
    http.Response res = await http.delete(Uri.parse('${baseUrl}users/$id'));
    return convertJSONToData(res);
  }

  Future<String> uploadImageToServer(File image) async {
    try {
      final uploadUrl =
      Uri.parse('https://api.cloudinary.com/v1_1/$CLOUD_NAME/image/upload');

      var req = http.MultipartRequest('POST', uploadUrl)
        ..fields['upload_preset'] = 'images' // Ensure this matches your Cloudinary preset
        ..files.add(await http.MultipartFile.fromPath('file', image.path));

      final res = await req.send();

      if (res.statusCode == 200) {
        var resData = await res.stream.bytesToString();
        var jsonRes = jsonDecode(resData);
        return jsonRes['secure_url'];
      } else {
        var resData = await res.stream.bytesToString();
        print('Error response data: $resData');
        throw Exception('Failed to upload image: ${res.statusCode}');
      }
    } catch (err) {
      throw Exception('Failed to upload image: $err');
    }
  }

  Future<void> removeImageFromServer(String imageUrl) async {
    try {
      var authHeader =
          'Basic ${base64Encode(utf8.encode('$API_KEY:$API_SECRET'))}';

      var url = Uri.parse(
          "https://api.cloudinary.com/v1_1/$CLOUD_NAME/image/destroy");

      var publicId = Uri.parse(imageUrl).pathSegments.last.split('.').first;

      var response = await http.post(
        url,
        headers: {"Authorization": authHeader},
        body: {"public_id": publicId},
      );

      if (response.statusCode == 200) {
        print("Image deleted successfully!");
      }
    } catch (e) {
      print('Error deleting image from Cloudinary: $e');
      throw Exception('Failed to delete image');
    }
  }

  Future<List<Map<String, dynamic>>?> convertJSONToData(http.Response res) async {
    if (res.statusCode == 200 || res.statusCode == 201) {
      // Decode the JSON response
      var decodedData = jsonDecode(res.body);

      // If the decoded data is a List, return it directly
      if (decodedData is List) {
        return decodedData.cast<Map<String, dynamic>>();
      }
      // If the decoded data is a Map, wrap it in a List
      else if (decodedData is Map<String, dynamic>) {
        return [decodedData];
      }
      // If the data is neither a List nor a Map, return null or handle accordingly
      else {
        return null;
      }
    } else if (res.statusCode == 400) {
      return [
        {'message': 'Please check your url'}
      ];
    } else if (res.statusCode == 500) {
      return [
        {'message': 'Server not found'}
      ];
    } else {
      return [
        {'message': 'No data found ${res.statusCode}'}
      ];
    }
  }
}