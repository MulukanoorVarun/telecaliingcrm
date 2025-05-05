
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../Services/UserApi.dart';
import '../model/ViewInfoModel.dart';
import '../providers/FollowupProvider.dart';
import '../services/Shimmers.dart';
import '../utils/ColorConstants.dart';
import '../utils/constants.dart';
import 'SubscriptionExpiredScreen.dart';

class FollowupInformation extends StatefulWidget {
  final String leadId;
  final String followupId;
  const FollowupInformation({super.key, required this.leadId,required this.followupId});
  @override
  State<FollowupInformation> createState() => _FollowupInformationState();
}

class _FollowupInformationState extends State<FollowupInformation> {
  bool is_loading = true;

  @override
  void initState() {
    getLeadsInformationApi();
    super.initState();
  }

  List<ViewInfo> leadinfo = [];
  void getLeadsInformationApi() async {
    var result = await Userapi.getViewInfo(widget.leadId);
    setState(() {
      if (result?.status == true) {
        leadinfo = result?.data ?? [];
        is_loading = false;
        debugPrint("Response: $result");
      } else {
        is_loading = false;
        debugPrint("Failed to update the call status.");
      }
    });
  }

  String formatDate(String dateTime) {
    // Parse the string into a DateTime object
    final DateTime parsedDate = DateTime.parse(dateTime);
    // Format the DateTime to Indian date format (DD-MM-YYYY)
    return "${parsedDate.day.toString().padLeft(2, '0')}-${parsedDate.month.toString().padLeft(2, '0')}-${parsedDate.year}";
  }

  // Function to send SMS
  Future<void> launchSMS(String phoneNumber) async {
    final Uri smsUri = Uri(scheme: 'sms', path: phoneNumber);
    if (await canLaunch(smsUri.toString())) {
      await launch(smsUri.toString());
    } else {
      throw 'Could not send SMS to $phoneNumber';
    }
  }

