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
import '../services/otherservices.dart';

class LeadScreen extends StatefulWidget {
  const LeadScreen({super.key});

  @override
  State<LeadScreen> createState() => _LeadsScreenState();
}

class _LeadsScreenState extends State<LeadScreen> {
  bool is_loading=true;
  @override
  void initState() {
    Provider.of<ConnectivityProviders>(context,listen: false).initConnectivity();
    getLeadsApi();
    super.initState();
  }

  List<Leads> data=[];
  void getLeadsApi() async {
    var result = await Userapi.getLeads();
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
      body:is_loading?Center(child: CircularProgressIndicator(),):
      Column(
        children: [
          SizedBox(
            height: 10,
          ),
          Row(mainAxisAlignment: MainAxisAlignment.end,
            children: [
              InkResponse(onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>Addleadsscreen()));
              },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 12,vertical: 4),
                  margin: EdgeInsets.only(right: 14,bottom: 10),
                  decoration: BoxDecoration(color: color28,borderRadius: BorderRadius.circular(8),),
                child: text(context, 'AddLeads', 18,fontWeight: FontWeight.w500,fontfamily: 'Inter',color: color37),),
              ),
            ],
          ),
          Expanded(
            child: ListView.builder(
                itemCount: data.length,
                itemBuilder: (context, index) {
                  var leads= data[index];
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
                                  text(context, leads.name==""?"unknown": leads.name??"unknown", 17,fontWeight: FontWeight.w600),
                                  text(context,leads.number??"unknown", 20,fontWeight: FontWeight.w500,color: Color(0xff949494)),
                                  text(context, "Followup : ${leads.followUpDate??""}", 16,fontWeight: FontWeight.w400,color: Color(0xff949494)),
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
                                          child: text(context, leads.stageName?.stageName??"", 14,
                                              color: color11)),


                                      InkWell(
                                        onTap: (){
                                          Navigator.push(context, MaterialPageRoute(builder: (context) => LeadInformation(ID:leads.id.toString() ,),));
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.only(right: 8.0),
                                          child: text(context, "View Info>", 14,
                                              color: Color(0xff646363),
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
                                    onTap:() async {
                                      await FlutterPhoneDirectCaller.callNumber(leads.number??"");
                                   },
                                    child: container(context,
                                        colors: primaryColor,
                                        padding: EdgeInsets.all(16),
                                        margin: EdgeInsets.all(0),
                                        child: Image(
                                          image: AssetImage("assets/call.png"),
                                          width: 20,
                                          height: 20,
                                        )),
                                  ),
                                  SizedBox(height: 14,),
                                GestureDetector(
                                  onTap:(){
                            _launchWhatsApp(leads.number??"");
                                   },
                                    child: container(context,
                                        colors: primaryColor,
                                        padding: EdgeInsets.all(16),
                                        margin: EdgeInsets.all(0),
                                        child: Image(
                                          image: AssetImage("assets/whatsapp.png"),
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
          ),
          SizedBox(
            height: 10,
          ),
        ],
      ),
    ): NoInternetWidget();
  }
}
