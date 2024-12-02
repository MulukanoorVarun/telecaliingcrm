import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:telecaliingcrm/Services/UserApi.dart';

import '../model/LeadeBoardModel.dart';
import '../providers/ConnectivityProviders.dart';
import '../services/Shimmers.dart';
import '../services/otherservices.dart';
import '../utils/ColorConstants.dart';
import '../utils/constants.dart';

class LeaderboardScreen extends StatefulWidget {
  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> {
  bool isloading = true;
  @override
  void initState() {
    fetchLeaderboardData();
    Provider.of<ConnectivityProviders>(context, listen: false)
        .initConnectivity();
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
    setState(() {
      if (res != null) {
        leaderboardData = res as List<LeaderBoardModel>;
        isloading = false;
      } else {
        isloading = false;
        print("No leaderboard data found.");
      }
    });
  }

  String capitalizeFirstLetter(String text) {
    if (text.isEmpty) {
      return text;
    }
    return text[0].toUpperCase() + text.substring(1);
  }

  @override
  Widget build(BuildContext context) {
    var connectiVityStatus = Provider.of<ConnectivityProviders>(context);
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
              leading: Container(),
              leadingWidth: 20,
            ),
            body: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child:isloading?
                    ListView.builder(
                      itemCount: 10, // Adjust the number of shimmer items as needed
                      itemBuilder: (context, index) {
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
                                shimmerText(30, 22), // Shimmer for leaderboard number
                                const SizedBox(width: 16.0),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8.0),
                                  child: Container(
                                    width: 50.0,
                                    height: 50.0,
                                    color: Colors.grey[300], // Background color for the shimmer
                                  ),
                                ),
                                const SizedBox(width: 16.0),
                                shimmerText(120, 16), // Shimmer for name
                                Spacer(),
                                shimmerText(60, 22), // Shimmer for count
                              ],
                            ),
                          ),
                        );
                      },
                    ):
                    ListView.builder(
                      itemCount: leaderboardData.length,
                      itemBuilder: (context, index) {
                        final leadboard = leaderboardData[index];
                        final leaderNumber = index + 1;
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
                                Text(
                                  leaderNumber.toString(),
                                  style: TextStyle(
                                    color: color28,
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: "Poppins",
                                  ),
                                ),
                                const SizedBox(width: 16.0),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8.0),
                                  child: Container(
                                    width: 50.0,
                                    height: 50.0,
                                    color: primaryColor, // Background color for the container (can be customized)
                                    alignment: Alignment.center, // Center the text
                                    child: Text(
                                      leadboard.name?.isNotEmpty ?? false
                                          ? leadboard.name![0].toUpperCase()
                                          : '', // Show first character or empty if name is null/empty
                                      style: const TextStyle(
                                        fontSize: 24.0, // Font size for the letter
                                        fontFamily: "Poppins",
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white, // Text color
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 16.0),
                                Text(
                                  capitalizeFirstLetter(leadboard.name ?? ""),
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
                                    fontWeight: FontWeight.w600,
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
          )
        : NoInternetWidget();
  }
  Widget _buildShimmerList() {
    return ListView.builder(
      itemCount: 10, // Adjust the number of shimmer items as needed
      shrinkWrap: true,
      physics: const AlwaysScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.symmetric(vertical: 6),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(7),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  shimmerRectangle(20), // Shimmer for calendar icon
                  const SizedBox(width: 8),
                  shimmerText(100, 15), // Shimmer for due date
                  const Spacer(),
                  shimmerRectangle(20), // Shimmer for edit icon
                ],
              ),
              const SizedBox(height: 20),
              shimmerText(150, 20), // Shimmer for milestone title
              const SizedBox(height: 4),
              shimmerText(300, 14), // Shimmer for milestone description
              const SizedBox(height: 10),
              shimmerText(350, 14),
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  shimmerText(60, 14), // Shimmer for "Progress" label
                  shimmerText(40, 14), // Shimmer for percentage
                ],
              ),
            ],
          ),
        );
      },
    );
  }

}
