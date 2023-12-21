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
  String val = "nyan";

  @override
  void initState() {
    super.initState();
    _postData();
  }

  void _postData() {
    Api.instance.postData(widget.image);
  }

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
                    });
                  },
                  child: Text('上の画像をAPIに送信します')),
              Text(val,style:TextStyle(fontSize: 15))
            ],
          ),
        ),
      ),
    );
  }
}