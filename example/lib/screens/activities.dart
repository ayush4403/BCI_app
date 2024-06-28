import 'dart:async';
import 'package:flutter/material.dart';

class ActivitiesScreen extends StatefulWidget {
  const ActivitiesScreen({super.key});
  @override
  _ActivitiesScreenState createState() => _ActivitiesScreenState();
}

class _ActivitiesScreenState extends State<ActivitiesScreen> {
  final PageController _activitiesController = PageController();
  final PageController _gamesController = PageController();
  Timer? _activitiesTimer;
  Timer? _gamesTimer;
  bool _isActivitiesSelected = true;
  final TextEditingController _searchController = TextEditingController();
  List<String> _activities = List.generate(8, (index) => 'Activity ${index + 1}');
  List<String> _games = List.generate(8, (index) => 'Game ${index + 1}');
  List<String> _filteredItems = [];

  @override
  void initState() {
    super.initState();
    _startAutoScroll();
    _filteredItems = _activities;
    _searchController.addListener(_filterItems);
  }

  void _startAutoScroll() {
    _activitiesTimer = Timer.periodic(Duration(seconds: 3), (timer) {
      if (_activitiesController.hasClients) {
        int nextPage = _activitiesController.page!.round() + 1;
        if (nextPage == 4) {
          nextPage = 0;
        }
        _activitiesController.animateToPage(
          nextPage,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeIn,
        );
      }
    });

    _gamesTimer = Timer.periodic(Duration(seconds: 3), (timer) {
      if (_gamesController.hasClients) {
        int nextPage = _gamesController.page!.round() + 1;
        if (nextPage == 4) {
          nextPage = 0;
        }
        _gamesController.animateToPage(
          nextPage,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeIn,
        );
      }
    });
  }

  void _filterItems() {
    setState(() {
      if (_isActivitiesSelected) {
        _filteredItems = _activities
            .where((activity) => activity.toLowerCase().contains(_searchController.text.toLowerCase()))
            .toList();
      } else {
        _filteredItems = _games
            .where((game) => game.toLowerCase().contains(_searchController.text.toLowerCase()))
            .toList();
      }
    });
  }

  @override
  void dispose() {
    _activitiesTimer?.cancel();
    _gamesTimer?.cancel();
    _activitiesController.dispose();
    _gamesController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: Center(
          child: ToggleButtons(
            borderColor: Colors.blue,
            fillColor: Colors.blue,
            borderWidth: 2,
            selectedBorderColor: Colors.blue,
            selectedColor: Colors.white,
            borderRadius: BorderRadius.circular(8),
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text('Activities'),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text('Games'),
              ),
            ],
            onPressed: (int index) {
              setState(() {
                _isActivitiesSelected = index == 0;
                _filterItems();
              });
            },
            isSelected: [_isActivitiesSelected, !_isActivitiesSelected],
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search...',
                hintStyle: TextStyle(color: Colors.white54),
                prefixIcon: Icon(Icons.search, color: Colors.white54),
                filled: true,
                fillColor: Colors.white12,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
              ),
              style: TextStyle(color: Colors.white),
            ),
            SizedBox(height: 20),
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemCount: _filteredItems.length,
                itemBuilder: (context, index) {
                  return buildCard(
                    Colors.primaries[index % Colors.primaries.length],
                    _filteredItems[index],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildCard(Color color, String title) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: Text(
          title,
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
      ),
    );
  }
}