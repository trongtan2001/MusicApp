
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music_app/ui/auth/login.dart';
import 'package:music_app/ui/discovery/discovery.dart';
import 'package:music_app/ui/home/viewmodel.dart';
import 'package:music_app/ui/now_playing/audio_player_manager.dart';
import 'package:music_app/ui/settings/settings.dart';
import 'package:music_app/ui/account/account.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../data/helper/download_song.dart';
import '../../data/model/song.dart';
import '../../plugin/ThemeProvider.dart';
import '../now_playing/playing.dart';

class MusicApp extends StatelessWidget {
  const MusicApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return MaterialApp(
      title: 'Music App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: themeProvider.isDarkMode ? Colors.black : Colors.white),
        useMaterial3: true,
      ),
      home: const MusicHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MusicHomePage extends StatefulWidget {
  const MusicHomePage({super.key});

  @override
  State<MusicHomePage> createState() => _MusicHomePageState();
}

class _MusicHomePageState extends State<MusicHomePage>
    with SingleTickerProviderStateMixin {
  List<Song> songs = [];
  List<Song> displayedSongs = [];
  final ValueNotifier<List<Song>> _displayedSongsNotifier = ValueNotifier([]);

  final List<Widget> _tabs = [
    const HomeTab(),
    const DiscoveryTab(),
    const AccountTab(),
    const SettingsTab(),
    const LoginPage(),
  ];

  late AnimationController _imageAnimController;

  bool isSearching = false;
  String searchQuery = "";
  late TextEditingController _searchController;
  late FocusNode _searchFocusNode;

  final AudioPlayerManager audioPlayerManager = AudioPlayerManager();

  @override
  void initState() {
    super.initState();
    _imageAnimController = AnimationController(
      vsync: this,
      duration:
          const Duration(milliseconds: 12000),
    )..repeat();

    _searchController = TextEditingController();
    _searchFocusNode = FocusNode();

    _displayedSongsNotifier.value = songs;
  }

  @override
  void dispose() {
    _imageAnimController.dispose();
    _searchController.dispose();
    _searchFocusNode.dispose();
    _displayedSongsNotifier.dispose();
    super.dispose();
  }

  void _setNextSong() {
  }

  void performSearch(String query) {
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    void navigate(Song song) {
      Navigator.push(context, CupertinoPageRoute(builder: (context) {
        return NowPlaying(
          songs: songs,
          playingSong: song,
        );
      }));
    }

    return Stack(
      children: [
        CupertinoPageScaffold(
          navigationBar: CupertinoNavigationBar(
            middle: isSearching ? CupertinoTextField(
              controller: _searchController,
              focusNode: _searchFocusNode,
              placeholder: "Tìm kiếm bài hát",
              onChanged: (value) {
                performSearch(value);
              },
            ): const Text('Zing MP3'),
            trailing: IconButton(
                icon: Icon(
                  isSearching ? Icons.close : Icons.search,
                  color: Colors.black,
                ),
                onPressed: () {
                  setState(() {
                    isSearching = !isSearching;
                    if(!isSearching) {
                      _searchController.clear();
                      performSearch("");
                      _searchFocusNode.unfocus();
                    }
                  });
                } ),
          ),
          child: CupertinoTabScaffold(
            tabBar: CupertinoTabBar(
              backgroundColor:
                  themeProvider.isDarkMode ? Colors.black : Colors.white,
              activeColor:
                  themeProvider.isDarkMode ? Colors.white : Colors.black,
              inactiveColor: Colors.grey,
              items: const [
                BottomNavigationBarItem(
                    icon: Icon(Icons.library_music_outlined),
                    label: 'Thư viên'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.album), label: 'Khám phá'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.account_circle_outlined),
                    label: 'Cá nhân'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.settings), label: 'Cài đặt'),
              ],
            ),
            tabBuilder: (BuildContext context, int index) {
              return _tabs[index];
            },
          ),
        ),
        Positioned(
          bottom: 49,
          left: 0,
          right: 0,
          child: ValueListenableBuilder<Song?>(
              valueListenable: audioPlayerManager.currentSongNotifier,
              builder: (context, song, child) {
                if (song == null) {
                  return const SizedBox.shrink();
                }
                return GestureDetector(
                  onTap: () {
                    navigate(song);
                  },
                  child: Material(
                    child: Container(
                      color: themeProvider.isDarkMode
                          ? Colors.black
                          : Colors.black12,
                      padding: const EdgeInsets.all(10),
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 24, right: 8),
                            child: RotationTransition(
                                turns: Tween(begin: 0.0, end: 1.0)
                                    .animate(_imageAnimController),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(50),
                                  child: Image.network(
                                    song.image,
                                    width: 48,
                                    height: 48,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Image.asset(
                                        'assets/image1.jpg',
                                        width: 48,
                                        height: 48,
                                      );
                                    },
                                  ),
                                )),
                          ),
                          Expanded(
                            child: ListTile(
                              title: Text(
                                song.title,
                                style: TextStyle(
                                  color: themeProvider.isDarkMode
                                      ? Colors.white
                                      : Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              subtitle: Text(
                                song.artist,
                                style: TextStyle(
                                  color: themeProvider.isDarkMode
                                      ? Colors.white.withOpacity(0.7)
                                      : Colors.black,
                                  fontSize: 14,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              IconButton(
                                icon: Icon(Icons.favorite_border,
                                    color: themeProvider.isDarkMode
                                        ? Colors.white
                                        : Colors.black),
                                onPressed: () {},
                              ),
                              StreamBuilder<PlayerState>(
                                stream:
                                audioPlayerManager.player.playerStateStream,
                                builder: (context, snapshot) {
                                  final playState = snapshot.data;
                                  final processingState =
                                      playState?.processingState;
                                  final playing = playState?.playing;

                                  if (processingState ==
                                      ProcessingState.loading ||
                                      processingState ==
                                          ProcessingState.buffering) {
                                    return SizedBox(
                                      width: 24,
                                      height: 24,
                                      child: CircularProgressIndicator(
                                        color: themeProvider.isDarkMode
                                            ? Colors.white
                                            : Colors.black,
                                        strokeWidth: 2.0,
                                      ),
                                    );
                                  } else if (playing != true) {
                                    return IconButton(
                                      icon: Icon(Icons.play_arrow,
                                          color: themeProvider.isDarkMode
                                              ? Colors.white
                                              : Colors.black),
                                      onPressed: () {
                                        audioPlayerManager.player.play();
                                      },
                                    );
                                  } else if (processingState !=
                                      ProcessingState.completed) {
                                    return IconButton(
                                      icon: Icon(Icons.pause,
                                          color: themeProvider.isDarkMode
                                              ? Colors.white
                                              : Colors.black),
                                      onPressed: () {
                                        audioPlayerManager.player.pause();
                                      },
                                    );
                                  } else {
                                    return IconButton(
                                      icon: Icon(Icons.replay,
                                          color: themeProvider.isDarkMode
                                              ? Colors.white
                                              : Colors.black),
                                      onPressed: () {
                                        audioPlayerManager.player
                                            .seek(Duration.zero);
                                      },
                                    );
                                  }
                                },
                              ),
                              IconButton(
                                icon: Icon(Icons.skip_next,
                                    color: themeProvider.isDarkMode
                                        ? Colors.white
                                        : Colors.black),
                                onPressed: () {
                                  _setNextSong();
                                },
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                );
              }),
        )
      ],
    );
  }
}

class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    return const HomeTabPage();
  }
}

class HomeTabPage extends StatefulWidget {
  const HomeTabPage({super.key});

