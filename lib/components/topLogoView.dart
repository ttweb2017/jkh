import 'package:flutter/material.dart';

class TopImage extends StatelessWidget {
  final String title;
  //final DecorationImage backgroundImage;
  final String backgroundImage;
  final Animation<double> containerGrowAnimation;

  final String TAG = 'logo';

  TopImage({this.title, this.backgroundImage, this.containerGrowAnimation});

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;

    return SizedBox(
      width: screenSize.width,
      child: Hero(
          tag: TAG,
          child: Container(
            //width: screenSize.width,
            height: 300,
            decoration: BoxDecoration(
                color: Color.fromRGBO(53, 102, 54, 1)
            ),
            child: Stack(
              alignment: Alignment.center,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(top: 5.0, right: 5.0, bottom: 25.0, left: 5.0),
                  alignment: Alignment.center,
                  child: Image.asset(
                    backgroundImage,
                    height: 300,
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(top: 5.0, right: 5.0, bottom: 15.0, left: 5.0),
                  alignment: Alignment.bottomCenter,
                  child: Text(
                    title,
                    style: TextStyle(color: Colors.white, fontSize: 25.0),
                  ),
                ),
              ],
            ),
          )
      ),
    );
  }
}