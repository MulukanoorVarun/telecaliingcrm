import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:telecaliingcrm/Services/UserApi.dart';
import 'package:telecaliingcrm/providers/leaderBoardprovider.dart';
import 'package:cached_network_image/cached_network_image.dart';
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

  Future<void> fetchLeaderboardData() async {
    final leaderBoard =
        Provider.of<LeaderBoardProvider>(context, listen: false);
    leaderBoard.fetchLeaderboardData(context);
  }

  String capitalizeFirstLetter(String text) {
    if (text.isEmpty) {
      return text;
    }
    return text[0].toUpperCase() + text.substring(1);
  }

  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
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
            body: Consumer<LeaderBoardProvider>(
              builder: (context, leaderBoardProvider, child) {
                return Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: leaderBoardProvider.isLoading
                      ? _buildShimmerList()
                      : Column(
                        children: [
                          Expanded(
                              child: NotificationListener<ScrollNotification>(
                                onNotification: (ScrollNotification scrollInfo) {
                                  if (leaderBoardProvider.isLoading &&
                                      scrollInfo.metrics.pixels ==
                                          scrollInfo.metrics.maxScrollExtent) {
                                    if (leaderBoardProvider.hasNext) {
                                      leaderBoardProvider
                                          .fetchMoreLeaderboardData(context);
                                    }
                                    return true;
                                  }
                                  return false;
                                },
                                child: CustomScrollView(
                                  slivers: [
                                    SliverList(
                                        delegate: SliverChildBuilderDelegate(
                                            (context, index) {
                                      final leadboard = leaderBoardProvider
                                          .leaderboardData[index];
                                      final leaderNumber = index + 1;
                                      String profile_image = leadboard.photo ?? '';
                                      return Card(
                                        child: Container(
                                          margin: const EdgeInsets.symmetric(vertical: 8.0),
                                          padding: const EdgeInsets.all(12.0),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(10.0),
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
                                              ClipOval(
                                                // borderRadius: BorderRadius.circular(8.0),
                                                child: Container(
                                                  width: 45.0,
                                                  height: 45.0,
                                                  decoration: BoxDecoration(
                                                    color: primaryColor, // Background color for the container
                                                    shape: BoxShape.circle,
                                                  ),
                                                  child: profile_image.isNotEmpty
                                                      ? CachedNetworkImage(
                                                    imageUrl: profile_image,
                                                    fit: BoxFit.cover,
                                                    placeholder: (BuildContext context, String url) {
                                                      return Center(
                                                        child: spinkits.getSpinningLinespinkit(),
                                                      );
                                                    },
                                                    errorWidget: (BuildContext context, String url, dynamic error) {
                                                      // Handle error if the image fails to load
                                                      return Icon(Icons.person);
                                                    },
                                                  )
                                                      : Center(
                                                    child: Text(
                                                      leadboard.name?.isNotEmpty ?? false
                                                          ? leadboard.name![0].toUpperCase()
                                                          : '',
                                                      style: const TextStyle(
                                                        fontSize: 24.0, // Font size for the letter
                                                        fontFamily: "Poppins",
                                                        fontWeight: FontWeight.w600,
                                                        color: Colors.white, // Text color
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),

                                              const SizedBox(width: 16.0),
                                              SizedBox(
                                                width: w*0.38,
                                                child: Text(
                                                  overflow: TextOverflow.ellipsis,
                                                  maxLines: 2,
                                                  capitalizeFirstLetter(
                                                      leadboard.name ?? ""),
                                                  style: const TextStyle(
                                                    fontSize: 15.0,
                                                    fontFamily: "Poppins",
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ),

                                              Spacer(),
                                              Text(
                                               "${leadboard.count.toString()}",
                                                style: TextStyle(
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
                                            childCount: leaderBoardProvider
                                                .leaderboardData.length)),
                                    if (leaderBoardProvider.pageLoading)
                                      SliverToBoxAdapter(
                                        child: Center(
                                          child: CircularProgressIndicator(
                                            strokeWidth: 0.8,
                                          ),
                                        ),
                                      )
                                  ],
                                ),
                              ),
                            ),
                        ],
                      ),
                );
              },
            ),
          )
        : NoInternetWidget();
  }

  Widget _buildShimmerList() {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: 10,
            shrinkWrap: true,
            physics: const AlwaysScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return Card(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          shimmerRectangle(20), // Shimmer for calendar icon
                          const SizedBox(width: 8),
                          shimmerCircle(50), // Shimmer for calendar icon
                          const SizedBox(width: 8),
                          shimmerText(130, 15), // Shimmer for due date
                          const Spacer(),
                          shimmerRectangle(20), // Shimmer for edit icon
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
