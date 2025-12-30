import '../utils/constants.dart';
import 'api_service.dart';

class UnsplashService {
  Future<String?> getDestinationImage(String cityName) async {
    try {
      final url =
          '${ApiConstants.unsplashBaseUrl}/search/photos?query=$cityName&per_page=1&client_id=${ApiConstants.unsplashAccessKey}';

      final data = await ApiService.get(url);
      final results = data['results'] as List?;
      
      if (results != null && results.isNotEmpty) {
        return results[0]['urls']?['regular'] as String?;
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<List<String>> getDestinationImages(String cityName, {int count = 5}) async {
    try {
      final url =
          '${ApiConstants.unsplashBaseUrl}/search/photos?query=$cityName&per_page=$count&client_id=${ApiConstants.unsplashAccessKey}';

      final data = await ApiService.get(url);
      final results = data['results'] as List? ?? [];
      
      return results
          .map((e) => e['urls']?['regular'] as String?)
          .whereType<String>()
          .toList();
    } catch (e) {
      return [];
    }
  }
}


