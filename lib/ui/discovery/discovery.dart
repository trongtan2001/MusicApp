import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/model/song.dart';
import '../../data/repository/repository.dart';
import '../../plugin/ThemeProvider.dart';

class DiscoveryTab extends StatefulWidget {
  const DiscoveryTab({super.key});

  @override
  _DiscoveryTabState createState() => _DiscoveryTabState();

}

class _DiscoveryTabState extends State<DiscoveryTab> {
  final Repository _repository = DefaultRepository();
  List<Song> songs = [];

  @override
  void initState() {
    super.initState();
    _loadSongs();
  }

  Future<void> _loadSongs() async {
    List<Song>? loadedSongs = await _repository.loadData();
    if (loadedSongs != null && loadedSongs.isNotEmpty) {
      setState(() {
        // Randomly select 5 songs from the loaded list
        songs = _getRandomSongs(loadedSongs, 5);
      });
    }
  }

  List<Song> _getRandomSongs(List<Song> allSongs, int count) {
    final random = Random();
    final selectedSongs = <Song>[];
    while (selectedSongs.length < count) {
      final song = allSongs[random.nextInt(allSongs.length)];
      if (!selectedSongs.contains(song)) {
        selectedSongs.add(song);
      }
    }
    return selectedSongs;
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    final List<Map<String, String>> categories = [
      {'name': 'Pop', 'image': 'assets/image1.jpg'},
      {'name': 'Rock', 'image': 'assets/image1.jpg'},
      {'name': 'Hip-Hop', 'image': 'assets/image1.jpg'},
      {'name': 'Jazz', 'image': 'assets/image1.jpg'},
      {'name': 'Classical', 'image': 'assets/image1.jpg'},
      {'name': 'Electronic', 'image': 'assets/image1.jpg'},
    ];

    return Scaffold(
      backgroundColor: themeProvider.isDarkMode ? Colors.black : Colors.white,
      body: SafeArea(
          child: ListView(
            padding: const EdgeInsets.all(8.0),
            children: [
              // Categories Section
              const SectionHeader(title: 'Thể loại'),
              SizedBox(
                height: 100,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: categories.length,
                  separatorBuilder: (context, index) => const SizedBox(width: 1),
                  itemBuilder: (context, index) {
                    final category = categories[index];
                    return SizedBox(
                      width: 100,
                      child: CategoryCard(
                        categoryName: category['name']!,
                        imageUrl: category['image']!,
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),

              // Featured Songs Section
              const SectionHeader(title: 'Bài hát nổi bật'),
              ...songs.map((song) => FeaturedSongTile(song: song)).toList(),
            ],
          )
      ),
    );
  }
}

class SectionHeader extends StatelessWidget {
  final String title;

  const SectionHeader({required this.title, super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: themeProvider.isDarkMode ? Colors.white : Colors.black,
        ),
      ),
    );
  }
}

class CategoryCard extends StatelessWidget {
  final String categoryName;
  final String imageUrl;

  const CategoryCard({required this.categoryName, required this.imageUrl, super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(horizontal: 5),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12), // Border radius for the card
      ),
     child: ClipRRect(
       borderRadius: BorderRadius.circular(12),
       child: Stack(
         children: [
           // Background image
           Positioned.fill(
             child: Image.asset(
               imageUrl,
               fit: BoxFit.cover,
             ),
           ),
           // Overlay with text
           Center(
             child: Padding(
               padding: const EdgeInsets.all(16.0),
               child: Text(
                 categoryName,
                 style: const TextStyle(
                   fontSize: 16,
                   fontWeight: FontWeight.bold,
                   color: Colors.black, // Text color
                 ),
                 textAlign: TextAlign.center,
               ),
             ),
           ),
         ],
       ),
     ),
    );
  }
}

class FeaturedSongTile extends StatelessWidget {
  final Song song;

  const FeaturedSongTile({required this.song, super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      color: themeProvider.isDarkMode ? Colors.grey[900] : Colors.grey[200],
      child: ListTile(
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: Image.network(
            song.image,
            width: 50,
            height: 50,
            fit: BoxFit.cover,
          ),
        ),
        title: Text(
          song.title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: themeProvider.isDarkMode ? Colors.white : Colors.black,
          ),
        ),
        subtitle: Text(
          song.artist,
          style: TextStyle(
            fontSize: 14,
            color: themeProvider.isDarkMode ? Colors.white70 : Colors.black,
          ),
        ),
        trailing: Icon(
          Icons.play_arrow,
          color: themeProvider.isDarkMode ? Colors.white : Colors.black,
        ),
        onTap: () {
          // Handle play song
        },
      ),
    );
  }
}
