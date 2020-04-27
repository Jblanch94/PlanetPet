import 'package:flutter/material.dart';

class AccountTextField extends StatefulWidget {
  final InputDecoration fieldDecorator;
  final String Function(String) validate;
  final Function(String) save;
  final TextInputType keyboardType;

  AccountTextField(
      {Key key,
      this.fieldDecorator,
      this.validate,
      this.save,
      this.keyboardType})
      : super(key: key);
  @override
  _AccountTextFieldState createState() => _AccountTextFieldState();
}

class _AccountTextFieldState extends State<AccountTextField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: widget.validate,
      onSaved: widget.save,
      keyboardType: widget.keyboardType,
      decoration: widget.fieldDecorator,
    );
  }
}
