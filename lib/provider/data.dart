import 'dart:async';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/day.dart';

class Data with ChangeNotifier {
  final List<Day> day = [];
  final nameController = TextEditingController();
  String name = 'Wprowadź Imię';
  String parsedName = '';
  var isError = false;
  var timeout = false;
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  Future<void> getDataFromSharedPreferences() async {
    final SharedPreferences prefs = await _prefs;
    name = prefs.getString('name') ?? 'Wprowadź Imię';
    parsedName = name.replaceAll(' ', '').toLowerCase();
    ChangeNotifier();
  }

  Future<void> saveDataInSharedPreferences(_value) async {
    final SharedPreferences prefs = await _prefs;
    prefs.setString('name', _value);
    ChangeNotifier();
  }

  Future<List<Day>> fetchJson() async {
    try {
      var url = Uri.parse('http://10.0.2.2:8000/$parsedName');
      var response = await http.get(url).timeout(const Duration(seconds: 5));
      print('response: ${response.body}');
      List<Day> dlist = [];

      if (response.statusCode == 200) {
        var drjson = json.decode(response.body);
        isError = false;
        timeout = false;
        ChangeNotifier();

        for (var jsondata in drjson) {
          dlist.add(Day.fromJson(jsondata));
          ChangeNotifier();
        }
      } else {
        isError = true;
      }

      return dlist;
    } on TimeoutException catch (_) {
      timeout = true;
      isError = true;
      List<Day> dlist = [];
      return dlist;
    }
  }

  double get totalHours {
    var total = 0.0;
    day.forEach((element) {
      total += double.parse(element.endTime) - double.parse(element.startTime);
    });

    return total;
  }

  void getAndSetName(value) {
    name = value;
    print(name);
    name = name.splitMapJoin(RegExp(r'\w+'),
        onMatch: (m) =>
            '${m.group(0)}'.substring(0, 1).toUpperCase() +
            '${m.group(0)}'.substring(1).toLowerCase(),
        onNonMatch: (n) => ' ');
    parsedName = name.replaceAll(' ', '').toLowerCase();
    saveDataInSharedPreferences(name);
  }

  DateTime? findLastDay() {
    if (day.isEmpty) {
      return DateTime.parse('2030-01-01');
    }
    DateTime _maxDate = DateTime.parse(DateFormat('yyyy-MM-dd')
        .format(DateTime.parse(day[0].date))
        .toString());
    for (var i = 0; i < day.length; i++) {
      if (DateTime.parse(DateFormat('yyyy-MM-dd')
              .format(DateTime.parse(day[i].date))
              .toString())
          .isAfter(_maxDate)) {
        _maxDate = DateTime.parse(DateFormat('yyyy-MM-dd')
            .format(DateTime.parse(day[i].date))
            .toString());
      }
    }
    return _maxDate;
  }

  DateTime? findFirstDay() {
    if (day.isEmpty) {
      return DateTime.parse('2021-01-01');
    }
    DateTime _minDate = DateTime.parse(DateFormat('yyyy-MM-dd')
        .format(DateTime.parse(day[0].date))
        .toString());
    for (var i = 0; i < day.length; i++) {
      if (DateTime.parse(DateFormat('yyyy-MM-dd')
              .format(DateTime.parse(day[i].date))
              .toString())
          .isBefore(_minDate)) {
        _minDate = DateTime.parse(DateFormat('yyyy-MM-dd')
            .format(DateTime.parse(day[i].date))
            .toString());
      }
    }
    return _minDate;
  }

  void scrollToChosenDay(DateTime selectedDay, _scrollController) {
    final _elementIndex = day.indexWhere((element) =>
        DateTime.parse(element.date).isAtSameMomentAs(selectedDay));
    if (_elementIndex <= -1) {
      return;
    } else {
      _scrollController.scrollTo(
        index: _elementIndex,
        duration: const Duration(milliseconds: 500),
        //alignment: 0.2,
      );
      notifyListeners();
    }
  }
}
