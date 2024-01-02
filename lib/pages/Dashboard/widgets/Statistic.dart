import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:safeguard/model/user_model.dart';
void main() {
  runApp(const Statistic());
}

class Statistic extends StatelessWidget {
  const Statistic({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'User Status Bar',
      theme: ThemeData.dark().copyWith(
        colorScheme: const ColorScheme.dark(
          primary: Color.fromARGB(255, 43, 87, 245),
          secondary: Color.fromARGB(255, 241, 179, 117),
        ),
      ),
      home: const UserStatusBar(),
    );
  }
}

class UserStatusBar extends StatefulWidget {
  const UserStatusBar({Key? key});

  @override
  _UserStatusBarState createState() => _UserStatusBarState();
}

class _UserStatusBarState extends State<UserStatusBar>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;

  List<User> activeUsers = [];
  List<User> bannedUsers = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    fetchData();
  }

  Future<void> fetchData() async {
    // Replace the URL with your actual API endpoint
    final apiUrl = 'http://127.0.0.1:9090/user/displayAllUsers';

    try {
final response = await http.get(Uri.parse(apiUrl));
final responseBody = json.decode(response.body);
if (responseBody is Map) {
  final List<User> users = (responseBody['users'] as List)
      .map((data) => User.fromJson(data))
      .toList();

      activeUsers = users
          .where((user) => user.status == 'active')
          .toList();
      bannedUsers = users
          .where((user) => user.status == 'banned')
          .toList();

      setState(() {});
    }} catch (error) {
      print('Error fetching data: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Status'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Active Users'),
            Tab(text: 'Banned Users'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Active Users Tab
          buildUserList(activeUsers),

          // Banned Users Tab
          buildUserList(bannedUsers),
        ],
      ),
    );
  }

  Widget buildUserList(List<User> users) {
    return Center(
      child: ListView.builder(
        itemCount: users.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(users[index].userName ?? ''),
            subtitle: Text('Email: ${users[index].email}'),
            // Add more details if needed
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    if (_tabController != null) {
      if (_tabController!.index == _tabController!.length - 1) {
        _tabController!.index = 0;
      }
      _tabController!.dispose();
    }
    super.dispose();
  }
}

