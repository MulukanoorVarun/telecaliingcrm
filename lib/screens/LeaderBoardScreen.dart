import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:telecaliingcrm/Services/UserApi.dart';

import '../model/LeadeBoardModel.dart';
import '../providers/ConnectivityProviders.dart';
import '../services/otherservices.dart';
import '../utils/ColorConstants.dart';

class LeaderboardScreen extends StatefulWidget {
  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> {
  bool isloading=true;
  @override
  void initState() {
    fetchLeaderboardData();
    Provider.of<ConnectivityProviders>(context,listen: false).initConnectivity();
    super.initState();
  }

  @override
  void dispose() {
    Provider.of<ConnectivityProviders>(context, listen: false).dispose();
    super.dispose();
  }

  List<LeaderBoardModel> leaderboardData = [];
  Future<void> fetchLeaderboardData() async {
    var res = await Userapi.getLeaderboard();
    setState(() {// Now it returns List<LeaderBoardModel>?
    if (res != null) {
        leaderboardData = res as List<LeaderBoardModel>;
        isloading=false;// Assign the list of LeaderBoardModel objects
    } else {
      isloading=false;
      print("No leaderboard data found.");
    }
    });
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
            final leadboard = leaderboardData[index];
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
                    // Text(
                    //   entry["leaderNo"].toString(),
                    //   style: const TextStyle(color: primaryColor, fontSize: 22,fontWeight: FontWeight.bold,fontFamily: "Poppins"),
                    // ),
                    // const SizedBox(width: 16.0),

                    // Rectangular Image
                    // ClipRRect(
                    //   borderRadius: BorderRadius.circular(8.0),
                    //   child: Image.network(
                    //     entry["imageUrl"],
                    //     width: 50.0,
                    //     height: 50.0,
                    //     fit: BoxFit.cover,
                    //   ),
                    // ),
                    const SizedBox(width: 16.0),

                    // Name and Score
                    Text(
                      leadboard.name??"",
                      style: const TextStyle(
                        fontSize: 16.0,
                        fontFamily: "Poppins",
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Spacer(),
                    Text(
                      leadboard.count.toString(),
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

