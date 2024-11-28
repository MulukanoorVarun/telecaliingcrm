import 'package:flutter/material.dart';
import 'package:telecaliingcrm/utils/constants.dart';

import '../utils/ColorConstants.dart';
import '../utils/ShakeWidget.dart';

class Addleadsscreen extends StatefulWidget {
  const Addleadsscreen({super.key});

  @override
  State<Addleadsscreen> createState() => _AddleadsscreenState();
}

class _AddleadsscreenState extends State<Addleadsscreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _remarksController = TextEditingController();
  DateTime? _selectedDate;
  String? _leadStatus = 'cold';

  String _validateFullName = "";
  String _validateMobilenumber = "";
  String _validatedate = "";
  String _validateRemarks = "";
  String _validateStatus = "";

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
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
            'Add Leads',
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
      body: container(
        context,
        w: w,
        margin:  EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20,),
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
              const SizedBox(height: 16),

              // Mobile Number Field
              TextFormField(
                controller: _mobileController,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 0,
                    horizontal: 10,
                  ),
                  labelText: "Mobile Number",
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
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 16),

              // Date Field
              TextFormField(
                controller: TextEditingController(
                  text: _selectedDate == null
                      ? ''
                      : '${_selectedDate!.toLocal()}'.split(' ')[0],
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
                        width: 1, color: Color(0xffCDE2FB)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(7),
                    borderSide: const BorderSide(
                        width: 1, color: Color(0xffCDE2FB)),
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
                    initialDate: _selectedDate ?? DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2101),
                  );
                  if (picked != null && picked != _selectedDate) {
                    setState(() {
                      _selectedDate = picked;
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
              const SizedBox(height: 16),

              // Radio Buttons
              Row(
                children: [
                  Expanded(
                    child: RadioListTile<String>(
                      visualDensity: VisualDensity.compact,
                      contentPadding: EdgeInsets.all(0),
                      title: text(context, "Cold", 13,textAlign: TextAlign.start),
                      value: 'cold',
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
                      title: text(context, "Warm", 13,textAlign: TextAlign.start),
                      value: 'warm',
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
                      title: text(context, "Hot", 13,textAlign: TextAlign.start),
                      value: 'hot',
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
              SizedBox(height: 50,),
              containertext(context, "Submit"),

              SizedBox(height: 20,),
            ],
          ),
        ),
      ),

    );
  }
}
