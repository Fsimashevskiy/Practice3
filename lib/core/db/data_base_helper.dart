import 'dart:convert';
import 'dart:ffi';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth/data/model/Delivery_of_goods.dart';
import 'package:flutter_auth/data/model/Doljnost.dart';
import 'package:flutter_auth/data/model/Client.dart';
import 'package:flutter_auth/data/model/Product.dart';
import 'package:flutter_auth/data/model/Country.dart';
import 'package:flutter_auth/data/model/Provider.dart';
import 'package:flutter_auth/data/model/Stock.dart';
import 'package:flutter_auth/domain/entity/role_entity.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

import '../../common/data_base_request.dart';
import '../../data/model/Role.dart';
import '../../data/model/Sotrudnik.dart';
import 'package:sqflite_common/sqlite_api.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class DataBaseHelper {
  static final DataBaseHelper instance = DataBaseHelper._instance();

  DataBaseHelper._instance();

  late final Directory _appDocumentDirectory;
  late final String _pathDB;
  late final Database dataBase;
  int _version = 1;

  Future<void> init() async {
    _appDocumentDirectory =
        await path_provider.getApplicationDocumentsDirectory();

    _pathDB = join(_appDocumentDirectory.path, 'Database.db');
    if (Platform.isWindows || Platform.isMacOS || Platform.isLinux) {
      sqfliteFfiInit();
      dataBase = await databaseFactoryFfi.openDatabase(_pathDB,
          options: OpenDatabaseOptions(
              version: _version,
              onCreate: (dataBase, version) async {
                await onCreateTable(dataBase);
              },
              onUpgrade: (dataBase, oldVersion, newVersion) async {
                await onUpdateTable(dataBase);
              }));
    } else {
      dataBase = await openDatabase(_pathDB, version: _version,
          onCreate: (dataBase, version) async {
        await onCreateTable(dataBase);
      }, onUpgrade: (dataBase, oldVersion, newVersion) async {
        await onUpdateTable(dataBase);
      });
    }
    //return Future.value(false);
  }

  Future<void> onUpdateTable(Database db) async {
    var tables = await db.rawQuery("SELECT name FROM sqlite_master");

    for (var table in DataBaseRequest.tableList.reversed) {
      if (tables.where((element) => element['name'] == table).isNotEmpty) {
        await db.execute(DataBaseRequest.deleteTable(table));
      }
    }

    for (var i = 0; i < DataBaseRequest.tableList.length; i++) {
      await db.execute(DataBaseRequest.createTableList[i]);
    }
    await onInitTable(db);
  }

  Future<void> onCreateTable(Database db) async {
    for (var i = 0; i < DataBaseRequest.tableList.length; i++) {
      await db.execute(DataBaseRequest.createTableList[i]);
    }
    db.execute('PRAGMA foreign_keys=on');
    await onInitTable(db);
  }

  Future<void> onDropDataBase() async {
    dataBase.close();
    if (Platform.isWindows || Platform.isMacOS || Platform.isLinux) {
      databaseFactoryFfi.deleteDatabase(dataBase.path);
    } else {
      deleteDatabase(_pathDB);
    }
  }

  Future<void> onInitTable(Database db) async {
    try {
      db.insert(DataBaseRequest.tableRole, Role(role: 'Admin').toMap());
      db.insert(DataBaseRequest.tableRole, Role(role: 'Sotrudnik').toMap());

      String hashPass = md5.convert(utf8.encode("TestAdmin1")).toString();

      db.insert(
          DataBaseRequest.tableUsers,
          User(
                  name: "TestUser1",
                  surname: "TestUser1",
                  patronymic: "TestUser1",
                  login: "TestAdmin1",
                  password: hashPass,
                  phoneNumber: "88005553535",
                  email: "pochta@mail.ru",
                  roleId: RoleEnum.admin.id)
              .toMap());

      db.insert(
          DataBaseRequest.tableProviders,
          Provider(name: "name", address: "address", phoneNumber: "88005553535")
              .toMap());

      db.insert(
          DataBaseRequest.tableStocks, Stock(address: "address ul.17").toMap());

      db.insert(
          DataBaseRequest.tableProductCategories,
          ProductCategory(name: "pervaya", description: "pervaya categoria")
              .toMap());

      db.insert(
          DataBaseRequest.tableProducts,
          Product(
                  description: "description",
                  price: 20.20,
                  name: "name",
                  exists: 1,
                  productCategoryId: 1,
                  stockId: 1,
                  count: 2,
                  vendor: "vendor")
              .toMap());

      db.insert(
          DataBaseRequest.tableArrivals,
          Arrival(
                  date: DateTime.now().toString(),
                  count: 1,
                  providerId: 1,
                  productId: 1)
              .toMap());

      db.insert(DataBaseRequest.tableIssuePoints,
          IssuePoint(name: "ozon", address: "Moscow Paver. Street 17").toMap());

      db.insert(
          DataBaseRequest.tableConsumptions,
          Consumption(
                  date: DateTime.now().toString(),
                  count: 2,
                  productId: 1,
                  userId: 1,
                  issuePointId: 1,
                  status: "On road")
              .toMap());
    } on DatabaseException catch (e) {}
  }
}
