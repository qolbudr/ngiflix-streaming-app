import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'list.dart' as list;
import 'search.dart' as cari;

void main(){
  runApp(
    new MaterialApp(
    home: new Splash(),
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      brightness: Brightness.dark,
      primaryColor: Colors.black,
      backgroundColor: Colors.black
    )
  ));
} 

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => new _SplashState();
}

class _SplashState extends State<Splash> {
  startTime() async {
    var _duration = new Duration(seconds: 3);
    return new Timer(_duration, gass);
  }

  void gass() {
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) {
      return Home();
    }));
    //Navigator.push(context, MaterialPageRoute(builder: (context) => Login()));
  }

  @override
  void initState() {
    super.initState();
    startTime();
    SystemChrome.setEnabledSystemUIOverlays ([SystemUiOverlay.top]);
  }

  @override
dispose(){
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  SystemChrome.setEnabledSystemUIOverlays ([SystemUiOverlay.top, SystemUiOverlay.bottom]);
  super.dispose();
}

  @override
  Widget build(BuildContext context) {
    return(
      new Scaffold(
        backgroundColor: Colors.black,
        body: new Center(
          child: new Image.asset("assets/images/ngiflix.png", width: 100)
        ),  
      )
    );
  }
}

class Home extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<Home> {
  int jumlah;
  bool isLoading = true;
  Map<String, dynamic> data;

  Future<String> check() async {
    final response = await http.get('http://bstrd-official.club/api/film/home.php');
    data = jsonDecode(response.body);
    jumlah = data["jml"];
    if (this.mounted) {
    setState(() {
      isLoading = false;
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
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
  systemNavigationBarColor: Colors.black,
));
    return Scaffold(
      body: Container(
        color: Colors.black,
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        padding: EdgeInsets.fromLTRB(20, 40, 20, 0),
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(bottom:10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text("Hello", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25)),
                      Container(
                        height:40, width:40,
                        child:
                          FlatButton(
                            splashColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => cari.Search())),
                            child: Icon(Icons.search),
                          )
                      ),
                    ],
                  ),
                  Text("Ready to choose your\nmovie?", style: TextStyle(fontSize: 15)),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                children: <Widget>[
                  FilmHome(jenis: "featured", total: 8, data: data, status: isLoading),
                  FilmHome(jenis: "tv", total: 8, data: data, status: isLoading),
                  FilmHome(jenis: "umum", total: 20, data: data, status: isLoading),
                ],
              )
            )
          ],
        ),
      )
    );
  }
}

class FilmHome extends StatelessWidget {
  FilmHome({this.jenis, this.total, this.data, this.status});
  final String jenis;
  final bool status;
  final int total;
  final Map<String, dynamic> data;
  @override
  Widget build(BuildContext context) {
    return(
      Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              jenis == "tv" ? Text("TV Series", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14))
                  : jenis == "featured" ? Text("Box Office", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14))
                  : Text("New Movies", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              Text("See all", style: TextStyle(fontSize: 12)),
            ],
          ),
          Container(
              padding: EdgeInsets.only(bottom: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  status ? Container(width: MediaQuery.of(context).size.width, child:Image.asset("assets/images/loading.gif")) :
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 200,
                    margin : EdgeInsets.only(top:20),
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: total,
                      itemBuilder: (context, index) {
                        return (list.FilmCard(rating: data[jenis][index.toString()]["rating"], durasi: data[jenis][index.toString()]["durasi"], url: data[jenis][index.toString()]["url"], img: data[jenis][index.toString()]["img"], judul: data[jenis][index.toString()]["judul"]));
                      },
                    )
                  )
                ],
              ),
            )
        ],
      )
    );
  }
}