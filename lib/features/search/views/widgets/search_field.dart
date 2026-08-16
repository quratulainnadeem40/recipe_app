
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/search_controller.dart'
    as search_controller;

class SearchField extends StatefulWidget {
  const SearchField({super.key});

  @override
  State<SearchField> createState() => _SearchFieldState();
}

class _SearchFieldState extends State<SearchField> {
  late final TextEditingController _textController;

  final search_controller.SearchController controller =
      Get.find<search_controller.SearchController>();

  @override
  void initState() {
    super.initState();

    _textController = TextEditingController(
      text: controller.searchQuery.value,
    );
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  // =========================================================
  // SEARCH
  // =========================================================

  void _search() {
    controller.searchRecipes(
      _textController.text,
    );
  }

  // =========================================================
  // CLEAR SEARCH
  // =========================================================

  void _clear() {
    _textController.clear();
    controller.clearSearch();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _textController,
      textInputAction: TextInputAction.search,

      // -------------------------------------------------------
      // SEARCH WHEN KEYBOARD SEARCH IS PRESSED
      // -------------------------------------------------------

      onSubmitted: (_) {
        _search();
      },

      decoration: InputDecoration(
        hintText: 'Search recipes...',

        // -----------------------------------------------------
        // SEARCH ICON
        // -----------------------------------------------------

        prefixIcon: const Icon(
          Icons.search_rounded,
        ),

        // -----------------------------------------------------
        // CLEAR BUTTON
        // -----------------------------------------------------

        suffixIcon: Obx(
          () {
            if (controller.searchQuery.value.isEmpty) {
              return const SizedBox.shrink();
            }

            return IconButton(
              onPressed: _clear,
              tooltip: 'Clear search',
              icon: const Icon(
                Icons.clear_rounded,
              ),
            );
          },
        ),

        // -----------------------------------------------------
        // FIELD STYLE
        // -----------------------------------------------------

        filled: true,

        fillColor: Theme.of(context)
            .colorScheme
            .surfaceContainerHighest,

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),

        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),

        contentPadding: const EdgeInsets.symmetric(
          vertical: 14,
          horizontal: 16,
        ),
      ),
    );
  }
}