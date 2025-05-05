import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../model/FollowUpTypesModel.dart';
import '../providers/FollowupProvider.dart';
import '../utils/ColorConstants.dart';
import '../utils/ShakeWidget.dart';
import '../utils/constants.dart';

class UpdateFollowupScreen extends StatefulWidget {
  final String followupId;
  final String leadId;
  final String staffId;
  const UpdateFollowupScreen({super.key, required this.followupId,required this.staffId,required this.leadId});

  @override
  State<UpdateFollowupScreen> createState() => _UpdateFollowupScreenState();
}

class _UpdateFollowupScreenState extends State<UpdateFollowupScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _remarksController = TextEditingController();

  String formattedDate = "";
  String formattedTime = '';
  String? _followupStatus;
  FollowUpTypes? _selectedFollowUpType;
  String? _selectedFollowUpTypeName;
  int? _selectedFollowUpTypeId;
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool _loading = false;
  String _validateFullName = "";
  String _validateRemarks = "";
  String followupstatusError = "";
  String leadstageError = "";

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<FollowupProvider>(context, listen: false).getFollowUpTypes();
    });
    _focusNode.addListener(() {
      if (!_focusNode.hasFocus && _selectedFollowUpType == null) {
        _searchController.clear();
      } else if (!_focusNode.hasFocus && _selectedFollowUpType != null) {
        _searchController.text = _selectedFollowUpType!.type ?? 'Unknown';
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
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
      // Validate Remarks
      _validateRemarks =
          _remarksController.text.isEmpty ? "Please add some remarks" : "";

      // Validate Lead Status
      followupstatusError =
          (_followupStatus == null) ? "Please select a lead status" : "";

      // Proceed only if all fields are valid
      if (_validateFullName.isEmpty &&
          _validateRemarks.isEmpty &&
          followupstatusError.isEmpty) {
        submitData();
      } else {
        _loading = false;
      }
    });
  }

  Future<void> submitData() async {
    try {
      final followupsProvider = Provider.of<FollowupProvider>(context, listen: false);
      var res;
      Map<String,dynamic> data={
        "staff_id":widget.staffId,
        "name":_nameController.text,
        "date":formattedDate,
        "time":formattedTime,
        "type_of_follow_up":_selectedFollowUpTypeId,
        "remarks":_remarksController.text,
        "status":_followupStatus,
        "lead_id":widget.leadId
      };
      if(widget.followupId==""){
        res= await followupsProvider.AddFollowUp(data);
      }else{
        res= await followupsProvider.updateFollowUp(data);
      }
    setState(() {
      if(res==true){
        _loading=false;
        CustomSnackBar.show(context, "Followup Added Successfully!");
      }else{
        _loading=false;
        CustomSnackBar.show(context, "Followup Added Failed!");
      }
    });
    } catch (e) {
      // Handle any errors
      debugPrint("Error occurred while adding Follow-up: $e");
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
              Consumer<FollowupProvider>(
                builder: (context, provider, child) {
                  return DropdownButtonHideUnderline(
                    child: DropdownButton2<FollowUpTypes>(
                      isExpanded: true,
                      hint: Text(
                        'Select Follow-Up Type',
                        style: TextStyle(
                          fontSize: 14,
                            fontFamily: "Poppins",
                          color: Colors.grey,
                        ),
                      ),
                      items: provider.followupTypes.isNotEmpty
                          ? provider.followupTypes.map((item) {
                        return DropdownMenuItem<FollowUpTypes>(
                          value: item,
                          child: Text(
                            item.type ?? 'Unknown',
                            style: const TextStyle(
                                fontSize: 14, fontFamily: "Poppins"),
                          ),
                        );
                      }).toList()
                          : [
                        const DropdownMenuItem<FollowUpTypes>(
                          enabled: false,
                          child: Text(
                            'No data found',
                            style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                                fontFamily: "Poppins"),
                          ),
                        )
                      ],
                      value: _selectedFollowUpType,
                      onChanged: (value) {
                        setState(() {
                          _selectedFollowUpType = value;
                          _selectedFollowUpTypeName = value?.type ?? '';
                          _selectedFollowUpTypeId = value?.id;
                        });
                        // If you want to print or use it immediately:
                        print("Selected Follow-Up Type: $_selectedFollowUpTypeName");
                        print("Selected Follow-Up ID: $_selectedFollowUpTypeId");
                      },

                      buttonStyleData: const ButtonStyleData(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        height: 50,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          border: Border.fromBorderSide(
                            BorderSide( width: 1,
                              color: Color(0xffCDE2FB),),
                          ),
                        ),
                      ),
                      dropdownStyleData: const DropdownStyleData(
                        maxHeight: 250,
                        padding: EdgeInsets.zero,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        scrollbarTheme: ScrollbarThemeData(
                          thumbVisibility: MaterialStatePropertyAll(
                              false), // disables scrollbar
                        ),
                      ),
                      menuItemStyleData: const MenuItemStyleData(
                        height: 45,
                        padding: EdgeInsets.symmetric(horizontal: 16),
                      ),
                      dropdownSearchData: DropdownSearchData(
                        searchController: _searchController,
                        searchInnerWidgetHeight: 50,
                        searchInnerWidget: Container(
                          height: 50,
                          padding: const EdgeInsets.all(5),
                          child: TextFormField(
                            controller: _searchController,
                            expands: true,
                            maxLines: null,
                            decoration: InputDecoration(
                              isDense: true,
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 8),
                              hintText: 'Search Follow-Up Type',
                              hintStyle: const TextStyle(
                                  fontSize: 12, fontFamily: "Poppins"),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide(
                                    width: 1,
                                    color: Color(0xffCDE2FB),
                                  )),
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
                  );
                },
              ),
              const SizedBox(height: 16),
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
