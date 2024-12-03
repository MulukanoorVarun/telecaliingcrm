import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:telecaliingcrm/screens/AddLeadsScreen.dart';
import 'package:telecaliingcrm/utils/ColorConstants.dart';
import 'package:telecaliingcrm/utils/constants.dart';
import 'package:url_launcher/url_launcher.dart';

import '../Services/UserApi.dart';
import '../model/ViewInfoModel.dart';
import '../providers/ConnectivityProviders.dart';
import '../services/Shimmers.dart';
import '../services/otherservices.dart';
import 'UpDateLeadScreen.dart';

class LeadInformation extends StatefulWidget {
  final String ID;
  const LeadInformation({super.key, required this.ID});

  @override
  State<LeadInformation> createState() => _LeadInformationState();
}

class _LeadInformationState extends State<LeadInformation> {
  bool is_loading = true;
  @override
  void initState() {
    Provider.of<ConnectivityProviders>(context, listen: false)
        .initConnectivity();
    getLeadsInformationApi();
    super.initState();
  }

  List<ViewInfo> leadinfo = [];
  void getLeadsInformationApi() async {
    var result = await Userapi.getViewInfo(widget.ID);
    setState(() {
      if (result?.status == true) {
        leadinfo = result?.data ?? [];
        is_loading = false;
        print("Response: $result");
      } else {
        is_loading = false;
        print("Failed to update the call status.");
      }
    });
  }

  @override
  void dispose() {
    Provider.of<ConnectivityProviders>(context, listen: false).dispose();
    super.dispose();
  }

  String formatDate(String? dateString) {
    // Check if the dateString is null or empty
    if (dateString == null || dateString.isEmpty) {
      return ''; // or return a default value like 'No Date Available'
    }

    // Parse the input string into a DateTime object
    DateTime dateTime = DateTime.parse(dateString);

    // Format the DateTime object to a string in 'yyyy-MM-dd' format
    String formattedDate = DateFormat('yyyy-MM-dd').format(dateTime);

    return formattedDate;
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
    var connectiVityStatus = Provider.of<ConnectivityProviders>(context);
    return (connectiVityStatus.isDeviceConnected == "ConnectivityResult.wifi" ||
            connectiVityStatus.isDeviceConnected == "ConnectivityResult.mobile")
        ? Scaffold(
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
                  Navigator.pop(context,true);
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
                        margin:
                            EdgeInsets.symmetric(vertical: 5, horizontal: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 5),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
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
                                              text(context,
                                                  leadinfo[0].number ?? "", 20,
                                                  fontWeight: FontWeight.w500,
                                                  color: Color(0xff949494)),
                                            ],
                                          ),
                                          Container(
                                            padding: EdgeInsets.all(0.0),
                                            decoration: BoxDecoration(
                                              color: primaryColor, // background color of the container
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      10), // rounded corners
                                            ),
                                            child: IconButton(
                                              visualDensity: VisualDensity.compact,
                                              padding: EdgeInsets.all(0),
                                              icon: Icon(
                                                Icons.edit,
                                                color:
                                                    Colors.white, // Icon color
                                              ),
                                              onPressed: () async {
                                                // Action when the edit button is pressed
                                                var res = await Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          UpDateLeadScreen(
                                                        ID: leadinfo[0]
                                                                .id
                                                                .toString() ??
                                                            "",
                                                        name:
                                                            leadinfo[0].name ??
                                                                "",
                                                        remarks: leadinfo[0]
                                                                .remarks ??
                                                            "",
                                                      ),
                                                    ));
                                                if (res == true) {
                                                  is_loading = true;
                                                  getLeadsInformationApi();
                                                }
                                              },
                                              tooltip: 'Edit',
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
                                          if (leadinfo[0].followUpDate !=
                                              null) ...[
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
                                              colors: (leadinfo[0]
                                                  .stageName
                                                  ?.stageName ==
                                                  "Cold")
                                                  ? coldbgColor
                                                  : (leadinfo[0]
                                                  .stageName
                                                  ?.stageName ==
                                                  "Hot")
                                                  ? Color(
                                                  0xffFFA89C)
                                                  : Color(
                                                  0xff95F8B6),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(5)),
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 2, horizontal: 10),
                                              margin: EdgeInsets.only(bottom: 0, left: 0),
                                              child: text(
                                                  context,
                                                  leadinfo[0]
                                                          .stageName
                                                          ?.stageName ??
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
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
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
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    // Call Icon
                                    Column(
                                      children: [
                                        GestureDetector(
                                          onTap: () async {
                                            await FlutterPhoneDirectCaller
                                                .callNumber(
                                                    leadinfo[0].number ?? "");
                                          },
                                          child: Image(
                                            image:
                                                AssetImage("assets/call.png"),
                                            color: primaryColor,
                                            width: 25,
                                            height: 25,
                                          ),
                                        ),
                                        Text("Call",
                                            style: TextStyle(fontSize: 14))
                                      ],
                                    ),
                                    // SMS Icon
                                    Column(
                                      children: [
                                        GestureDetector(
                                          onTap: () => launchSMS(leadinfo[0]
                                                  .number ??
                                              ""), // Replace with actual phone number
                                          child: Image(
                                            image: AssetImage("assets/sms.png"),
                                            color: primaryColor,
                                            width: 25,
                                            height: 25,
                                          ),
                                        ),
                                        Text("SMS",
                                            style: TextStyle(fontSize: 14))
                                      ],
                                    ),
                                    // WhatsApp Icon
                                    Column(
                                      children: [
                                        GestureDetector(
                                          onTap: () => launchWhatsApp(
                                              leadinfo[0].number ?? "",
                                              'Hello!'), // Replace with actual phone number and message
                                          child: Image(
                                            image: AssetImage(
                                                "assets/whatsapp.png"),
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
                          ))
                    ],
                  ),
          )
        : NoInternetWidget();
  }
  Widget _buildShimmerList() {
    return ListView.builder(
      itemCount: 2, // Adjust the number of shimmer items as needed
      shrinkWrap: true,
      physics: const AlwaysScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.symmetric(vertical: 8,horizontal: 16),
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
