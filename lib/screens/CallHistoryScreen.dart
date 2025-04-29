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
  String date;
  String type;
  Callhistoryscreen({super.key, required this.date, required this.type});

  @override
  State<Callhistoryscreen> createState() => _CallhistoryscreenState();
}

class _CallhistoryscreenState extends State<Callhistoryscreen> {

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getCallHistoryApi();
    });
    super.initState();
  }

  Future<void> getCallHistoryApi() async {
    final callhistory =
        Provider.of<CallHistoryProvider>(context, listen: false);
    callhistory.getCallHistoryApi(widget.date);
  }

  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    var h = MediaQuery.of(context).size.height;
    return  Scaffold(
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
              leading: widget.type != ""
                  ? IconButton(
                      icon: Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        Navigator.pop(context, true);
                      },
                    )
                  : Container(),

              leadingWidth: widget.type != '' ? 56 : 20,

            ),
            body: Consumer<CallHistoryProvider>(
              builder: (context, callhistoryprovider, child) {
                if (callhistoryprovider.loading) {
                  return _buildShimmerList();
                } else if (callhistoryprovider.call_history.isEmpty) {
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
                } else {
                  return Column(
                    children: [
                      SizedBox(
                        height: 16,
                      ),
                      Expanded(
                        child: NotificationListener<ScrollNotification>(
                          onNotification: (ScrollNotification scrollInfo) {
                            if (!callhistoryprovider.pageLoading &&
                                scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
                              if (callhistoryprovider.hasNext) {
                                callhistoryprovider.getMoreCallHistoryApi(widget.date);
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
                                return Card(elevation: 2,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  margin: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                                  child: Padding(
                                    padding: const EdgeInsets.all(20.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              call.number ?? "Unknown Number",
                                              style: TextStyle(
                                                fontSize: 20,
                                                fontFamily: "Poppins",
                                                fontWeight: FontWeight.w600,
                                                color: Colors.black87,
                                              ),
                                            ),
                                            Row(
                                              children: [
                                                Icon(Icons.calendar_today, size: 16, color: Colors.grey[600]),
                                                SizedBox(width: 6),
                                                Text(
                                                  call.latestUpdate ?? "No Date",
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.grey[700],
                                                    fontFamily: "Poppins",
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),

                                        SizedBox(height: 16),


                                        Divider(color: Colors.grey[300],height: 0.5,thickness: 1,),

                                        SizedBox(height: 10),
                                        Row(
                                          children: [
                                            Icon(Icons.info_outline, size: 20, color: Colors.blueAccent),
                                            SizedBox(width: 10),
                                            Expanded(
                                              child: Text(
                                                'Call Status: ${call.callStatus}',
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontFamily: "Poppins",
                                                  color: Colors.black87,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),

                                        SizedBox(height: 10),
                                        Row(
                                          children: [
                                            Icon(Icons.access_time, size: 20, color: Colors.orangeAccent),
                                            SizedBox(width: 10),
                                            Expanded(
                                              child: Text(
                                                'Duration: ${call.callDuration}',
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontFamily: "Poppins",
                                                  color: Colors.black87,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                                      childCount: callhistoryprovider.call_history.length)),
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
          );
  }

  Widget _buildShimmerList() {
    return Column(
      children: [
        SizedBox(height: 20,),
        Expanded(
          child: ListView.builder(
            itemCount: 10, // Adjust the number of shimmer items as needed
            shrinkWrap: true,
            physics: const AlwaysScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
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
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
