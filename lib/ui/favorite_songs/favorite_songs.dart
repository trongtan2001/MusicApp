import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/helper/user_preferences.dart';
import '../../data/model/song.dart';
import '../../data/repository/repository.dart';
import '../../plugin/ThemeProvider.dart';

class FavoriteSongs extends StatefulWidget {
  const FavoriteSongs({super.key});

  @override
  State<FavoriteSongs> createState() => _FavoriteSongsState();
}

class _FavoriteSongsState extends State<FavoriteSongs> {
  final Repository _repository = DefaultRepository();
  List<Song> allSongs = [];
  List<Song> favoriteSongs = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAllSongs();
  }

  Future<void> _loadAllSongs() async {
    List<Song>? loadedSongs = await _repository.loadData();
    if (loadedSongs != null && loadedSongs.isNotEmpty) {
      setState(() {
        allSongs = loadedSongs;
      });
      _fetchFavoriteSongs();
    }
  }

  Future<void> _fetchFavoriteSongs() async{
    final userId = await UserPreferences.getUserId();
    if(userId != null) {
      try {
        final response = await Dio().get('http://10.0.2.2:3000/favorites/$userId');
        if(response.data['success']) {
          List<dynamic> favoriteSongIds = response.data['favorites'];
            _filterFavoriteSongs(favoriteSongIds);
        } else {
          setState(() {
            isLoading = false;
          });
        }
      } catch (e) {
        print('Error fetching favorite songs: $e');
      }
    }
  }

  void _filterFavoriteSongs(List<dynamic> favoriteSongIds) {
    setState(() {
      favoriteSongs = allSongs
          .where((song) =>
          favoriteSongIds.any((fav) => fav['song_id'].toString() == song.id))
          .toList();
      isLoading = false;
    });
  }

  Future<void> _removeFavoriteSong(String songId) async{
    try{
      final userId = await UserPreferences.getUserId();

      if(userId !=  null) {
        final response =  await Dio().delete(
          'http://10.0.2.2:3000/favorites/',
          data: {
            "user_id": userId,
            "song_id": songId,
          },
        );
        if(response.data['success']) {
          setState(() {
            favoriteSongs.removeWhere((song) => song.id == songId);
          });

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Bài hát đã được xóa khỏi danh sách yêu thích.')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Xóa bài hát thất bại.')),
          );
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Đã xảy ra lỗi khi xóa bài hát.')),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: themeProvider.isDarkMode ? Colors.black : Colors.white,
            floating: true,
            pinned: true,
            expandedHeight: 200,
            iconTheme: IconThemeData(
              color: themeProvider.isDarkMode ? Colors.white : Colors.black, 
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: themeProvider.isDarkMode
                        ? [Colors.black87, Colors.black54]
                        : [Colors.blueAccent, Colors.lightBlueAccent],
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Bài hát yêu thích',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: themeProvider.isDarkMode ? Colors.white : Colors.white70,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                        '${favoriteSongs.length} bài hát . Đã lưu vào thư viện',
                        style: TextStyle(
                          fontSize: 16,
                          color: themeProvider.isDarkMode ? Colors.white : Colors.white70,
                    )
                    )],
                ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                final song = favoriteSongs[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
                  child: Card(
                    elevation: 6,
                    shadowColor: themeProvider.isDarkMode ? Colors.white24 : Colors.black26,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        color: themeProvider.isDarkMode ? Colors.grey[850] : Colors.white,
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: ListTile(
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(12.0),
                          child: Image.network(
                            song.image,
                            width: 60,
                            height: 60,
                            fit: BoxFit.cover,
                          ),
                        ),
                        title: Text(
                          song.title,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: themeProvider.isDarkMode ? Colors.white : Colors.black87,
                          ),
                        ),
                        subtitle: Text(
                          song.artist,
                          style: TextStyle(
                            fontSize: 14,
                            color: themeProvider.isDarkMode ? Colors.white70 : Colors.black54,
                          ),
                        ),
                        trailing: IconButton(
                          icon: Icon(
                            Icons.favorite,
                            color: themeProvider.isDarkMode ? Colors.redAccent : Colors.red,
                          ),
                          onPressed: () {
                            _removeFavoriteSong(song.id);
                          },
                        ),
                        onTap: () {
                          // Optionally navigate to song details or play
                        },
                      ),
                    ),
                  ),
                );
              },
              childCount: favoriteSongs.length,
            ),
          ),
        ],
      ),
    );
  }

}
