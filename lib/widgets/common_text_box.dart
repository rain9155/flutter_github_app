
import 'package:flutter/material.dart';

class CommonTextBox extends StatelessWidget{

  const CommonTextBox(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(5, 1, 5, 1),
      decoration: BoxDecoration(
          border: Border.all(
              color: Theme.of(context).disabledColor,
              width: 0.35
          ),
          color: Colors.grey.withOpacity(0.12),
          borderRadius: BorderRadius.circular(5)
      ),
      child: Text(
        text,
        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
            color: Theme.of(context).disabledColor
        ),
      ),
    );
  }
}