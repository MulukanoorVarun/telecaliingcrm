import 'package:flutter/material.dart';
import 'package:telecaliingcrm/utils/ColorConstants.dart';
import 'package:telecaliingcrm/utils/constants.dart';

class FollowupsScreen extends StatefulWidget {
  const FollowupsScreen({super.key});

  @override
  State<FollowupsScreen> createState() => _FollowupsScreenState();
}

class _FollowupsScreenState extends State<FollowupsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            text(context, "7382373824", 20),
                            text(context, "Followup : 24-10-1988", 15),
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
                                    mainAxisAlignment: MainAxisAlignment.start,
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
                                      SizedBox(
                                        width: 35,
                                      ),
                                      text(context, "View Info>", 14,
                                          color: color11,
                                          textdecoration:
                                              TextDecoration.underline,
                                          decorationcolor: color11)
                                    ],
                                  ),
                                  text(context, "ABCD ENTERPRISES", 18),
                                  text(
                                      context,
                                      "Client told to work on the proposal and send it to me on monday",
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
    );
  }
}
