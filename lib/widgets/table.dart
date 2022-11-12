import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {

  final String label;
  final String value;

  const MyTextField({Key? key, required this.label, required this.value}) : super(key: key);



  @override
  Widget build(BuildContext context) {

    TextStyle textStyle = const TextStyle(
        fontSize: 20
    );

    return Container(
      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
      child: Card(
        margin: EdgeInsets.all(8),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label,
              style: textStyle,),
              Text(value,
              style: textStyle,),
            ],
          ),
        ),
      ),
    );
  }
}
