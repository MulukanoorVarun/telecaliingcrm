import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../model/FollowUpTypesModel.dart';
import '../providers/DashBoardProvider.dart';
import '../providers/FollowupProvider.dart';
import '../utils/ColorConstants.dart';
import '../utils/ShakeWidget.dart';
import '../utils/constants.dart';

class UpdateFollowupScreen extends StatefulWidget {
  final String followupId;
  final String leadId;
  final String staffId;
  const UpdateFollowupScreen(
      {super.key,
      required this.followupId,
      required this.staffId,
      required this.leadId});

  @override
  State<UpdateFollowupScreen> createState() => _UpdateFollowupScreenState();
}

class _UpdateFollowupScreenState extends State<UpdateFollowupScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _remarksController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  String formattedDate = "";
  String formattedTime = '';
  String? _followupStatus;
  FollowUpTypes? _selectedFollowUpType;
  String? _selectedFollowUpTypeName;
  int? _selectedFollowUpTypeId;
  bool _loading = false;
  String _validateFullName = "";
  String _validateMobile = "";
  String _validateRemarks = "";
  String followupstatusError = "";
  String leadstageError = "";

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<FollowupProvider>(context, listen: false);
      // Fetch follow-up types
      provider.getFollowUpTypes();
      // Fetch follow-up details if editing (followupId is provided)
      if (widget.followupId.isNotEmpty) {
        debugPrint("Fetching follow-up with ID: ${widget.followupId}");
        provider.getFollowUpByID(widget.followupId).then((success) {
          if (success) {
            setState(() {
              if (widget.followupId.isNotEmpty &&
                  provider.selectedFollowUp != null) {
                final followUp = provider.selectedFollowUp!;
                _nameController.text = followUp.name ?? '';
                _remarksController.text = followUp.remarks ?? '';
                _mobileController.text = followUp.phone ?? "";
                formattedDate = followUp.date ?? '';
                formattedTime = followUp.time ?? '';
                _followupStatus = followUp.status?.toLowerCase();

                // Set the follow-up type
                if (followUp.typeOfFollowUp != null) {
                  try {
                    // Find the matching FollowUpTypes object in the current provider.followupTypes
                    final matchingType = provider.followupTypes.firstWhere(
                          (type) => type.id == followUp.typeOfFollowUp,
                      orElse: () => FollowUpTypes(id: null, type: null),
                    );
                    if (matchingType.id != null) {
                      // Ensure we use the exact object from provider.followupTypes
                      _selectedFollowUpType = provider.followupTypes.firstWhere(
                            (type) => type == matchingType,
                        orElse: () => FollowUpTypes(id: null, type: null),
                      );
                      _selectedFollowUpTypeId = _selectedFollowUpType?.id;
                      _selectedFollowUpTypeName = _selectedFollowUpType?.type;
                      debugPrint(
                          "Initialized Follow-Up Type: $_selectedFollowUpTypeName (ID: $_selectedFollowUpTypeId)");
                      // Verify containment
                      if (!provider.followupTypes.contains(_selectedFollowUpType)) {
                        debugPrint(
                            "Warning: _selectedFollowUpType not in provider.followupTypes");
                      }
                    } else {
                      debugPrint(
                          "No matching FollowUpType found for ID: ${followUp
                              .typeOfFollowUp}");
                    }
                  } catch (e) {
                    debugPrint("Error setting FollowUpType: $e");
                  }
                }
              }
            });

          } else {
            CustomSnackBar.show(context, "Failed to load follow-up details!");
          }
        });
      }
    });

    _focusNode.addListener(() {
      if (!_focusNode.hasFocus && _selectedFollowUpType == null) {
        _searchController.clear();
      } else if (!_focusNode.hasFocus && _selectedFollowUpType != null) {
        // _searchController.text = _selectedFollowUpType!.type ?? 'Unknown';
      }
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _remarksController.dispose();
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _validateFields() {
    setState(() {
      _loading = true;
      // Validate Full Name
      _validateFullName = _nameController.text.isEmpty
              ? "Please enter a valid name"
              : "";
      // Validate Remarks
      _validateRemarks =
          _remarksController.text.isEmpty ? "Please add some remarks" : "";
      _validateMobile =
          _mobileController.text.isEmpty || _mobileController.text.length<10 ? "Please Enter A Valid Mobile Number." : "";
      // Validate Lead Status
      followupstatusError =
          (_followupStatus == null) ? "Please select a lead status" : "";
      // Validate Follow-Up Type
      leadstageError = (_selectedFollowUpTypeId == null)
          ? "Please select a follow-up type"
          : "";

      // Proceed only if all fields are valid
      if (_validateFullName.isEmpty &&
          _validateRemarks.isEmpty &&
          _validateMobile.isEmpty &&
          followupstatusError.isEmpty &&
          leadstageError.isEmpty) {
        submitData();
      } else {
        _loading = false;
      }
    });
  }

  Future<void> submitData() async {
    try {
      final followupsProvider =
          Provider.of<FollowupProvider>(context, listen: false);
      Map<String, dynamic> data = {
        "staff_id": widget.staffId,
        "name": _nameController.text,
        "phone": _mobileController.text,
        "date": formattedDate,
        "time": formattedTime,
        "type_of_follow_up": _selectedFollowUpTypeId,
        "remarks": _remarksController.text,
        "status": _followupStatus,
        "lead_id": widget.leadId,
      };

      bool? res;
      if (widget.followupId.isEmpty) {
        res = await followupsProvider.AddFollowUp(data);
      } else {
        res = await followupsProvider.updateFollowUp(data,widget.followupId);
      }

      setState(() {
        if (res == true) {
          _loading = false;
          CustomSnackBar.show(
              context,
              widget.followupId.isEmpty
                  ? "Followup Added Successfully!"
                  : "Followup Updated Successfully!");
          if(widget.followupId.isEmpty){
            Provider.of<DashboardProvider>(context, listen: false).fetchDashBoardDetails("Pending");
          }
            context.pushReplacement("/followups");
        } else {
          _loading = false;
          CustomSnackBar.show(
              context,
              widget.followupId.isEmpty
                  ? "Followup Added Failed!"
                  : "Followup Updated Failed!");
        }
      });
    } catch (e) {
      setState(() {
        _loading = false;
      });
      debugPrint("Error occurred while submitting follow-up: $e");
      CustomSnackBar.show(context, "An error occurred. Please try again.");
    }
  }

  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: scaffoldbgColor,
      appBar: AppBar(
        title: Text(
          widget.followupId.isEmpty ? 'Add FollowUp' : 'Update FollowUp',
          style: TextStyle(
              fontSize: 22,
              fontFamily: "Poppins",
              fontWeight: FontWeight.w600,
              color: Colors.white),
        ),
        backgroundColor: primaryColor,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Consumer<FollowupProvider>(
        builder: (context, provider, child) {
          return container(
            context,
            w: w,
            margin: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20),
                  // Name Field
                  TextFormField(
                    controller: _nameController,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                      labelText: "Name",
                      labelStyle: TextStyle(
                        fontSize: 14,
                        letterSpacing: 0,
                        height: 25.73 / 14,
                        color: Colors.grey,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w400,
                      ),
                      filled: true,
                      fillColor: Color(0xffffffff),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(7),
                        borderSide:
                            BorderSide(width: 1, color: Color(0xffCDE2FB)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(7),
                        borderSide:
                            BorderSide(width: 1, color: Color(0xffCDE2FB)),
                      ),
                    ),
                  ),
                  if (_validateFullName.isNotEmpty) ...[
                    Container(
                      alignment: Alignment.topLeft,
                      margin: EdgeInsets.only(left: 8, bottom: 10, top: 5),
                      width: MediaQuery.of(context).size.width * 0.6,
                      child: ShakeWidget(
                        key: Key("name"),
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
                  // Name Field
                  TextFormField(
                    controller: _mobileController,
                    keyboardType: TextInputType.phone,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(10)
                    ],
                    decoration: InputDecoration(
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                      labelText: "Mobile Number",
                      labelStyle: TextStyle(
                        fontSize: 14,
                        letterSpacing: 0,
                        height: 25.73 / 14,
                        color: Colors.grey,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w400,
                      ),
                      filled: true,
                      fillColor: Color(0xffffffff),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(7),
                        borderSide:
                            BorderSide(width: 1, color: Color(0xffCDE2FB)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(7),
                        borderSide:
                            BorderSide(width: 1, color: Color(0xffCDE2FB)),
                      ),
                    ),
                  ),
                  if (_validateMobile.isNotEmpty) ...[
                    Container(
                      alignment: Alignment.topLeft,
                      margin: EdgeInsets.only(left: 8, bottom: 10, top: 5),
                      width: MediaQuery.of(context).size.width * 0.6,
                      child: ShakeWidget(
                        key: Key("mobile"),
                        duration: Duration(milliseconds: 700),
                        child: Text(
                          _validateMobile,
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
                  // Follow-Up Type Dropdown
                  DropdownButtonHideUnderline(
                    child: DropdownButton2<FollowUpTypes>(
                      isExpanded: true,
                      hint: Text(
                        'Select Follow-Up Type',
                        style: TextStyle(fontSize: 14, fontFamily: "Poppins", color: Colors.grey),
                      ),
                      items: provider.followupTypes.isNotEmpty
                          ? provider.followupTypes.map((item) {
                        return DropdownMenuItem<FollowUpTypes>(
                          value: item,
                          child: Text(
                            item.type ?? 'Unknown',
                            style: TextStyle(fontSize: 14, fontFamily: "Poppins"),
                          ),
                        );
                      }).toList()
                          : [
                        DropdownMenuItem<FollowUpTypes>(
                          enabled: false,
                          child: Text(
                            'No data found',
                            style: TextStyle(
                                fontSize: 14, color: Colors.grey, fontFamily: "Poppins"),
                          ),
                        )
                      ],
                      value: _selectedFollowUpType != null &&
                          provider.followupTypes.any(
                                  (item) => item.id == _selectedFollowUpType!.id)
                          ? provider.followupTypes.firstWhere(
                              (item) => item.id == _selectedFollowUpType!.id)
                          : null,
                      onChanged: (value) {
                        setState(() {
                          _selectedFollowUpType = value;
                          _selectedFollowUpTypeId = value?.id;
                          _selectedFollowUpTypeName = value?.type ?? '';
                          debugPrint("Selected Follow-Up Type: $_selectedFollowUpTypeName (ID: $_selectedFollowUpTypeId)");
                        });
                      },
                      buttonStyleData: ButtonStyleData(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        height: 50,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          border: Border.fromBorderSide(
                            BorderSide(width: 1, color: Color(0xffCDE2FB)),
                          ),
                        ),
                      ),
                      dropdownStyleData: DropdownStyleData(
                        maxHeight: 250,
                        padding: EdgeInsets.zero,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        scrollbarTheme: ScrollbarThemeData(
                          thumbVisibility: MaterialStatePropertyAll(false),
                        ),
                      ),
                      menuItemStyleData: MenuItemStyleData(
                        height: 45,
                        padding: EdgeInsets.symmetric(horizontal: 16),
                      ),
                      dropdownSearchData: DropdownSearchData(
                        searchController: _searchController,
                        searchInnerWidgetHeight: 50,
                        searchInnerWidget: Container(
                          height: 50,
                          padding: EdgeInsets.all(5),
                          child: TextFormField(
                            controller: _searchController,
                            focusNode: _focusNode,
                            expands: true,
                            maxLines: null,
                            decoration: InputDecoration(
                              isDense: true,
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 8),
                              hintText: 'Search Follow-Up Type',
                              hintStyle: TextStyle(
                                  fontSize: 12, fontFamily: "Poppins"),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(
                                    width: 1, color: Color(0xffCDE2FB)),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(7),
                                borderSide: BorderSide(
                                    width: 1, color: Color(0xffCDE2FB)),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(7),
                                borderSide: BorderSide(
                                    width: 1, color: Color(0xffCDE2FB)),
                              ),
                            ),
                          ),
                        ),
                        searchMatchFn: (item, searchValue) {
                          return item.value?.type
                                  ?.toLowerCase()
                                  .contains(searchValue.toLowerCase()) ??
                              false;
                        },
                      ),
                      onMenuStateChange: (isOpen) {
                        if (!isOpen) {
                          _searchController.clear();
                        }
                      },
                    ),
                  ),
                  if (leadstageError.isNotEmpty) ...[
                    Container(
                      alignment: Alignment.topLeft,
                      margin: EdgeInsets.only(left: 8, bottom: 10, top: 5),
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
                  ] else ...[
                    SizedBox(height: 16),
                  ],
                  // Date Field
                  TextFormField(
                    controller: TextEditingController(text: formattedDate),
                    decoration: InputDecoration(
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                      labelText: 'Date',
                      labelStyle: TextStyle(
                        fontSize: 14,
                        letterSpacing: 0,
                        height: 25.73 / 14,
                        color: Colors.grey,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w400,
                      ),
                      hintText: 'Choose Date',
                      filled: true,
                      fillColor: Color(0xffffffff),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(7),
                        borderSide:
                            BorderSide(width: 1, color: Color(0xffCDE2FB)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(7),
                        borderSide:
                            BorderSide(width: 1, color: Color(0xffCDE2FB)),
                      ),
                      suffixIcon:
                          Icon(Icons.calendar_today, color: primaryColor),
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
                          formattedDate =
                              DateFormat('yyyy-MM-dd').format(picked);
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
                  SizedBox(height: 16),
                  // Time Field
                  TextFormField(
                    controller: TextEditingController(text: formattedTime),
                    decoration: InputDecoration(
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                      labelText: 'Time',
                      labelStyle: TextStyle(
                        fontSize: 14,
                        letterSpacing: 0,
                        height: 25.73 / 14,
                        color: Colors.grey,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w400,
                      ),
                      hintText: 'Choose Time',
                      filled: true,
                      fillColor: Color(0xffffffff),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(7),
                        borderSide:
                            BorderSide(width: 1, color: Color(0xffCDE2FB)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(7),
                        borderSide:
                            BorderSide(width: 1, color: Color(0xffCDE2FB)),
                      ),
                      suffixIcon: Icon(Icons.access_time, color: primaryColor),
                    ),
                    readOnly: true,
                    onTap: () async {
                      final TimeOfDay? picked = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                      );
                      if (picked != null) {
                        setState(() {
                          formattedTime = picked.format(context);
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
                  SizedBox(height: 16),
                  // Remarks Field
                  TextFormField(
                    controller: _remarksController,
                    decoration: InputDecoration(
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                      labelText: "Remarks",
                      labelStyle: TextStyle(
                        fontSize: 14,
                        letterSpacing: 0,
                        height: 25.73 / 14,
                        color: Colors.grey,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w400,
                      ),
                      filled: true,
                      fillColor: Color(0xffffffff),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(7),
                        borderSide:
                            BorderSide(width: 1, color: Color(0xffCDE2FB)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(7),
                        borderSide:
                            BorderSide(width: 1, color: Color(0xffCDE2FB)),
                      ),
                    ),
                    maxLines: 4,
                  ),
                  if (_validateRemarks.isNotEmpty) ...[
                    Container(
                      alignment: Alignment.topLeft,
                      margin: EdgeInsets.only(left: 8, bottom: 10, top: 5),
                      child: ShakeWidget(
                        key: Key("remarks"),
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
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      RadioListTile<String>(
                        visualDensity: VisualDensity.compact,
                        contentPadding: EdgeInsets.zero,
                        title: Transform.translate(
                          offset: Offset(-8, 0),
                          child: text(context, "Open", 13,
                              textAlign: TextAlign.start),
                        ),
                        value: 'open',
                        groupValue: _followupStatus,
                        onChanged: (value) {
                          setState(() {
                            _followupStatus = value;
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
                        groupValue: _followupStatus,
                        onChanged: (value) {
                          setState(() {
                            _followupStatus = value;
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
                        groupValue: _followupStatus,
                        onChanged: (value) {
                          setState(() {
                            _followupStatus = value;
                          });
                        },
                      ),
                    ],
                  ),
                  if (followupstatusError.isNotEmpty) ...[
                    Container(
                      alignment: Alignment.topLeft,
                      margin: EdgeInsets.only(left: 8, bottom: 10, top: 5),
                      child: Text(
                        followupstatusError,
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
                  SizedBox(height: 50),
                  containertext(
                    context,
                    widget.followupId.isEmpty ? "Submit" : "Update",
                    color: primaryColor,
                    isLoading: _loading,
                    onTap: () {
                      if (!_loading) {
                        _validateFields();
                      }
                    },
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