  @override
  State<HomeTabPage> createState() => _HomeTabPageState();
}

class _HomeTabPageState extends State<HomeTabPage> {
  List<Song> songs = [];
  late MusicAppViewModel _viewModel;
  final AudioPlayerManager audioPlayerManager = AudioPlayerManager();

  @override
  void initState() {
    _viewModel = MusicAppViewModel();
    _viewModel.loadSongs();
    observeData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      backgroundColor: themeProvider.isDarkMode ? Colors.black : Colors.white,
      body: getBody(),
    );
  }

  @override
  void dispose() {
    _viewModel.songStream.close();
    AudioPlayerManager().dispose();
    super.dispose();
  }

  Widget getBody() {
    bool showLoading = songs.isEmpty;
    if (showLoading) {
      return getProgressBar();
    } else {
      return getListView();
    }
  }

  Widget getProgressBar() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  ListView getListView() {
    return ListView.separated(
      itemBuilder: (context, position) {
        return getRow(position);
      },
      separatorBuilder: (context, index) {
        return const Divider(
          color: Colors.grey,
          thickness: 1,
          indent: 24,
          endIndent: 24,
        );
      },
      itemCount: songs.length,
      shrinkWrap: true,
    );
  }

  Widget getRow(int index) {
    return _songItemSection(
      parent: this,
      song: songs[index],
      audioPlayerManager: audioPlayerManager,
    );
  }

