import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:telecaliingcrm/Services/UserApi.dart';
import 'package:telecaliingcrm/Services/otherservices.dart';
import 'package:telecaliingcrm/providers/ConnectivityProviders.dart';
import '../services/Shimmers.dart';
import '../utils/ColorConstants.dart';
import '../providers/CallHistoryProvider.dart';

class Callhistoryscreen extends StatefulWidget {
  const Callhistoryscreen({super.key});

  @override
  State<Callhistoryscreen> createState() => _CallhistoryscreenState();
}

class _CallhistoryscreenState extends State<Callhistoryscreen> {
  final List<Map<String, String>> callData = [
    {
      'number': '9440161007',
      'dateAdded': 'Jan 21 2025 10:57 AM',
      'callStatus': 'Not Interested',
      'calledStatus': 'Called',
      'callDuration': '21 sec',
      'latestUpdate': 'Jan 24 2025 5:24 PM',
    },
    {
      'number': '8919273834',
      'dateAdded': 'Jan 24 2025 5:22 PM',
      'callStatus': 'Not Lifting',
      'calledStatus': 'Called',
      'callDuration': '0 sec',
      'latestUpdate': 'Jan 24 2025 5:25 PM',
    },
  ];
  late ConnectivityProviders _connectivityProvider;
  @override
  void initState() {
    // Save the provider reference during initState
    _connectivityProvider = Provider.of<ConnectivityProviders>(context, listen: false);
    _connectivityProvider.initConnectivity();
    getCallHistoryApi();
    super.initState();
  }

  @override
  void dispose() {
    // Use the saved reference to dispose of the connectivity provider
    _connectivityProvider.dispose();
    super.dispose();
  }

  Future<void> getCallHistoryApi() async {
    final callhistory =
        Provider.of<CallHistoryProvider>(context, listen: false);
    callhistory.getCallHistoryApi(context);
  }

  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    var h = MediaQuery.of(context).size.height;
    var connectiVityStatus = Provider.of<ConnectivityProviders>(context);
    return (connectiVityStatus.isDeviceConnected == "ConnectivityResult.wifi" ||
            connectiVityStatus.isDeviceConnected == "ConnectivityResult.mobile")
        ? Scaffold(
            appBar: AppBar(
              title: Text(
                'Call History',
                style: TextStyle(
                    fontSize: 22,
                    fontFamily: "Poppins",
                    fontWeight: FontWeight.w600,
                    color: Colors.white),
              ),

              backgroundColor: primaryColor,
              leading: Container(),
              leadingWidth: 10,
              // IconButton(
              //   icon: Icon(
              //     Icons.arrow_back,
              //     color: Colors.white,
              //   ),
              //   onPressed: () {
              //     Navigator.pop(context, true);
              //   },
              // ),
            ),
            body: Consumer<CallHistoryProvider>(
              builder: (context, callhistoryprovider, child) {
                if (callhistoryprovider.loading) {
                  return _buildShimmerList();
                }else if(callhistoryprovider.call_history.isEmpty){
                  return Center(
                    child: Column(
                      children: [
                        SizedBox(
                          height: w * 0.54,
                        ),
                        Lottie.asset(
                          'assets/animations/nodata1.json', // Your Lottie animation file
                          width: 150, // Adjust the size as needed
                          height: 150,
                          fit: BoxFit.cover,
                        ),
                      ],
                    ),
                  );
                }
                else {
                  return Column(
                    children: [
                      SizedBox(height: 16,),
                      Expanded(
                        child: NotificationListener<ScrollNotification>(
                          onNotification: (ScrollNotification scrollinfo) {
                            if (callhistoryprovider.loading &&
                                scrollinfo.metrics.pixels ==
                                    scrollinfo.metrics.maxScrollExtent) {
                              if (callhistoryprovider.hasNext) {
                                callhistoryprovider.getMoreCallHistoryApi(context);
                              }
                              return true;
                            }
                            return false;
                          },
                          child: CustomScrollView(
                            slivers: [
                              SliverList(
                                  delegate: SliverChildBuilderDelegate(
                                      (context, index) {
                                final call =
                                    callhistoryprovider.call_history[index];
                                return Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                                  child: Card(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15.0),
                                    ),
                                    elevation: 4,
                                    child: Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(height: 8),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                call.number ?? "",
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  fontFamily: "Poppins",
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              Row(
                                                children: [
                                                  Icon(Icons.calendar_today,
                                                      size: 16, color: Colors.grey),
                                                  SizedBox(width: 8),
                                                  Text(
                                                    call.dateAdded ?? "",
                                                    style: TextStyle(
                                                      color: Colors.grey,
                                                      fontFamily: "Poppins",
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 8),
                                          Text(
                                            'Call Status: ${call.callStatus}',
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontFamily: "Poppins",
                                                fontWeight: FontWeight.w400,
                                                color: Colors.black),
                                          ),
                                          Text(
                                            'Duration: ${call.callDuration}',
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontFamily: "Poppins",
                                                fontWeight: FontWeight.w400,
                                                color: Colors.black),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                                      childCount:
                                          callhistoryprovider.call_history.length)),

                              SliverPadding(
                                padding: EdgeInsets.only(bottom: 30),
                                sliver: SliverToBoxAdapter(
                                  child: SizedBox(
                                    height: 10,
                                  ),
                                ),
                              ),
                              if (callhistoryprovider.pageLoading)
                                SliverToBoxAdapter(
                                  child: Center(
                                    child: CircularProgressIndicator(
                                      strokeWidth: 0.8,
                                    ),
                                  ),
                                )
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                }
              },
            ),
          )
        : NoInternetWidget();
  }

  Widget _buildShimmerList() {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: 10, // Adjust the number of shimmer items as needed
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
        ),
      ],
    );
  }
}
