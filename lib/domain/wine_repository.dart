// lib/domain/wine_repository.dart
import 'wine_data.dart';

abstract class WineRepository {
  Future<WineData> loadWineData();
}