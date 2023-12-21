import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'api.dart';
import 'Database.dart';


class StatePostPage extends StatefulWidget{
  const StatePostPage(this.image, {Key? key}) : super(key: key);
  final XFile image;

  @override
    PostPage createState() => PostPage();
}

class PostPage extends State<StatePostPage> {
  String val = "cat";
  List<String> vals = ["dog"];

  @override
  void initState() {
    super.initState();
    _postData();
  }

  void _postData() {
    Api.instance.postData(widget.image);
  }

  bool _isLoading = false;
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child:SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.file(File(path.join(widget.image.path))),
              TextButton(
                  onPressed: () async{
                    setState(() {
                      _isLoading = true;
                    });

                    await Api.instance.postData(widget.image);

                    List<Map<String, dynamic>> databaseContent = await dblist().getData();
                    List<String> contentList = await Api.instance.getContentList();
                    print("ボタン押されたから持ってきたcontent；$contentList");

                    setState(() {  //ほんまにここでやることなんか？
                      print("ボタン押されたからセットステートするで");
                      String values = "";

                      for(Map<String, dynamic> dbc in databaseContent){
                        for(String s in contentList) {
                          String word = dbc['foodname'];
                          if (s.contains(word)) {
                            values = "$values \n $s";
                            debugPrint("追加：　$s");
                            debugPrint("表示： $values");
                            break;
                          }
                        }
                      }
                      if(values == ""){
                        values = "何も検知されませんでした";
                      }
                      val = values;
                      vals = contentList;

                      _isLoading = false;
                    });
                  },
                  child: _isLoading
                      ? CircularProgressIndicator()
                  : Text('上の画像をAPIに送信します')),
              SizedBox(height: 20), // スペースを追加してタイトルと枠を分ける
              const Text(
                '照合結果',
                style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
              ),
              Container(
                width: 300.0,
                height: 150.0,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.black,
                    width: 2.0,
                  ),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Text(val,style:TextStyle(fontSize: 15)
                ),
              ),
              SizedBox(height: 20), // スペースを追加してタイトルと枠を分ける
              const Text(
                '文字認識結果',
                style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
              ),
              Container(
                width: 300.0,
                height: 150.0,
                margin: EdgeInsets.only(bottom: 16.0),
               decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.black,
                    width: 2.0,
                  ),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: ListView.builder(
                  itemCount: vals.length,
                  itemBuilder: (BuildContext context, int index){
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0).copyWith(left: 5.0),
                      child: Text(vals[index]),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}