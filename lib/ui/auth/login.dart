import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:music_app/data/helper/user_preferences.dart';
import 'package:music_app/data/model/user.dart';
import 'package:provider/provider.dart';

import '../../plugin/ThemeProvider.dart';
import '../account/account.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();

    return Scaffold(
      backgroundColor: themeProvider.isDarkMode ? Colors.black : Colors.white,
      body: Column(
        children: [
          CupertinoNavigationBar(
            middle: Text(
              'Đăng nhập',
              style: TextStyle(
                color: themeProvider.isDarkMode ? Colors.white : Colors.black,
              ),
            ),
            leading: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Icon(
                CupertinoIcons.back,
                color: themeProvider.isDarkMode ? Colors.white : Colors.black,
              ),
            ),
            backgroundColor:
                themeProvider.isDarkMode ? Colors.black : Colors.white,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Chào mừng trở lại!',
                        style: TextStyle(
                          color: themeProvider.isDarkMode
                              ? Colors.white
                              : Colors.black,
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Vui lòng đăng nhập để tiếp tục',
                        style: TextStyle(
                          color: themeProvider.isDarkMode
                              ? Colors.white70
                              : Colors.black87,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 32),
                      TextField(
                        controller: emailController,
                        style: TextStyle(
                          color: themeProvider.isDarkMode
                              ? Colors.white
                              : Colors.black,
                        ),
                        decoration: InputDecoration(
                          labelText: 'Email',
                          labelStyle: TextStyle(
                            color: themeProvider.isDarkMode
                                ? Colors.white70
                                : Colors.black87,
                          ),
                          filled: true,
                          fillColor: themeProvider.isDarkMode
                              ? Colors.grey[850]
                              : Colors.grey[300],
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: passwordController,
                        obscureText: true,
                        style: TextStyle(
                          color: themeProvider.isDarkMode
                              ? Colors.white
                              : Colors.black,
                        ),
                        decoration: InputDecoration(
                          labelText: 'Mật khẩu',
                          labelStyle: TextStyle(
                            color: themeProvider.isDarkMode
                                ? Colors.white70
                                : Colors.black87,
                          ),
                          filled: true,
                          fillColor: themeProvider.isDarkMode
                              ? Colors.grey[850]
                              : Colors.grey[300],
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: () async{
                          final email = emailController.text.trim();
                          final password = passwordController.text.trim();

                          final user = await UserPreferences.getUser();
                          if(user != null && user.email == email && user.password == password) {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => const AccountTab()),
                            );
                          } else {
                            showDialog(context: context, builder: (context) => AlertDialog(
                              title: const Text('Error'),
                              content: const Text('Email hoặc mật khẩu không đúng'),
                              actions: [
                                TextButton(onPressed: () {
                                  Navigator.pop(context);
                                }, child: const Text('OK'))
                              ],
                            ));
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: themeProvider.isDarkMode
                              ? Colors.blueAccent
                              : Colors.blue,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            'Đăng nhập',
                            style: TextStyle(
                              fontSize: 18,
                              color: themeProvider.isDarkMode
                                  ? Colors.white
                                  : Colors.white,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const ForgotPasswordPage()));
                          },
                          child: Text(
                            'Quên mật khẩu?',
                            style: TextStyle(
                              color: themeProvider.isDarkMode
                                  ? Colors.white70
                                  : Colors.black87,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),
                      Align(
                        alignment: Alignment.center,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              CupertinoPageRoute(
                                builder: (context) => SignUpPage(),
                              ),
                            );
                          },
                          child: Text(
                            'Chưa có tài khoản? Đăng ký',
                            style: TextStyle(
                              color: themeProvider.isDarkMode
                                  ? Colors.white70
                                  : Colors.black87,
                              fontSize: 16,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ForgotPasswordPage extends StatelessWidget {
  const ForgotPasswordPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      backgroundColor: themeProvider.isDarkMode ? Colors.black : Colors.white,
      appBar: CupertinoNavigationBar(
        middle: Text(
          'Quên mật khẩu',
          style: TextStyle(
            color: themeProvider.isDarkMode ? Colors.white : Colors.black,
          ),
        ),
        backgroundColor: themeProvider.isDarkMode ? Colors.black : Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Khôi phục mật khẩu',
                  style: TextStyle(
                    color:
                        themeProvider.isDarkMode ? Colors.white : Colors.black,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Nhập email của bạn để khôi phục mật khẩu',
                  style: TextStyle(
                    color: themeProvider.isDarkMode
                        ? Colors.white70
                        : Colors.black87,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 32),
                TextField(
                  style: TextStyle(
                    color:
                        themeProvider.isDarkMode ? Colors.white : Colors.black,
                  ),
                  decoration: InputDecoration(
                    labelText: 'Email',
                    labelStyle: TextStyle(
                      color: themeProvider.isDarkMode
                          ? Colors.white70
                          : Colors.black87,
                    ),
                    filled: true,
                    fillColor: themeProvider.isDarkMode
                        ? Colors.grey[850]
                        : Colors.grey[300],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {
                    // Xử lý khôi phục mật khẩu
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: themeProvider.isDarkMode
                        ? Colors.blueAccent
                        : Colors.blue,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      'Gửi liên kết khôi phục',
                      style: TextStyle(
                        fontSize: 18,
                        color: themeProvider.isDarkMode
                            ? Colors.white
                            : Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SignUpPage extends StatelessWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    final nameController = TextEditingController();
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    final confirmPasswordController = TextEditingController();

    return Scaffold(
      backgroundColor: themeProvider.isDarkMode ? Colors.black : Colors.white,
      appBar: CupertinoNavigationBar(
        middle: Text(
          'Đăng ký',
          style: TextStyle(
            color: themeProvider.isDarkMode ? Colors.white : Colors.black,
          ),
        ),
        backgroundColor: themeProvider.isDarkMode ? Colors.black : Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Tạo tài khoản mới',
                  style: TextStyle(
                    color:
                        themeProvider.isDarkMode ? Colors.white : Colors.black,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Điền thông tin để tạo tài khoản',
                  style: TextStyle(
                    color: themeProvider.isDarkMode
                        ? Colors.white70
                        : Colors.black87,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 32),
                TextField(
                  controller: nameController,
                  style: TextStyle(
                    color:
                        themeProvider.isDarkMode ? Colors.white : Colors.black,
                  ),
                  decoration: InputDecoration(
                    labelText: 'Tên đầy đủ',
                    labelStyle: TextStyle(
                      color: themeProvider.isDarkMode
                          ? Colors.white70
                          : Colors.black87,
                    ),
                    filled: true,
                    fillColor: themeProvider.isDarkMode
                        ? Colors.grey[850]
                        : Colors.grey[300],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: emailController,
                  style: TextStyle(
                    color:
                        themeProvider.isDarkMode ? Colors.white : Colors.black,
                  ),
                  decoration: InputDecoration(
                    labelText: 'Email',
                    labelStyle: TextStyle(
                      color: themeProvider.isDarkMode
                          ? Colors.white70
                          : Colors.black87,
                    ),
                    filled: true,
                    fillColor: themeProvider.isDarkMode
                        ? Colors.grey[850]
                        : Colors.grey[300],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: passwordController,
                  obscureText: true,
                  style: TextStyle(
                    color:
                        themeProvider.isDarkMode ? Colors.white : Colors.black,
                  ),
                  decoration: InputDecoration(
                    labelText: 'Mật khẩu',
                    labelStyle: TextStyle(
                      color: themeProvider.isDarkMode
                          ? Colors.white70
                          : Colors.black87,
                    ),
                    filled: true,
                    fillColor: themeProvider.isDarkMode
                        ? Colors.grey[850]
                        : Colors.grey[300],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: confirmPasswordController,
                  obscureText: true,
                  style: TextStyle(
                    color:
                        themeProvider.isDarkMode ? Colors.white : Colors.black,
                  ),
                  decoration: InputDecoration(
                    labelText: 'Xác nhận mật khẩu',
                    labelStyle: TextStyle(
                      color: themeProvider.isDarkMode
                          ? Colors.white70
                          : Colors.black87,
                    ),
                    filled: true,
                    fillColor: themeProvider.isDarkMode
                        ? Colors.grey[850]
                        : Colors.grey[300],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () async {
                    final name = nameController.text.trim();
                    final email = emailController.text.trim();
                    final password = passwordController.text.trim();
                    final confirmPassword =
                        confirmPasswordController.text.trim();

                    if (password == confirmPassword) {
                      final user = User(
                          id: null,
                          name: name,
                          role: ROLE_MEMBER,
                          email: email,
                          password: password);

                      await UserPreferences.saveUser(user);
                      print(user);
                      Navigator.pop(context);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Mật khẩu không khớp')),
                      );
                    }

                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        themeProvider.isDarkMode ? Colors.white : Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      'Đăng ký',
                      style: TextStyle(
                        fontSize: 18,
                        color: themeProvider.isDarkMode
                            ? Colors.black
                            : Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Align(
                  alignment: Alignment.center,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      'Đã có tài khoản? Đăng nhập',
                      style: TextStyle(
                        color: themeProvider.isDarkMode
                            ? Colors.white70
                            : Colors.black87,
                        fontSize: 16,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
