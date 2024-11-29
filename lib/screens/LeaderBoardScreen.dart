import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/ConnectivityProviders.dart';
import '../services/otherservices.dart';
import '../utils/ColorConstants.dart';

class LeaderboardScreen extends StatefulWidget {
  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> {
  // Sample leaderboard data
  final List<Map<String, dynamic>> leaderboardData = [
    {"leaderNo": 1, "imageUrl": "https://via.placeholder.com/50", "name": "Alice", "score": 1200},
    {"leaderNo": 2, "imageUrl": "https://via.placeholder.com/50", "name": "Bob", "score": 1150},
    {"leaderNo": 3, "imageUrl": "https://via.placeholder.com/50", "name": "Charlie", "score": 1100},
    {"leaderNo": 4, "imageUrl": "https://via.placeholder.com/50", "name": "David", "score": 1050},
    {"leaderNo": 5, "imageUrl": "https://via.placeholder.com/50", "name": "Eve", "score": 1000},
  ];
  @override
  void initState() {
    Provider.of<ConnectivityProviders>(context,listen: false).initConnectivity();
    super.initState();
  }

  @override
  void dispose() {
    Provider.of<ConnectivityProviders>(context, listen: false).dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    var connectiVityStatus =Provider.of<ConnectivityProviders>(context);
    return (connectiVityStatus.isDeviceConnected == "ConnectivityResult.wifi" ||
        connectiVityStatus.isDeviceConnected == "ConnectivityResult.mobile")
        ? Scaffold(
      appBar: AppBar(
        title: Text(
          'Leaderboard',
          style: TextStyle(
              fontSize: 22,
              fontFamily: "Poppins",
              fontWeight: FontWeight.w600,
              color: Colors.white),
        ),
        backgroundColor: primaryColor,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            print('Menu button pressed');
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: leaderboardData.length,
          itemBuilder: (context, index) {
            final entry = leaderboardData[index];
            return Card(
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 8.0),
                padding: const EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Row(
                  children: [
                    // Leader Number
                    Text(
                      entry["leaderNo"].toString(),
                      style: const TextStyle(color: primaryColor, fontSize: 22,fontWeight: FontWeight.bold,fontFamily: "Poppins"),
                    ),
                    const SizedBox(width: 16.0),

                    // Rectangular Image
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Image.network(
                        entry["imageUrl"],
                        width: 50.0,
                        height: 50.0,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: 16.0),

                    // Name and Score
                    Text(
                      entry["name"],
                      style: const TextStyle(
                        fontSize: 16.0,
                        fontFamily: "Poppins",
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Spacer(),
                    Text(
                      "${entry["score"]}",
                      style: const TextStyle(
                        fontSize: 22.0,
                        fontFamily: "Poppins",
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    ): NoInternetWidget();
  }
}

