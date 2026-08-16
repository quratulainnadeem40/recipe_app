import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recipe_app/features/feedback/controller/feedback_controller.dart';



class FeedbackTextField
    extends GetView<FeedbackController> {
  const FeedbackTextField({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller.messageController,
      maxLines: 5,
      maxLength: 500,
      textInputAction: TextInputAction.newline,
      decoration: InputDecoration(
        hintText: 'Write your feedback here...',
        prefixIcon: const Padding(
          padding: EdgeInsets.only(
            left: 12,
            bottom: 75,
          ),
          child: Icon(
            Icons.feedback_outlined,
          ),
        ),
        filled: true,
        fillColor: Theme.of(context)
            .colorScheme
            .surfaceContainerHighest,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.all(16),
      ),
    );
  }
}