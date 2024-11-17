import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:innershakti_assignment/screens/category/model/music_category.dart';
import 'package:innershakti_assignment/screens/category_details/model/category_details.dart';

class MusicRepository {
  Future<List<MusicCategory>> fetchMusicCategories() async {
    final response = await http
        .get(Uri.parse('https://mock-backend-hlhx.onrender.com/api/collection'))
        .timeout(const Duration(seconds: 10));
    ;
    if (response.statusCode == 200) {
      final data = json.decode(response.body) as List;
      return data.map((json) => MusicCategory.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load music categories');
    }
  }

  Future<List<CategoryDetails>> fetchSessions(String id) async {
    final response = await http
        .get(Uri.parse(
            'https://mock-backend-hlhx.onrender.com/api/audiobook/$id/chapters'))
        .timeout(const Duration(seconds: 10));
    ;
    if (response.statusCode == 200) {
      final data = json.decode(response.body) as List;
      return data.map((json) => CategoryDetails.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load sessions');
    }
  }
}
