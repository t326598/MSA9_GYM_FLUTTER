import 'package:flutter/material.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(color: Colors.blue),
            child: Text(
              "메뉴",
              style: TextStyle(color: Colors.white, fontSize: 24),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text("홈"),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, "/home");
            },
          ),
          ListTile(
            leading: const Icon(Icons.login),
            title: const Text("로그인"),
            onTap: () {
              Navigator.pushNamed(context, "/login");
            },
          ),
          ListTile(
            leading: const Icon(Icons.people),
            title: const Text("회원가입"),
            onTap: () {
              Navigator.pushNamed(context, "/join");
            },
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text("마이페이지"),
            onTap: () {
              Navigator.pushNamed(context, "/mypage");
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text("로그아웃"),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
