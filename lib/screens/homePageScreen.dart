import 'package:flutter/material.dart';
import 'package:pw_app/provider/data.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:provider/provider.dart';

import '../widgets/WorkDaysList.dart';
import '../provider/data.dart';

class HomePageScreen extends StatefulWidget {
  @override
  State<HomePageScreen> createState() => _HomePageScreenState();
}

class _HomePageScreenState extends State<HomePageScreen> {
  double appBarHeight = AppBar().preferredSize.height;

  DateTime _focusedDay = DateTime.now();

  DateTime? _selectedDay;
  var isEmpty = false;
  var isInit = true;
  var isLoading = false;
  var nameIsSet = false;

  final ItemScrollController _scrollController = ItemScrollController();

  @override
  void didChangeDependencies() {
    final _data = Provider.of<Data>(context);
    Future.delayed(Duration.zero, () async {
      await _data.getDataFromSharedPreferences();
      if (_data.name != 'Wprowadź Imię') {
        setState(() {
          _data.timeout = false;
          nameIsSet = true;
        });
      }
      if (isInit == true && _data.name != 'Wprowadź Imię') {
        setState(() {
          isLoading = true;
          isInit = false;
        });
        Provider.of<Data>(context, listen: false).fetchJson().then((value) {
          setState(() {
            isLoading = false;
            Provider.of<Data>(context, listen: false).day.addAll(value);
          });
        });
      }
    });
    super.didChangeDependencies();
  }

  Widget _buildCalendarChild(_data) {
    final _data = Provider.of<Data>(context);
    if (nameIsSet == false) {
      return Center(
        child: Image.asset('assets/images/lifeguard.png'),
      );
    } else if (_data.isError == true) {
      return Column(
        children: [
          Center(
            child: Image.asset(
              'assets/images/warning.png',
              height: 200,
              width: 200,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 25.0),
            child: Center(
                child: _data.timeout
                    ? const Text(
                        'Serwer nie odpowiada',
                        style: TextStyle(fontSize: 18),
                      )
                    : const Text(
                        'Sprawdź czy poprawnie wpisałeś imię',
                        style: TextStyle(fontSize: 18),
                      )),
          )
        ],
      );
    } else if (isLoading == true) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    } else {
      return TableCalendar(
        startingDayOfWeek: StartingDayOfWeek.monday,
        headerStyle: const HeaderStyle(formatButtonVisible: false),
        firstDay: _data.findFirstDay()!,
        lastDay: DateTime.parse('2022-08-27'), //_data.findLastDay()!
        focusedDay: _focusedDay,
        selectedDayPredicate: (day) {
          return isSameDay(_selectedDay, day);
        },
        onDaySelected: (selectedDay, focusedDay) {
          setState(() {
            _selectedDay = selectedDay;
            _focusedDay = focusedDay; // update `_focusedDay` here as well
          });
          _data.scrollToChosenDay(_selectedDay!, _scrollController);
        },
      );
    }
  }

  Widget _buildListViewContainer() {
    final _data = Provider.of<Data>(context);
    if (nameIsSet == false || isLoading == true || _data.isError == true) {
      return SizedBox();
    } else {
      return Container(
          width: double.infinity, child: WorkDaysList(_scrollController));
    }
  }

  // @override
  @override
  Widget build(BuildContext context) {
    final _data = Provider.of<Data>(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text(
          'Grafik',
          style: TextStyle(fontSize: 20),
        ),
        actions: [
          TextButton(
              onPressed: () {},
              style: TextButton.styleFrom(
                primary: Colors.white,
              ),
              child: Text(
                'Godziny: ${_data.totalHours}',
                style: TextStyle(fontSize: 20),
              ))
        ],
      ),
      body: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: SizedBox(
          width: double.infinity,
          height: MediaQuery.of(context).size.height - appBarHeight,
          child: Column(
            children: [
              Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.1,
                child: Center(
                  child: TextButton(
                    onPressed: () async {
                      await showModalBottomSheet(
                          context: context,
                          builder: (BuildContext context) {
                            return Padding(
                              padding: EdgeInsets.only(
                                  bottom:
                                      MediaQuery.of(context).viewInsets.bottom),
                              child: SingleChildScrollView(
                                child: Card(
                                  child: Container(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.33,
                                      child: Padding(
                                        padding: const EdgeInsets.only(top: 50),
                                        child: Center(
                                          child: Column(
                                            children: [
                                              const Center(
                                                  child: Text(
                                                      'Wpisz imię oraz nazwisko, aby sprawdzić grafik:')),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(20.0),
                                                child: Container(
                                                  child: TextField(
                                                    decoration: const InputDecoration(
                                                        border:
                                                            OutlineInputBorder(),
                                                        labelText:
                                                            'Imię i Nazwisko'),
                                                    controller:
                                                        _data.nameController,
                                                    onSubmitted: (value) {
                                                      if (_data.nameController
                                                          .text.isNotEmpty) {
                                                        _data.getAndSetName(
                                                            value);
                                                        print(value);
                                                        Navigator.pop(context);
                                                      } else {
                                                        isEmpty = true;
                                                        Navigator.pop(context);
                                                      }
                                                    },
                                                  ),
                                                ),
                                              ),
                                              TextButton(
                                                  onPressed: () async {
                                                    if (_data.nameController
                                                        .text.isNotEmpty) {
                                                      _data.getAndSetName(_data
                                                          .nameController.text);
                                                      Navigator.pop(context);
                                                    } else {
                                                      isEmpty = true;
                                                      Navigator.pop(context);
                                                    }
                                                  },
                                                  child: const Text(
                                                      'Pobierz i zapisz'))
                                            ],
                                          ),
                                        ),
                                      )),
                                ),
                              ),
                            );
                          });
                      if (_data.nameController.text.isNotEmpty) {
                        return setState(() {
                          _data.day.clear();
                          isInit = true;
                          isLoading = false;
                          nameIsSet = false;
                          if (_data.name != 'Wprowadź Imię') {
                            setState(() {
                              nameIsSet = true;
                            });
                          }
                          if (isInit == true && _data.name != 'Wprowadź Imię') {
                            setState(() {
                              isLoading = true;
                              isInit = false;
                            });
                            Provider.of<Data>(context, listen: false)
                                .fetchJson()
                                .then((value) {
                              setState(() {
                                isLoading = false;
                                Provider.of<Data>(context, listen: false)
                                    .day
                                    .addAll(value);
                              });
                            });

                            // onError: (){
                            //   _isError = true;
                            // });
                          }
                        });
                      } else {
                        if (isEmpty == true) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text("Pole nie może być puste!")));
                          setState(() {
                            isEmpty = false;
                          });
                        }
                      }
                    },
                    style: TextButton.styleFrom(
                      primary: Colors.black,
                    ),
                    child: Text(
                      _data.name,
                      style: TextStyle(fontSize: 25),
                    ),
                  ),
                ),
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.51,
                child: _buildCalendarChild(_data),
              ),
              Expanded(
                child: _buildListViewContainer(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
