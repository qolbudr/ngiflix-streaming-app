import 'package:flutter/material.dart';
import 'package:html_unescape/html_unescape.dart';
import 'view.dart' as detail;

class FilmCard extends StatelessWidget {
  FilmCard({this.img, this.judul, this.url, this.durasi, this.rating});
  final String img, url, durasi, rating;
  final String judul;
  final unescape = new HtmlUnescape();
  @override
  Widget build(BuildContext context) {
    return(
      Container(
      width: 136,
      height: 228,
      child:  
      Card(
        clipBehavior: Clip.antiAliasWithSaveLayer,
        semanticContainer: true,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5))),
        elevation: 3,
        child:
        Stack(
          children: [
          Container(
            width: 136,
            height: 228,
            child: Image.network(img),
          ),
          Container(
            color: Colors.black.withOpacity(0.5),
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.all(5),
            child: Text(unescape.convert(judul)),
          ),
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
      )
  );
}
}