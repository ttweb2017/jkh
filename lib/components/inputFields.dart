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
    this.maxLen,
    this.keyboardType
  }):super(key: key);

  final String name;
  final String hint;
  final bool obscure;
  final IconData icon;
  final int maxLen;

  final textController;
  final TextInputAction inputActionType;
  final TextInputType keyboardType;


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

    return CupertinoTextField(
      keyboardType: widget.keyboardType,
      textInputAction: widget.inputActionType,
      maxLength: widget.maxLen,
      obscureText: widget.obscure,
      prefix: Icon(
        widget.icon,
        color: CupertinoColors.lightBackgroundGray,
        size: 28.0,
      ),
      padding: EdgeInsets.symmetric(horizontal: 6.0, vertical: 12.0),
      clearButtonMode: OverlayVisibilityMode.editing,
      textCapitalization: TextCapitalization.none,
      autocorrect: false,
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(width: 0.0, color: CupertinoColors.inactiveGray)),
      ),
      placeholder: widget.hint,
      onChanged: (value){
        if(value.isEmpty){
          return widget.name + " dolduruň!";
        }

        return null;
      },
    );
  }
}
