import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:music_app/ui/auth/login.dart';

import '../../data/model/user.dart';
import '../../plugin/ThemeProvider.dart';
import '../../data/helper/user_preferences.dart';

class AccountTab extends StatelessWidget {
  const AccountTab({super.key});

  Future<User?> _getUser() async {
    final userId = await UserPreferences.getUserId();
    if(userId != null) {
      try {
        final response = await Dio().get('http://10.0.2.2:3000/user/$userId');
        if(response.data['success']) {
          return User.fromJson(response.data['user']);
        } else {
          return null;
        }
      } catch (e) {
        print('Error fetching user details: $e');
        return null;
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      backgroundColor: themeProvider.isDarkMode ? Colors.black : Colors.white,
      body: SafeArea(
        child: FutureBuilder<User?>(
          future: _getUser(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (!snapshot.hasData || snapshot.data == null) {
              return _buildLoggedOutView(context, themeProvider);
            } else {
              final user = snapshot.data!;
              return SingleChildScrollView(
                child: _buildLoggedInView(user, themeProvider, context),
              );
            }
          },
        ),
      ),
    );
  }

  Widget _buildLoggedInView(User user, ThemeProvider themeProvider, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 50,
                backgroundImage: user.image.isEmpty
                    ? const AssetImage('assets/profile_picture.jpg') as ImageProvider
                    : NetworkImage(user.image),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user.name,
                    style: TextStyle(
                        color: themeProvider.isDarkMode ? Colors.white : Colors.black,
                        fontSize: 24,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    user.role,
                    style: TextStyle(
                        color: themeProvider.isDarkMode ? Colors.white70 : Colors.black87,
                        fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    user.email,
                    style: TextStyle(
                        color: themeProvider.isDarkMode ? Colors.white70 : Colors.black87,
                        fontSize: 16),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 32),
          // Recent activity section
          Text(
            'Hoạt động gần đây',
            style: TextStyle(
                color: themeProvider.isDarkMode ? Colors.white : Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Container(
            color: themeProvider.isDarkMode ? Colors.grey[800] : Colors.grey[300],
            child: ListTile(
              leading: Icon(Icons.music_note,
                  color: themeProvider.isDarkMode ? Colors.white : Colors.black),
              title: Text('Listened to "Song Title"',
                  style: TextStyle(
                      color: themeProvider.isDarkMode ? Colors.white : Colors.black)),
              subtitle: Text('2 hours ago',
                  style: TextStyle(
                      color: themeProvider.isDarkMode ? Colors.white70 : Colors.black)),
            ),
          ),
          const SizedBox(height: 16),
          Container(
            color: themeProvider.isDarkMode ? Colors.grey[800] : Colors.grey[300],
            child: ListTile(
              leading: Icon(Icons.playlist_play,
                  color: themeProvider.isDarkMode ? Colors.white : Colors.black),
              title: Text('Added to Playlist "Favorites"',
                  style: TextStyle(
                      color: themeProvider.isDarkMode ? Colors.white : Colors.black)),
              subtitle: Text('1 day ago',
                  style: TextStyle(
                      color: themeProvider.isDarkMode ? Colors.white70 : Colors.black)),
            ),
          ),
          const SizedBox(height: 32),
          // Settings options
          Text(
            'Cài đặt',
            style: TextStyle(
                color: themeProvider.isDarkMode ? Colors.white : Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.bold),
          ),
          ListTile(
            leading: Icon(Icons.notifications,
                color: themeProvider.isDarkMode ? Colors.white : Colors.black),
            title: Text('Thông báo',
                style: TextStyle(
                    color: themeProvider.isDarkMode ? Colors.white : Colors.black)),
            onTap: () {
              // Handle notifications settings
            },
          ),
          ListTile(
            leading: Icon(Icons.lock,
                color: themeProvider.isDarkMode ? Colors.white : Colors.black),
            title: Text('Cài đặt quyền riêng tư',
                style: TextStyle(
                    color: themeProvider.isDarkMode ? Colors.white : Colors.black)),
            onTap: () {
              // Handle privacy settings
            },
          ),
          ListTile(
            leading: Icon(Icons.security,
                color: themeProvider.isDarkMode ? Colors.white : Colors.black),
            title: Text('Thay đổi mật khẩu',
                style: TextStyle(
                    color: themeProvider.isDarkMode ? Colors.white : Colors.black)),
            onTap: () {
              // Handle change password
            },
          ),
          ListTile(
            leading: Icon(Icons.payment,
                color: themeProvider.isDarkMode ? Colors.white : Colors.black),
            title: Text('Phương thức thanh toán',
                style: TextStyle(
                    color: themeProvider.isDarkMode ? Colors.white : Colors.black)),
            onTap: () {
              // Handle payment methods
            },
          ),
          ListTile(
            leading: Icon(Icons.logout,
                color: themeProvider.isDarkMode ? Colors.white : Colors.black),
            title: Text('Đăng xuất',
                style: TextStyle(
                    color: themeProvider.isDarkMode ? Colors.white : Colors.black)),
            onTap: () {
              _logout(context);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildLoggedOutView(BuildContext context, ThemeProvider themeProvider) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.account_circle,
              size: 100,
              color: themeProvider.isDarkMode ? Colors.white : Colors.black,
            ),
            const SizedBox(height: 16),
            Text(
              'Bạn chưa đăng nhập',
              style: TextStyle(
                  color: themeProvider.isDarkMode ? Colors.white : Colors.black,
                  fontSize: 24,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor:
                themeProvider.isDarkMode ? Colors.white : Colors.black,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'Đăng nhập',
                style: TextStyle(fontSize: 18, color: themeProvider.isDarkMode ? Colors.black : Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _logout(BuildContext context) async {
    final navigator = Navigator.of(context);
    await UserPreferences.clearUserId();
    navigator.pushReplacement(CupertinoPageRoute(builder: (context) {
      return const LoginPage();
    }));
  }
}
