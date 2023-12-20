import 'package:flutter/cupertino.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DBProvider {

  DBProvider._();

  static final DBProvider instance = DBProvider._();
  Database? _database;

  // Databaseが存在するかどうか確認して、あったら返す。
  Future<Database> get database async {
    debugPrint("データベースが存在しているか確認しにきました");
    if (_database != null) return _database!;
    // Databaseがない場合に作成する。
    _database = await _initDatabase();
    return _database!;
  }
  Future<List<Map<String, dynamic>>> getAllData() async {
    final db = await database;

    return await db.query('food');
  }

  Future<Database> _initDatabase() async {
    debugPrint("_initDatabaseにきました");

    final path = join(await getDatabasesPath(), 'ocrlist.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    debugPrint("_onCreateしにきました");

    await db.execute('PRAGMA foreign_keys = ON;');//外部キーON
    debugPrint("外部キー指定しました");

    //カテゴリー表
    await db.execute('''
        CREATE TABLE category(
          categoryid TEXT PRIMARY KEY,
          categoryname TEXT
        )
    ''');debugPrint("カテゴリー表を作成しました");
    //食品表
    await db.execute('''
        CREATE TABLE food(
          foodid TEXT PRIMARY KEY, 
          foodname TEXT,
          categoryid TEXT,
          FOREIGN KEY(categoryid) REFERENCES category(categoryid)
        )
    ''');debugPrint("食品表を作成しました");

    //初期データ
    final categories = [
      {'categoryid': 'HG', 'categoryname': '表示義務'},
      {'categoryid': 'HS', 'categoryname': '表示推奨'},
      {'categoryid': 'BH', 'categoryname': '非推奨'},
      {'categoryid': 'TS', 'categoryname': '追加成分'},
    ];

    final foods = [
      {'foodid': 'GA1', 'foodname': 'えび', 'categoryid': 'HG'},
      {'foodid': 'GA2', 'foodname': '海老', 'categoryid': 'HG'},
      {'foodid': 'GA3', 'foodname': 'shrimp', 'categoryid': 'HG'},
      { 'foodid': 'GB1','foodname': 'くるみ','categoryid': 'HG'},
      { 'foodid': 'GB2','foodname': '胡桃','categoryid': 'HG'},
      { 'foodid': 'GB3','foodname': 'walnut','categoryid': 'HG'},
      { 'foodid': 'GC1','foodname': 'かに','categoryid': 'HG'},
      { 'foodid': 'GC2','foodname': '蟹','categoryid': 'HG'},
      { 'foodid': 'GC3','foodname': 'crab','categoryid': 'HG'},
      { 'foodid': 'GD1','foodname': 'こむぎ','categoryid': 'HG'},
      { 'foodid': 'GD2','foodname': '小麦','categoryid': 'HG'},
      { 'foodid': 'GD3','foodname': 'wheat','categoryid': 'HG'},
      { 'foodid': 'GE1','foodname': 'そば','categoryid': 'HG'},
      { 'foodid': 'GE2','foodname': '蕎麦','categoryid': 'HG'},
      { 'foodid': 'GE3','foodname': 'buckwheat','categoryid': 'HG'},
      { 'foodid': 'GF1','foodname': 'たまご','categoryid': 'HG'},
      { 'foodid': 'GF2','foodname': '卵','categoryid': 'HG'},
      { 'foodid': 'GF3','foodname': 'egg','categoryid': 'HG'},
      { 'foodid': 'GG1','foodname': '乳','categoryid': 'HG'},
      { 'foodid': 'GG2','foodname': 'dairy','categoryid': 'HG'},
      { 'foodid': 'GG3','foodname': '牛乳','categoryid': 'HG'},
      { 'foodid': 'GG4','foodname': 'milk','categoryid': 'HG'},
      { 'foodid': 'GH1','foodname': 'ピーナッツ','categoryid': 'HG'},
      { 'foodid': 'GH2','foodname': '落花生','categoryid': 'HG'},
      { 'foodid': 'GH3','foodname': 'peanut','categoryid': 'HG'},
      { 'foodid': 'SA1', 'foodname': 'アーモンド', 'categoryid': 'HS'},
      { 'foodid': 'SA2', 'foodname': '扁桃', 'categoryid': 'HS'},
      { 'foodid': 'SA3', 'foodname': 'almond', 'categoryid': 'HS'},
      { 'foodid': 'SB1','foodname': 'あわび','categoryid': 'HS'},
      { 'foodid': 'SB2','foodname': '鮑','categoryid': 'HS'},
      { 'foodid': 'SB3','foodname': 'abalone','categoryid': 'HS'},
      { 'foodid': 'SC1','foodname': 'いか','categoryid': 'HS'},
      { 'foodid': 'SC2','foodname': '烏賊','categoryid': 'HS'},
      { 'foodid': 'SC3','foodname': 'squid','categoryid': 'HS'},
      { 'foodid': 'SD1','foodname': 'いくら','categoryid': 'HS'},
      { 'foodid': 'SD2','foodname': '鮭卵','categoryid': 'HS'},
      { 'foodid': 'SD3','foodname': 'salmon roe','categoryid': 'HS'},
      { 'foodid': 'SE1','foodname': 'カシューナッツ','categoryid': 'HS'},
      { 'foodid': 'SE2','foodname': '加州','categoryid': 'HS'},
      { 'foodid': 'SE3','foodname': 'cashew nuts','categoryid': 'HS'},
      { 'foodid': 'SF1','foodname': 'オレンジ','categoryid': 'HS'},
      { 'foodid': 'SF2','foodname': '甘橙','categoryid': 'HS'},
      { 'foodid': 'SF3','foodname': 'orange','categoryid': 'HS'},
      { 'foodid': 'SG1','foodname': 'キウイ','categoryid': 'HS'},
      { 'foodid': 'SG2','foodname': 'キウイフルーツ','categoryid': 'HS'},
      { 'foodid': 'SG3','foodname': '彌猴桃','categoryid': 'HS'},
      { 'foodid': 'SG4','foodname': 'kiwi','categoryid': 'HS'},
      { 'foodid': 'SH1','foodname': 'ぎゅうにく','categoryid': 'HS'},
      { 'foodid': 'SH2','foodname': '牛肉','categoryid': 'HS'},
      { 'foodid': 'SH3','foodname': 'beef','categoryid': 'HS'},
      { 'foodid': 'SI1','foodname': 'ごま','categoryid': 'HS'},
      { 'foodid': 'SI2','foodname': '胡麻','categoryid': 'HS'},
      { 'foodid': 'SI3','foodname': 'sesame','categoryid': 'HS'},
      { 'foodid': 'SJ1','foodname': 'さけ','categoryid': 'HS'},
      { 'foodid': 'SJ2','foodname': '鮭','categoryid': 'HS'},
      { 'foodid': 'SJ3','foodname': 'salmon','categoryid': 'HS'},
      { 'foodid': 'SK1','foodname': 'さば','categoryid': 'HS'},
      { 'foodid': 'SK2','foodname': '鯖','categoryid': 'HS'},
      { 'foodid': 'SK3','foodname': 'mackerel','categoryid': 'HS'},
      { 'foodid': 'SL1','foodname': 'だいず','categoryid': 'HS'},
      { 'foodid': 'SL2','foodname': '大豆','categoryid': 'HS'},
      { 'foodid': 'SL3','foodname': 'soybean','categoryid': 'HS'},
      { 'foodid': 'SM1','foodname': 'とりにく','categoryid': 'HS'},
      { 'foodid': 'SM2','foodname': '鶏肉','categoryid': 'HS'},
      { 'foodid': 'SM3','foodname': 'chicken','categoryid': 'HS'},
      { 'foodid': 'SN1','foodname': 'バナナ','categoryid': 'HS'},
      { 'foodid': 'SN2','foodname': '甘蕉','categoryid': 'HS'},
      { 'foodid': 'SN3','foodname': 'banana','categoryid': 'HS'},
      { 'foodid': 'SO1','foodname': 'ぶたにく','categoryid': 'HS'},
      { 'foodid': 'SO2','foodname': '豚肉','categoryid': 'HS'},
      { 'foodid': 'SO3','foodname': 'pork','categoryid': 'HS'},
      { 'foodid': 'SP1','foodname': 'まつたけ','categoryid': 'HS'},
      { 'foodid': 'SP2','foodname': '松茸','categoryid': 'HS'},
      { 'foodid': 'SP3','foodname': 'matsutake mushroom','categoryid': 'HS'},
      { 'foodid': 'SQ1','foodname': 'もも','categoryid': 'HS'},
      { 'foodid': 'SQ2','foodname': '桃','categoryid': 'HS'},
      { 'foodid': 'SQ3','foodname': 'peach','categoryid': 'HS'},
      { 'foodid': 'SR1','foodname': 'やまいも','categoryid': 'HS'},
      { 'foodid': 'SR2','foodname': '山芋','categoryid': 'HS'},
      { 'foodid': 'SR3','foodname': 'yam','categoryid': 'HS'},
      { 'foodid': 'SS1','foodname': 'りんご','categoryid': 'HS'},
      { 'foodid': 'SS2','foodname': '林檎','categoryid': 'HS'},
      { 'foodid': 'SS3','foodname': 'apple','categoryid': 'HS'},
      { 'foodid': 'ST1','foodname': 'ゼラチン','categoryid': 'HS'},
      { 'foodid': 'ST2','foodname': '膠','categoryid': 'HS'},
      { 'foodid': 'ST3','foodname': 'gelatin','categoryid': 'HS'},
    ];
    // カテゴリの挿入
    for (final category in categories) {
      await db.insert('category', category);
    }
    // フードの挿入
    for (final food in foods) {
      await db.insert('food', food);
    }
  }
}

class dblist{
  dblist(){
    fetchDataFromDatabase();
  }
  List<Map<String, dynamic>> databaseContent = []; // データベースの中身を格納するリスト

  // データベースの中身を取得する処理
  Future<void> fetchDataFromDatabase() async {
    databaseContent = await DBProvider.instance.getAllData();
    //setState(() {}); // データが取得されたことを反映
    debugPrint("DBくん:$databaseContent");
  }

  Future<List<Map<String, dynamic>>> getData() async{
    databaseContent = await DBProvider.instance.getAllData();
    return databaseContent;
  }
}