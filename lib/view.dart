import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'list.dart' as list;
import 'nonton.dart' as nonton;
import 'package:html_unescape/html_unescape.dart';

class View extends StatefulWidget {
  View({this.url, this.img, this.judul, this.durasi, this.rating});
  final String url, img, judul, durasi, rating;
  @override
  _ViewState createState() => _ViewState();
}

class _ViewState extends State<View> {
  bool isLoading1 = true;
  var unescape = new HtmlUnescape();
  Map<String, dynamic> data;

  Future<String> check() async {
    final response = await http.get("http://bstrd-official.club/api/film/view.php?url=${widget.url}");
    data = jsonDecode(response.body);
    if (this.mounted) {
    setState(() {
      isLoading1 = false;
    });
    }
    return "Sucesss";
    
  }

  @override
  void initState() {
    super.initState();
    check();
  }

  @override
  Widget build(BuildContext context) {
    return(
      Scaffold(
        body: isLoading1 ? Center(child: Container(color: Colors.black, height: MediaQuery.of(context).size.height, child:Image.asset("assets/images/loading.gif"))) : Container(
        width: MediaQuery.of(context).size.width,
        color: Colors.black,
        height: MediaQuery.of(context).size.height,
        child: ListView(
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height*1/3,
              width: MediaQuery.of(context).size.width,
              child:
              Stack (
                children: <Widget>[
                  Container(
                  height: MediaQuery.of(context).size.height*1/3,
                  width: MediaQuery.of(context).size.width,
                  child:
                    Image.network(widget.img, fit: BoxFit.fitWidth),
                  ),
                  data["tv"] == 1 ?  Container() : Container(
                    height: MediaQuery.of(context).size.height*1/3,
                    width: MediaQuery.of(context).size.width,
                    color: Colors.black.withOpacity(0.3),
                    child: FlatButton(
                      onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => nonton.Play(id: data["id"]))),
                      child: Icon(Icons.play_arrow, size: 100)
                    ),
                  ),
                ],
              )
            ),
            Container(
              padding: EdgeInsets.only(bottom: 30, left:10, right: 10, top:20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Text(widget.judul, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                  Divider(),
                  RichText(
                    textAlign: TextAlign.justify,
                    text: TextSpan(
                    text: unescape.convert(data["sinopsis"])),
                  ),
                ],
              )
            ),
            Container(
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.only(bottom: 30, left:10, right: 10),
            child:
            Column(
              children: <Widget>[
                Divider(color: Colors.white54),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text("Judul    "),
                    Text(":   "),
                    Container(
                    padding: EdgeInsets.only(right:10),
                    width: MediaQuery.of(context).size.width*3.8/5,
                    child:
                    RichText(
                      textAlign: TextAlign.justify,
                      text: TextSpan(
                        text: widget.judul, 
                    )))
                  ],
                ),
                Divider(color: Colors.white54),
                Row(
                  children: <Widget>[
                    Text("Durasi   "),
                    Text(":   "),
                    Text(data["durasi"])
                  ],
                ),
                Divider(color: Colors.white54),
                Row(
                  children: <Widget>[
                    Text("Rating   "),
                    Text(":   "),
                    Icon(Icons.star, color: Colors.yellow, size:12),
                    Text(" ${widget.rating}")
                  ],
                ),
                Divider(color: Colors.white54),
              ],
            ),
            ),

            data["tv"] == 1 ? Container(
              padding: EdgeInsets.only(bottom: 30, left:10, right: 10),
              child: 
              Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children : [
              Container(
                margin: EdgeInsets.only(bottom:20),
                child:
              Text("Episodes", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: episode(x: data["jml_episode"], data: data)
              )
              ]
            ))
            
            
            : Container(),

            Container(
              padding: EdgeInsets.only(bottom: 30, left:10, right: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text("Related Movies", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 200,
                    margin : EdgeInsets.only(top:20),
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: data["jmlrelated"],
                      itemBuilder: (context, index) {
                        return (list.FilmCard(rating: data["related"][index.toString()]["rating"], durasi: data["related"][index.toString()]["durasi"], url: data["related"][index.toString()]["url"], img: data["related"][index.toString()]["img"], judul: data["related"][index.toString()]["judul"]));
                      },
                    )
                  )
                ],
              ),
            )
          ],
        ),
      )
    )
    );
  }
}

List<Widget> episode({int x, Map<String, dynamic> data}) {
    List<Widget> list = List();
    for (int index = 0; index < x; index++) {
      list.add(
        Episode(img: data["episode"][index.toString()]["img"], judul: data["episode"][index.toString()]["judul"], id: data["episode"][index.toString()]["id"], sinopsis: data["episode"][index.toString()]["sinopsis"]),
      );//add any Widget in place of Text("Index $i")
    }
    return list;// all widget added now retrun the list here 
}

class Episode extends StatelessWidget {
  Episode({this.judul, this.sinopsis, this.id, this.img});
  final String img, judul, sinopsis, id;
  final unescape = new HtmlUnescape();
  @override
  Widget build(BuildContext context) {
    return(
      Stack(
      children: [
      Container(
        margin: EdgeInsets.only(bottom:10),
        width: MediaQuery.of(context).size.width,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.only(right: 10, top:8),
              child:
              Image.network(img, fit: BoxFit.cover),
            ),
            
            Container(
              width: MediaQuery.of(context).size.width-90,
            child:
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Divider(color: Colors.white54),
              
                Text("Judul      :    ${unescape.convert(judul)}", maxLines: 1),
                Divider(color: Colors.white54),
                Container(
                  width: MediaQuery.of(context).size.width,
                  child:
                  Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text("Sinopsis "),
                    Text(":   "),
                    Container(
                    width: MediaQuery.of(context).size.width-167,
                    child:
                    RichText(
                      textAlign: TextAlign.justify,
                      text: TextSpan(
                        text: unescape.convert(sinopsis), 
                    )))
                  ],
                ),
                ),
                
              ],
            )
            )
          ]
        ),
      ),

      Container(
        margin: EdgeInsets.only(bottom:10),
        width: MediaQuery.of(context).size.width,
        child: 
        FlatButton(
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => nonton.Play(id: id))),
            child: Container()
        ),

      ),
    ]
    )
  );
}
}