  void observeData() {
    _viewModel.songStream.stream.listen((songList) {
      setState(() {
        songs.addAll(songList);
      });
    });
  }

  Color gray11 = const Color(0xFF1C1C1C);

  void showBottomSheet(Song song) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(16)),
              child: Container(
                height: 400,
                color: themeProvider.isDarkMode ? gray11 : Colors.white,
                child: Column(
                  children: <Widget>[
                    ListTile(
                      contentPadding: const EdgeInsets.only(
                        left: 24,
                        right: 8,
                      ),
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: FadeInImage.assetNetwork(
                          placeholder: 'assets/image1.jpg',
                          image: song.image,
                          width: 48,
                          height: 48,
                          imageErrorBuilder: (context, error, stackTrace) {
                            return Image.asset(
                              'assets/image1.jpg',
                              width: 48,
                              height: 48,
                            );
                          },
                        ),
                      ),
                      title: Text(
                        song.title,
                        style: TextStyle(
                            color: themeProvider.isDarkMode
                                ? Colors.white
                                : Colors.black),
                      ),
                      subtitle: Text(
                        song.artist,
                        style: TextStyle(
                            color: themeProvider.isDarkMode
                                ? Colors.white
                                : Colors.black),
                      ),
                      trailing: IconButton(
                          onPressed: () {
                            Share.share(
                              'Check out this song!',
                            );
                            Navigator.pop(context);
                          },
                          icon: Icon(
                            Icons.share_outlined,
                            color: themeProvider.isDarkMode
                                ? Colors.white
                                : Colors.black,
                          )),
                    ),
                    const Divider(),
                    Expanded(
                        child: ListView(
                      children: [
                        ListTile(
                          leading: Icon(
                            Icons.download_outlined,
                            color: themeProvider.isDarkMode
                                ? Colors.white
                                : Colors.black,
                          ),
                          title: Text('Tải xuống',
                              style: TextStyle(
                                  color: themeProvider.isDarkMode
                                      ? Colors.white
                                      : Colors.black)),
                          onTap: () async {
                            String? filePath =
                                await DownloadSongHelper.downloadSong(
                                song.source, song.title);
                            if (filePath != null) {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title:
                                      const Text('Tải xuống thành công'),
                                      content:
                                      Text('Đã tải xuống: $filePath'),
                                      actions: <Widget>[
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context)
                                                .pop();
                                          },
                                          child: const Text('OK'),
                                        ),
                                      ],
                                    );
                                  });

                            } else {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: const Text('Lỗi'),
                                      content:
                                      const Text('Lỗi khi tải bài hát xuống'),
                                      actions: <Widget>[
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context)
                                                .pop();
                                          },
                                          child: const Text('OK'),
                                        ),
                                      ],
                                    );
                                  });
                            }
                          },
                        ),
                        ListTile(
                          leading: Icon(
                            Icons.favorite_outline,
                            color: themeProvider.isDarkMode
                                ? Colors.white
                                : Colors.black,
                          ),
                          title: Text('Thêm vào thư viện',
                              style: TextStyle(
                                  color: themeProvider.isDarkMode
                                      ? Colors.white
                                      : Colors.black)),
                          onTap: () {},
                        ),
                        ListTile(
                          leading: Icon(
                            Icons.music_note_outlined,
                            color: themeProvider.isDarkMode
                                ? Colors.white
                                : Colors.black,
                          ),
                          title: Text('Thêm vào playlist',
                              style: TextStyle(
                                  color: themeProvider.isDarkMode
                                      ? Colors.white
                                      : Colors.black)),
                          onTap: () {},
                        ),
                        ListTile(
                          leading: Icon(
                            Icons.playlist_play,
                            color: themeProvider.isDarkMode
                                ? Colors.white
                                : Colors.black,
                          ),
                          title: Text('Phát bài hát và nội dung tương tự',
                              style: TextStyle(
                                  color: themeProvider.isDarkMode
                                      ? Colors.white
                                      : Colors.black)),
                          onTap: () {},
                        ),
                        ListTile(
                          leading: Icon(
                            Icons.add_circle_outline,
                            color: themeProvider.isDarkMode
                                ? Colors.white
                                : Colors.black,
                          ),
                          title: Text('Thêm vào danh sách phát',
                              style: TextStyle(
                                  color: themeProvider.isDarkMode
                                      ? Colors.white
                                      : Colors.black)),
                          onTap: () {},
                        ),
                        ListTile(
                          leading: Icon(
                            Icons.playlist_play_sharp,
                            color: themeProvider.isDarkMode
                                ? Colors.white
                                : Colors.black,
                          ),
                          title: Text('Phát kế tiếp',
                              style: TextStyle(
                                  color: themeProvider.isDarkMode
                                      ? Colors.white
                                      : Colors.black)),
                          onTap: () {},
                        ),
                        ListTile(
                          leading: Icon(
                            Icons.library_music_outlined,
                            color: themeProvider.isDarkMode
                                ? Colors.white
                                : Colors.black,
                          ),
                          title: Text('Đặt làm nhạc chờ zalo',
                              style: TextStyle(
                                  color: themeProvider.isDarkMode
                                      ? Colors.white
                                      : Colors.black)),
                          onTap: () {},
                        ),
                        ListTile(
                          leading: Icon(
                            Icons.music_video_outlined,
                            color: themeProvider.isDarkMode
                                ? Colors.white
                                : Colors.black,
                          ),
                          title: Text('Xem album',
                              style: TextStyle(
                                  color: themeProvider.isDarkMode
                                      ? Colors.white
                                      : Colors.black)),
                          onTap: () {},
                        ),
                        ListTile(
                          leading: Icon(
                            Icons.personal_injury_outlined,
                            color: themeProvider.isDarkMode
                                ? Colors.white
                                : Colors.black,
                          ),
                          title: Text('Xem nghệ sĩ',
                              style: TextStyle(
                                  color: themeProvider.isDarkMode
                                      ? Colors.white
                                      : Colors.black)),
                          onTap: () {},
                        ),
                        ListTile(
                          leading: Icon(
                            Icons.block,
                            color: themeProvider.isDarkMode
                                ? Colors.white
                                : Colors.black,
                          ),
                          title: Text('Chặn',
                              style: TextStyle(
                                  color: themeProvider.isDarkMode
                                      ? Colors.white
                                      : Colors.black)),
                          onTap: () {},
                        ),
                        ListTile(
                          leading: Icon(
                            Icons.report_gmailerrorred,
                            color: themeProvider.isDarkMode
                                ? Colors.white
                                : Colors.black,
                          ),
                          title: Text('Báo lỗi',
                              style: TextStyle(
                                  color: themeProvider.isDarkMode
                                      ? Colors.white
                                      : Colors.black)),
                          onTap: () {},
                        ),
                      ],
                    ))
                  ],
                ),
              ));
        });
  }

  void navigate(Song song) {
    Navigator.push(context, CupertinoPageRoute(builder: (context) {
      return NowPlaying(
        songs: songs,
        playingSong: song,
      );
    }));
  }
}

