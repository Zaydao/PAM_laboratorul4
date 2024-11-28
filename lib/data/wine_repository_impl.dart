// lib/data/wine_repository_impl.dart
import '../domain/wine_data.dart';
import '../domain/wine_repository.dart';
import 'wine_datasource.dart';

class WineRepositoryImpl implements WineRepository {
  final WineDataSource _dataSource;

  WineRepositoryImpl(this._dataSource);

  @override
  Future<WineData> loadWineData() async {
    return await _dataSource.loadWineDataFromJson();
  }
}