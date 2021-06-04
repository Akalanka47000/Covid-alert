import 'package:flutter/material.dart';

class MessageTile extends StatelessWidget {
  final Color bgColor;
  final String message;
  final String name;
  final bool sendByMe;
  final String date;

  final bool read;

  MessageTile({@required this.message, @required this.name, @required this.sendByMe, this.date, this.read, this.bgColor});
  getReadIcon(bool read) {
    if (read == false) {
      return Icon(
        Icons.check,
        color: Colors.black45,
        size: 20,
      );
    } else {
      return Icon(
        Icons.check,
        color: Colors.redAccent,
        size: 20,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          color: bgColor,
          padding: EdgeInsets.only(top: 18, bottom: 18, left: sendByMe ? 0 : 18, right: sendByMe ? 18 : 0),
          alignment: sendByMe ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
              margin: sendByMe ? EdgeInsets.only(left: 18) : EdgeInsets.only(right: 18),
              padding: EdgeInsets.only(top: 15, bottom: 15, left: 20, right: 20),
              decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: sendByMe ? Colors.redAccent.withOpacity(0.8) : Colors.black38,
                      blurRadius: 1.0,
                      spreadRadius: 0.0,
                      offset: Offset(
                        0.0,
                        0.0,
                      ),
                    ),
                    BoxShadow(
                      color: sendByMe ? Colors.redAccent.withOpacity(0.2) : Colors.black38,
                      blurRadius: 6.0,
                      spreadRadius: 0.0,
                      offset: Offset(
                        0.0,
                        0.0,
                      ),
                    ),
                  ],
                  borderRadius: sendByMe
                      ? BorderRadius.only(topLeft: Radius.circular(23), topRight: Radius.circular(23), bottomLeft: Radius.circular(23))
                      : BorderRadius.only(topLeft: Radius.circular(23), topRight: Radius.circular(23), bottomRight: Radius.circular(23)),
                  color: sendByMe ? Colors.redAccent.withOpacity(0.2) : Colors.black38),
              child: Column(
                crossAxisAlignment: sendByMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: [
                  sendByMe
                      ? Padding(
                          padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                          child: Text(
                            "You",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                color: Colors.black.withOpacity(0.7),
                                fontSize: 12,
                                //fontFamily: 'OverpassRegular',
                                fontWeight: FontWeight.w300),
                          ),
                        )
                      : Padding(
                          padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                          child: Text(
                            name,
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                color: Colors.redAccent.withOpacity(0.7),
                                fontSize: 12,
                                //fontFamily: 'OverpassRegular',
                                fontWeight: FontWeight.w300),
                          ),
                        ),
                  Text(
                    message,
                    textAlign: TextAlign.start,
                    style: sendByMe
                        ? TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            //fontFamily: 'OverpassRegular',
                            fontWeight: FontWeight.w300)
                        : TextStyle(
                            color: Colors.white70,
                            fontSize: 16,
                            //fontFamily: 'OverpassRegular',
                            fontWeight: FontWeight.w300),
                  ),
                ],
              )),
        ),
        sendByMe
            ? Align(
                alignment: Alignment.centerRight,
                child: Container(
                    color: bgColor,
                    padding: EdgeInsets.only(
                        top: 0,
                        bottom: 0,
                        //left: sendByMe ? 0 : 24,
                        right: 15),
                    //color: Colors.blue,
                    margin: sendByMe ? EdgeInsets.only(left: 30) : EdgeInsets.only(right: 30),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          date,
                          // textAlign: sendByMe ? TextAlign.right : TextAlign.right,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        getReadIcon(read),
                      ],
                    )),
              )
            : Align(
                alignment: Alignment.centerLeft,
                child: Container(
                    color: bgColor,
                    padding: EdgeInsets.only(
                      top: 0,
                      bottom: 0,
                      left: 17,
                    ),
                    //right: 15),
                    //color: Colors.blue,
                    margin: sendByMe ? EdgeInsets.only(left: 30) : EdgeInsets.only(right: 30),
                    child: Text(
                      date,
                      // textAlign: sendByMe ? TextAlign.right : TextAlign.right,
                    )),
              ),
        Container(
          height: MediaQuery.of(context).size.height*0.02,
        ),
      ],

    );
  }
}
