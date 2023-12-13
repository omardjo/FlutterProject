import 'package:flutter/material.dart';

void main() {
  runApp(const Statistic());
}

class Statistic extends StatelessWidget {
  const Statistic({super.key});

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
  const UserStatusBar({super.key});

  @override
  _UserStatusBarState createState() => _UserStatusBarState();
}

class _UserStatusBarState extends State<UserStatusBar>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Status'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Active'),
            Tab(text: 'Banned'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          // Active Users Tab
          Center(
            child: Text('Active Users'),
          ),

          // Banned Users Tab
          Center(
            child: Text('Banned Users'),
          ),
        ],
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
