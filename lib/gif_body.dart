import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';

class GifBody extends StatefulWidget {
  @override
  _GifBodyState createState() => _GifBodyState();
}

class _GifBodyState extends State<GifBody> {

  final TextEditingController input = TextEditingController();
  final String urlgif1 =
      '';
      
  final String urlgif2 = '&limit=5&offset=0&rating=G&lang=en';
  var data;
  bool isLoading = true;
  bool isDownloading = false;
  void getGif(String search) async {
    print('button pressed');
    setState(() {
      isLoading = true;
    });
    var resolve = await http.get(urlgif1 + search + urlgif2);
    data = json
        .decode(resolve.body)["data"]; //[1]["images"]["fixed_height"]["url"]
    print('before loading 2');
    setState(() {
      isLoading = false;
    });
    print('loading completed');
  }

  Future<void> downloadGif(String url, int index) async {
    Dio image = Dio();
    print('download working 1');
    try {
      var dir = await getApplicationDocumentsDirectory();
      print('hey i am printing directory');
      print(dir.path.toString());
      print('did you got that directory/try to save file');
      await image
          .download(url,"${dir.path}/myGif.gif", //'+ index.toString() + '
              onReceiveProgress: (rec, tot) {
        setState(() {
          isDownloading = true;
          
        });
      });
    } catch (e) {
      print(e);
    }
    print('download ho gaya hai');
    setState(() {
      isDownloading = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text('search your gif'),
      ),
      body: Column(
        children: <Widget>[
          Container(
            height: height * 0.080,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: TextField(
                    controller: input,
                    decoration: InputDecoration(
                      labelText: 'Search your gif',
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(3.0),
                        borderSide: BorderSide(color: Colors.greenAccent),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(3.0),
                        borderSide: BorderSide(color: Colors.greenAccent),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: RaisedButton(
                    onPressed: () {
                      getGif(input.text);
                    },
                    child: Text(
                      'search',
                      style: TextStyle(color: Colors.black),
                    ),
                    color: Colors.grey,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: height * 0.05,
          ),
          DropdownButton(items: [DropdownMenuItem(child: Text("GIF"),value: ,)], onChanged: (dd){

          }),
          isLoading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : //Text('data loaded')
              Expanded(
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 2 / 2,
                        crossAxisSpacing: 8.0,
                        mainAxisSpacing: 8.0),
                    itemCount:5,//data.length ,
                    itemBuilder: ((context, index) {
                      String previewImageUrl = (data[index]["images"]
                              ["fixed_height_still"]["url"])
                          .toString();
                      String gifUrl = (data[index]["images"]["fixed_height"]
                              ["url"])
                          .toString();
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: GridTile(
                          footer: GridTileBar(
                            leading: IconButton(key: Key(index.toString()),
                                icon: !isDownloading
                                    ? Icon(Icons.file_download)
                                    : Icon(
                                        Icons.check_circle_outline,
                                        color: Colors.green,
                                      ),
                                onPressed: () {
                                  print('download button presed');
                                  downloadGif(gifUrl, index);
                                  print('download seems to be completed');
                                }),
                          ),
                          child: Container(
                            child: Image.network(gifUrl),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.greenAccent),
                              color: Colors.black54,
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ),
        ],
      ),
    );
  }
}
/*
Stack(
                              alignment: Alignment.center,
                              children: <Widget>[
                                Image.network(
                                  previewImageUrl,
                                  filterQuality: FilterQuality.low,
                                  fit: BoxFit.contain,
                                ),
                                // BackdropFilter(
                                //   filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                                //   child: Container(
                                //     color: Colors.black.withOpacity(0),
                                //   ),
                                // ),
                                // Image.network(
                                //   imageUrl,
                                //   fit: BoxFit.cover,
                                // ),
                              ],
                            ),*/
