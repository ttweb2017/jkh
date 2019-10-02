import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class InputFieldArea extends StatefulWidget {

  InputFieldArea({
    Key key,
    this.name,
    this.hint,
    this.obscure,
    this.icon,
    this.textController,
    this.inputActionType,
    this.maxLen
  }):super(key: key);

  final String name;
  final String hint;
  final bool obscure;
  final IconData icon;
  final int maxLen;

  final textController;
  final TextInputAction inputActionType;


  @override
  _InputFieldAreaState createState() => _InputFieldAreaState();

  //InputFieldArea({this.name, this.hint, this.obscure, this.icon});
}

class _InputFieldAreaState extends State<InputFieldArea> {

  @override
  void initState() {
    /*_textController.addListener(() {
      final text = _textController.text;
      _textController.value = _textController.value.copyWith(
        text: text,
        selection:
        TextSelection(baseOffset: text.length, extentOffset: text.length),
        composing: TextRange.empty,
      );
    });*/
    super.initState();
  }

  void dispose() {
    widget.textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Container(
      margin: const EdgeInsets.only(top: 30.0),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            width: 0.5,
            color: Color.fromRGBO(53, 102, 54, 1),
          ),
        ),
      ),
      child: CupertinoTextField(
        maxLength: widget.maxLen,
        textInputAction: widget.inputActionType,
        controller: widget.textController,
        obscureText: widget.obscure,
        style: const TextStyle(
          color: Color.fromRGBO(53, 102, 54, 1),
        ),
        /*decoration: InputDecoration(
          icon: Icon(
            widget.icon,
            color: Color.fromRGBO(53, 102, 54, 1),
          ),
          border: InputBorder.none,
          hintText: widget.hint,
          hintStyle: const TextStyle(color: Color.fromRGBO(53, 102, 54, 1), fontSize: 15.0),
          contentPadding: const EdgeInsets.only(top: 5.0, right: 30.0, bottom: 5.0, left: 5.0),
        ),*/
        onChanged: (value){
          if(value.isEmpty){
            return widget.name + " dolduruň!";
          }

          return null;
        },
      ),
    );
  }
}
