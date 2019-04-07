import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:notekeeper/com/model.dart';

class NoteItem extends StatelessWidget {
  Note _noteModel;
  String _title, _body;
  DocumentSnapshot document;
  NoteItem(this.document);
  @override
  Widget build(BuildContext context) {
    return Card(
        color: Colors.blueGrey,
        margin: const EdgeInsets.symmetric(horizontal: 6.0),
        elevation: 2.0,
        child: Container(
            child: new Container(
                margin: const EdgeInsets.only(left: 10.0),
                padding: const EdgeInsets.only(top: 9.5, bottom: 0.0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      RichText(
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
                          /*document['body'].length < 50
                              ? document['body']
                              : '${document['body'].substring(0, 50)}...',*/
                          style: TextStyle(
                              fontSize: 14.0,
                              color: const Color(0xFF393431),
                              fontWeight: FontWeight.w300,
                              fontFamily: "Montserrat"),
                        ),
                      ),
                    ]))));
  }
}
