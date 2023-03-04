import 'package:flutter/material.dart';
import 'package:horizontal_week_calendar/horizontal_week_calendar.dart';
import 'package:intl/intl.dart';

class HorizontalWeekCalendarPackage extends StatefulWidget {
  const HorizontalWeekCalendarPackage({super.key});

  @override
  State<HorizontalWeekCalendarPackage> createState() =>
      _HorizontalWeekCalendarPackageState();
}

class _HorizontalWeekCalendarPackageState
    extends State<HorizontalWeekCalendarPackage> {
  var selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Horizontal Week Calendar",
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              CustomWeekCalender(
                onDateChange: (date) {
                  setState(() {
                    selectedDate = date;
                  });
                },
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Selected Date",
                      textAlign: TextAlign.center,
                      style: theme.textTheme.titleMedium!.copyWith(
                        color: theme.primaryColor,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      DateFormat('dd MMM yyyy').format(selectedDate),
                      textAlign: TextAlign.center,
                      style: theme.textTheme.titleLarge!.copyWith(
                        color: theme.primaryColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
