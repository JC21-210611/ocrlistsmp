import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Api{
  static List<String> contentList = [""];

  void postData(XFile img) async {
    print("パス：" + img.path);
    File file = File(img.path);
    // 画像のバイナリデータを読み込みます.
    ByteData data = await file.readAsBytes().then((bytes) =>
        ByteData.sublistView(Uint8List.fromList(bytes)));
    List<int> imageBytes = data.buffer.asUint8List(); // 修正

    var response = await http
        .post(Uri.parse(
        'https://r05-jk3a15cognitive.cognitiveservices.azure.com/computervision/imageanalysis:analyze?language=ja&api-version=2023-02-01-preview&features=read'),
        headers: {
          'Ocp-Apim-Subscription-Key': '2a4e99f274a14a94a4b5f26077b97cf0',
          'Content-Type': 'application/octet-stream',
        },
        body: imageBytes
    );
    Map<String, dynamic> jsonDataMap = json.decode(response.body);
    // "content"フィールドの値を取得
    String content = jsonDataMap['readResult']['content'];

    //contentの値を1行にする
    String contentMoji = content.replaceAll('\n', '');

    print(contentMoji);

    String genStr = "";

    if (contentMoji.contains("原材料")) {
      //原材料後、内容量までをString型で保持
      RegExp moji = RegExp(r"原材料名(.*?)內容量(.*)");
      RegExp moji2 = RegExp(r"原材料名(.*)");
      RegExpMatch? matchMoji = moji.firstMatch(contentMoji);
      RegExpMatch? matchMoji2 = moji2.firstMatch(contentMoji);

      debugPrint("マッチしたか1:$matchMoji");
      debugPrint("マッチしたか2:$matchMoji2");

      if (matchMoji != null) {
        genStr = matchMoji.group(1)!.trim();
        debugPrint("原材料後1：$genStr");
      } else if (matchMoji2 != null) {
        genStr = matchMoji2.group(1)!.trim();
        debugPrint("原材料後2：$genStr");
      }
    } else {
      print("else");
      genStr = contentMoji;
    }

    //、を見つけるまでを1要素として配列に格納する
    contentList = genStr.split('、');

    // contentに改行コードあり、「、」なしで文字列として代入
    content = content.replaceAll("、", "");

    debugPrint("読み込んだ文字：$contentList");
  }
   Future<List<String>> getContentList() async{
    return contentList;
  }
}