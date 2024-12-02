import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:telecaliingcrm/utils/ColorConstants.dart';
import 'package:telecaliingcrm/utils/constants.dart';
import 'package:url_launcher/url_launcher.dart';

import '../Services/UserApi.dart';
import '../model/GetFollowUpModel.dart';
import '../providers/ConnectivityProviders.dart';
import '../services/Shimmers.dart';
import '../services/otherservices.dart';
import 'AddFollowUp.dart';
import 'LeadInformation.dart';

class FollowupsScreen extends StatefulWidget {
  const FollowupsScreen({super.key});

  @override
  State<FollowupsScreen> createState() => _FollowupsScreenState();
}

class _FollowupsScreenState extends State<FollowupsScreen> {
  @override
  void initState() {
    getFollowUpApi();
    Provider.of<ConnectivityProviders>(context,listen: false).initConnectivity();
    super.initState();
  }

  @override
  void dispose() {
    Provider.of<ConnectivityProviders>(context, listen: false).dispose();
    super.dispose();
  }
 bool is_loading =true;

  List<FollowUpModel> data=[];

  void getFollowUpApi() async {

    var result = await Userapi.getFollowup();

    setState(() {

      if (result?.status == true) {
        data=result?.data??[];
        is_loading=false;
        print("Response: $result");
      } else {
        is_loading=false;
        print("Failed to update the call status.");
      }
    });
  }
  String formatDate(String dateTime) {
    // Parse the string into a DateTime object
    final DateTime parsedDate = DateTime.parse(dateTime);
    // Format the DateTime to only display the date
    return "${parsedDate.year}-${parsedDate.month.toString().padLeft(2, '0')}-${parsedDate.day.toString().padLeft(2, '0')}";
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
    var connectiVityStatus =Provider.of<ConnectivityProviders>(context);
    return (connectiVityStatus.isDeviceConnected == "ConnectivityResult.wifi" ||
        connectiVityStatus.isDeviceConnected == "ConnectivityResult.mobile")
        ?
     Scaffold(
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
            Navigator.pop(context,true);
          },
        ),
      ),
      body: is_loading?_buildShimmerList():

      Column(
        children: [
          SizedBox(
            height: 10,
          ),

          Expanded(
            child: ListView.builder(
                itemCount: data.length,
                itemBuilder: (context, index) {
                  final followup_List=data[index];
                  return container(
                    context,
                    margin: EdgeInsets.symmetric(vertical: 5, horizontal: 16),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            text(context,'${followup_List.leadType?.number??""}', 20),
                            text(context, "Followup: ${formatDate(followup_List.followupDate??"")}", 15),
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
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      container(context,
                                          colors: coldbgColor,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(5)),
                                          padding: EdgeInsets.symmetric(
                                              vertical: 2, horizontal: 10),
                                          margin: EdgeInsets.only(bottom: 0,left: 0),
                                          child: text(context, followup_List.leadType?.stageName?.stageName??"", 14,
                                              color: color11)),
                                      // SizedBox(
                                      //   width: 35,
                                      // ),
                                      InkWell(
                                        onTap:(){
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    LeadInformation(
                                                      ID: followup_List.leadId
                                                          .toString(),
                                                    ),
                                              ));
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: text(context, "View Info>", 14,
                                              color: color11,
                                              textdecoration:
                                                  TextDecoration.underline,
                                              decorationcolor: color11),
                                        ),
                                      ),
                                    ],
                                  ),
                                  text(context, '${followup_List.name}', 18),
                                  text(
                                      context,
                                      '${followup_List.remarks}',
                                      14,
                                      maxLines: 3,
                                      textAlign: TextAlign.start),
                                ],
                              ),
                            ),
                            Column(
                              children: [
                                InkWell(
                                  onTap: () async {
                                    await FlutterPhoneDirectCaller
                                        .callNumber(
                                        followup_List.phone.toString() ?? "");
                                  },
                                  child: container(context,
                                      colors: primaryColor,
                                      padding: EdgeInsets.all(10),
                                      margin: EdgeInsets.symmetric(
                                          vertical: 3, horizontal: 3),
                                      child: Image(
                                        image: AssetImage("assets/call.png"),
                                        width: 30,
                                        height: 30,
                                      )),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    _launchWhatsApp(
                                        followup_List.phone.toString()  ?? "");
                                  },
                                  child: container(context,
                                      colors: primaryColor,
                                      padding: EdgeInsets.all(10),
                                      margin: EdgeInsets.symmetric(
                                          vertical: 3, horizontal: 3),
                                      child: Image(
                                        image: AssetImage("assets/whatsapp.png"),
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
                }),
          ),
          SizedBox(
            height: 10,
          ),
        ],
      ),
    ): NoInternetWidget();
  }
  Widget _buildShimmerList() {
    return ListView.builder(
      itemCount: 10, // Adjust the number of shimmer items as needed
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
