import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter/services.dart';

class Play extends StatefulWidget {
  Play({this.id});
  final String id;
  @override
  _PlayState createState() => _PlayState();
}

class _PlayState extends State<Play> {
  bool isLoadings = true;
  String data;

  Future<String> check() async {
    final response = await http.get("http://bstrd-official.club/api/film/get_player.php?id=${widget.id}");
    data = response.body;
    if (this.mounted) {
    setState(() {
      isLoadings = false;
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
dispose(){
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  SystemChrome.setEnabledSystemUIOverlays ([SystemUiOverlay.top]);
  super.dispose();
}

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays ([]);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
  ]);
    return Scaffold(
      body: isLoadings ? Center(child: Container(color: Colors.black, height: MediaQuery.of(context).size.height, width: MediaQuery.of(context).size.width, child:Image.asset("assets/images/loading.gif"))) : WebView(
        initialUrl: "https://$data",
        javascriptMode: JavascriptMode.unrestricted,
        userAgent: "Opera/9.80 (Android; Opera Mini/36.2.2254/119.132; U; id) Presto/2.12.423 Version/12.16",
      ),
    );
  }
}