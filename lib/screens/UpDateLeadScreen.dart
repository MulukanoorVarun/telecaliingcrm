import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:telecaliingcrm/Services/UserApi.dart';
import 'package:telecaliingcrm/utils/constants.dart';

import '../providers/ConnectivityProviders.dart';
import '../providers/LeadsProvider.dart';
import '../services/otherservices.dart';
import '../utils/ColorConstants.dart';
import '../utils/ShakeWidget.dart';

class UpDateLeadScreen extends StatefulWidget {
  final String ID;
  final String name;
  final String remarks;
  const UpDateLeadScreen(
      {super.key, required this.ID, required this.name, required this.remarks});

  @override
  State<UpDateLeadScreen> createState() => _UpDateLeadScreenState();
}

class _UpDateLeadScreenState extends State<UpDateLeadScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _remarksController = TextEditingController();

  String formattedDate = "";
  String? _leadStatus;
  String? _leadStage;
  bool _loading = false;
  String _validateFullName = "";
  String _validateRemarks = "";
  String leadstatusError = "";
  String leadstageError = "";

  @override
  void initState() {
    _nameController.text = widget.name;
    _remarksController.text = widget.remarks;
    super.initState();
  }

  void _validateFields() {
    setState(() {
      _loading = true;

      // Validate Full Name
      _validateFullName =
          !_nameController.text.contains(RegExp(r"^[a-zA-Z\s]+$"))
              ? "Please enter a valid name"
              : "";
      // Validate Remarks
      _validateRemarks =
          _remarksController.text.isEmpty ? "Please add some remarks" : "";

      // Validate Lead Status
      leadstatusError =
          (_leadStatus == null) ? "Please select a lead status" : "";
      leadstageError = (_leadStage == null) ? "Please select a lead stage" : "";

      // Proceed only if all fields are valid
      if (_validateFullName.isEmpty &&
          _validateRemarks.isEmpty &&
          leadstatusError.isEmpty &&
          leadstageError.isEmpty) {
        UpdateLeads(); // Trigger the AddLeads function if validations pass
      } else {
        _loading = false;
      }
    });
  }

  Future<void> UpdateLeads() async {
    setState(() {
      _loading = true;
    });

    try {
      final leadsProvider = Provider.of<LeadsProvider>(context, listen: false);

      final response = await leadsProvider.UpdateleadsApi(
        _nameController.text,
        widget.ID,
        _remarksController.text,
        _leadStatus,
        _leadStage,
      );

      setState(() {
        _loading = false;
      });

      if (response == true) {
        CustomSnackBar.show(context, "Lead Updated Successfully!");
        Navigator.pop(context, true); // Returning true as a success flag
      } else {
        final errorMessage = "Failed to update lead.";
        CustomSnackBar.show(context, errorMessage);
        debugPrint("Failed to update lead: $errorMessage");
      }
    } catch (e, stack) {
      setState(() {
        _loading = false;
      });

      debugPrint("Exception in UpdateLeads: $e");
      debugPrint("Stack trace: $stack");

      CustomSnackBar.show(context, "Something went wrong. Please try again.");
    }
  }

  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    var h = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: scaffoldbgColor,
      appBar: AppBar(
        title: Text(
          'Update Lead',
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
                    borderSide:
                        const BorderSide(width: 1, color: Color(0xffCDE2FB)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(7),
                    borderSide:
                        const BorderSide(width: 1, color: Color(0xffCDE2FB)),
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
                    borderSide:
                        const BorderSide(width: 1, color: Color(0xffCDE2FB)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(7),
                    borderSide:
                        const BorderSide(width: 1, color: Color(0xffCDE2FB)),
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
              text(context, "UPDATE LEAD STAGE", 16,
                  fontWeight: FontWeight.w500),
              Column(
                children: [
                  RadioListTile<String>(
                    visualDensity: VisualDensity.compact,
                    contentPadding: EdgeInsets.all(0),
                    title: text(context, "Interested", 13,
                        textAlign: TextAlign.start),
                    value: 'open',
                    groupValue: _leadStage,
                    onChanged: (value) {
                      setState(() {
                        _leadStage = value;
                      });
                    },
                  ),
                  RadioListTile<String>(
                    visualDensity: VisualDensity.compact,
                    contentPadding: EdgeInsets.all(0),
                    title: text(context, "Not Interested", 13,
                        textAlign: TextAlign.start),
                    value: 'closed',
                    groupValue: _leadStage,
                    onChanged: (value) {
                      setState(() {
                        _leadStage = value;
                      });
                    },
                  ),
                  RadioListTile<String>(
                    visualDensity: VisualDensity.compact,
                    contentPadding: EdgeInsets.all(0),
                    title:
                        text(context, "Cancel", 13, textAlign: TextAlign.start),
                    value: 'cancel',
                    groupValue: _leadStage,
                    onChanged: (value) {
                      setState(() {
                        _leadStage = value;
                      });
                    },
                  ),
                ],
              ),
              if (leadstageError.isNotEmpty) ...[
                Container(
                  alignment: Alignment.topLeft,
                  margin: EdgeInsets.only(left: 8, bottom: 10, top: 5),
                  width: MediaQuery.of(context).size.width * 0.6,
                  child: ShakeWidget(
                    key: Key("value"),
                    duration: Duration(milliseconds: 700),
                    child: Text(
                      leadstageError,
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
              text(context, "UPDATE LEAD STATUS", 16,
                  fontWeight: FontWeight.w500),
              // Radio Buttons
              Row(
                children: [
                  Expanded(
                    child: RadioListTile<String>(
                      visualDensity: VisualDensity.compact,
                      contentPadding: EdgeInsets.all(0),
                      title:
                          text(context, "Cold", 13, textAlign: TextAlign.start),
                      value: '10',
                      groupValue: _leadStatus,
                      onChanged: (value) {
                        setState(() {
                          _leadStatus = value;
                        });
                      },
                    ),
                  ),
                  Expanded(
                    child: RadioListTile<String>(
                      visualDensity: VisualDensity.compact,
                      contentPadding: EdgeInsets.all(0),
                      title:
                          text(context, "Warm", 13, textAlign: TextAlign.start),
                      value: '11',
                      groupValue: _leadStatus,
                      onChanged: (value) {
                        setState(() {
                          _leadStatus = value;
                        });
                      },
                    ),
                  ),
                  Expanded(
                    child: RadioListTile<String>(
                      visualDensity: VisualDensity.compact,
                      contentPadding: EdgeInsets.all(0),
                      title:
                          text(context, "Hot", 13, textAlign: TextAlign.start),
                      value: '12',
                      groupValue: _leadStatus,
                      onChanged: (value) {
                        setState(() {
                          _leadStatus = value;
                        });
                      },
                    ),
                  ),
                ],
              ),
              if (leadstatusError.isNotEmpty) ...[
                Container(
                  alignment: Alignment.topLeft,
                  margin: EdgeInsets.only(left: 8, bottom: 10, top: 5),
                  child: Text(
                    leadstatusError,
                    style: TextStyle(
                      fontFamily: "Poppins",
                      fontSize: 12,
                      color: Colors.red,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ] else ...[
                SizedBox(height: 8),
              ],
              SizedBox(
                height: 50,
              ),
              containertext(context, "Submit",
                  color: primaryColor, isLoading: _loading, onTap: () {
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
    );
  }
}
