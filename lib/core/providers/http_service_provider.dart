import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../api/http_service.dart';

final httpServiceProvider = Provider<HttpService>((ref) {
  return HttpService();
});
