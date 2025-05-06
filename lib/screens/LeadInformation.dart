import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:telecaliingcrm/screens/AddLeadsScreen.dart';
import 'package:telecaliingcrm/utils/ColorConstants.dart';
import 'package:telecaliingcrm/utils/constants.dart';
import 'package:url_launcher/url_launcher.dart';

import '../Services/UserApi.dart';
import '../model/ViewInfoModel.dart';
import '../providers/ConnectivityProviders.dart';
import '../providers/FollowupProvider.dart';
import '../providers/LeadsProvider.dart';
import '../services/Shimmers.dart';
import '../services/otherservices.dart';
import 'SubscriptionExpiredScreen.dart';
import 'UpDateLeadScreen.dart';

class LeadInformation extends StatefulWidget {
  final String ID;
  const LeadInformation({super.key, required this.ID});

  @override
  State<LeadInformation> createState() => _LeadInformationState();
}

class _LeadInformationState extends State<LeadInformation> {
  // bool is_loading = true;

  // @override
  // void initState() {
  //   Provider.of<LeadsProvider>(context,listen: false).getLeadsInformationApi(widget.ID);
  //   super.initState();
  // }
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();
    });
  }
  Future<void> _loadData() async {
    final leadsProvider = Provider.of<LeadsProvider>(context, listen: false);
    await Future.wait([
      leadsProvider.getLeadsInformationApi(widget.ID),
      leadsProvider.getFollowUpByLeadID(widget.ID),
    ]);
  }

  void _launchWhatsApp(number) async {
    final url = 'https://wa.me/$number';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not open WhatsApp.';
    }
  }

  String formatDate(String? dateTime) {
    if (dateTime == null || dateTime.isEmpty) {
      return "N/A";
    }
    try {
      final DateTime parsedDate = DateTime.parse(dateTime);
      final DateFormat formatter = DateFormat('dd-MM-yyyy');
      return formatter.format(parsedDate);
    } catch (e) {
      debugPrint("Error parsing date: $e");
      return "N/A";
    }
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
    // final followupProvider =
    //     Provider.of<FollowupProvider>(context, listen: false);
    return Scaffold(
      backgroundColor: scaffoldbgColor,
      appBar: AppBar(
        title: Text(
          'Lead Information',
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
      body:  Consumer<LeadsProvider>(builder: (context, leadsInfo, child) {
            if(leadsInfo.isLoading){
              return  _buildShimmerList();
            }
              return Column(
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
                                            text(context,
                                                leadsInfo.leadinfo[0].number.toString(), 17,
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
                                                "/update_lead?ID=${ leadsInfo.leadinfo[0].id}&name=${ leadsInfo.leadinfo[0].name}&remarks=${ leadsInfo.leadinfo[0].remarks}");
                                          },
                                          child: Icon(
                                            Icons.edit,
                                            color: Colors.white,
                                            size: 20,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      // FilledButton(
                                      //     style: FilledButton.styleFrom(
                                      //       backgroundColor: primaryColor,
                                      //       padding: EdgeInsets.zero,
                                      //       shape: RoundedRectangleBorder(
                                      //         borderRadius:
                                      //         BorderRadius.circular(8),
                                      //       ),
                                      //       visualDensity: VisualDensity.compact,
                                      //     ),
                                      //
                                      //     child: const Text(
                                      //       "Lost",
                                      //       style:
                                      //       TextStyle(fontFamily: "Poppins"),
                                      //     )),
                                      SizedBox(
                                        width: 35, // Square size
                                        height: 35,
                                        child: FilledButton(
                                          style: FilledButton.styleFrom(
                                            backgroundColor: primaryColor,
                                            padding: EdgeInsets.zero,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                            visualDensity: VisualDensity.compact,
                                          ),   onPressed: () {
                                          context.pushReplacement(
                                              "/lost_lead?id=${ leadsInfo.leadinfo[0].id}&name=${leadsInfo.leadinfo[0].name}&remarks=${ leadsInfo.leadinfo[0].remarks}&dealStage=${leadsInfo.leadinfo[0].dealStatus}&leadsStage=${leadsInfo.leadinfo[0].leadStageId}&stage_type=${leadsInfo.leadinfo[0].leadStageId}&service_type=${leadsInfo.leadinfo[0].serviceType}&industry_type=${leadsInfo.leadinfo[0].industryType}");
                                        },
                                          // onPressed: () async {
                                          //   var res = await Provider.of<
                                          //       FollowupProvider>(context,
                                          //       listen: false)
                                          //       .deleteFollowUp(widget.followupId);
                                          //   if(res==true){
                                          //     Provider.of<DashboardProvider>(context, listen: false).fetchDashBoardDetails("Pending");
                                          //     context.pop();
                                          //   }
                                          // },
                                          child: const Icon(
                                            Icons.delete_outline_sharp,
                                            color: Colors.white,
                                            size: 20,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 5),
                                  Divider(
                                    height: 1.8,
                                    thickness: 0.8,
                                    color: Colors.black.withOpacity(0.25),
                                  ),
                                  SizedBox(height: 5),
                                  text(overflow: TextOverflow.ellipsis,maxLines: 2,textAlign: TextAlign.start,
                                      context,leadsInfo.leadinfo[0].name!= "" ? leadsInfo.leadinfo[0].name ?? "": "Unknown",
                                      17,
                                      fontWeight: FontWeight.w600),
                                  Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: [
                                      text(
                                          context,
                                          "Created on\n${formatDate( leadsInfo.leadinfo[0].dateAdded ?? "")}",
                                          16,
                                          fontWeight: FontWeight.w400,
                                          color: Color(0xff949494),
                                          textAlign: TextAlign.start),
                                      if ( leadsInfo.leadinfo[0].followUpDate != null) ...[
                                        text(
                                            context,
                                            "Next Followup\n${formatDate( leadsInfo.leadinfo[0].followUpDate ?? "")}",
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
                                          ( leadsInfo.leadinfo[0].stageName?.stageName ==
                                              "Cold")
                                              ? coldbgColor
                                              : ( leadsInfo.leadinfo[0]
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
                                              leadsInfo.leadinfo[0].stageName?.stageName ??
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
                                      leadsInfo.leadinfo[0].remarks != null
                                          ?  leadsInfo.leadinfo[0].remarks ?? ""
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
                                            leadsInfo.leadinfo[0].number.toString());
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
                                      onTap: () => launchSMS(leadsInfo.leadinfo[0]
                                          .number
                                          .toString()), // Replace with actual phone number
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
                                          leadsInfo.leadinfo[0].number.toString(),
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
                    child: CustomScrollView(
                      slivers: [
                        SliverList(
                          delegate: SliverChildBuilderDelegate(
                                (context, index) {
                                  // String formatDate(String? dateTime) {
                                  //   if (dateTime == null || dateTime.isEmpty) {
                                  //     return "N/A";
                                  //   }
                                  //   try {
                                  //     final DateTime parsedDate = DateTime.parse(dateTime);
                                  //     return "${parsedDate.day.toString().padLeft(2, '0')}-${parsedDate.month.toString().padLeft(2, '0')}-${parsedDate.year}";
                                  //   } catch (e) {
                                  //     debugPrint("Error parsing date: $e");
                                  //     return "N/A";
                                  //   }
                                  // }
                                  final followup_List = leadsInfo.selectedFollowUpByLead[index];
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
                                                  text(textAlign: TextAlign.start,maxLines: 2,overflow: TextOverflow.ellipsis,
                                                      context,
                                                      '${followup_List.name}', 17),
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Text.rich(
                                                        TextSpan(
                                                          children: [
                                                            TextSpan(
                                                                text: 'Status : ',
                                                                style: TextStyle(
                                                                    fontWeight:
                                                                    FontWeight.bold,
                                                                    fontFamily:
                                                                    "Poppins")),
                                                            TextSpan(
                                                                text: '${followup_List.status}',
                                                                style: TextStyle(
                                                                    fontWeight:
                                                                    FontWeight.normal,fontFamily: "Poppins")),
                                                          ],
                                                        ),
                                                        maxLines: 3,
                                                        textAlign: TextAlign.start,
                                                        overflow: TextOverflow
                                                            .ellipsis, // Optional, to handle text overflow
                                                      ),
                                                      InkWell(
                                                        onTap: () {
                                                          context.pushReplacement(
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
                            },
                            childCount: leadsInfo.selectedFollowUpByLead.length,
                          ),
                        ),
                    
                        SliverPadding(
                          padding: EdgeInsets.only(bottom: 20),
                          sliver: SliverToBoxAdapter(child: SizedBox(height: 10)),
                        ),
                    
                      ],
                    ),
                  ),
                ],
              );

          },
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