class _songItemSection extends StatelessWidget {
  const _songItemSection({
    required this.parent,
    required this.song,
    required AudioPlayerManager audioPlayerManager,
  });

  final _HomeTabPageState parent;
  final Song song;

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return ListTile(
      contentPadding: const EdgeInsets.only(
        left: 24,
        right: 8,
      ),
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: FadeInImage.assetNetwork(
          placeholder: 'assets/image1.jpg',
          image: song.image,
          width: 48,
          height: 48,
          imageErrorBuilder: (context, error, stackTrace) {
            return Image.asset(
              'assets/image1.jpg',
              width: 48,
              height: 48,
            );
          },
        ),
      ),
      title: Text(
        song.title,
        style: TextStyle(
            color: themeProvider.isDarkMode ? Colors.white : Colors.black),
      ),
      subtitle: Text(
        song.artist,
        style: TextStyle(
            color: themeProvider.isDarkMode ? Colors.white : Colors.black),
      ),
      trailing: IconButton(
          icon: Icon(Icons.more_horiz,
              color: themeProvider.isDarkMode ? Colors.white : Colors.black),
          onPressed: () {
            parent.showBottomSheet(song);
          }),
      onTap: () {
        parent.audioPlayerManager.playSong(song);
        parent.navigate(song);
      },
    );
  }
}
