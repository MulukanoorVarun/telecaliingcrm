import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:telecaliingcrm/providers/FollowupProvider.dart';
import 'package:telecaliingcrm/utils/ColorConstants.dart';
import 'package:telecaliingcrm/utils/constants.dart';
import 'package:url_launcher/url_launcher.dart';
import '../providers/ConnectivityProviders.dart';
import '../services/Shimmers.dart';
import '../services/otherservices.dart';
import 'LeadInformation.dart';

class FollowupsScreen extends StatefulWidget {
  const FollowupsScreen({super.key});

  @override
  State<FollowupsScreen> createState() => _FollowupsScreenState();
}

class _FollowupsScreenState extends State<FollowupsScreen> {
  @override
  void initState() {
    Provider.of<ConnectivityProviders>(context, listen: false).initConnectivity();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchFollowups();
    });
    super.initState();
  }

  Future<void> _fetchFollowups() async {
    final leadsProvider = Provider.of<FollowupProvider>(context, listen: false);
    leadsProvider.getFollowUpApi(context);
  }

  @override
  void dispose() {
    Provider.of<ConnectivityProviders>(context, listen: false).dispose();
    super.dispose();
  }

  String formatDate(String dateTime) {
    // Parse the string into a DateTime object
    final DateTime parsedDate = DateTime.parse(dateTime);
    // Format the DateTime to Indian date format (DD-MM-YYYY)
    return "${parsedDate.day.toString().padLeft(2, '0')}-${parsedDate.month.toString().padLeft(2, '0')}-${parsedDate.year}";
  }

  void _launchWhatsApp(number) async {
    final url = 'https://wa.me/$number';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not open WhatsApp.';
    }
  }

  @override
  Widget build(BuildContext context) {
    var connectiVityStatus = Provider.of<ConnectivityProviders>(context);
    var w = MediaQuery.of(context).size.width;
    var h = MediaQuery.of(context).size.height;
    return (connectiVityStatus.isDeviceConnected == "ConnectivityResult.wifi" ||
            connectiVityStatus.isDeviceConnected == "ConnectivityResult.mobile")
        ? WillPopScope(
            onWillPop: () async {
              Navigator.pop(context, true);
              return false; // Return true to allow the pop
            },
            child: Scaffold(
              backgroundColor: scaffoldbgColor,
              appBar: AppBar(
                title: Text(
                  'Followups',
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
                    Navigator.pop(context, true);
                  },
                ),
              ),
              body:Consumer<FollowupProvider>(builder: (context,followupProvider,child){
                if(followupProvider.isLoading){
                  return _buildShimmerList();
                }else if(followupProvider.followupList.length>0){
                  return Column(
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      Expanded(
                        child: NotificationListener<ScrollNotification>(
                          onNotification: (ScrollNotification scrollInfo) {
                            if (!followupProvider.isLoading &&
                                scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
                              if (followupProvider.nextPage) {
                                followupProvider.fetchMoreFollowUpList(context);
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
                                    final followup_List = followupProvider.followupList[index];
                                    return container(
                                      context,
                                      margin: EdgeInsets.symmetric(
                                          vertical: 5, horizontal: 16),
                                      child: Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                            children: [
                                              text(
                                                  context,
                                                  '${followup_List.leadType?.number ?? ""}',
                                                  20),
                                              text(
                                                  context,
                                                  "Followup: ${formatDate(followup_List.followupDate ?? "")}",
                                                  15),
                                            ],
                                          ),
                                          Divider(
                                            height: 1.8,
                                            thickness: 0.8,
                                            color:
                                            Colors.black.withOpacity(0.25),
                                          ),
                                          SizedBox(height: 5),
                                          Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                            children: [
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                      children: [
                                                        container(context,
                                                            colors: (followup_List
                                                                .leadType
                                                                ?.stageName
                                                                ?.stageName ==
                                                                "Cold")
                                                                ? coldbgColor
                                                                : (followup_List.leadType?.stageName?.stageName ==
                                                                "Hot")
                                                                ? Color(
                                                                0xffFFA89C)
                                                                : Color(
                                                                0xff95F8B6),
                                                            borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    5)),
                                                            padding: EdgeInsets.symmetric(
                                                                vertical: 2,
                                                                horizontal: 10),
                                                            margin: EdgeInsets.only(
                                                                bottom: 0,
                                                                left: 0),
                                                            child: text(
                                                                context,
                                                                followup_List.leadType?.stageName?.stageName ?? "",
                                                                14,
                                                                color: color11)),
                                                        // SizedBox(
                                                        //   width: 35,
                                                        // ),
                                                        InkWell(
                                                          onTap: () {
                                                            Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                  builder:
                                                                      (context) =>
                                                                      LeadInformation(
                                                                        ID: followup_List
                                                                            .leadId
                                                                            .toString(),
                                                                      ),
                                                                ));
                                                          },
                                                          child: Padding(
                                                            padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                            child: text(
                                                                context,
                                                                "View Info>",
                                                                14,
                                                                color:
                                                                primaryColor,
                                                                textdecoration:
                                                                TextDecoration
                                                                    .underline,
                                                                decorationcolor:
                                                                primaryColor),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    text(
                                                        context,
                                                        '${followup_List.name}',
                                                        18),
                                                    Text.rich(
                                                      TextSpan(
                                                        children: [
                                                          TextSpan(
                                                              text:
                                                              'Remarks : ',
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                                  fontFamily:
                                                                  "Poppins")),
                                                          TextSpan(
                                                              text: followup_List
                                                                  .remarks !=
                                                                  null
                                                                  ? '${followup_List.remarks}'
                                                                  : "NA",
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                  FontWeight
                                                                      .normal)),
                                                        ],
                                                      ),
                                                      maxLines: 3,
                                                      textAlign:
                                                      TextAlign.start,
                                                      overflow: TextOverflow
                                                          .ellipsis, // Optional, to handle text overflow
                                                    )
                                                  ],
                                                ),
                                              ),
                                              Column(
                                                children: [
                                                  InkWell(
                                                    onTap: () async {
                                                      await FlutterPhoneDirectCaller
                                                          .callNumber(followup_List
                                                          .phone
                                                          .toString() ??
                                                          "");
                                                    },
                                                    child: container(context,
                                                        colors: primaryColor,
                                                        padding:
                                                        EdgeInsets.all(10),
                                                        margin: EdgeInsets
                                                            .symmetric(
                                                            vertical: 3,
                                                            horizontal: 3),
                                                        child: Image(
                                                          image: AssetImage(
                                                              "assets/call.png"),
                                                          width: 30,
                                                          height: 30,
                                                        )),
                                                  ),
                                                  GestureDetector(
                                                    onTap: () {
                                                      _launchWhatsApp(
                                                          followup_List.phone
                                                              .toString() ??
                                                              "");
                                                    },
                                                    child: container(context,
                                                        colors: primaryColor,
                                                        padding:
                                                        EdgeInsets.all(10),
                                                        margin: EdgeInsets
                                                            .symmetric(
                                                            vertical: 3,
                                                            horizontal: 3),
                                                        child: Image(
                                                          image: AssetImage(
                                                              "assets/whatsapp.png"),
                                                          width: 30,
                                                          height: 30,
                                                        )),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                    );;
                                  },
                                  childCount: followupProvider.followupList.length,
                                ),
                              ),
                              SliverPadding(
                                padding: EdgeInsets.only(bottom: 30),
                                sliver: SliverToBoxAdapter(
                                  child: SizedBox(
                                    height: 10,
                                  ),
                                ),
                              ),
                              if (followupProvider.pageLoading)
                                SliverToBoxAdapter(
                                  child: Align(alignment: Alignment.center,
                                    child:CircularProgressIndicator(strokeWidth: 1)
                                  ),
                                )
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                    ],
                  );
                }else{
                  return Center(
                    child: Column(
                      children: [
                        SizedBox(
                          height: w * 0.54,
                        ),
                        Lottie.asset(
                          'assets/animations/nodata1.json', // Your Lottie animation file
                          width: 150, // Adjust the size as needed
                          height: 150,
                          fit: BoxFit.cover,
                        ),
                      ],
                    ),
                  );
                }

              }),
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
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
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
