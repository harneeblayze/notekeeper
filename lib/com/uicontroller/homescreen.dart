import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MyHomePage extends StatelessWidget {
  Container _textItem(BuildContext context, double textsize, Color color,
      String content, double marginTop, FontWeight fontweight) {
    return Container(
      margin: EdgeInsets.only(
        top: marginTop,
      ),
      child: Text(
        content,
        style: TextStyle(
          fontSize: textsize,
          color: color,
          fontWeight: fontweight,
        ),
      ),
    );
  }

  Widget _buildItem(context, DocumentSnapshot document) {
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 6),
      elevation: 2.0,
      child: new Container(
          margin: const EdgeInsets.only(left: 10.0),
          padding: const EdgeInsets.only(top: 9.5, bottom: 0.0),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                _textItem(context, 16.4, Colors.black, document['title'], 5,
                    FontWeight.bold),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: _textItem(
                      context,
                      14,
                      Colors.grey,
                      document['body'].length < 30
                          ? document['body']
                          : '${document['body'].substring(0, 30)}...',
                      4,
                      FontWeight.w300),
                ),
                /*RichText(
                  text: TextSpan(
                    text: document['title'],
                    style: new TextStyle(
                      fontSize: 16.4,
                      fontWeight: FontWeight.bold,
                      fontFamily: "Montserrat",
                      color: const Color(0xFF5F138D),
                    ),
                  ),
                ),
                Flexible(
                  child: Text(
                    document['body'],
                    */ /*document['body'].length < 50
                              ? document['body']
                              : '${document['body'].substring(0, 50)}...',*/ /*
                    style: TextStyle(
                        fontSize: 14.0,
                        color: const Color(0xFF393431),
                        fontWeight: FontWeight.w300,
                        fontFamily: "Montserrat"),
                  ),
                ),*/
              ])),
    );
  }

  void _showMyBottomSheet(BuildContext context) {
    // the context of the bottomSheet will be this widget
    //the context here is where you want to showthe bottom sheet
    showBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return AddNote(); // returns your BottomSheet widget
        });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Text('chai'),
        ),
        body: StreamBuilder(
            stream: Firestore.instance.collection('Note').snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) return const Text("...Loading");
              return ListView.builder(
                  itemCount: snapshot.data.documents.length,
                  itemBuilder: (context, index) =>
                      _buildItem(context, snapshot.data.documents[index])
                  /*NoteItem(snapshot.data.documents[index])*/);
            }),
        /*Center(
          // Center is a layout widget. It takes a single child and positions it
          // in the middle of the parent.
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'You have pushed the button this many times:',
              ),
              Text(
                'ball',
                style: Theme.of(context).textTheme.display1,
              ),
            ],
          ),
        ),*/
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _showMyBottomSheet(context);
          },
          tooltip: 'Increment',
          child: Icon(Icons.add),
        ), // This trailing comma makes auto-formatting nicer for build methods.
      ),
    );
  }
}

class AddNote extends StatefulWidget {
  @override
  _AddNoteState createState() => _AddNoteState();
}

class _AddNoteState extends State<AddNote> {
  final _scaffoldKey = new GlobalKey<ScaffoldState>();
  VoidCallback _showPersBottomSheetCallBack;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _showPersBottomSheetCallBack = _showConfirmQrBottomSheet;
  }

  Container _pullDownTray(Size screenSize) {
    return Container(
      width: screenSize.width / 4,
      height: 5.0,
      color: const Color(0xffefefef),
      margin: EdgeInsets.only(top: 16.0),
    );
  }

//text item method for text on bottom sheet
  Container _textItem(BuildContext context, double textsize, Color color,
      String content, double marginTop, FontWeight fontweight) {
    return Container(
      margin: EdgeInsets.only(
        top: marginTop,
      ),
      child: Center(
          child: Text(
        content,
        style: TextStyle(
          fontSize: textsize,
          color: color,
          fontWeight: fontweight,
        ),
      )),
    );
  }

//Button
  Widget _showButton(String buttonText) {
    return FlatButton(
        onPressed: null,
        child: Container(
          decoration: BoxDecoration(
              color: Colors.green,
              borderRadius: BorderRadius.all(Radius.circular(3.0))),
          margin: const EdgeInsets.only(top: 11),
          width: MediaQuery.of(context).size.width / 1.2,
          height: 56,
          //color: Colors.green,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Container(
                  margin: const EdgeInsets.only(
                    left: 18,
                  ),
                  child: _textItem(context, 16, Colors.white, buttonText, 2,
                      FontWeight.w400)),
              Container(
                margin: const EdgeInsets.only(right: 15),
                child: ClipOval(
                  child: Container(
                    //margin: const EdgeInsets.only(right: 15),
                    height: 26,
                    width: 26,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.white, width: 1.0)),
                    child: IconButton(
                        padding: const EdgeInsets.only(
                          top: 0.5,
                          left: 1.0,
                        ),
                        icon: Icon(
                          Icons.chevron_right,
                          color: Colors.white,
                          size: 20,
                        ),
                        onPressed: null),
                  ),
                ),
              )
            ],
          ),
        ));
  }

  void _showConfirmQrBottomSheet() {
    setState(() {
      _showPersBottomSheetCallBack = null;
    });

    _scaffoldKey.currentState
        .showBottomSheet((context) {
          Size screenSize = MediaQuery.of(context).size;
          return new Container(
            height: screenSize.height / 1.2,
            decoration: BoxDecoration(
                color: const Color(0xffffffff),
                borderRadius: new BorderRadius.only(
                    topLeft: new Radius.circular(11.0),
                    topRight: new Radius.circular(11.0))),
            child: Column(mainAxisSize: MainAxisSize.max, children: <Widget>[
              _pullDownTray(screenSize),
              _textItem(context, 20, Color(0xff4a4a4a), "Confirm QRcode", 22,
                  FontWeight.normal),
              _textItem(context, 14, Color(0xff9f9f9f),
                  "Seller should scan to confirm", 6, FontWeight.w500),
              //Flexible(child: _showBarcodeImage('images/qr_scan.png')),
              _textItem(context, 24, Color(0xff0d4811), '₦20000', 34,
                  FontWeight.w700),
              _showButton("Close")
            ]),
          );
        })
        .closed
        .whenComplete(() {
          if (mounted) {
            setState(() {
              _showPersBottomSheetCallBack = _showConfirmQrBottomSheet;
            });
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Container(
        child: new Container(
      height: screenSize.height / 1.2,
      decoration: BoxDecoration(
          color: const Color(0xffffffff),
          borderRadius: new BorderRadius.only(
              topLeft: new Radius.circular(11.0),
              topRight: new Radius.circular(11.0))),
      child: Column(mainAxisSize: MainAxisSize.max, children: <Widget>[
        _pullDownTray(screenSize),
        _textItem(context, 20, Color(0xff4a4a4a), "Confirm QRcode", 22,
            FontWeight.normal),
        _textItem(context, 14, Color(0xff9f9f9f),
            "Seller should scan to confirm", 6, FontWeight.w500),
        //Flexible(child: _showBarcodeImage('images/qr_scan.png')),
        _textItem(
            context, 24, Color(0xff0d4811), '₦20000', 34, FontWeight.w700),
        _showButton("Close")
      ]),
    ));
    /*floatingActionButton: FloatingActionButton(
        onPressed: _showPersBottomSheetCallBack,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),*/
  }
}
