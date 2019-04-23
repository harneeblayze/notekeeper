import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _scaffoldKey = new GlobalKey<ScaffoldState>();
  VoidCallback _showPersBottomSheetCallBack;
  bool removeaAddButton = false;
  TextEditingController _titleEditingController = new TextEditingController();
  TextEditingController _bodyEditingController = new TextEditingController();
  ScrollController _scrollController = new ScrollController();
  GlobalKey _titleKey = new GlobalKey();
  GlobalKey formKey = new GlobalKey<FormState>();
  GlobalKey _bodyKey = new GlobalKey();
  Map<String, dynamic> noteData;
  bool autoval = false;

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

  Future<void> addNote(noteData) async {
    Firestore.instance.collection('Note').add(noteData).catchError((e) {
      print(e);
    });
  }

//Button
  Widget _showButton() {
    return ButtonTheme(
      minWidth: 200,
      height: 50,
      child: new RaisedButton(
        shape: new RoundedRectangleBorder(
          borderRadius: new BorderRadius.circular(30.0),
        ),
        child: const Text('Stack Note',
            style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Colors.white)),
        color: Theme.of(context).accentColor,
        elevation: 4.0,
        splashColor: Colors.blueGrey,
        onPressed: () {
          setState(() {
            autoval = true;
          });
          print('>>>>>>>>>>>>>>>>>>>>>>' + _titleEditingController.text);
          //Navigator.pop(context);
          //Navigator.of(context).pop();
          noteData = {
            'title': _titleEditingController.text,
            'body': _bodyEditingController.text
          };

          final form = formKey.currentState;
          //data['productRef']

          addNote(noteData).then((result) {
            if (noteData['title'] != null &&
                noteData['title'] != "" &&
                noteData['body'] != null) {
              _titleEditingController.clear();
              _bodyEditingController.clear();

              setState(() {
                autoval = true;
              });
            } else {
              setState(() {
                autoval = false;
              });
              return;
            }
          });
          // Perform some action
        },
      ),
    );
  }

  void moveToSpecifiedPosition(GlobalKey key) {
    final RenderBox renderBox = key.currentContext.findRenderObject();
    final positionRed = renderBox.localToGlobal(Offset(0, 20));
    _scrollController.animateTo(positionRed.dy,
        duration: Duration(milliseconds: 300), curve: Curves.easeIn);
  }

  Widget _buildInputField(
      TextEditingController controller,
      //FocusNode _focusNode,
      Key key,
      String hintText,
      String errorText,
      int maxLines,
      double hintSize) {
    return Container(
      margin:
          const EdgeInsets.only(top: 8.5, left: 34.0, right: 33.0, bottom: 8),
      child: new Theme(
          data: new ThemeData(
              fontFamily: 'Montserrat',
              errorColor: const Color(0xFFFFB822),
              hintColor: Colors.grey.shade400),
          child: Container(
            //constraints: BoxConstraints.expand(),
            key: key,
            child: new TextFormField(
              controller: controller,
              maxLines: maxLines,
              keyboardType: TextInputType.text,
              decoration: new InputDecoration(
                hintText: hintText,
                hintStyle: new TextStyle(fontSize: 12.0, color: Colors.white),
                border: new OutlineInputBorder(
                  borderRadius: new BorderRadius.circular(4.0),
                  borderSide:
                      new BorderSide(width: 0.1, color: Colors.grey.shade100),
                ),
                contentPadding:
                    const EdgeInsets.only(top: 13.0, bottom: 13.0, left: 8.0),
              ),
              style: TextStyle(color: Colors.white),
              autovalidate: autoval,
              validator: (val) {
                if (val.isEmpty) {
                  moveToSpecifiedPosition(key);

                  return errorText;
                } else {
                  return null;
                }
              },
              autofocus: true,
            ),
          )),
    );
  }

  void _showConfirmQrBottomSheet() {
    setState(() {
      _showPersBottomSheetCallBack = null;
      removeaAddButton = true;
    });

    _scaffoldKey.currentState
        .showBottomSheet((context) {
          Size screenSize = MediaQuery.of(context).size;
          return new Container(
            height: screenSize.height / 1.4,
            decoration: BoxDecoration(
                color: Color(0xff36454f),
                borderRadius: new BorderRadius.only(
                    topLeft: new Radius.circular(11.0),
                    topRight: new Radius.circular(11.0))),
            child: Form(
              key: formKey,
              child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Center(child: _pullDownTray(screenSize)),
                    Padding(
                      padding: const EdgeInsets.only(left: 34.0),
                      child: _textItem(context, 12, Colors.white, "Title", 18,
                          FontWeight.normal),
                    ),
                    _buildInputField(_titleEditingController, _titleKey,
                        'Enter a Title', 'Title cannot be Blank', 1, 12.0),
                    Padding(
                      padding: const EdgeInsets.only(left: 34.0),
                      child: _textItem(context, 12, Colors.white,
                          "Note Content", 18, FontWeight.normal),
                    ),
                    Flexible(
                      child: _buildInputField(
                          _bodyEditingController,
                          _bodyKey,
                          'Type the Note content..',
                          'please write a note',
                          12,
                          12.0),
                    ),

                    //_formField(
                    //  10.0, 15.0, 1.0, 'Type a Note', 14.0, _bodyEditingController),
                    //Flexible(child: _showBarcodeImage('images/qr_scan.png')),
                    Flexible(child: Center(child: _showButton()))
                  ]),
            ),
          );
        })
        .closed
        .whenComplete(() {
          if (mounted) {
            setState(() {
              _showPersBottomSheetCallBack = _showConfirmQrBottomSheet;
              removeaAddButton = false;
            });
          }
        });
  }

  Widget _buildItem(context, DocumentSnapshot document) {
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 6),
      elevation: 5.0,
      child: new Container(
          margin: const EdgeInsets.only(left: 10.0),
          padding: const EdgeInsets.only(top: 9.5, bottom: 0.0),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: _textItem(context, 16.4, Color(0xff36454f),
                      document['title'], 5, FontWeight.bold),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: _textItem(
                      context,
                      14,
                      Color(0xff36454f),
                      document['body'].length < 30
                          ? document['body']
                          : '${document['body'].substring(0, 30)}...',
                      4,
                      FontWeight.w300),
                ),
              ])),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(canvasColor: Colors.transparent),
      home: Scaffold(
        //resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        key: _scaffoldKey,
        appBar: AppBar(
          //backgroundColor: Color(0xff36454f),
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Text('Note Keeper'),
        ),
        body: StreamBuilder(
            stream: Firestore.instance.collection('Note').snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) return const Text("...Loading");
              return ListView.builder(
                  itemCount: snapshot.data.documents.length,
                  itemBuilder: (context, index) => _buildItem(
                      context,
                      snapshot.data.documents[
                          snapshot.data.documents.length - (index + 1)])
                  /*NoteItem(snapshot.data.documents[index])*/);
            }),
        floatingActionButton: removeaAddButton
            ? Container()
            : FloatingActionButton(
                onPressed: _showPersBottomSheetCallBack,
                tooltip: 'Add Note',
                child: Icon(Icons.add),
              ), // This trailing comma makes auto-formatting nicer for build methods.
      ),
    );
  }
}
