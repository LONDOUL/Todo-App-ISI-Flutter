import 'package:flutter/material.dart';
import 'package:todo_app/models/categories.dart';
import 'package:todo_app/common/commons.dart';

class SliderItem extends StatelessWidget {
  final Categories category;
  final int tasksNumber;
  final double progress;
  const SliderItem(
      {Key? key,
      required this.category,
      required this.tasksNumber,
      required this.progress})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20.0),
      width: screenWidth * 0.5,
      decoration: BoxDecoration(
          color: primaryBackground,
          borderRadius: const BorderRadius.all(Radius.circular(20.0)),
          boxShadow: kElevationToShadow[8]),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 5.0,
            ),
            Text(
              "$tasksNumber Tasks",
              style: TextStyle(
                color: iconColor,
                fontSize: 14.0,
              ),
            ),
            const SizedBox(
              height: 5.0,
            ),
            Text(
              category.name,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24.0,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(
              height: 10.0,
            ),
            LinearProgressIndicator(
              value: progress,
              color: category == Categories.Business
                  ? businessIndicator
                  : personalIndicator,
              backgroundColor: Colors.white.withOpacity(.3),
              minHeight: 3.0,
            ),
          ],
        ),
      ),
    );
  }
}
