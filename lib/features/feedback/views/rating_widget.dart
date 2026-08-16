import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recipe_app/features/feedback/controller/feedback_controller.dart';


class RatingWidget extends GetView<FeedbackController> {
  const RatingWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            5,
            (index) {
              final rating = index + 1;

              final isSelected =
                  rating <= controller.selectedRating.value;

              return IconButton(
                onPressed: () {
                  controller.setRating(rating);
                },
                icon: Icon(
                  isSelected
                      ? Icons.star_rounded
                      : Icons.star_border_rounded,
                  size: 40,
                  color: isSelected
                      ? Colors.amber
                      : Colors.grey,
                ),
              );
            },
          ),
        );
      },
    );
  }
}