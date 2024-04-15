
import 'package:flutter/material.dart';

class LinearLoadingWidget extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return LinearProgressIndicator(
        color: Theme.of(context).colorScheme.secondary,
      );
  }

}