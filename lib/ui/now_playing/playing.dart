import 'dart:math';

import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music_app/data/helper/download_song.dart';
import 'package:music_app/ui/now_playing/audio_player_manager.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../data/model/song.dart';
import '../../plugin/ThemeProvider.dart';

class NowPlaying extends StatelessWidget {
  const NowPlaying({super.key, required this.playingSong, required this.songs});

  final Song playingSong;
  final List<Song> songs;

  @override
  Widget build(BuildContext context) {
    return NowPlayingPage(songs: songs, playingSong: playingSong);
  }
}

class NowPlayingPage extends StatefulWidget {
  const NowPlayingPage({
    super.key,
    required this.songs,
    required this.playingSong,
  });

  final Song playingSong;
  final List<Song> songs;

  @override
  State<NowPlayingPage> createState() => _NowPlayingPageState();
}

class _NowPlayingPageState extends State<NowPlayingPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _imageAnimController;
  late AudioPlayerManager _audioPlayerManager;
  late int _selectedItemIndex;
  late Song _song;
  late double _currentAnimationPosition = 0.0;
  bool _isShuffle = false;
  late LoopMode _loopMode;

  @override
  void initState() {
    super.initState();
    _song = widget.playingSong;
    _imageAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 12000),
    );
    _audioPlayerManager = AudioPlayerManager();
    _audioPlayerManager.player.playerStateStream.listen((state) {
      if (state.processingState == ProcessingState.completed) {
        _handleSongCompletion();
      }
    });
    if (_audioPlayerManager.songUrl.compareTo(_song.source) != 0) {
      _audioPlayerManager.updateSongUrl(_song.source);
      _audioPlayerManager.prepare(isNewSong: true);
    } else {
      _audioPlayerManager.prepare(isNewSong: false);
    }
    _selectedItemIndex = widget.songs.indexOf(widget.playingSong);
    _loopMode = LoopMode.off;
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final themeProvider = Provider.of<ThemeProvider>(context);
    const delta = 64;
    final radius = (screenWidth - delta) / 2;

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
                              Icons.heart_broken,
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

    return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          middle: const Text(
            'Now Playing',
          ),
          trailing: IconButton(
            onPressed: () {
              showBottomSheet(_song);
            },
            icon: const Icon(Icons.more_horiz, color: Colors.black),
          ),
          leading: CupertinoNavigationBarBackButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        child: Scaffold(
          backgroundColor:
              themeProvider.isDarkMode ? Colors.black : Colors.white,
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  _song.album,
                  style: TextStyle(
                      color: themeProvider.isDarkMode
                          ? Colors.white
                          : Colors.black,
                      fontSize: 17.0),
                ),
                const SizedBox(
                  height: 16,
                ),
                Text('_ ___ _',
                    style: TextStyle(
                        color: themeProvider.isDarkMode
                            ? Colors.white
                            : Colors.black)),
                const SizedBox(
                  height: 48,
                ),
                RotationTransition(
                  turns:
                      Tween(begin: 0.0, end: 1.0).animate(_imageAnimController),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(radius),
                    child: FadeInImage.assetNetwork(
                      placeholder: 'assets/image1.jpg',
                      image: _song.image,
                      width: screenWidth - delta,
                      height: screenWidth - delta,
                      imageErrorBuilder: (context, error, stackTrace) {
                        return Image.asset(
                          'assets/image1.jpg',
                          width: screenWidth - delta,
                          height: screenWidth - delta,
                        );
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 64, bottom: 16),
                  child: SizedBox(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        IconButton(
                          onPressed: () {
                            Share.share(
                              'Check out this song!',
                            );
                            // Navigator.pop(context);
                          },
                          icon: Icon(Icons.share_outlined,
                              color: themeProvider.isDarkMode
                                  ? Colors.white
                                  : Colors.black),
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        Column(
                          children: [
                            Text(
                              _song.title,
                              style: TextStyle(
                                  color: themeProvider.isDarkMode
                                      ? Colors.white
                                      : Colors.black,
                                  fontSize: 17.0),
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            Text(
                              _song.artist,
                              style: TextStyle(
                                  color: themeProvider.isDarkMode
                                      ? Colors.white
                                      : Colors.black,
                                  fontStyle: FontStyle.italic),
                            )
                          ],
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: Icon(Icons.favorite_outline,
                              color: themeProvider.isDarkMode
                                  ? Colors.white
                                  : Colors.black),
                          color: Theme.of(context).colorScheme.primary,
                        )
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      top: 32, left: 24, right: 24, bottom: 16),
                  child: _progressBar(),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 24,
                    right: 24,
                  ),
                  child: _mediaButtons(),
                )
              ],
            ),
          ),
        ));
  }

  @override
  void dispose() {
    _imageAnimController.dispose();
    super.dispose();
  }

  Widget _mediaButtons() {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return SizedBox(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          MediaButtonControl(
              function: _setShuffle,
              icon: Icons.shuffle,
              color: _getShuffleColor(),
              size: 24),
          MediaButtonControl(
              function: _setPrevSong,
              icon: Icons.skip_previous,
              color: themeProvider.isDarkMode ? Colors.white : Colors.black,
              size: 36),
          _playerButton(),
          MediaButtonControl(
              function: _setNextSong,
              icon: Icons.skip_next,
              color: themeProvider.isDarkMode ? Colors.white : Colors.black,
              size: 36),
          MediaButtonControl(
              function: _setRepeatOption,
              icon: _repeatingIcon(),
              color: _getrepeatingIconColor(),
              size: 24),
        ],
      ),
    );
  }

  StreamBuilder<DurationState> _progressBar() {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return StreamBuilder<DurationState>(
        stream: _audioPlayerManager.durationState,
        builder: (context, snapshot) {
          final durationState = snapshot.data;
          final progress = durationState?.progress ?? Duration.zero;
          final buffered = durationState?.buffered ?? Duration.zero;
          final total = durationState?.total ?? Duration.zero;
          return ProgressBar(
            progress: progress,
            total: total,
            buffered: buffered,
            onSeek: _audioPlayerManager.player.seek,
            barHeight: 5.0,
            barCapShape: BarCapShape.round,
            baseBarColor: Colors.grey.withOpacity(0.3),
            progressBarColor:
                themeProvider.isDarkMode ? Colors.white : Colors.black,
            bufferedBarColor: Colors.grey.withOpacity(0.3),
            thumbColor: themeProvider.isDarkMode ? Colors.white : Colors.black,
            thumbGlowColor: Colors.green.withOpacity(0.3),
            thumbRadius: 10.0,
            timeLabelTextStyle: TextStyle(
              color: themeProvider.isDarkMode ? Colors.white : Colors.black,
            ),
          );
        });
  }

  StreamBuilder<PlayerState> _playerButton() {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return StreamBuilder(
        stream: _audioPlayerManager.player.playerStateStream,
        builder: (context, snapshot) {
          final playState = snapshot.data;
          final processingState = playState?.processingState;
          final playing = playState?.playing;
          if (processingState == ProcessingState.loading ||
              processingState == ProcessingState.buffering) {
            _pauseRotationAnim();
            return Container(
              margin: const EdgeInsets.all(8),
              width: 48,
              height: 48,
              child: const CircularProgressIndicator(),
            );
          } else if (playing != true) {
            return MediaButtonControl(
              function: () {
                _audioPlayerManager.player.play();
              },
              icon: Icons.play_arrow,
              color: themeProvider.isDarkMode ? Colors.white : Colors.black,
              size: 48,
            );
          } else if (processingState != ProcessingState.completed) {
            _playRotationAnim();
            return MediaButtonControl(
                function: () {
                  _audioPlayerManager.player.pause();
                  _pauseRotationAnim();
                },
                icon: Icons.pause,
                color: themeProvider.isDarkMode ? Colors.white : Colors.black,
                size: 48);
          } else {
            if (processingState == ProcessingState.completed) {
              _stopRotationAnim();
              _resetRotationAnim();
            }
            return MediaButtonControl(
                function: () {
                  _audioPlayerManager.player.seek(Duration.zero);
                  _resetRotationAnim();
                  _playRotationAnim();
                },
                icon: Icons.replay,
                color: null,
                size: 48);
          }
        });
  }

  void _handleSongCompletion() {
    if (_loopMode == LoopMode.all) {
      _setNextSong();
    }
  }

  void _setShuffle() {
    setState(() {
      _isShuffle = !_isShuffle;
    });
  }

  Color? _getShuffleColor() {
    return _isShuffle ? Colors.white : Colors.grey;
  }

  void _setNextSong() {
    if (_isShuffle) {
      var random = Random();
      _selectedItemIndex = random.nextInt(widget.songs.length);
    } else if (_selectedItemIndex < widget.songs.length - 1) {
      ++_selectedItemIndex;
    } else if (_loopMode == LoopMode.all &&
        _selectedItemIndex == widget.songs.length - 1) {
      _selectedItemIndex = 0;
    }

    if (_selectedItemIndex >= widget.songs.length) {
      _selectedItemIndex = _selectedItemIndex % widget.songs.length;
    }

    final nextSong = widget.songs[_selectedItemIndex];
    _audioPlayerManager.updateSongUrl(nextSong.source);
    _resetRotationAnim();
    setState(() {
      _song = nextSong;
    });
  }

  void _setPrevSong() {
    if (_isShuffle) {
      var random = Random();
      _selectedItemIndex = random.nextInt(widget.songs.length);
    } else if (_selectedItemIndex > 0) {
      --_selectedItemIndex;
    } else if (_loopMode == LoopMode.all && _selectedItemIndex == 0) {
      _selectedItemIndex = widget.songs.length - 1;
    }
    if (_selectedItemIndex < 0) {
      _selectedItemIndex = (-1 * _selectedItemIndex) % widget.songs.length;
    }
    final nextSong = widget.songs[_selectedItemIndex];
    _audioPlayerManager.updateSongUrl(nextSong.source);
    _audioPlayerManager.prepare(isNewSong: true);
    _resetRotationAnim();
    setState(() {
      _song = nextSong;
    });
  }

  void _setRepeatOption() {
    if (_loopMode == LoopMode.off) {
      _loopMode = LoopMode.one;
    } else if (_loopMode == LoopMode.one) {
      _loopMode = LoopMode.all;
    } else {
      _loopMode = LoopMode.off;
    }

    setState(() {
      _audioPlayerManager.player.setLoopMode(_loopMode);
    });
  }

  IconData _repeatingIcon() {
    switch (_loopMode) {
      case LoopMode.one:
        return Icons.repeat_one;
      case LoopMode.all:
        return Icons.repeat_on;
      default:
        return Icons.repeat;
    }
  }

  Color? _getrepeatingIconColor() {
    return _loopMode == LoopMode.off ? Colors.grey : Colors.white;
  }

  void _playRotationAnim() {
    _imageAnimController.forward(from: _currentAnimationPosition);
    _imageAnimController.repeat();
  }

  void _pauseRotationAnim() {
    _stopRotationAnim();
    _currentAnimationPosition = _imageAnimController.value;
  }

  void _stopRotationAnim() {
    _imageAnimController.stop();
  }

  void _resetRotationAnim() {
    _currentAnimationPosition = 0.0;
    _imageAnimController.value = _currentAnimationPosition;
  }
}

class MediaButtonControl extends StatefulWidget {
  const MediaButtonControl({
    super.key,
    required this.function,
    required this.icon,
    required this.color,
    required this.size,
  });

  final void Function()? function;
  final IconData icon;
  final double? size;
  final Color? color;

  @override
  State<StatefulWidget> createState() => _MediaButtonControlState();
}

class _MediaButtonControlState extends State<MediaButtonControl> {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: widget.function,
      icon: Icon(widget.icon),
      color: widget.color ?? Colors.white,
    );
  }
}
