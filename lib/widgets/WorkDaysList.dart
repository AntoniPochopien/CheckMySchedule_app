import 'package:flutter/material.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../provider/data.dart';
import '../widgets/day_item.dart';

class WorkDaysList extends StatelessWidget {
  final ItemScrollController _scrollController;
  WorkDaysList(this._scrollController);

  @override
  Widget build(BuildContext context) {
    final _data = Provider.of<Data>(context);
    return ScrollablePositionedList.builder(
      itemScrollController: _scrollController,
      shrinkWrap: true,
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.all(10.0),
      itemCount: _data.day.length,
      itemBuilder: (ctx, i) => DayItem(
        totalWorkTime: double.parse(_data.day[i].endTime) -
            double.parse(_data.day[i].startTime),
        startTime: double.parse(_data.day[i].startTime),
        endTime: double.parse(_data.day[i].endTime),
        dateTime: DateTime.parse(DateFormat('yyyy-MM-dd')
            .format(DateTime.parse(_data.day[i].date))
            .toString()),
      ),
    );
  }
}
