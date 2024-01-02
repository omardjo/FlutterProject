import 'package:flutter/material.dart';

class CardStat extends StatelessWidget {
  final String title;
  final int randomNumber;

  const CardStat({
    Key? key,
    required this.title,
    required this.randomNumber,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(16.0),
      padding: EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: Colors.blue[50], // Light blue background
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.blueGrey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: Colors.blue[900], // Dark blue text
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Random Number: $randomNumber',
            style: TextStyle(
              color: Colors.blue[800], // Slightly lighter blue text
              fontSize: 18,
            ),
          ),
        ],
      ),
    );
  }
}
