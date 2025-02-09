import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:telecaliingcrm/screens/FollowupsScreen.dart';

import '../Services/UserApi.dart';
import '../providers/ConnectivityProviders.dart';
import '../providers/FollowupProvider.dart';
import '../services/otherservices.dart';
import '../utils/ColorConstants.dart';
import '../utils/ShakeWidget.dart';
import '../utils/constants.dart';

class AddFollowUp extends StatefulWidget {
  String id;
  String name;
   AddFollowUp({super.key,required this.id,required this.name});

  @override
  State<AddFollowUp> createState() => _AddFollowUpState();
}

class _AddFollowUpState extends State<AddFollowUp> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  // final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _remarksController = TextEditingController();

  String formattedDate="";
  String? _leadStatus;
  bool _loading = false;
  String _validateFullName = "";
  String _validatedate = "";
  String _validateRemarks = "";



  @override
  void initState() {
    Provider.of<ConnectivityProviders>(context, listen: false)
        .initConnectivity();
    _nameController.text= widget.name;
    super.initState();
  }

  @override
  void dispose() {
    Provider.of<ConnectivityProviders>(context, listen: false).dispose();
    super.dispose();
  }

  void _validateFields() {
    setState(() {
      _loading = true;
      // Validate Full Name
      _validateFullName =
      !_nameController.text.contains(RegExp(r"^[a-zA-Z\s]+$"))
          ? "Please enter a valid name"
          : "";
      // Validate date
      _validatedate = formattedDate.isEmpty
          ? "Please select a valid Date."
          : "";

      _validateRemarks =
      _remarksController.text.isEmpty ? "Please add some remarks" : "";
      if (_validateFullName.isEmpty && _validatedate.isEmpty && _validateRemarks.isEmpty) {
        AddFollowUp(context);
      } else {
        _loading = false;

      }
    });
  }

  Future<void> AddFollowUp(BuildContext context) async {
    try {
      final followupsProvider = Provider.of<FollowupProvider>(context, listen: false);
      var res= await followupsProvider.AddFollowUp(context,widget.id, _nameController.text, formattedDate, _remarksController.text,);
    setState(() {
      if(res==true){
        _loading=false;
        Navigator.of(context)
            .pushReplacement(PageRouteBuilder(
          pageBuilder: (context, animation,
              secondaryAnimation) {
            return FollowupsScreen();
          },
          transitionsBuilder: (context,
              animation,
              secondaryAnimation,
              child) {
            const begin = Offset(1.0, 0.0);
            const end = Offset.zero;
            const curve = Curves.easeInOut;
            var tween = Tween(
                begin: begin, end: end)
                .chain(CurveTween(
                curve: curve));
            var offsetAnimation =
            animation.drive(tween);
            return SlideTransition(
                position: offsetAnimation,
                child: child);
          },
        ));
        CustomSnackBar.show(context, "Followup Added Successfully!");
      }else{
        _loading=false;
        CustomSnackBar.show(context, "Followup Added Failed!");
      }
    });
    } catch (e) {
      // Handle any errors
      print("Error occurred while adding Follow-up: $e");
    }
  }


  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    var h = MediaQuery.of(context).size.height;
    var connectiVityStatus = Provider.of<ConnectivityProviders>(context);
    return (connectiVityStatus.isDeviceConnected == "ConnectivityResult.wifi" ||
        connectiVityStatus.isDeviceConnected == "ConnectivityResult.mobile")
        ? Scaffold(
      backgroundColor: scaffoldbgColor,
      appBar: AppBar(
        title: Text(
          'Add Follow Up',
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
            Navigator.pop(context);
          },
        ),
      ),
      body: container(
        context,
        w: w,
        margin: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 20,
              ),
              // Name Field
              TextFormField(
                controller: _nameController,
                keyboardType: TextInputType.text,
                readOnly: true,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 0,
                    horizontal: 10,
                  ),
                  labelText: "Name",
                  labelStyle: const TextStyle(
                    fontSize: 14,
                    letterSpacing: 0,
                    height: 25.73 / 14,
                    color: Colors.grey,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w400,
                  ),
                  filled: true,
                  fillColor: const Color(0xffffffff),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(7),
                    borderSide: const BorderSide(
                        width: 1, color: Color(0xffCDE2FB)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(7),
                    borderSide: const BorderSide(
                        width: 1, color: Color(0xffCDE2FB)),
                  ),
                ),
              ),
              if (_validateFullName.isNotEmpty) ...[
                Container(
                  alignment: Alignment.topLeft,
                  margin: EdgeInsets.only(left: 8, bottom: 10, top: 5),
                  width: MediaQuery.of(context).size.width * 0.6,
                  child: ShakeWidget(
                    key: Key("value"),
                    duration: Duration(milliseconds: 700),
                    child: Text(
                      _validateFullName,
                      style: TextStyle(
                        fontFamily: "Poppins",
                        fontSize: 12,
                        color: Colors.red,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ] else ...[
                SizedBox(height: 16),
              ],
              TextFormField(
                controller: TextEditingController(
                    text: formattedDate
                ),
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 0,
                    horizontal: 10,
                  ),
                  labelText: 'Date',
                  labelStyle: const TextStyle(
                    fontSize: 14,
                    letterSpacing: 0,
                    height: 25.73 / 14,
                    color: Colors.grey,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w400,
                  ),
                  hintText: 'Choose Date',
                  filled: true,
                  fillColor: const Color(0xffffffff),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(7),
                    borderSide: const BorderSide(
                      width: 1,
                      color: Color(0xffCDE2FB),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(7),
                    borderSide: const BorderSide(
                      width: 1,
                      color: Color(0xffCDE2FB),
                    ),
                  ),
                  suffixIcon: const Icon(
                    Icons.calendar_today,
                    color: Color(0xff2196F3), // Replace with primaryColor if defined
                  ),
                ),
                readOnly: true,
                onTap: () async {
                  final DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2101),
                  );

                  if (picked != null) {
                    setState(() {
                      // Strip the time part by creating a new DateTime with only the date
                      DateTime _selectedDate = DateTime(picked.year, picked.month, picked.day);

                      // Format the date as a string (yyyy-MM-dd)
                      formattedDate = DateFormat('yyyy-MM-dd').format(_selectedDate);

                      // Print the formatted date
                      print("Formatted Date: $formattedDate");
                    });
                  }
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a date';
                  }
                  return null;
                },
              ),
              if (_validatedate.isNotEmpty) ...[
                Container(
                  alignment: Alignment.topLeft,
                  margin: EdgeInsets.only(left: 8, bottom: 10, top: 5),
                  width: MediaQuery.of(context).size.width * 0.6,
                  child: ShakeWidget(
                    key: Key("value"),
                    duration: Duration(milliseconds: 700),
                    child: Text(
                      _validatedate,
                      style: TextStyle(
                        fontFamily: "Poppins",
                        fontSize: 12,
                        color: Colors.red,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ] else ...[
                SizedBox(height: 16),
              ],
              // Remarks Field
              TextFormField(
                controller: _remarksController,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 10,
                  ),
                  labelText: "Remarks",
                  labelStyle: const TextStyle(
                    fontSize: 14,
                    letterSpacing: 0,
                    height: 25.73 / 14,
                    color: Colors.grey,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w400,
                  ),
                  filled: true,
                  fillColor: const Color(0xffffffff),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(7),
                    borderSide: const BorderSide(
                        width: 1, color: Color(0xffCDE2FB)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(7),
                    borderSide: const BorderSide(
                        width: 1, color: Color(0xffCDE2FB)),
                  ),
                ),
                maxLines: 4,
              ),
              if (_validateRemarks.isNotEmpty) ...[
                Container(
                  alignment: Alignment.topLeft,
                  margin: EdgeInsets.only(left: 8, bottom: 10, top: 5),
                  width: MediaQuery.of(context).size.width * 0.6,
                  child: ShakeWidget(
                    key: Key("value"),
                    duration: Duration(milliseconds: 700),
                    child: Text(
                      _validateRemarks,
                      style: TextStyle(
                        fontFamily: "Poppins",
                        fontSize: 12,
                        color: Colors.red,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ] else ...[
                SizedBox(height: 8),
              ],
              // const SizedBox(height: 16),
              //
              // // Radio Buttons
              // Row(
              //   children: [
              //     Expanded(
              //       child: RadioListTile<String>(
              //         visualDensity: VisualDensity.compact,
              //         contentPadding: EdgeInsets.all(0),
              //         title: text(context, "Cold", 13,
              //             textAlign: TextAlign.start),
              //         value: '10',
              //         groupValue: _leadStatus,
              //         onChanged: (value) {
              //           setState(() {
              //             _leadStatus = value;
              //           });
              //         },
              //       ),
              //     ),
              //     Expanded(
              //       child: RadioListTile<String>(
              //         visualDensity: VisualDensity.compact,
              //         contentPadding: EdgeInsets.all(0),
              //         title: text(context, "Warm", 13,
              //             textAlign: TextAlign.start),
              //         value: '11',
              //         groupValue: _leadStatus,
              //         onChanged: (value) {
              //           setState(() {
              //             _leadStatus = value;
              //           });
              //         },
              //       ),
              //     ),
              //     Expanded(
              //       child: RadioListTile<String>(
              //         visualDensity: VisualDensity.compact,
              //         contentPadding: EdgeInsets.all(0),
              //         title: text(context, "Hot", 13,
              //             textAlign: TextAlign.start),
              //         value: '12',
              //         groupValue: _leadStatus,
              //         onChanged: (value) {
              //           setState(() {
              //             _leadStatus = value;
              //           });
              //         },
              //       ),
              //     ),
              //   ],
              // ),
              // if (_leadStatus == null || _leadStatus!.isEmpty) ...[
              //   Container(
              //     alignment: Alignment.topLeft,
              //     margin: EdgeInsets.only(left: 8, bottom: 10, top: 5),
              //     child: Text(
              //       "Please select a status",
              //       style: TextStyle(
              //         fontFamily: "Poppins",
              //         fontSize: 12,
              //         color: Colors.red,
              //         fontWeight: FontWeight.w500,
              //       ),
              //     ),
              //   ),
              // ] else ...[
              //   SizedBox(height: 8),
              // ],
              SizedBox(
                height: 50,
              ),
              containertext(context, "Submit",color:primaryColor,isLoading: _loading, onTap: () {
                if (_loading) {
                } else {
                  _validateFields();
                }
              }),

              SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    )
        : NoInternetWidget();
  }


}