import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:telecaliingcrm/utils/ColorConstants.dart';
import 'package:telecaliingcrm/utils/constants.dart';

import '../providers/ConnectivityProviders.dart';
import '../services/otherservices.dart';

class LeadScreen extends StatefulWidget {
  const LeadScreen({super.key});

  @override
  State<LeadScreen> createState() => _LeadsScreenState();
}

class _LeadsScreenState extends State<LeadScreen> {
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
    var connectiVityStatus =Provider.of<ConnectivityProviders>(context);
    return (connectiVityStatus.isDeviceConnected == "ConnectivityResult.wifi" ||
        connectiVityStatus.isDeviceConnected == "ConnectivityResult.mobile")
        ?
    Scaffold(
      backgroundColor: scaffoldbgColor,
      appBar: AppBar(
        title: Text(
          'Leads',
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
          Expanded(
            child: ListView.builder(
                itemCount: 10,
                itemBuilder: (context, index) {
                  return container(
                    context,
                    margin: EdgeInsets.symmetric(vertical: 5, horizontal: 16),
                    child: Column(
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
                                  text(context, "ABCD ENTERPRISES", 17,fontWeight: FontWeight.w600),
                                  text(context, "9988776650", 20,fontWeight: FontWeight.w500,color: Color(0xff949494)),
                                  text(context, "Followup : 24-10-1988", 16,fontWeight: FontWeight.w400,color: Color(0xff949494)),
                                  SizedBox(height: 10,),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      container(context,
                                          colors: coldbgColor,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(5)),
                                          padding: EdgeInsets.symmetric(
                                              vertical: 2, horizontal: 10),
                                          margin: EdgeInsets.only(bottom: 10,left: 0),
                                          child: text(context, "cold", 14,
                                              color: color11)),
                                      Padding(
                                        padding: const EdgeInsets.only(right: 8.0),
                                        child: text(context, "View Info>", 14,
                                            color: Color(0xff646363),
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              children: [
                                container(context,
                                    colors: primaryColor,
                                    padding: EdgeInsets.all(16),
                                    margin: EdgeInsets.all(0),
                                    child: Image(
                                      image: AssetImage("assets/call.png"),
                                      width: 20,
                                      height: 20,
                                    )),
                                SizedBox(height: 14,),
                                container(context,
                                    colors: primaryColor,
                                    padding: EdgeInsets.all(16),
                                    margin: EdgeInsets.all(0),
                                    child: Image(
                                      image: AssetImage("assets/whatsapp.png"),
                                      width: 20,
                                      height: 20,
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
