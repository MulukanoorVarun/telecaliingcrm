import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:provider/provider.dart';
import 'package:telecaliingcrm/screens/AddFollowUp.dart';
import 'package:telecaliingcrm/screens/AddLeadsScreen.dart';
import 'package:telecaliingcrm/screens/LeadInformation.dart';
import 'package:telecaliingcrm/utils/ColorConstants.dart';
import 'package:telecaliingcrm/utils/constants.dart';
import 'package:url_launcher/url_launcher.dart';

import '../Services/UserApi.dart';
import '../model/LeadsModel.dart';
import '../providers/ConnectivityProviders.dart';
import '../providers/LeadsProvider.dart';
import '../services/Shimmers.dart';
import '../services/otherservices.dart';

class LeadScreen extends StatefulWidget {
  const LeadScreen({super.key});

  @override
  State<LeadScreen> createState() => _LeadsScreenState();
}

class _LeadsScreenState extends State<LeadScreen> {
  bool is_loading = true;
  @override
  void initState() {
    Provider.of<ConnectivityProviders>(context, listen: false)
        .initConnectivity();
    _fetchLeads();
    super.initState();
  }

  void _fetchLeads() async {
    // Access the LeadsProvider to fetch the data
    final leadsProvider = Provider.of<LeadsProvider>(context, listen: false);
    // Call the fetchLeadsList method from the provider
    bool? result = await leadsProvider.fetchLeadsList();
    // After fetching, update the state accordingly
    setState(() {
      is_loading = leadsProvider.isLoading;
      if (result == false) {
        print("Failed to fetch leads.");
      } else {
        print("Leads fetched successfully.");
      }
    });
  }

  @override
  void dispose() {
    Provider.of<ConnectivityProviders>(context, listen: false).dispose();
    super.dispose();
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
    var connectiVityStatus = Provider.of<ConnectivityProviders>(context);
    return (connectiVityStatus.isDeviceConnected == "ConnectivityResult.wifi" ||
            connectiVityStatus.isDeviceConnected == "ConnectivityResult.mobile")
        ? Scaffold(
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
                  Navigator.pop(context, true);
                },
              ),
              actions: [
                InkResponse(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Addleadsscreen()));
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: 12, vertical: 4),
                    margin: EdgeInsets.only(right: 15),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.white)
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.add_box_outlined,size:20,color: Colors.white,),
                        SizedBox(width: 10,),
                        text(context, 'AddLeads', 15,
                            fontWeight: FontWeight.w500,
                            color: Colors.white),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            body: is_loading
                ?_buildShimmerList()
                : Column(
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      Consumer<LeadsProvider>(
                          builder: (context, leadsProvider, child) {
                        final LeadsList = leadsProvider.leadsList ?? [];
                        return Expanded(
                          child: ListView.builder(
                              itemCount: LeadsList.length,
                              itemBuilder: (context, index) {
                                var leads = LeadsList[index];
                                return container(
                                  context,
                                  margin: EdgeInsets.symmetric(
                                      vertical: 5, horizontal: 16),
                                  child: Column(
                                    children: [
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
                                                text(
                                                    context,
                                                    leads.name == ""
                                                        ? "unknown"
                                                        : leads.name ??
                                                            "unknown",
                                                    17,
                                                    fontWeight:
                                                        FontWeight.w600),
                                                text(
                                                    context,
                                                    leads.number ?? "unknown",
                                                    20,
                                                    fontWeight: FontWeight.w500,
                                                    color: Color(0xff949494)),
                                                if (leads.followUpDate !=
                                                    null) ...[
                                                  text(
                                                      context,
                                                      "Followup : ${leads.followUpDate ?? ""}",
                                                      16,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color: Color(0xff949494)),
                                                ],
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    container(context,
                                                        colors:(leads.stageName?.stageName=="Cold")? coldbgColor:(leads.stageName?.stageName=="Hot")?Color(0xffFFA89C):Color(0xff95F8B6),
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    5)),
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                vertical: 2,
                                                                horizontal: 10),
                                                        margin: EdgeInsets.only(
                                                            bottom: 10,
                                                            left: 0),
                                                        child: text(
                                                            context,
                                                            leads.stageName
                                                                    ?.stageName ??
                                                                "",
                                                            14,
                                                            color: color11)),
                                                    InkResponse(
                                                      onTap: () {
                                                        Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        AddFollowUp(
                                                                          id: leads
                                                                              .id
                                                                              .toString(),
                                                                        )));
                                                      },
                                                      child: text(context,
                                                          'Add Follow Up>', 13,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontfamily: 'Poppins',
                                                          color: primaryColor),
                                                    ),
                                                    InkWell(
                                                      onTap: () {
                                                        Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                              builder: (context) =>
                                                                  LeadInformation(
                                                                ID: leads.id
                                                                    .toString(),
                                                              ),
                                                            ));
                                                      },
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                                right: 8.0),
                                                        child: text(
                                                          context,
                                                          "View Info>",
                                                          14,
                                                          color:
                                                              Color(0xff646363),
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                          Column(
                                            children: [
                                              InkWell(
                                                onTap: () async {
                                                  await FlutterPhoneDirectCaller
                                                      .callNumber(
                                                          leads.number ?? "");
                                                },
                                                child: container(context,
                                                    colors: primaryColor,
                                                    padding: EdgeInsets.all(16),
                                                    margin: EdgeInsets.all(0),
                                                    child: Image(
                                                      image: AssetImage(
                                                          "assets/call.png"),
                                                      width: 20,
                                                      height: 20,
                                                    )),
                                              ),
                                              SizedBox(
                                                height: 14,
                                              ),
                                              GestureDetector(
                                                onTap: () {
                                                  _launchWhatsApp(
                                                      leads.number ?? "");
                                                },
                                                child: container(context,
                                                    colors: primaryColor,
                                                    padding: EdgeInsets.all(16),
                                                    margin: EdgeInsets.all(0),
                                                    child: Image(
                                                      image: AssetImage(
                                                          "assets/whatsapp.png"),
                                                      width: 20,
                                                      height: 20,
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
                        );
                      }),
                      SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
          )
        : NoInternetWidget();
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
