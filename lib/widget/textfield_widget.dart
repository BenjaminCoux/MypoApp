import 'package:flutter/material.dart';
import 'package:mypo/pages/home_page.dart';

class TextFieldWidget extends StatefulWidget {
  final int maxLines;
  final String label;
  final String text;
  final String hint;
  final ValueChanged<String> onChanged;

  const TextFieldWidget({
    Key? key,
    this.maxLines = 1,
    required this.hint,
    required this.label,
    required this.text,
    required this.onChanged,
  }) : super(key: key);

  @override
  _TextFieldWidgetState createState() => _TextFieldWidgetState();
}

class _TextFieldWidgetState extends State<TextFieldWidget> {
  late final controller = TextEditingController(text: widget.text);

  @override
  // ignore: override_on_non_overriding_member
  void initSate() {
    super.initState();
  }

  initState();
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Container(
        padding: EdgeInsets.symmetric(horizontal: 48),
        child: Column(
          //crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.label,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
            ),
            const SizedBox(
              height: 8,
            ),
            TextField(
              controller: controller,
              onSubmitted: widget.onChanged,
              maxLines: widget.maxLines,
              decoration: InputDecoration(
                hintText: widget.hint,
                labelStyle: TextStyle(color: Colors.black),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: d_green)),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: d_darkgray)),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: d_darkgray)),
              ),
            ),
          ],
        ),
      );
}

/*

- This widget is used in prog page
*/
class textFieldWidget extends StatefulWidget {
  final String labelText;
  final String hintText;
  final TextEditingController controller;
  final TextInputType typeOfInputText;

  const textFieldWidget({
    Key? key,
    required this.labelText,
    required this.hintText,
    required this.controller,
    required this.typeOfInputText,
  }) : super(key: key);

  @override
  _textFieldWidgetState createState() => _textFieldWidgetState();
}

class _textFieldWidgetState extends State<textFieldWidget> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      onSubmitted: (value) => widget.controller.text = value,
      keyboardType: widget.typeOfInputText,
      controller: widget.controller,
      decoration: InputDecoration(
        labelText: widget.labelText,
        labelStyle: TextStyle(color: Colors.black),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.transparent)),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.transparent)),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.transparent)),
        hintText: widget.hintText,
        hintStyle: TextStyle(
          fontSize: 16,
          fontStyle: FontStyle.italic,
          fontWeight: FontWeight.w300,
          color: Colors.black,
        ),
      ),
    );
  }
}
