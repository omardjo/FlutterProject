import 'package:flutter/material.dart';

class RecentFile {
  final AssetImage? icon;
  final String? title, date, size;

  RecentFile({this.icon, this.title, this.date, this.size});
}

List demoRecentFiles = [
  RecentFile(
    icon: AssetImage('assets/images/earthquake.png'),
    title: "25 km SE of Skwentna, Alaska",
    date: "01-03-2021",
    size: "3.5 Richter",
  ),
  RecentFile(
    icon: AssetImage('assets/images/earthquake.png'),
    title: "Island of Hawaii, Hawaii",
    date: "27-02-2021",
    size: "1.9 Richter",
  ),
  RecentFile(
    icon: AssetImage('assets/images/earthquake.png'),
    title: "29 km NW of Toyah, Texas",
    date: "23-02-2021",
    size: "2.2 Richter",
  ),
  RecentFile(
    icon: AssetImage('assets/images/earthquake.png'),
    title: "6 km NNW of The Geysers, CA",
    date: "21-02-2021",
    size: "3.5 Richter",
  ),
  RecentFile(
    icon: AssetImage('assets/images/earthquake.png'),
    title: "Fiji region",
    date: "23-02-2021",
    size: "2.5 Richter",
  ),
];