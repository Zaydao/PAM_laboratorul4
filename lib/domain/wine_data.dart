// lib/domain/wine_data.dart
class WineFilter {
  final String tag;
  final String name;

  WineFilter({required this.tag, required this.name});
}

class WineLocation {
  final String country;
  final String city;

  WineLocation({required this.country, required this.city});
}

class Wine {
  final String name;
  final String image;
  final int criticScore;
  final String bottleSize;
  final double priceUsd;
  final String type;
  final WineLocation from;

  Wine({
    required this.name,
    required this.image,
    required this.criticScore,
    required this.bottleSize,
    required this.priceUsd,
    required this.type,
    required this.from,
  });
}

class WineData {
  final List<WineFilter> winesBy;
  final List<Wine> carousel;

  WineData({required this.winesBy, required this.carousel});
}