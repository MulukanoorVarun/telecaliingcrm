import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:telecaliingcrm/utils/ColorConstants.dart';
import 'package:telecaliingcrm/utils/constants.dart';

import '../providers/ConnectivityProviders.dart';
import '../services/otherservices.dart';

class LeadInformation extends StatefulWidget {
  const LeadInformation({super.key});

  @override
  State<LeadInformation> createState() => _LeadInformationState();
}

class _LeadInformationState extends State<LeadInformation> {
  @override
  void initState() {
    Provider.of<ConnectivityProviders>(context,listen: false).initConnectivity();
    super.initState();
  }

  @override
  void dispose() {
    Provider.of<ConnectivityProviders>(context, listen: false).dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var w= MediaQuery.of(context).size.width;
    var h= MediaQuery.of(context).size.height;
    var connectiVityStatus =Provider.of<ConnectivityProviders>(context);
    return (connectiVityStatus.isDeviceConnected == "ConnectivityResult.wifi" ||
        connectiVityStatus.isDeviceConnected == "ConnectivityResult.mobile")
        ?      Scaffold(
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
            print('Menu button pressed');
          },
        ),
      ),
      body: Column(
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
                          text(context, "ABCD ENTERPRISES", 17,
                              fontWeight: FontWeight.w600),
                          text(context, "9988776650", 20,
                              fontWeight: FontWeight.w500,
                              color: Color(0xff949494)),
                          Divider(
                            height: 1.8,
                            thickness: 0.8,
                            color: Colors.black.withOpacity(0.25),
                          ),
                          SizedBox(height: 5),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              text(context, "Created on\n24-10-1988", 16,
                                  fontWeight: FontWeight.w400,
                                  color: Color(0xff949494),
                                  textAlign: TextAlign.start),
                              text(context, "Next Followup\n24-10-1988", 16,
                                  fontWeight: FontWeight.w400,
                                  color: Color(0xff949494),
                                  textAlign: TextAlign.end),
                            ],
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              text(context, "Remarks", 16,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black),
                              container(context,
                                  colors: coldbgColor,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5)),
                                  padding: EdgeInsets.symmetric(
                                      vertical: 2, horizontal: 10),
                                  margin: EdgeInsets.only(bottom: 10, left: 0),
                                  child: text(context, "cold", 14,
                                      color: color11)),
                            ],
                          ),
                          SizedBox(
                            height: 2,
                          ),
                          text(
                              context,
                              "Client told to work on the proposal and send it to me on monday",
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
                  text(context, "Quick Connect", 18,fontWeight: FontWeight.w500),
                  SizedBox(height: 10,),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            Image(image: AssetImage("assets/call.png"),color: primaryColor,width: 25,height: 25,),
                            text(context, "Call", 14)
                          ],
                        ),
                        Column(
                          children: [
                            Image(image: AssetImage("assets/sms.png"),color: primaryColor,width: 25,height: 25,),
                            text(context, "SMS", 14)
                          ],
                        ),
                        Column(
                          children: [
                            Image(image: AssetImage("assets/whatsapp.png"),color: primaryColor,width: 25,height: 25,),
                            text(context, "Whatsapp", 14)
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ))
        ],
      ),
    ): NoInternetWidget();
  }
}
