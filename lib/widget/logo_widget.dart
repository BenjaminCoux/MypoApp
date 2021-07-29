import 'package:flutter/material.dart';

/*
    -that class creates the logo in the middle
*/
class Logo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.25,
      decoration: BoxDecoration(
          color: Colors.grey.shade100,
          image: DecorationImage(image: AssetImage('assets/images/logo.png'))),
    );
  }
}

class LogoPremium extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ColorFiltered(
        colorFilter: ColorFilter.mode(
            Colors.grey.shade800.withOpacity(0), BlendMode.srcOver),
        child: Container(
          height: MediaQuery.of(context).size.height * 0.25,
          decoration: BoxDecoration(
              color: Colors.transparent,
              image: DecorationImage(
                  image: AssetImage('assets/images/logopremium.png'))),
        ));
  }
}
