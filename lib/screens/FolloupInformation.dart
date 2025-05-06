import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../Services/UserApi.dart';
import '../model/ViewInfoModel.dart';
import '../providers/DashBoardProvider.dart';
import '../providers/FollowupProvider.dart';
import '../services/Shimmers.dart';
import '../utils/ColorConstants.dart';
import '../utils/constants.dart';
import 'SubscriptionExpiredScreen.dart';

class FollowupInformation extends StatefulWidget {
  final String leadId;
  final String followupId;
  const FollowupInformation(
      {super.key, required this.leadId, required this.followupId});
  @override
  State<FollowupInformation> createState() => _FollowupInformationState();
}

class _FollowupInformationState extends State<FollowupInformation> {
  @override
  void initState() {
    Provider.of<FollowupProvider>(context, listen: false)
        .getFollowUpByID(widget.followupId);
    super.initState();
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
      body: Consumer<FollowupProvider>(builder: (context, provider, child) {
        if (provider.isLoading) {
          return _buildShimmerList();
        }
        return Column(
          children: [
            container(
              context,
              margin: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      text(
                                          context,
                                          provider.selectedFollowUp?.name != ""
                                              ? provider
                                                      .selectedFollowUp?.name ??
                                                  ""
                                              : "Unknown",
                                          17,
                                          fontWeight: FontWeight.w600),
                                      text(
                                          context,
                                          provider.selectedFollowUp?.phone ??
                                              "",
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
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      visualDensity: VisualDensity.compact,
                                    ),
                                    onPressed: () {
                                      context.pushReplacement(
                                          "/update_followup?followupId=${widget.followupId}&staffId=${provider.selectedFollowUp?.staffId}&leadId=${widget.leadId}");
                                    },
                                    child: const Icon(
                                      Icons.edit,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
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
                                    ),
                                    onPressed: () async {
                                      var res = await Provider.of<
                                                  FollowupProvider>(context,
                                              listen: false)
                                          .deleteFollowUp(widget.followupId);
                                      if(res==true){
                                        Provider.of<DashboardProvider>(context, listen: false).fetchDashBoardDetails("Pending");
                                        context.pop();
                                      }
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                text(
                                    context,
                                    "Status\n${provider.selectedFollowUp?.status}",
                                    16,
                                    fontWeight: FontWeight.w400,
                                    color: Color(0xff949494),
                                    textAlign: TextAlign.start),
                                text(
                                    context,
                                    "Created on\n${formatDate(provider.selectedFollowUp?.createdAt ?? "")}",
                                    16,
                                    fontWeight: FontWeight.w400,
                                    color: Color(0xff949494),
                                    textAlign: TextAlign.start),
                              ],
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                text(context, "FollowUp Type : ", 15,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black),
                                text(
                                    context,
                                    "${provider.selectedFollowUp?.typeOfFollowUp}",
                                    16,
                                    fontWeight: FontWeight.w400,
                                    color: Color(0xff949494),
                                    textAlign: TextAlign.start),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                text(context, "Remarks", 16,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black),
                                // container(context,
                                //     colors:
                                //     (leadinfo[0].stageName?.stageName ==
                                //         "Cold")
                                //         ? coldbgColor
                                //         : (leadinfo[0]
                                //         .stageName
                                //         ?.stageName ==
                                //         "Hot")
                                //         ? Color(0xffFFA89C)
                                //         : Color(0xff95F8B6),
                                //     borderRadius: BorderRadius.all(
                                //         Radius.circular(5)),
                                //     padding: EdgeInsets.symmetric(
                                //         vertical: 2, horizontal: 10),
                                //     margin:
                                //     EdgeInsets.only(bottom: 0, left: 0),
                                //     child: text(
                                //         context,
                                //         leadinfo[0].stageName?.stageName ??
                                //             "",
                                //         14,
                                //         color: color11)),
                              ],
                            ),
                            SizedBox(
                              height: 2,
                            ),
                            text(
                                context,
                                provider.selectedFollowUp?.remarks != null
                                    ? provider.selectedFollowUp?.remarks ?? ""
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
                                      provider.selectedFollowUp?.phone ?? "");
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
                                onTap: () => launchSMS(
                                    provider.selectedFollowUp?.phone ??
                                        ""), // Replace with actual phone number
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
                                    provider.selectedFollowUp?.phone ?? "",
                                    'Hello!'), // Replace with actual phone number and message
                                child: Image(
                                  image: AssetImage("assets/whatsapp.png"),
                                  color: primaryColor,
                                  width: 25,
                                  height: 25,
                                ),
                              ),
                              Text("Whatsapp", style: TextStyle(fontSize: 14))
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                )),
          ],
        );
      }),
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
