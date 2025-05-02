import 'package:flutter/material.dart';
import 'package:flutter_searchable_dropdown/flutter_searchable_dropdown.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:telecaliingcrm/Services/UserApi.dart';
import 'package:telecaliingcrm/utils/constants.dart';

import '../providers/ConnectivityProviders.dart';
import '../providers/LeadsProvider.dart';
import '../providers/leaderBoardprovider.dart';
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
  int? selectedIndustryId;
  int? selectservicesId;
  int? selectStageId;
  String formattedDate = "";
  String? _leadStatus;
  String? _leadStage;
  bool _loading = false;
  String _validateFullName = "";
  String _validateindustires = "";
  String _validatestages = "";
  String _validateservices = "";
  String _validateRemarks = "";
  String leadstatusError = "";
  String leadstageError = "";

  // @override
  // void initState() {
  //   print('idgfshgdgh:${widget.ID}');
  //   WidgetsBinding.instance.addPostFrameCallback((_) {
  //     Provider.of<LeaderBoardProvider>(context, listen: false).getData(widget.ID);
  //   });
  //
  //   super.initState();
  // }
  @override
  void initState() {
    super.initState();
    print('Lead ID: ${widget.ID}');
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final leaderBoardProvider =
          Provider.of<LeaderBoardProvider>(context, listen: false);
      leaderBoardProvider.getData(widget.ID).then((_) {
        // Update state with fetched data only if the widget is still mounted
        if (mounted) {
          setState(() {
            if (leaderBoardProvider.leadinfo.isNotEmpty) {
              _nameController.text =
                  leaderBoardProvider.leadinfo[0].name ?? widget.name;
              _remarksController.text =
                  leaderBoardProvider.leadinfo[0].remarks ?? widget.remarks;
              selectedIndustryId = leaderBoardProvider.leadinfo[0].industryType;
              selectStageId = leaderBoardProvider.leadinfo[0].stageType;
              selectservicesId = leaderBoardProvider.leadinfo[0].serviceType;
              _leadStatus =
                  leaderBoardProvider.leadinfo[0].leadStageId.toString();
              _leadStage = leaderBoardProvider.leadinfo[0].dealStatus;
            }
          });
        }
      });
    });
  }

  void _validateFields() {
    setState(() {
      _loading = true;
      _validateFullName =
          !_nameController.text.contains(RegExp(r"^[a-zA-Z\s]+$"))
              ? "Please enter a valid name"
              : "";
      _validateindustires =
          selectedIndustryId == null ? "Please select an industries name" : "";
      _validateservices =
          selectservicesId == null ? "Please select an services name" : "";
      _validatestages =
          selectStageId == null ? "Please select an stages name" : "";
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
          _validateindustires.isEmpty &&
          _validateservices.isEmpty &&
          _validatestages.isEmpty &&
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
      final Map<String, dynamic> data = {
        "name": _nameController.text,
        "lead_id": widget.ID,
        "remarks": _remarksController.text,
        "lead_stage_id": _leadStatus,
        "deal_stage": _leadStage,
        "stage_type": selectStageId,
        "service_type": selectservicesId,
        "industry_type": selectedIndustryId,
      };
      final response = await leadsProvider.UpdateleadsApi(data);

      setState(() {
        _loading = false;
      });
      if (response == true) {
        CustomSnackBar.show(context, "Lead Updated Successfully!");
        Navigator.pop(context, true);
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
      body: Consumer<LeaderBoardProvider>(
        builder: (context, leaderBoard, child) {
          if (leaderBoard.isLoading) {
            return Center(
                child: CircularProgressIndicator(
              color: Colors.blue,
            ));
          }
          // if (leaderBoard.leadinfo.isNotEmpty) {
          //   _nameController.text = leaderBoard.leadinfo[0].name ?? "";
          //   selectedIndustryId= leaderBoard.leadinfo[0].industryType ?? 0;
          //   selectStageId= leaderBoard.leadinfo[0].stageType ?? 0;
          //   selectservicesId= leaderBoard.leadinfo[0].serviceType ?? 0;
          //   _remarksController.text= leaderBoard.leadinfo[0].remarks ?? "";
          //   _leadStatus= leaderBoard.leadinfo[0].leadStageId.toString()??"";
          //   _leadStage= leaderBoard.leadinfo[0].dealStatus??"";
          // }

          return container(context,
              w: w,
              margin: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 20,
                    ),
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
                    Text('Industires',
                        style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontFamily: "Poppins",
                            color: Colors.grey,
                            fontSize: 14)),
                    SizedBox(height: 6),
                    Container(
                      height: 50,
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(7),
                        border: Border.all(width: 1, color: Color(0xffCDE2FB)),
                      ),
                      child: SingleChildScrollView(
                        child: SearchableDropdown<int>.single(
                          items: leaderBoard.industires
                              .map((industry) => DropdownMenuItem<int>(
                                    value: industry.id,
                                    child: Text(
                                      industry.type ?? "",
                                      style: TextStyle(
                                        fontSize: 14,
                                        letterSpacing: 0,
                                        height: 25.73 / 14,
                                        color: Colors.black,
                                        fontFamily: 'Poppins',
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ))
                              .toList(),
                          value: selectedIndustryId,
                          hint: Text(
                            "Select Industries",
                            style: TextStyle(
                                fontSize: 16, color: Colors.grey.shade600),
                          ),
                          searchHint: Text(
                            "Search and select Industries",
                            style: TextStyle(
                                fontSize: 16, color: Colors.grey.shade600),
                          ),
                          onChanged: (value) {
                            setState(() {
                              selectedIndustryId = value;
                            });
                          },
                          doneButton: "Done",
                          displayItem: (item, selected) {
                            return Row(
                              children: [
                                Icon(
                                  selected
                                      ? Icons.radio_button_checked
                                      : Icons.radio_button_unchecked,
                                  color: selected ? primaryColor : Colors.grey,
                                ),
                                SizedBox(width: 10),
                                Expanded(
                                  child: DefaultTextStyle(
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.black),
                                    child: item,
                                  ),
                                ),
                              ],
                            );
                          },
                          isExpanded: true,
                          icon: Icon(Icons.arrow_drop_down,
                              color: Colors.grey.shade700),
                        ),
                      ),
                    ),
                    if (_validateindustires.isNotEmpty) ...[
                      Container(
                        alignment: Alignment.topLeft,
                        margin: EdgeInsets.only(left: 8, bottom: 10, top: 5),
                        width: MediaQuery.of(context).size.width * 0.6,
                        child: ShakeWidget(
                          key: Key("value"),
                          duration: Duration(milliseconds: 700),
                          child: Text(
                            _validateindustires,
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
                    Text('Services',
                        style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontFamily: "Poppins",
                            color: Colors.grey,
                            fontSize: 14)),
                    SizedBox(height: 6),
                    Container(
                      height: 50,
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(7),
                        border: Border.all(width: 1, color: Color(0xffCDE2FB)),
                      ),
                      child: SingleChildScrollView(
                        child: SearchableDropdown<int>.single(
                          items: leaderBoard.services
                              .map((services) => DropdownMenuItem<int>(
                                    value: services.id,
                                    child: Text(
                                      services.type ?? "",
                                      style: TextStyle(
                                        fontSize: 14,
                                        letterSpacing: 0,
                                        height: 25.73 / 14,
                                        color: Colors.black,
                                        fontFamily: 'Poppins',
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ))
                              .toList(),
                          value: selectservicesId,
                          hint: Text(
                            "Select Services",
                            style: TextStyle(
                                fontSize: 16, color: Colors.grey.shade600),
                          ),
                          searchHint: Text(
                            "Search and select Services",
                            style: TextStyle(
                                fontSize: 16, color: Colors.grey.shade600),
                          ),
                          onChanged: (value) {
                            setState(() {
                              selectservicesId = value;
                            });
                          },
                          doneButton: "Done",
                          displayItem: (item, selected) {
                            return Row(
                              children: [
                                Icon(
                                  selected
                                      ? Icons.radio_button_checked
                                      : Icons.radio_button_unchecked,
                                  color: selected ? primaryColor : Colors.grey,
                                ),
                                SizedBox(width: 10),
                                Expanded(
                                  child: DefaultTextStyle(
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.black),
                                    child: item,
                                  ),
                                ),
                              ],
                            );
                          },
                          isExpanded: true,
                          icon: Icon(Icons.arrow_drop_down,
                              color: Colors.grey.shade700),
                        ),
                      ),
                    ),
                    if (_validateservices.isNotEmpty) ...[
                      Container(
                        alignment: Alignment.topLeft,
                        margin: EdgeInsets.only(left: 8, bottom: 10, top: 5),
                        width: MediaQuery.of(context).size.width * 0.6,
                        child: ShakeWidget(
                          key: Key("value"),
                          duration: Duration(milliseconds: 700),
                          child: Text(
                            _validateservices,
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
                    Text('Stages',
                        style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontFamily: "Poppins",
                            color: Colors.grey,
                            fontSize: 14)),
                    SizedBox(height: 6),
                    Container(
                      height: 50,
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(7),
                        border: Border.all(width: 1, color: Color(0xffCDE2FB)),
                      ),
                      child: SingleChildScrollView(
                        child: SearchableDropdown<int>.single(
                          items: leaderBoard.stages
                              .map((stages) => DropdownMenuItem<int>(
                                    value: stages.id,
                                    child: Text(
                                      stages.type ?? "",
                                      style: TextStyle(
                                        fontSize: 14,
                                        letterSpacing: 0,
                                        height: 25.73 / 14,
                                        color: Colors.black,
                                        fontFamily: 'Poppins',
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ))
                              .toList(),
                          value: selectStageId,
                          hint: Text(
                            "Select Stages",
                            style: TextStyle(
                                fontSize: 16, color: Colors.grey.shade600),
                          ),
                          searchHint: Text(
                            "Search and select Stages",
                            style: TextStyle(
                                fontSize: 16, color: Colors.grey.shade600),
                          ),
                          onChanged: (value) {
                            setState(() {
                              selectStageId = value;
                            });
                          },
                          doneButton: "Done",
                          displayItem: (item, selected) {
                            return Row(
                              children: [
                                Icon(
                                  selected
                                      ? Icons.radio_button_checked
                                      : Icons.radio_button_unchecked,
                                  color: selected ? primaryColor : Colors.grey,
                                ),
                                SizedBox(width: 10),
                                Expanded(
                                  child: DefaultTextStyle(
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.black),
                                    child: item,
                                  ),
                                ),
                              ],
                            );
                          },
                          isExpanded: true,
                          icon: Icon(Icons.arrow_drop_down,
                              color: Colors.grey.shade700),
                        ),
                      ),
                    ),
                    if (_validatestages.isNotEmpty) ...[
                      Container(
                        alignment: Alignment.topLeft,
                        margin: EdgeInsets.only(left: 8, bottom: 10, top: 5),
                        width: MediaQuery.of(context).size.width * 0.6,
                        child: ShakeWidget(
                          key: Key("value"),
                          duration: Duration(milliseconds: 700),
                          child: Text(
                            _validatestages,
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
                    SizedBox(height: 16),
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
                          title: text(context, "Cancel", 13,
                              textAlign: TextAlign.start),
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
                            title: text(context, "Cold", 13,
                                textAlign: TextAlign.start),
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
                            title: text(context, "Warm", 13,
                                textAlign: TextAlign.start),
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
                            title: text(context, "Hot", 13,
                                textAlign: TextAlign.start),
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
              ));
        },
      ),
    );
  }
}
