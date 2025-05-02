import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../model/FollowUpTypesModel.dart';
import '../providers/FollowupProvider.dart';
import '../providers/LeadsProvider.dart';
import '../utils/ColorConstants.dart';
import '../utils/ShakeWidget.dart';
import '../utils/constants.dart';

class UpdateFollowupScreen extends StatefulWidget {
  final String id;
  final String type;
  const UpdateFollowupScreen({super.key, required this.id, required this.type});

  @override
  State<UpdateFollowupScreen> createState() => _UpdateFollowupScreenState();
}

class _UpdateFollowupScreenState extends State<UpdateFollowupScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _remarksController = TextEditingController();

  String formattedDate = "";
  String formattedTime = ''; // Initialize as needed
  String? _leadStatus;
  FollowUpTypes? _selectedFollowUpType;
  String? _leadStage;
  bool _loading = false;
  String _validateFullName = "";
  String _validateRemarks = "";
  String leadstatusError = "";
  String leadstageError = "";

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<FollowupProvider>(context, listen: false).getFollowUpTypes();
    });
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
        // UpdateLeads(); // Trigger the AddLeads function if validations pass
      } else {
        _loading = false;
      }
    });
  }
  //
  // Future<void> UpdateLeads() async {
  //   setState(() {
  //     _loading = true;
  //   });
  //   try {
  //     final leadsProvider = Provider.of<LeadsProvider>(context, listen: false);
  //
  //     final response = await leadsProvider.UpdateleadsApi(
  //       _nameController.text,
  //       widget.ID,
  //       _remarksController.text,
  //       _leadStatus,
  //       _leadStage,
  //     );
  //
  //     setState(() {
  //       _loading = false;
  //     });
  //
  //     if (response == true) {
  //       CustomSnackBar.show(context, "Lead Updated Successfully!");
  //       Navigator.pop(context, true); // Returning true as a success flag
  //     } else {
  //       final errorMessage = "Failed to update lead.";
  //       CustomSnackBar.show(context, errorMessage);
  //       debugPrint("Failed to update lead: $errorMessage");
  //     }
  //   } catch (e, stack) {
  //     setState(() {
  //       _loading = false;
  //     });
  //
  //     debugPrint("Exception in UpdateLeads: $e");
  //     debugPrint("Stack trace: $stack");
  //
  //     CustomSnackBar.show(context, "Something went wrong. Please try again.");
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    var h = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: scaffoldbgColor,
      appBar: AppBar(
        title: Text(
          'Update FollowUp',
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
              // Date Field
              TextFormField(
                controller: TextEditingController(text: formattedDate),
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
                    color: primaryColor, // Replace with primaryColor if defined
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
                      DateTime _selectedDate =
                          DateTime(picked.year, picked.month, picked.day);
                      // Format the date as a string (yyyy-MM-dd)
                      formattedDate =
                          DateFormat('yyyy-MM-dd').format(_selectedDate);
                      // Print the formatted date
                      debugPrint("Formatted Date: $formattedDate");
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
              const SizedBox(height: 16),
              TextFormField(
                controller: TextEditingController(
                  text: formattedTime,
                ),
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 0,
                    horizontal: 10,
                  ),
                  labelText: 'Time',
                  labelStyle: const TextStyle(
                    fontSize: 14,
                    letterSpacing: 0,
                    height: 25.73 / 14,
                    color: Colors.grey,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w400,
                  ),
                  hintText: 'Choose Time',
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
                    Icons.access_time,
                    color: primaryColor, // Replace with primaryColor if defined
                  ),
                ),
                readOnly: true,
                onTap: () async {
                  final TimeOfDay? picked = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  );
                  if (picked != null) {
                    setState(() {
                      // Format the time as a string (HH:mm)
                      formattedTime = picked.format(
                          context); // e.g., '2:30 PM' or '14:30' based on device settings
                      // Optionally, force 24-hour format
                      // formattedTime = '${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}';
                      debugPrint("Formatted Time: $formattedTime");
                    });
                  }
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a time';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              Consumer<FollowupProvider>(
                builder: (context, provider, child) {
                  return provider.isLoading
                      ? Center(child: CircularProgressIndicator())
                      : provider.followupTypes.isEmpty
                          ? Center(child: Text('No Follow-Up Types Available'))
                          : DropdownButtonFormField<FollowUpTypes>(
                              decoration: InputDecoration(
                                labelText: 'Select Follow-Up Type',
                                border: OutlineInputBorder(),
                                prefixIcon: Icon(Icons.arrow_drop_down),
                              ),
                              value: _selectedFollowUpType,
                              items: provider.followupTypes
                                  .map((FollowUpTypes type) {
                                return DropdownMenuItem<FollowUpTypes>(
                                  value: type,
                                  child: Text(type.type ?? 'Unknown'),
                                );
                              }).toList(),
                              onChanged: provider.followupTypes.isNotEmpty
                                  ? (FollowUpTypes? newValue) {
                                      setState(() {
                                        _selectedFollowUpType = newValue;
                                      });
                                    }
                                  : null, // Disable dropdown if empty
                              isExpanded:
                                  true, // Makes dropdown take full width
                              hint: Text('Select Follow-Up Type'),
                            );
                },
              ),
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
                SizedBox(height: 10),
              ],
              text(context, "UPDATE FOLLOWUP STATUS", 16,
                  fontWeight: FontWeight.w500),
              // Radio Buttons
              Column(
                mainAxisAlignment: MainAxisAlignment
                    .start, // Align items to start or adjust as needed
                children: [
                  RadioListTile<String>(
                    visualDensity: VisualDensity.compact,
                    contentPadding: EdgeInsets.zero,
                    title: Transform.translate(
                      offset: Offset(-8,
                          0), // Slightly reduced offset for better alignment
                      child:
                          text(context, "Open", 13, textAlign: TextAlign.start),
                    ),
                    value: 'open',
                    groupValue: _leadStatus,
                    onChanged: (value) {
                      setState(() {
                        _leadStatus = value;
                      });
                    },
                  ),
                  RadioListTile<String>(
                    visualDensity: VisualDensity.compact,
                    contentPadding: EdgeInsets.zero,
                    title: Transform.translate(
                      offset: Offset(-8, 0),
                      child: text(context, "Pending", 13,
                          textAlign: TextAlign.start),
                    ),
                    value: 'pending',
                    groupValue: _leadStatus,
                    onChanged: (value) {
                      setState(() {
                        _leadStatus = value;
                      });
                    },
                  ),
                  RadioListTile<String>(
                    visualDensity: VisualDensity.compact,
                    contentPadding: EdgeInsets.zero,
                    title: Transform.translate(
                      offset: Offset(-8, 0),
                      child: text(context, "Completed", 13,
                          textAlign: TextAlign.start),
                    ),
                    value: 'completed',
                    groupValue: _leadStatus,
                    onChanged: (value) {
                      setState(() {
                        _leadStatus = value;
                      });
                    },
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
