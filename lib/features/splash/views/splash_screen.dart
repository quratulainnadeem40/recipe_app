import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recipe_app/features/splash/controllers/splash_controller.dart';

class SplashScreen extends StatelessWidget {
  SplashScreen({super.key});

  final SplashController controller =
      Get.put(SplashController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox.expand(
        child: Stack(
          fit: StackFit.expand,
          children: [

            // COOKmate splash image
            Image.asset(
              "assets\Cookmate.png",
              fit: BoxFit.cover,
            ),

            // Loading UI
            Positioned(
              left: 55,
              right: 55,
              bottom: 125,
              child: Obx(
                () => Column(
                  children: [

                    // Loading bar
                    Container(
                      height: 9,
                      decoration: BoxDecoration(
                        color: const Color(0xFF40104F),
                        borderRadius:
                            BorderRadius.circular(20),
                        border: Border.all(
                          color: const Color(0xFF7B1FA2),
                          width: 1,
                        ),
                      ),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: FractionallySizedBox(
                          widthFactor:
                              controller.progress.value,
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [
                                  Color(0xFFFF8A00),
                                  Color(0xFFFFB300),
                                ],
                              ),
                              borderRadius:
                                  BorderRadius.circular(20),
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Loading percentage
                    Text(
                      'Loading ${(controller.progress.value * 100).toInt()}%',
                      style: const TextStyle(
                        color: Color(0xFFFFF8EE),
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 1,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}