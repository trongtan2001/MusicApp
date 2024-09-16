import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../plugin/ThemeProvider.dart';

class SettingsTab extends StatefulWidget {
  const SettingsTab({super.key});

  @override
  _SettingsTabState createState() => _SettingsTabState();
}

class _SettingsTabState extends State<SettingsTab> {
  String _selectedQuality = 'Chất lượng cao (320kbps)';

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      backgroundColor: themeProvider.isDarkMode ? Colors.black : Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Audio Quality Settings
              Text(
                'Chất lượng nhạc',
                style: TextStyle(
                    color: themeProvider.isDarkMode ? Colors.white : Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
              _buildQualityOption('Chất lượng cao (320kbps)'),
              _buildQualityOption('Chất lượng thường (256kbps)'),
              _buildQualityOption('Chất lượng thấp (128kbps)'),
              const SizedBox(height: 20,),           // Playback Settings
              Text(
                'Giao diện',
                style: TextStyle(
                    color: themeProvider.isDarkMode ? Colors.white : Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
              SwitchListTile(
                title: Text('Sáng/Tối',
                    style: TextStyle(color: themeProvider.isDarkMode ? Colors.white : Colors.black)),
                subtitle:  Text('Hiệu ứng chuyển động',
                    style: TextStyle(color: themeProvider.isDarkMode ? Colors.white70 : Colors.black87)),
                value: themeProvider.isDarkMode,
                onChanged: (bool value) {
                  themeProvider.toggleTheme();
                },
                activeColor: Colors.white,
                inactiveThumbColor: Colors.grey,
              ),
              const Divider(),
              // About & Support
              ListTile(
                leading: Icon(Icons.info_outline, color: themeProvider.isDarkMode ? Colors.white : Colors.black),
                title: Text('Giới thiệu',
                    style: TextStyle(color: themeProvider.isDarkMode ? Colors.white : Colors.black)),
                onTap: () {
                  _showAboutDialog(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.class_outlined, color: themeProvider.isDarkMode ? Colors.white : Colors.black),
                title: Text('Thỏa thuận sử dụng',
                    style: TextStyle(color: themeProvider.isDarkMode ? Colors.white : Colors.black)),
                onTap: () {
                  _showHelpDialog(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.privacy_tip_outlined, color: themeProvider.isDarkMode ? Colors.white : Colors.black),
                title: Text('Chính sách bảo mật',
                    style: TextStyle(color: themeProvider.isDarkMode ? Colors.white : Colors.black)),
                onTap: () {
                  _showHelpDialog(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.flag_outlined, color: themeProvider.isDarkMode ? Colors.white : Colors.black),
                title: Text('Báo cáo vi phạm bản quyền',
                    style: TextStyle(color: themeProvider.isDarkMode ? Colors.white : Colors.black)),
                onTap: () {
                  _showHelpDialog(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.ad_units, color: themeProvider.isDarkMode ? Colors.white : Colors.black),
                title: Text('Quảng cáo',
                    style: TextStyle(color: themeProvider.isDarkMode ? Colors.white : Colors.black)),
                onTap: () {
                  _showHelpDialog(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.phone, color: themeProvider.isDarkMode ? Colors.white : Colors.black),
                title: Text('Liên hệ',
                    style: TextStyle(color: themeProvider.isDarkMode ? Colors.white : Colors.black)),
                onTap: () {
                  _showHelpDialog(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQualityOption(String quality) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return ListTile(
      leading: Icon(Icons.music_note_outlined, color: themeProvider.isDarkMode ? Colors.white : Colors.black),
      title: Text(quality, style: TextStyle(color: themeProvider.isDarkMode ? Colors.white : Colors.black)),
      trailing: _selectedQuality == quality
          ? const Icon(Icons.check, color: Colors.blue)
          : null,
      onTap: () {
        setState(() {
          _selectedQuality = quality;
        });
      },
    );
  }

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Giới thiệu'),
          content: const Text(
              'Giấy phép mạng xã hội: 157/GP-BTTTT do Bộ Thông tin và Truyền thông cấp ngày 24/4/2019. Chủ quản: Công Ty Cổ Phần VNGZ06 Đường số 13, phường Tân Thuận Đông, quận 7, thành phố Hồ Chí Minh, Việt Nam'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Đóng'),
            ),
          ],
        );
      },
    );
  }

  void _showHelpDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Xin chào'),
          content: const Text(
              'Chức năng này chúng tôi đang phát triển, xin lỗi vì sự bất tiện này <3 '),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Đóng'),
            ),
          ],
        );
      },
    );
  }
}
