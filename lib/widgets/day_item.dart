import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DayItem extends StatelessWidget {
  final double startTime;
  final double endTime;
  final double totalWorkTime;
  final DateTime dateTime;

  DayItem({
    required this.totalWorkTime,
    required this.endTime,
    required this.startTime,
    required this.dateTime,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
          child: Text(DateFormat('dd-MM').format(dateTime)),
        ),
        Card(
          elevation: 20,
          color: totalWorkTime != 0.00 ? Colors.green[400] : Colors.grey[300],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Container(
            padding: EdgeInsets.all(25),
            height: MediaQuery.of(context).size.height * 0.2,
            width: MediaQuery.of(context).size.width * 0.9,
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        startTime.toString(),
                        style: TextStyle(fontSize: 22),
                      ),
                      Icon(Icons.arrow_right_alt),
                      Text(
                        endTime.toString(),
                        style: TextStyle(fontSize: 22),
                      ),
                    ],
                  ),
                ),
                Divider(),
                Center(
                  child: Column(
                    children: [
                      Text(
                        'Czas Pracy: $totalWorkTime',
                        style: TextStyle(fontSize: 18),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Divider(),
                      ),
                      Text(
                        'Szef: szef',
                        style: TextStyle(fontSize: 15),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
