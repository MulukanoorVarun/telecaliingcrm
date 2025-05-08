import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:telecaliingcrm/utils/ColorConstants.dart';
import 'package:telecaliingcrm/utils/constants.dart';
import 'package:url_launcher/url_launcher.dart';
import '../providers/LeadsProvider.dart';
import '../services/Shimmers.dart';

class LeadScreen extends StatefulWidget {
  const LeadScreen({super.key});

  @override
  State<LeadScreen> createState() => _LeadsScreenState();
}

class _LeadsScreenState extends State<LeadScreen> {
  String stage_name = "";
  @override
  void initState() {
    // Delay fetchLeads until after the widget tree has finished building
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchLeads();
    });
    super.initState();
  }

  Future<void> _fetchLeads() async {
    final leadsProvider = Provider.of<LeadsProvider>(context, listen: false);
    leadsProvider.fetchLeadsList(stage_name);
  }

  void _launchWhatsApp(number) async {
    final url = 'https://wa.me/$number';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not open WhatsApp.';
    }
  }

  int _selectedTabIndex = 0;
  void _onButtonPressed(int index) {
    setState(() {
      _selectedTabIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    var h = MediaQuery.of(context).size.height;
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, true);
        return false;
      },
      child: Scaffold(
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
              context.pop();
            },
          ),
          actions: [
            InkResponse(
              onTap: () {
                context.push("/add_lead");
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                margin: EdgeInsets.only(right: 15),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.white)),
                child: Row(
                  children: [
                    Icon(
                      Icons.add_box_outlined,
                      size: 20,
                      color: Colors.white,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    text(context, 'Add Leads', 15,
                        fontWeight: FontWeight.w500, color: Colors.white),
                  ],
                ),
              ),
            ),
          ],
        ),
        body: Column(
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: w * 0.25,
                      height: w * 0.1,
                      child: ElevatedButton(
                        style: ButtonStyle(
                          // padding: MaterialStateProperty.all(
                          //   const EdgeInsets.symmetric(
                          //       vertical: 0,
                          //       horizontal: 18), // Adjust as needed
                          // ),
                          shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  8), // Adjust the value to your desired radius
                            ),
                          ),
                          backgroundColor: MaterialStateProperty.all(
                            _selectedTabIndex == 0
                                ? Color(0xff7165E3)
                                : Colors.white, // Active color if selected
                          ),
                        ),
                        onPressed: () {
                          _onButtonPressed(0);
                          setState(() {
                            stage_name = "";
                          });
                          _fetchLeads();
                        },
                        child: Text(
                          'ALL',
                          style: TextStyle(
                            color: _selectedTabIndex == 0
                                ? Colors.white
                                : Color(0xff7165E3),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    SizedBox(
                      width: w * 0.25,
                      height: w * 0.1,
                      child: ElevatedButton(
                        style: ButtonStyle(
                          shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  8), // Adjust the value to your desired radius
                            ),
                          ),
                          backgroundColor: MaterialStateProperty.all(
                            _selectedTabIndex == 1
                                ? Color(0xff7165E3)
                                : Colors.white, // Active color if selected
                          ),
                        ),
                        onPressed: () {
                          _onButtonPressed(1);
                          setState(() {
                            stage_name = "hot";
                          });
                          _fetchLeads();
                        },
                        child: Text(
                          'HOT',
                          style: TextStyle(
                              color: _selectedTabIndex == 1
                                  ? Colors.white
                                  : Color(0xff7165E3)),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    SizedBox(
                      width: w * 0.25,
                      height: w * 0.1,
                      child: ElevatedButton(
                        style: ButtonStyle(
                          shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          backgroundColor: MaterialStateProperty.all(
                            _selectedTabIndex == 2
                                ? Color(0xff7165E3)
                                : Colors.white, // Active color if selected
                          ),
                        ),
                        onPressed: () {
                          _onButtonPressed(2);
                          setState(() {
                            stage_name = "cold";
                          });
                          _fetchLeads();
                        },
                        child: Text(
                          'COLD',
                          style: TextStyle(
                              color: _selectedTabIndex == 2
                                  ? Colors.white
                                  : Color(0xff7165E3)),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    SizedBox(
                      width: w * 0.28,
                      height: w * 0.1,
                      child: ElevatedButton(
                        style: ButtonStyle(
                          shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  8), // Adjust the value to your desired radius
                            ),
                          ),
                          backgroundColor: MaterialStateProperty.all(
                            _selectedTabIndex == 3
                                ? Color(0xff7165E3)
                                : Colors.white, // Active color if selected
                          ),
                        ),
                        onPressed: () {
                          setState(() {
                            stage_name = "warm";
                          });
                          _fetchLeads();
                          _onButtonPressed(3);
                        },
                        child: Text(
                          'WARM',
                          style: TextStyle(
                              color: _selectedTabIndex == 3
                                  ? Colors.white
                                  : Color(0xff7165E3)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Consumer<LeadsProvider>(
              builder: (context, leadsProvider, child) {
                debugPrint(
                    'Consumer Rebuild - isLoading: ${leadsProvider.isLoading}, LeadsList: ${leadsProvider.leadsList?.length}');
                final LeadsList = leadsProvider.leadsList ?? [];

                if (leadsProvider.isLoading) {
                  return _buildShimmerList();
                } else if (LeadsList.isEmpty) {
                  return Center(
                    child: Column(
                      children: [
                        SizedBox(
                            height: MediaQuery.of(context).size.width * 0.54),
                        Lottie.asset(
                          'assets/animations/nodata1.json',
                          width: 150,
                          height: 150,
                          fit: BoxFit.cover,
                        ),
                      ],
                    ),
                  );
                }

                return Expanded(
                  child: NotificationListener<ScrollNotification>(
                    onNotification: (ScrollNotification scrollInfo) {
                      if (leadsProvider.hasNextPage &&
                          !leadsProvider.pageLoading &&
                          scrollInfo.metrics.pixels >=
                              scrollInfo.metrics.maxScrollExtent - 50) {
                        leadsProvider.fetchMoreLeadsList(stage_name);
                      }
                      return true;
                    },
                    child: CustomScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      slivers: [
                        SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
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
                                                textAlign: TextAlign.start,
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                context,
                                                leads.name.isEmpty ?? true
                                                    ? "unknown"
                                                    : leads.name,
                                                17,
                                                fontWeight: FontWeight.w600,
                                              ),
                                              text(
                                                context,
                                                "${leads.number.toString()}",
                                                20,
                                                fontWeight: FontWeight.w500,
                                                color: Color(0xff949494),
                                              ),
                                              if (leads.followUpDate != null)
                                                text(
                                                  context,
                                                  "Followup: ${leads.followUpDate}",
                                                  16,
                                                  fontWeight: FontWeight.w400,
                                                  color: Color(0xff949494),
                                                ),
                                              SizedBox(height: 10),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  container(
                                                    context,
                                                    colors: leads.stageName
                                                                ?.stageName ==
                                                            "Cold"
                                                        ? coldbgColor
                                                        : leads.stageName
                                                                    ?.stageName ==
                                                                "Hot"
                                                            ? Color(0xffFFA89C)
                                                            : Color(0xff95F8B6),
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(5)),
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            vertical: 2,
                                                            horizontal: 10),
                                                    margin: EdgeInsets.only(
                                                        bottom: 10, left: 0),
                                                    child: text(
                                                      context,
                                                      leads.stageName
                                                              .stageName ??
                                                          "",
                                                      14,
                                                      color: color11,
                                                    ),
                                                  ),
                                                  InkResponse(
                                                    onTap: () {
                                                      context.pushReplacement(
                                                          "/update_followup?followupId=${""}&staffId=${leads.staffId}&leadId=${leads.id}");
                                                    },
                                                    child: text(
                                                      context,
                                                      'Add Follow Up>',
                                                      13,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontfamily: 'Poppins',
                                                      color: primaryColor,
                                                    ),
                                                  ),
                                                  InkWell(
                                                    onTap: () {
                                                      context.push(
                                                          "/lead_information?ID=${leads.id}");
                                                    },
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              right: 8.0),
                                                      child: text(
                                                        context,
                                                        "View Info>",
                                                        14,
                                                        color:
                                                            Color(0xff646363),
                                                      ),
                                                    ),
                                                  ),
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
                                                    .callNumber(leads.number
                                                        .toString());
                                              },
                                              child: container(
                                                context,
                                                colors: primaryColor,
                                                padding: EdgeInsets.all(16),
                                                margin: EdgeInsets.all(0),
                                                child: Image(
                                                  image: AssetImage(
                                                      "assets/call.png"),
                                                  width: 20,
                                                  height: 20,
                                                ),
                                              ),
                                            ),
                                            SizedBox(height: 14),
                                            GestureDetector(
                                              onTap: () {
                                                _launchWhatsApp(
                                                    leads.number ?? "");
                                              },
                                              child: container(
                                                context,
                                                colors: primaryColor,
                                                padding: EdgeInsets.all(16),
                                                margin: EdgeInsets.all(0),
                                                child: Image(
                                                  image: AssetImage(
                                                      "assets/whatsapp.png"),
                                                  width: 20,
                                                  height: 20,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            },
                            childCount: LeadsList.length,
                          ),
                        ),
                        SliverPadding(
                          padding: EdgeInsets.only(bottom: 30),
                          sliver: SliverToBoxAdapter(
                            child: SizedBox(height: 10),
                          ),
                        ),
                        if (leadsProvider.pageLoading)
                          SliverToBoxAdapter(
                            child: Align(
                              alignment: Alignment.center,
                              child: CircularProgressIndicator(strokeWidth: 1),
                            ),
                          ),
                        SliverPadding(
                          padding: EdgeInsets.only(bottom: 20),
                          sliver: SliverToBoxAdapter(
                            child: SizedBox(height: 10),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }

  Widget _buildShimmerList() {
    return Expanded(
      child: ListView.builder(
        itemCount: 4,
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
      ),
    );
  }
}
