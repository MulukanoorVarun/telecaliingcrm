import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:telecaliingcrm/utils/ColorConstants.dart';
import 'package:telecaliingcrm/utils/constants.dart';

import '../Services/UserApi.dart';
import '../model/GetFollowUpModel.dart';
import '../providers/ConnectivityProviders.dart';
import '../services/otherservices.dart';
import 'AddFollowUp.dart';

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
      body: is_loading?Center(child: CircularProgressIndicator(color: color28,)):

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
                                          margin: EdgeInsets.only(bottom: 10,left: 0),
                                          child: text(context, followup_List.leadType?.stageName?.stageName??"", 14,
                                              color: color11)),
                                      // SizedBox(
                                      //   width: 35,
                                      // ),
                                      text(context, "View Info>", 14,
                                          color: color11,
                                          textdecoration:
                                              TextDecoration.underline,
                                          decorationcolor: color11),
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
                                container(context,
                                    colors: primaryColor,
                                    padding: EdgeInsets.all(16),
                                    margin: EdgeInsets.symmetric(
                                        vertical: 3, horizontal: 3),
                                    child: Image(
                                      image: AssetImage("assets/call.png"),
                                      width: 30,
                                      height: 30,
                                    )),
                                container(context,
                                    colors: primaryColor,
                                    padding: EdgeInsets.all(16),
                                    margin: EdgeInsets.symmetric(
                                        vertical: 3, horizontal: 3),
                                    child: Image(
                                      image: AssetImage("assets/whatsapp.png"),
                                      width: 30,
                                      height: 30,
                                    )),
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
}
