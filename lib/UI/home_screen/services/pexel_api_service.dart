import 'package:dio/dio.dart';
import 'package:lanars_test_task/api_keys.dart';

import '../models/photo.dart';

class PexelsApiService {
  final Dio dio = Dio();
  final String apiKey = pexelsKey;

  Future<List<Photo>> fetchPhotos({int page = 1, int perPage = 50}) async {
    try {
      final response = await dio.get(
        'https://api.pexels.com/v1/curated',
        queryParameters: {'page': page, 'per_page': perPage},
        options: Options(
          headers: {'Authorization': apiKey},
        ),
      );

      if (response.statusCode == 200) {
        final data = response.data['photos'] as List;
        return data.map((item) => Photo.fromJson(item)).toList();
      } else {
        throw Exception('Failed to load photos');
      }
    } catch (e) {
      throw Exception('Failed to load photos: $e');
    }
  }
}
