import 'package:flutter/material.dart';
import 'package:telecaliingcrm/utils/ColorConstants.dart';
import 'package:telecaliingcrm/utils/constants.dart';

class LeadInformation extends StatefulWidget {
  const LeadInformation({super.key});

  @override
  State<LeadInformation> createState() => _LeadInformationState();
}

class _LeadInformationState extends State<LeadInformation> {
  @override
  Widget build(BuildContext context) {
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
                                  fontWeight: FontWeight.w500,color: Colors.black),
                              container(context,
                                  colors: coldbgColor,
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(5)),
                                  padding: EdgeInsets.symmetric(
                                      vertical: 2, horizontal: 10),
                                  margin: EdgeInsets.only(bottom: 10,left: 0),
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
        ],
      ),
    );
  }
}
