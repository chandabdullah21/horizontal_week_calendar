library horizontal_week_calendar;

import 'package:carousel_slider/carousel_slider.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

class HorizontalWeekCalendar extends StatefulWidget {
  ///get DateTime on date select
  final Function(DateTime)? onDateChange;

  ///get the list of DateTime on week change
  final Function(List<DateTime>)? onWeekChange;

  const HorizontalWeekCalendar({
    super.key,
    this.onDateChange,
    this.onWeekChange,
  });

  @override
  State<HorizontalWeekCalendar> createState() => _HorizontalWeekCalendarState();
}

class _HorizontalWeekCalendarState extends State<HorizontalWeekCalendar> {
  CarouselController carouselController = CarouselController();

  DateTime today = DateTime.now();

  DateTime selectedDate = DateTime.now();
  List<DateTime> currentWeek = [];
  int currentWeekIndex = 0;

  List<List<DateTime>> listOfWeeks = [];

  @override
  void initState() {
    initCalender();
    super.initState();
  }

  initCalender() {
    List<DateTime> minus3Days = [];
    List<DateTime> add3Days = [];
    for (int index = 0; index < 3; index++) {
      DateTime minusDate = today.add(Duration(days: -(index + 1)));
      minus3Days.add(minusDate);
      DateTime addDate = today.add(Duration(days: (index + 1)));
      add3Days.add(addDate);
    }

    currentWeek.addAll(minus3Days.reversed.toList());
    currentWeek.add(today);
    currentWeek.addAll(add3Days);

    listOfWeeks.add(currentWeek);
    getMorePreviousWeeks();
  }

  getMorePreviousWeeks() {
    List<DateTime> minus7Days = [];
    DateTime startFrom = listOfWeeks.isEmpty
        ? DateTime.now()
        : listOfWeeks[currentWeekIndex].isEmpty
            ? DateTime.now()
            : listOfWeeks[currentWeekIndex][0];

    for (int index = 0; index < 7; index++) {
      DateTime minusDate = startFrom.add(Duration(days: -(index + 1)));
      minus7Days.add(minusDate);
    }
    listOfWeeks.add(minus7Days.reversed.toList());
    setState(() {});
    // Logger().d(listOfWeeks.length);
  }

  onDateSelect(DateTime date) {
    setState(() {
      selectedDate = date;
    });
    widget.onDateChange?.call(selectedDate);
  }

  onBackClick() {
    carouselController.nextPage();
  }

  onNextClick() {
    carouselController.previousPage();
  }

  onWeekChange(index) {
    currentWeekIndex = index;
    currentWeek = listOfWeeks[currentWeekIndex];

    if (currentWeekIndex + 1 == listOfWeeks.length) {
      getMorePreviousWeeks();
    }

    widget.onWeekChange?.call(currentWeek);
    setState(() {});
  }

  // =================

  isNextDisabled() {
    return listOfWeeks[currentWeekIndex].last.isBefore(DateTime.now());
  }

  isCurrentYear() {
    return DateFormat('yyyy').format(currentWeek[0]) ==
        DateFormat('yyyy').format(today);
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var withOfScreen = MediaQuery.of(context).size.width;

    double boxHeight = withOfScreen / 7;

    return currentWeek.isEmpty
        ? const SizedBox()
        : Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      onBackClick();
                    },
                    child: Row(
                      children: [
                        Icon(
                          Icons.arrow_back_ios_new,
                          color: theme.primaryColor,
                        ),
                        const SizedBox(
                          width: 4,
                        ),
                        Text(
                          "Back",
                          style: theme.textTheme.bodyLarge!.copyWith(
                            color: theme.primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    isCurrentYear()
                        ? DateFormat('MMMM').format(
                            currentWeek[0],
                          )
                        : DateFormat('MMMM yyyy').format(
                            currentWeek[0],
                          ),
                    style: theme.textTheme.titleMedium!.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.primaryColor,
                    ),
                  ),
                  GestureDetector(
                    onTap: isNextDisabled()
                        ? () {
                            onNextClick();
                          }
                        : null,
                    child: Row(
                      children: [
                        Text(
                          "Next",
                          style: theme.textTheme.bodyLarge!.copyWith(
                            color: isNextDisabled()
                                ? theme.primaryColor
                                : Colors.grey,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(
                          width: 4,
                        ),
                        Icon(
                          Icons.arrow_forward_ios,
                          color: isNextDisabled()
                              ? theme.primaryColor
                              : Colors.grey,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 12,
              ),
              CarouselSlider(
                carouselController: carouselController,
                items: [
                  if (listOfWeeks.isNotEmpty)
                    for (int ind = 0; ind < listOfWeeks.length; ind++)
                      Container(
                        height: boxHeight,
                        width: withOfScreen,
                        color: Colors.transparent,
                        child: Row(
                          children: [
                            for (int weekIndex = 0;
                                weekIndex < listOfWeeks[ind].length;
                                weekIndex++)
                              Expanded(
                                child: GestureDetector(
                                  onTap: listOfWeeks[ind][weekIndex]
                                          .isBefore(DateTime.now())
                                      ? () {
                                          onDateSelect(
                                            listOfWeeks[ind][weekIndex],
                                          );
                                        }
                                      : null,
                                  child: Container(
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      color: DateFormat('dd-MM-yyyy').format(
                                                  listOfWeeks[ind]
                                                      [weekIndex]) ==
                                              DateFormat('dd-MM-yyyy')
                                                  .format(selectedDate)
                                          ? theme.primaryColor
                                          : listOfWeeks[ind][weekIndex]
                                                  .isBefore(DateTime.now())
                                              ? theme.primaryColor
                                                  .withOpacity(.2)
                                              : Colors.grey,
                                      border: Border.all(
                                        color: theme.scaffoldBackgroundColor,
                                      ),
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        FittedBox(
                                          child: Text(
                                            // "$weekIndex: ${listOfWeeks[ind][weekIndex] == DateTime.now()}",
                                            "${listOfWeeks[ind][weekIndex].day}",
                                            textAlign: TextAlign.center,
                                            style: theme.textTheme.titleLarge!
                                                .copyWith(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 4,
                                        ),
                                        Text(
                                          DateFormat(
                                            'EEE',
                                          ).format(
                                            listOfWeeks[ind][weekIndex],
                                          ),
                                          textAlign: TextAlign.center,
                                          style: theme.textTheme.bodyLarge!
                                              .copyWith(
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                ],
                options: CarouselOptions(
                  scrollPhysics: const ClampingScrollPhysics(),
                  height: boxHeight,
                  viewportFraction: 1,
                  enableInfiniteScroll: false,
                  reverse: true,
                  onPageChanged: (index, reason) {
                    onWeekChange(index);
                  },
                ),
              ),
            ],
          );
  }
}