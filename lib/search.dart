import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:html_unescape/html_unescape.dart';
import 'view.dart' as detail;

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  final querycon = TextEditingController();
  int jumlah;
  String query;
  bool awal = true;
  bool isLoadings = true;
  Map<String, dynamic> data;

  void search(String value) {
    setState(() {
      awal = false;
      isLoadings = true;
      check();
    });
  }

  Future<String> check() async {
    query = querycon.text;
    String queries = query.replaceAll(' ', "%20").toString();
    print(queries);
    final response = await http.get("http://bstrd-official.club/api/film/search.php?query=${Uri.encodeFull(queries)}");
    data = jsonDecode(response.body);
    jumlah = data["jml"];
    if (this.mounted) {
    setState(() {
      isLoadings = false;
    });
    }
    return "Sucesss";
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body:
      Container(
        color: Colors.black,
        padding: EdgeInsets.only(right:20, top:40, left:20),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child:
        Column(
        children : [
          Container(padding: EdgeInsets.only(bottom:20), child: TextFormField(onFieldSubmitted: search, controller: querycon, keyboardType: TextInputType.url, style: new TextStyle(fontSize: 15, color: Colors.white), decoration: new InputDecoration(contentPadding: new EdgeInsets.symmetric(vertical: 10, horizontal: 20), hintText: "eg: Starwars, The Happening, etc.", hintStyle: TextStyle(color: Colors.white60, fontSize: 15), filled: true, fillColor: Colors.white30, enabledBorder: UnderlineInputBorder(borderRadius: BorderRadius.circular(50), borderSide: BorderSide(color: Colors.transparent)), focusedBorder: UnderlineInputBorder(borderRadius: BorderRadius.circular(50), borderSide: BorderSide(color: Colors.transparent))))),
          Expanded(
          child:
          awal ? Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center, children: [ Image.asset("assets/images/wrong_pass.png", height:200), Text("\n\nNothing to show here try to start searching", style: TextStyle(color: Colors.white70),) ]) : 
          isLoadings ? Center(child: Container(height: MediaQuery.of(context).size.height, child:Image.asset("assets/images/loading.gif"))) : 
          ListView.builder(
              //scrollDirection: Axis.horizontal,
              itemCount: data["jml"],
              itemBuilder: (context, index) {
                return(
                  FilmCard(rating: data[index.toString()]["rating"], durasi: data[index.toString()]["durasi"], url: data[index.toString()]["url"], img: data[index.toString()]["img"], judul: data[index.toString()]["judul"])  
                );
              },
            )
          )] 
        ),
      ),
    );
  }
}

class FilmCard extends StatelessWidget {
  FilmCard({this.img, this.judul, this.url, this.durasi, this.rating});
  final String img, url, durasi, rating;
  final String judul;
  final unescape = new HtmlUnescape();
  @override
  Widget build(BuildContext context) {
    return(
      Container(
      child:  
        Stack(
          children: [
          Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          Container(
            width: 136,
            height: 228,
            child: Image.network(img),
          ),
          Container(
            padding: EdgeInsets.only(left:10),
            width: MediaQuery.of(context).size.width-184,
            child:
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Divider(color: Colors.white54),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text("Judul    "),
                    Text(":   "),
                    Container(
                    width: MediaQuery.of(context).size.width-267,
                    child:
                    RichText(
                      textAlign: TextAlign.justify,
                      text: TextSpan(
                        text: unescape.convert(judul), 
                    )))
                  ],
                ),
              Divider(color: Colors.white54),
                Row(
                  children: <Widget>[
                    Text("Durasi   "),
                    Text(":   "),
                    Text(durasi)
                  ],
                ),
             Divider(color: Colors.white54),
                Row(
                  children: <Widget>[
                    Text("Rating   "),
                    Text(":   "),
                    Icon(Icons.star, color: Colors.yellow, size:12),
                    Text(" $rating")
                  ],
                ),
                Divider(color: Colors.white54)
              ]
            ),
          )
          ]),
          Container(
            width: 136,
            height: 228,
            child: FlatButton(
              onPressed: () =>
              Navigator.push(context, MaterialPageRoute(builder: (context) => detail.View(rating: rating, durasi: durasi, url: url, judul: judul, img: img))),
              child: null,
            ),
          )
        ]
      )
    )
  );
}
}