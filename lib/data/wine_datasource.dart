// lib/data/wine_datasource.dart
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';
import '../domain/wine_data.dart';

class WineDataSource {
  Future<WineData> loadWineDataFromJson() async {
    try {
      final String jsonString = await rootBundle.loadString('assets/wine.json');
      final Map<String, dynamic> jsonData = json.decode(jsonString);

      return WineData(
        winesBy: (jsonData['wines_by'] as List)
            .map((filter) => WineFilter(
          tag: filter['tag'],
          name: filter['name'],
        ))
            .toList(),
        carousel: (jsonData['carousel'] as List)
            .map((wine) => Wine(
          name: wine['name'],
          image: wine['image'],
          criticScore: wine['critic_score'],
          bottleSize: wine['bottle_size'],
          priceUsd: wine['price_usd'].toDouble(),
          type: wine['type'],
          from: WineLocation(
            country: wine['from']['country'],
            city: wine['from']['city'],
          ),
        ))
            .toList(),
      );
    } catch (e) {
      print('Error loading wine data: $e');
      rethrow;
    }
  }
}