import 'package:flutter/material.dart';
import 'package:telecaliingcrm/Services/UserApi.dart';

import '../model/CallHistoryModel.dart';
import '../services/Shimmers.dart';
import '../utils/ColorConstants.dart';

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

  @override
  void initState() {
    getCallHistoryApi();
    super.initState();
  }

  bool loading=true;
  List<CallHistory> call_history=[];
  Future<void> getCallHistoryApi() async {
    try {
      var res = await  Userapi.getCallHistory();
      setState(() {
        if (res != null) {
          call_history= res.call_history??[];
          loading=false;
        } else {
          loading=false;
          debugPrint("No data received");
        }
      });
    } catch (e) {
      debugPrint("Error in GetCallHistoryApi: $e");
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        leading:Container(),
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
      body:loading?_buildShimmerList():
      Padding(
        padding: EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: call_history.length,
          itemBuilder: (context, index) {
            final call = call_history[index];
            return Card(
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
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          call.number??"",
                          style: TextStyle(
                            fontSize: 18,
                            fontFamily: "Poppins",
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Row(
                          children: [
                            Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                            SizedBox(width: 8),
                            Text(
                              call.dateAdded??"",
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
                    Text('Call Status: ${call.callStatus}',
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: "Poppins",
                        fontWeight: FontWeight.w400,
                        color: Colors.black),),
                    Text('Duration: ${call.callDuration}',
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: "Poppins",
                        fontWeight: FontWeight.w400,
                        color: Colors.black),),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildShimmerList() {
    return ListView.builder(
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
    );
  }
}

