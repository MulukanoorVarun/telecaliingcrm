import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:go_router/go_router.dart';
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
  String _selectedFilter = "open";
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchFollowups();
    });
    super.initState();
  }

  Future<void> _fetchFollowups() async {
    final leadsProvider = Provider.of<FollowupProvider>(context, listen: false);
    leadsProvider.getFollowUpApi(_selectedFilter);
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
    var w = MediaQuery.of(context).size.width;
    var h = MediaQuery.of(context).size.height;
    return WillPopScope(
      onWillPop: () async {
        context.pop();
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
              context.pop();
            },
          ),
          actions: [
            IconButton(
              visualDensity: VisualDensity.compact,
              padding: EdgeInsets.all(0),
              onPressed: () {
                _showFilterBottomSheet(context);
              },
              icon: Icon(Icons.filter_alt_sharp, color: Colors.white),
            ),
          ],
        ),
        body: Consumer<FollowupProvider>(
            builder: (context, followupProvider, child) {
          if (followupProvider.isLoading) {
            return _buildShimmerList();
          } else if (followupProvider.followupList.length > 0) {
            return Column(
              children: [
                SizedBox(
                  height: 10,
                ),
                Expanded(
                  child: NotificationListener<ScrollNotification>(
                    onNotification: (ScrollNotification scrollInfo) {
                      if (!followupProvider.isLoading &&
                          scrollInfo.metrics.pixels ==
                              scrollInfo.metrics.maxScrollExtent) {
                        if (followupProvider.nextPage) {
                          followupProvider
                              .fetchMoreFollowUpList(_selectedFilter);
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
                              final followup_List =
                                  followupProvider.followupList[index];
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
                                            '${followup_List.phone ?? ""}',
                                            20),
                                        text(
                                            context,
                                            "Followup: ${formatDate(followup_List.createdAt ?? "")}",
                                            15),
                                      ],
                                    ),
                                    Divider(
                                      height: 1.8,
                                      thickness: 0.8,
                                      color: Colors.black.withOpacity(0.25),
                                    ),
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
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  // container(context,
                                                  //     colors: (followup_List
                                                  //                 .leadType
                                                  //                 ?.stageName
                                                  //                 ?.stageName ==
                                                  //             "Cold")
                                                  //         ? coldbgColor
                                                  //         : (followup_List.leadType?.stageName?.stageName ==
                                                  //                 "Hot")
                                                  //             ? Color(
                                                  //                 0xffFFA89C)
                                                  //             : Color(
                                                  //                 0xff95F8B6),
                                                  //     borderRadius: BorderRadius.all(
                                                  //         Radius.circular(5)),
                                                  //     padding: EdgeInsets.symmetric(
                                                  //         vertical: 2,
                                                  //         horizontal: 10),
                                                  //     margin: EdgeInsets.only(
                                                  //         bottom: 0, left: 0),
                                                  //     child: text(
                                                  //         context,
                                                  //         followup_List
                                                  //                 .leadType
                                                  //                 ?.stageName
                                                  //                 ?.stageName ??
                                                  //             "",
                                                  //         14,
                                                  //         color: color11)),
                                                  text(context,
                                                      '${followup_List.name}', 18),
                                                  InkWell(
                                                    onTap: () {
                                                      context.push(
                                                          "/followup_information?leadId=${followup_List.leadId}&followupId=${followup_List.id}");
                                                    },
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: text(context,
                                                          "View Info>", 14,
                                                          color: primaryColor,
                                                          textdecoration:
                                                              TextDecoration
                                                                  .underline,
                                                          decorationcolor:
                                                              primaryColor),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Text.rich(
                                                TextSpan(
                                                  children: [
                                                    TextSpan(
                                                        text: 'Remarks : ',
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
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
                                                textAlign: TextAlign.start,
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
                                                  padding: EdgeInsets.all(10),
                                                  margin: EdgeInsets.symmetric(
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
                                                _launchWhatsApp(followup_List
                                                        .phone
                                                        .toString() ??
                                                    "");
                                              },
                                              child: container(context,
                                                  colors: primaryColor,
                                                  padding: EdgeInsets.all(10),
                                                  margin: EdgeInsets.symmetric(
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
                              );
                              ;
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
                            child: Align(
                                alignment: Alignment.center,
                                child:
                                    CircularProgressIndicator(strokeWidth: 1)),
                          ),
                        SliverPadding(
                          padding: EdgeInsets.only(bottom: 20),
                          sliver: SliverToBoxAdapter(
                            child: SizedBox(
                              height: 10,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
              ],
            );
          } else {
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
    );
  }

  void _showFilterBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      backgroundColor: Colors.white,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 5,
                      margin: EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  Text(
                    'Filter by',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                        fontFamily: "Poppins"),
                  ),
                  SizedBox(height: 15),
                  _buildRadioTile(
                    title: 'Open',
                    value: 'open',
                    groupValue: _selectedFilter,
                    onChanged: (value) {
                      setState(() {
                        _selectedFilter = value ?? "";
                      });
                    },
                  ),
                  _buildRadioTile(
                    title: 'Pending',
                    value: 'pending',
                    groupValue: _selectedFilter,
                    onChanged: (value) {
                      setState(() async {
                        _selectedFilter = value ?? "";
                        var res = await Provider.of<FollowupProvider>(context,
                                listen: false)
                            .getFollowUpApi(_selectedFilter ?? "");
                        if (res == true) {
                          context.pop();
                        }
                      });
                    },
                  ),
                  _buildRadioTile(
                    title: 'Completed',
                    value: 'completed',
                    groupValue: _selectedFilter,
                    onChanged: (value) {
                      setState(() async {
                        _selectedFilter = value ?? "";
                        var res = await Provider.of<FollowupProvider>(context,
                                listen: false)
                            .getFollowUpApi(_selectedFilter ?? "");
                        if (res == true) {
                          context.pop();
                        }
                      });
                    },
                  ),
                  SizedBox(height: 24),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildRadioTile({
    required String title,
    required String value,
    required String? groupValue,
    required ValueChanged<String?> onChanged,
  }) {
    return RadioListTile<String>(
      title: Text(title,
          style: TextStyle(
              fontSize: 16,
              color: Colors.black87,
              fontWeight: FontWeight.w400,
              fontFamily: "Poppins")),
      value: value,
      groupValue: groupValue,
      onChanged: onChanged,
      activeColor: primaryColor,
      contentPadding: EdgeInsets.symmetric(horizontal: 8),
      visualDensity: VisualDensity.compact,
    );
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
