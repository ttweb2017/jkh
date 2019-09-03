import 'package:flutter/material.dart';

class DashboardCard extends StatelessWidget {
  final Icon icon;
  final String title;
  final String description;
  final double marginRight;
  final Offset offset;
  final String route;

  DashboardCard({this.icon, this.title, this.description, this.marginRight, this.offset, this.route});

  void _cardViewTapped(BuildContext context) {
    Navigator.pushReplacementNamed(context, route);
  }

  @override
  Widget build(BuildContext context) {

    return SizedBox(
      width: 160,
      height: 200,
        child: Material(
          child: InkWell(
            onTap: () {
              _cardViewTapped(context);
            },
            splashColor: Colors.grey,
            child: Container(
              decoration: BoxDecoration(
                  boxShadow: [BoxShadow(color: Colors.grey[400], offset: offset, blurRadius: 3.0)],
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(3.0)
              ),
              padding: const EdgeInsets.only(top: 10.0, right: 5.0, bottom: 5.0, left: 5.0),
              margin: EdgeInsets.only(right: marginRight),
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      color: Colors.green[800],
                      shape: BoxShape.circle,
                    ),
                    child: icon,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15.0),
                    child: Text(
                        title,
                        textAlign: TextAlign.center,
                        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey[600])
                    ),
                  ),
                  Container(
                    height: 1,
                    decoration: BoxDecoration(
                        color: Colors.grey[400]
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Text(
                        description,
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey[600], fontSize: 10.0)
                    ),
                  ),
                ],
              ),
            ),
          ),
        )
    );
  }
}