import 'package:get/get.dart';
import 'package:recipe_app/features/feedback/controller/feedback_controller.dart';
import 'package:recipe_app/features/feedback/repositories/feedback_repositories.dart';


class FeedbackBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FeedbackRepository>(
      () => FeedbackRepository(),
    );

    Get.lazyPut<FeedbackController>(
      () => FeedbackController(
        repository: Get.find<FeedbackRepository>(),
      ),
    );
  }
}