import 'package:flutter/material.dart';

class CustomTxtfields extends StatefulWidget {
  String label_txt;
  IconData? prefixIcon;
  TextEditingController controller;
  VoidCallback onpress;
  bool isreadable;
  CustomTxtfields({super.key,required this.label_txt,required this.controller, this.prefixIcon,required this.onpress,this.isreadable=true});

  @override
  State<CustomTxtfields> createState() => _CustomTxtfieldsState();
}

class _CustomTxtfieldsState extends State<CustomTxtfields> {
  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: TextField(
        controller: widget.controller,
        readOnly: widget.isreadable,
        decoration: InputDecoration(
          prefixIcon: Icon(widget.prefixIcon),
          label: Text(widget.label_txt),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.blue,
              width: 1,
            ),
          ),
          enabledBorder: OutlineInputBorder(
          )
        ),
        onTap: widget.onpress,
      ),
    );
  }
}