  // Function to launch WhatsApp
  Future<void> launchWhatsApp(String phoneNumber, String message) async {
    final Uri whatsappUri =
    Uri.parse("https://wa.me/$phoneNumber?text=${Uri.encodeFull(message)}");
    if (await canLaunch(whatsappUri.toString())) {
      await launch(whatsappUri.toString());
    } else {
      throw 'Could not open WhatsApp';
    }
  }

  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    var h = MediaQuery.of(context).size.height;
    final followupProvider =
    Provider.of<FollowupProvider>(context, listen: false);
    return Scaffold(
      backgroundColor: scaffoldbgColor,
      appBar: AppBar(
        title: Text(
          'FollowUp Information',
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
      body: is_loading
          ? _buildShimmerList()
          : Column(
        children: [
          SizedBox(
            height: 10,
          ),
          container(
            context,
            margin: EdgeInsets.symmetric(vertical: 5, horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: [
                                    text(
                                        context,
                                        leadinfo[0].name != ""
                                            ? leadinfo[0].name ?? ""
                                            : "Unknown",
                                        17,
                                        fontWeight: FontWeight.w600),
                                    text(context, leadinfo[0].number.toString(),
                                        17,
                                        fontWeight: FontWeight.w500,
                                        color: Color(0xff949494)),
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: 35, // Square size
                                height: 35,
                                child: FilledButton(
                                  style: FilledButton.styleFrom(
                                    backgroundColor: primaryColor,
                                    padding: EdgeInsets.zero,
                                    shape: RoundedRectangleBorder(
                                      borderRadius:
                                      BorderRadius.circular(8),
                                    ),
                                    visualDensity: VisualDensity.compact,
                                  ),
                                  onPressed: () {
                                    context.push(
                                        "/update_followup?followupId=${widget.followupId}&staffId=${leadinfo[0].staffId}&leadId=${widget.leadId}");
                                  },
                                  child: const Icon(
                                    Icons.edit,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                ),
                              ),
                              SizedBox(width: 10,),
                              SizedBox(
                                width: 35, // Square size
                                height: 35,
                                child: FilledButton(
                                  style: FilledButton.styleFrom(
                                    backgroundColor: primaryColor,
                                    padding: EdgeInsets.zero,
                                    shape: RoundedRectangleBorder(
                                      borderRadius:
                                      BorderRadius.circular(8),
                                    ),
                                    visualDensity: VisualDensity.compact,
                                  ),
                                  onPressed: () async {
                                    var res = await Provider.of<FollowupProvider>(context, listen: false).deleteFollowUp(widget.followupId);
                                  },
                                  child: const Icon(
                                    Icons.delete_outline_sharp,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Divider(
                            height: 1.8,
                            thickness: 0.8,
                            color: Colors.black.withOpacity(0.25),
                          ),
                          SizedBox(height: 5),
                          Row(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                            children: [
                              text(
                                  context,
                                  "Created on\n${formatDate(leadinfo[0].dateAdded ?? "")}",
                                  16,
                                  fontWeight: FontWeight.w400,
                                  color: Color(0xff949494),
                                  textAlign: TextAlign.start),
                              if (leadinfo[0].followUpDate != null) ...[
                                text(
                                    context,
                                    "Next Followup\n${formatDate(leadinfo[0].followUpDate ?? "")}",
                                    16,
                                    fontWeight: FontWeight.w400,
                                    color: Color(0xff949494),
                                    textAlign: TextAlign.end),
                              ]
                            ],
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Row(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                            children: [
                              text(context, "Remarks", 16,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black),
                              container(context,
                                  colors:
                                  (leadinfo[0].stageName?.stageName ==
                                      "Cold")
                                      ? coldbgColor
                                      : (leadinfo[0]
                                      .stageName
                                      ?.stageName ==
                                      "Hot")
                                      ? Color(0xffFFA89C)
                                      : Color(0xff95F8B6),
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(5)),
                                  padding: EdgeInsets.symmetric(
                                      vertical: 2, horizontal: 10),
                                  margin:
                                  EdgeInsets.only(bottom: 0, left: 0),
                                  child: text(
                                      context,
                                      leadinfo[0].stageName?.stageName ??
                                          "",
                                      14,
                                      color: color11)),
                            ],
                          ),
                          SizedBox(
                            height: 2,
                          ),
                          text(
                              context,
                              leadinfo[0].remarks != null
                                  ? leadinfo[0].remarks ?? ""
                                  : "No remarks found",
                              16,
                              fontWeight: FontWeight.w400,
                              textAlign: TextAlign.start,
                              color: Color(0xff736D6D)),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          container(context,
              w: w,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  text(context, "Quick Connect", 18,
                      fontWeight: FontWeight.w500),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Call Icon
                        Column(
                          children: [
                            GestureDetector(
                              onTap: () async {
                                await FlutterPhoneDirectCaller.callNumber(
                                    leadinfo[0].number.toString());
                              },
                              child: Image(
                                image: AssetImage("assets/call.png"),
                                color: primaryColor,
                                width: 25,
                                height: 25,
                              ),
                            ),
                            Text("Call", style: TextStyle(fontSize: 14))
                          ],
                        ),
                        // SMS Icon
                        Column(
                          children: [
                            GestureDetector(
                              onTap: () => launchSMS(leadinfo[0].number.toString()), // Replace with actual phone number
                              child: Image(
                                image: AssetImage("assets/sms.png"),
                                color: primaryColor,
                                width: 25,
                                height: 25,
                              ),
                            ),
                            Text("SMS", style: TextStyle(fontSize: 14))
                          ],
                        ),
                        // WhatsApp Icon
                        Column(
                          children: [
                            GestureDetector(
                              onTap: () => launchWhatsApp(
                                  leadinfo[0].number.toString(),
                                  'Hello!'), // Replace with actual phone number and message
                              child: Image(
                                image: AssetImage("assets/whatsapp.png"),
                                color: primaryColor,
                                width: 25,
                                height: 25,
                              ),
                            ),
                            Text("Whatsapp",
                                style: TextStyle(fontSize: 14))
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              )),
          Expanded(
            child: NotificationListener<ScrollNotification>(
              onNotification: (ScrollNotification scrollInfo) {
                if (!followupProvider.isLoading &&
                    scrollInfo.metrics.pixels ==
                        scrollInfo.metrics.maxScrollExtent) {
                  if (followupProvider.nextPage) {
                    followupProvider.fetchMoreFollowUpList("Open");
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
                                      "Followup: ${formatDate(followup_List.createdAt?? "")}",
                                      15),
                                ],
                              ),
                              Divider(
                                height: 1.8,
                                thickness: 0.8,
                                color: Colors.black.withOpacity(0.25),
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
                                            // container(context,
                                            //     colors: (followup_List.leadType?.stageName
                                            //         ?.stageName ==
                                            //         "Cold")
                                            //         ? coldbgColor
                                            //         : (followup_List.leadType?.stageName?.stageName ==
                                            //         "Hot")
                                            //         ? Color(
                                            //         0xffFFA89C)
                                            //         : Color(
                                            //         0xff95F8B6),
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
                                            //             .leadType
                                            //             ?.stageName
                                            //             ?.stageName ??
                                            //             "",
                                            //         14,
                                            //         color: color11)),
                                            // SizedBox(
                                            //   width: 35,
                                            // ),
                                            InkWell(
                                              onTap: () {
                                                context.push(
                                                    "/lead_information?ID=${followup_List.leadId}");
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
                                        text(context,
                                            '${followup_List.name}', 18),
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
                                          launchWhatsApp(
                                              followup_List.phone
                                                  .toString() ??
                                                  "",
                                              "Hello!");
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
        ],
      ),
    );
  }

  Widget _buildShimmerList() {
    return ListView.builder(
      itemCount: 2, // Adjust the number of shimmer items as needed
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