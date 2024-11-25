import 'package:csc_picker/csc_picker.dart';
import 'package:fancy_snackbar/fancy_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:moon_design/moon_design.dart';
import 'package:random_string/random_string.dart';

import '../../Firebase/FIrebase_operation.dart';

class AddTask extends StatefulWidget {
  final bool isEdit;
  final Map<String , dynamic>? eventData;
   AddTask({super.key,this.isEdit=false,required this.eventData});

  @override
  State<AddTask> createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  String? selectedDate;
  String? selectedTime;
  bool ispressedDate = false;
  bool ispressedTime = false;
  String? status='pending';
  String statevalue = ' ';
  String cityvalue = '';
  List<int> mobileList = [];
  String id = randomAlphaNumeric(10);
  TextEditingController _remark = TextEditingController();
  TextEditingController _address = TextEditingController();
  TextEditingController _mobile_num = TextEditingController();

  void initState(){
    super.initState();
    if(widget.isEdit && widget.eventData!.isNotEmpty){
      ispressedDate=true;
      ispressedTime=true;
      selectedDate = widget.eventData?['date'];
      selectedTime = widget.eventData?['time'];
      _address.text = widget.eventData?['address'];
      _remark.text = widget.eventData?['remark'];
      mobileList = List<int>.from(widget.eventData?['mobile_no']);
      statevalue = widget.eventData?['state'];
      cityvalue = widget.eventData?['city'];
      id = widget.eventData?['id'];  // Use the existing event ID for edit
      status = widget.eventData?['status'];
    }
  }
  Future<void> _selectime() async {
    TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      // initialEntryMode: TimePickerEntryMode.input,
    );
    if (picked != null) {
      setState(() {
        ispressedTime = true;
      });
      selectedTime = '${picked.hour}:${picked.minute}';
    }
  }

  Future<void> _addMobileNum() async {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Enter your mobile number'),
            content: MoonFormTextInput(
              maxLength: 10,
              height: 50,
              controller: _mobile_num,
              validator: (String? value) {
                if (value == null || value.isEmpty) {
                  return "Please enter the mobile number";
                }
                if (value.length < 10) {
                  return "Please enter the correct mobile number";
                }
                return null;
              },
              onTap: () => _mobile_num.clear(),
              leading: const Icon(
                Icons.phone,
                color: Colors.orange,
              ),
            ),
            actions: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  MoonFilledButton(
                    buttonSize: MoonButtonSize.sm,
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    backgroundColor: Colors.orange,
                    leading: const Icon(MoonIcons.sport_canoeing_16_light),
                    label: const Text("Cancel",style: TextStyle(color: Colors.white),),
                  ),

                  MoonFilledButton(
                    buttonSize: MoonButtonSize.sm,
                    onTap: () {
                      mobileList.add(int.parse(_mobile_num.text));
                      Navigator.pop(context);
                    },
                    backgroundColor: Colors.orange,
                    leading: const Icon(Icons.add,color: Colors.white,),
                    label: const Text("Add",style: TextStyle(color: Colors.white),),
                  ),
                ],
              )
            ],
          );
        });
  }

  Future<void> _selectdate() async {
    DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2020),
        lastDate: DateTime(2050));
    if (picked != null) {

      setState(() {
        ispressedDate = true;
        selectedDate = '${picked.day}/ ${picked.month}/ ${picked.year}';
      });
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _address.dispose();
    _remark.dispose();
    _mobile_num.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        centerTitle: true,
        title: Text('Add Task',style: TextStyle(color: Colors.white,fontSize: 23,fontWeight: FontWeight.bold),),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 20,
            horizontal: 10,
          ),
          child: Form(
            child: Column(
              children: [
                SizedBox(
                  height: 20,
                ),
                // TODO: Date and Time
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    MoonButton(
                      buttonSize: MoonButtonSize.sm,
                      onTap: () {
                        setState(() {
                          _selectdate();
                        });
                      },
                      leading: const Icon(MoonIcons.time_calendar_add_16_light),
                      label: !ispressedDate
                          ? Text('Select Date: ')
                          : Text(selectedDate!),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    MoonButton(
                      buttonSize: MoonButtonSize.sm,
                      onTap: () {
                        setState(() {
                          _selectime();
                        });
                      },
                      leading: const Icon(MoonIcons.time_alarm_16_regular),
                      label: !ispressedTime
                          ? Text('Select Time: ')
                          : Text(selectedTime!),
                    ),
                  ],
                ),
                SizedBox(
                  height: 35,
                ),
                // TODO: Address
                MoonFormTextInput(
                  height: 60,
                  controller: _address,
                  validator: (String? value) => value != null && value.length < 5
                      ? "The text should be longer than 5 characters."
                      : null,
                  onTap: () => _address.clear(),
                  leading: Icon(Icons.home_outlined),
                ),
                SizedBox(
                  height: 40,
                ),
                // TODO: State and City
                CSCPicker(
                  defaultCountry: CscCountry.India,
                  disableCountry: true,
                  onCountryChanged: (country) {},
                  onStateChanged: (state) {
                    setState(() {
                      statevalue = state ?? " ";
                    });
                  },
                  onCityChanged: (city) {
                    setState(() {
                      cityvalue = city ?? " ";
                    });
                  },

                  ///Dialog box radius [OPTIONAL PARAMETER]
                  dropdownDialogRadius: 10.0,

                  ///Search bar radius [OPTIONAL PARAMETER]
                  searchBarRadius: 10.0,
                ),
                SizedBox(
                  height: 20,
                ),
                // TODO: Remark
                MoonTextArea(
                  controller:_remark ,
                  hintText: 'Remark',
                  height: 150,
                  validator: (String? value) =>
                      value?.length != null && value!.length < 4
                          ? "The text should be longer than 5 characters."
                          : null,
                ),
                SizedBox(
                  height: 10,
                ),
                // TODO: Mobile no
                Align(
                  alignment: Alignment.centerRight,
                  child: MoonOutlinedButton(
                    buttonSize: MoonButtonSize.sm,
                    onTap: () {
                      _addMobileNum();
                      _mobile_num.clear();
                    },
                    leading: const Icon(Icons.add,color: Colors.orange,),
                    label: mobileList.isEmpty
                        ? Text("Add Contact")
                        : Text('Add More'),
                  ),
                ),
                // TODO: ShowMobile Numbers
                SizedBox(
                  height: 20,
                ),
                mobileList.isNotEmpty
                    ? Wrap(
                        children: [
                          for (int item in mobileList)
                            MoonChip(
                              chipSize: MoonChipSize.sm,
                              leading: Icon(Icons.phone_android),
                              label: Text('$item'),
                              onLongPress: ()  {
                                setState(() {
                                  mobileList.remove(item);
                                });
                              },
                            ),
                        ],
                      )
                    : Text(''),
                mobileList.isNotEmpty
                    ? Align(
                        alignment: Alignment.centerRight,
                        child: Text('* Long press to delete',style: TextStyle(color: Colors.orange),))
                    : Text(''),
                SizedBox(
                  height: 80,
                ),

                // TODO: Submit Form
                MoonFilledButton(
                  width: double.infinity,
                  buttonSize: MoonButtonSize.sm,
                  onTap: () async {
                    if(selectedTime!=null && selectedDate!=null && _address.text.isNotEmpty){
                      String epochTime=(selectedDate!+selectedTime!).replaceAll(RegExp(r'[^0-9]'),'');
                      int epochDateTime=int.parse(epochTime);
                      Map<String, dynamic> detailsmap = {
                        'id': id,
                        'date': selectedDate,
                        'time':selectedTime,
                        'address': _address.text.toString(),
                        'mobile_no': mobileList,
                        'remark':_remark.text.toString(),
                        'epochdtTm':epochDateTime,
                        'state':statevalue,
                         'city':cityvalue,
                        'status':status,
                      };
                      if (widget.isEdit) {
                        // If editing, update the existing document
                        await FirebaseOperation().updateAll(detailsmap, id);
                      } else {
                        // If adding, create a new document
                        await FirebaseOperation().AddDetails(detailsmap, id);
                      }

                      setState(() {
                        _remark.clear();
                        _address.clear();
                        selectedTime='';
                        selectedDate='';
                        statevalue=" ";
                        cityvalue=" ";
                        ispressedTime=false;
                        ispressedDate=false;
                        mobileList.clear();
                      });
                    }else{
                      FancySnackbar.showSnackbar(
                        context,
                        snackBarType: FancySnackBarType.error,
                        title: "Please fill all the fields",
                        message: "",
                        duration: 4,
                      );
                    }
                  },
                  backgroundColor: Colors.orange,
                  label: const Text("Submit",style: TextStyle(color: Colors.white),),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
