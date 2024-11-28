// lib/presentation/wine_home_page.dart
import 'package:flutter/material.dart';
import '../domain/wine_data.dart';
import '../domain/wine_repository.dart';
import '../data/wine_datasource.dart';
import '../data/wine_repository_impl.dart';

class WineHomePage extends StatefulWidget {
  @override
  _WineHomePageState createState() => _WineHomePageState();
}

class _WineHomePageState extends State<WineHomePage> {
  WineData? wineData;
  late WineRepository _wineRepository;

  @override
  void initState() {
    super.initState();
    _wineRepository = WineRepositoryImpl(WineDataSource());
    _loadWineData();
  }

  Future<void> _loadWineData() async {
    try {
      final loadedData = await _wineRepository.loadWineData();
      setState(() {
        wineData = loadedData;
      });
    } catch (e) {
      print('Error loading wine data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (wineData == null) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildAppBar(),
              _buildSearchBar(),
              _buildShopWinesBy(),
              _buildWineTypeGrid(),
              _buildWineList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(Icons.location_on, color: Colors.grey),
              SizedBox(width: 8),
              Text('Donnerville Drive ▼',
                  style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          Stack(
            children: [
              Icon(Icons.notifications_outlined, size: 30),
              Positioned(
                right: 0,
                top: 0,
                child: Container(
                  padding: EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  constraints: BoxConstraints(minWidth: 14, minHeight: 14),
                  child: Text(
                    '12',
                    style: TextStyle(color: Colors.white, fontSize: 8),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(8),
        ),
        child: TextField(
          decoration: InputDecoration(
            hintText: 'Search',
            prefixIcon: Icon(Icons.search),
            suffixIcon: Icon(Icons.mic),
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }

  Widget _buildShopWinesBy() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Shop wines by',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          SizedBox(height: 8),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: wineData!.winesBy.map((filter) {
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: _buildFilterChip(
                    filter.name,
                    isSelected: filter.tag == 'type',
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, {bool isSelected = false}) {
    return Chip(
      label: Text(label),
      backgroundColor: isSelected ? Colors.red[100] : Colors.grey[200],
      labelStyle: TextStyle(color: isSelected ? Colors.red : Colors.black),
    );
  }

  Widget _buildWineTypeGrid() {
    final wineTypes = wineData!.carousel
        .map((wine) => wine.type)
        .toSet()
        .toList();

    return Container(
      height: 150,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: wineTypes.length,
        itemBuilder: (context, index) {
          final type = wineTypes[index];
          final count = wineData!.carousel
              .where((wine) => wine.type == type)
              .length;
          final wine = wineData!.carousel
              .firstWhere((wine) => wine.type == type);

          return _buildWineTypeCard(
            '${type.substring(0, 1).toUpperCase()}${type.substring(1)} wines',
            count.toString(),
            wine.image,
          );
        },
      ),
    );
  }

  Widget _buildWineTypeCard(String title, String count, String imageUrl) {
    return Container(
      width: 150,
      margin: EdgeInsets.only(left: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
          ),
        ],
      ),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              imageUrl,
              width: 150,
              height: 150,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 150,
                  height: 150,
                  color: Colors.grey[300],
                  child: Icon(Icons.error),
                );
              },
            ),
          ),
          Positioned(
            top: 8,
            right: 8,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                count,
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [Colors.black87, Colors.transparent],
                ),
              ),
              child: Text(
                title,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWineList() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Wine',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              Text('view all', style: TextStyle(color: Colors.red)),
            ],
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: wineData!.carousel.length,
          itemBuilder: (context, index) {
            final wine = wineData!.carousel[index];
            return _buildWineCard(
              wine.name,
              '${wine.type} wine',
              'From ${wine.from.city}, ${wine.from.country}',
              '\$${wine.priceUsd.toStringAsFixed(2)}',
              'Available',
              _getColorForWineType(wine.type),
              false,
              wine.criticScore,
              wine.image,
            );
          },
        ),
      ],
    );
  }

  Widget _buildWineCard(String title, String type, String origin, String price,
      String availability, Color color, bool isAdded, int score, String imageUrl) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 80,
              height: 120,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey[300],
                      child: Icon(Icons.error),
                    );
                  },
                ),
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(availability,
                      style: TextStyle(
                          color: availability == 'Available'
                              ? Colors.green
                              : Colors.red)),
                  Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(height: 4),
                  Text(type, style: TextStyle(color: Colors.grey)),
                  SizedBox(height: 4),
                  Text(origin),
                  SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(price, style: TextStyle(fontWeight: FontWeight.bold)),
                      IconButton(
                        icon: Icon(
                            isAdded ? Icons.favorite : Icons.favorite_border,
                            color: color),
                        onPressed: () {
                          // Favorite action
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Column(
              children: [
                Icon(Icons.star, color: Colors.yellow),
                Text(score.toString(),
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _getColorForWineType(String type) {
    switch (type.toLowerCase()) {
      case 'red':
        return Colors.red[100]!;
      case 'white':
        return Colors.green[100]!;
      case 'sparkling':
        return Colors.orange[100]!;
      case 'rose':
        return Colors.pink[100]!;
      default:
        return Colors.grey[100]!;
    }
  }
}

class WineApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.red,
        scaffoldBackgroundColor: Colors.white,
      ),
      home: WineHomePage(),
    );
  }
}

void main() {
  runApp(WineApp());
}