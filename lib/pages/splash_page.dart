
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SplashPage extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
                'assets/images/github.png'
            ),
            Text(
              'Github',
              style: Theme.of(context).textTheme.headline3,
            )
          ],
        ),
      ),
    );
  }
}