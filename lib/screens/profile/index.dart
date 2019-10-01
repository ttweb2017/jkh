import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:halkbank_app/constants.dart';
import 'package:halkbank_app/screens/home/index.dart';
import 'package:halkbank_app/util/user.dart';

class ProfileScreen extends StatefulWidget {

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String _name = '';
  String _street  = '';
  String _house  = '';
  String _flat  = '';
  String _xmlId  = '';

  _getUserData() async {
    // obtain shared preferences
    Map<String, String> data = await UserUtil.getUserData();

    setState(() {
      _name = data[UserUtil.FULL_NAME];
      _street = data[UserUtil.STREET];
      _house = data[UserUtil.HOUSE];
      _flat = data[UserUtil.FLAT];
      _xmlId = data[UserUtil.XML_ID];
    });
  }

  @override
  void initState() {
    _getUserData();

    super.initState();
  }

  @override
  void dispose() {

    super.dispose();
  }

  Future<bool> _onWillPop(){
    return showDialog(
        context: context,
        builder: (context) => HomeScreen()
    ) ?? false;
  }

  @override
  Widget build(BuildContext context) {
    Size sSize = MediaQuery.of(context).size;
    double firstHeadContainerWidth = (sSize.width / 2 - 45.0);
    double thirdHeadContainerWidth = (sSize.width / 2 + 15.0);

    return CupertinoPageScaffold(
      child: Scaffold(
        body: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              backgroundColor: Colors.green[800],
              floating: true,
              pinned: true,
              expandedHeight: 300,
              flexibleSpace: FlexibleSpaceBar(
                  title: Text(_name, style: TextStyle(fontSize: 15.0)),
                  background: Image.asset(Constants.LOGO_PATH)
              ),
            ),
            SliverList(
              delegate: SliverChildListDelegate([
                Container(
                  margin: const EdgeInsets.only(top: 30.0, right: 15.0, bottom: 5.0, left: 15.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            width: firstHeadContainerWidth,
                            child: Text(
                                "H/h",
                                textAlign: TextAlign.start,
                                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold, color: Colors.green[800])
                            ),
                          ),
                          Container(
                            width: thirdHeadContainerWidth,
                            child: Text(_xmlId, textAlign: TextAlign.end, style: TextStyle(fontSize: 14.0, fontStyle: FontStyle.italic, color: Colors.grey[700])),
                          )
                        ],
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 2.0, bottom: 10.0),
                        height: 1,
                        decoration: BoxDecoration(
                            color: Colors.grey[400]
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            width: firstHeadContainerWidth,
                            child: Text(
                                "Köçe",
                                textAlign: TextAlign.start,
                                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold, color: Colors.green[800])
                            ),
                          ),
                          Container(
                            width: thirdHeadContainerWidth,
                            child: Text(_street, textAlign: TextAlign.end, style: TextStyle(fontSize: 14.0, fontStyle: FontStyle.italic, color: Colors.grey[700])),
                          ),
                        ],
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 2.0, bottom: 10.0),
                        height: 1,
                        decoration: BoxDecoration(
                            color: Colors.grey[400]
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            width: firstHeadContainerWidth,
                            child: Text(
                                "Jaý",
                                textAlign: TextAlign.start,
                                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold, color: Colors.green[800])
                            ),
                          ),
                          Container(
                            width: thirdHeadContainerWidth,
                            child: Text(_house, textAlign: TextAlign.end, style: TextStyle(fontSize: 14.0, fontStyle: FontStyle.italic, color: Colors.grey[700])),
                          ),
                        ],
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 2.0, bottom: 10.0),
                        height: 1,
                        decoration: BoxDecoration(
                            color: Colors.grey[400]
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            width: firstHeadContainerWidth,
                            child: Text(
                                "Öý",
                                textAlign: TextAlign.start,
                                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold, color: Colors.green[800])
                            ),
                          ),
                          Container(
                            width: thirdHeadContainerWidth,
                            child: Text(_flat, textAlign: TextAlign.end, style: TextStyle(fontSize: 14.0, fontStyle: FontStyle.italic, color: Colors.grey[700])),
                          ),
                        ],
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 2.0, bottom: 10.0),
                        height: 1,
                        decoration: BoxDecoration(
                            color: Colors.grey[400]
                        ),
                      )
                    ],
                  ),
                )
              ]),
            )
          ],
        ),
      ),
    );
  }
  /*@override
  Widget build(BuildContext context) {
    Size sSize = MediaQuery.of(context).size;
    double firstHeadContainerWidth = (sSize.width / 2 - 45.0);
    double thirdHeadContainerWidth = (sSize.width / 2 + 15.0);

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        body: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              backgroundColor: Colors.green[800],
              floating: true,
              pinned: true,
              expandedHeight: 300,
              flexibleSpace: FlexibleSpaceBar(
                  title: Text(_name, style: TextStyle(fontSize: 15.0)),
                  background: Image.asset(Constants.LOGO_PATH)
              ),
            ),
            SliverList(
              delegate: SliverChildListDelegate([
                Container(
                  margin: const EdgeInsets.only(top: 30.0, right: 15.0, bottom: 5.0, left: 15.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            width: firstHeadContainerWidth,
                            child: Text(
                                "H/h",
                                textAlign: TextAlign.start,
                                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold, color: Colors.green[800])
                            ),
                          ),
                          Container(
                            width: thirdHeadContainerWidth,
                            child: Text(_xmlId, textAlign: TextAlign.end, style: TextStyle(fontSize: 14.0, fontStyle: FontStyle.italic, color: Colors.grey[700])),
                          )
                        ],
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 2.0, bottom: 10.0),
                        height: 1,
                        decoration: BoxDecoration(
                            color: Colors.grey[400]
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            width: firstHeadContainerWidth,
                            child: Text(
                                "Köçe",
                                textAlign: TextAlign.start,
                                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold, color: Colors.green[800])
                            ),
                          ),
                          Container(
                            width: thirdHeadContainerWidth,
                            child: Text(_street, textAlign: TextAlign.end, style: TextStyle(fontSize: 14.0, fontStyle: FontStyle.italic, color: Colors.grey[700])),
                          ),
                        ],
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 2.0, bottom: 10.0),
                        height: 1,
                        decoration: BoxDecoration(
                            color: Colors.grey[400]
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            width: firstHeadContainerWidth,
                            child: Text(
                                "Jaý",
                                textAlign: TextAlign.start,
                                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold, color: Colors.green[800])
                            ),
                          ),
                          Container(
                            width: thirdHeadContainerWidth,
                            child: Text(_house, textAlign: TextAlign.end, style: TextStyle(fontSize: 14.0, fontStyle: FontStyle.italic, color: Colors.grey[700])),
                          ),
                        ],
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 2.0, bottom: 10.0),
                        height: 1,
                        decoration: BoxDecoration(
                            color: Colors.grey[400]
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            width: firstHeadContainerWidth,
                            child: Text(
                                "Öý",
                                textAlign: TextAlign.start,
                                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold, color: Colors.green[800])
                            ),
                          ),
                          Container(
                            width: thirdHeadContainerWidth,
                            child: Text(_flat, textAlign: TextAlign.end, style: TextStyle(fontSize: 14.0, fontStyle: FontStyle.italic, color: Colors.grey[700])),
                          ),
                        ],
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 2.0, bottom: 10.0),
                        height: 1,
                        decoration: BoxDecoration(
                            color: Colors.grey[400]
                        ),
                      )
                    ],
                  ),
                )
              ]),
            )
          ],
        ),
      )
    );
  }*/
}