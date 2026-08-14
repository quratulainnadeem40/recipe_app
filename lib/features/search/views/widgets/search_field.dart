
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

    _textController = TextEditingController();
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _search() {
    controller.searchRecipes(
      _textController.text,
    );
  }

  void _clear() {
    _textController.clear();
    controller.clearSearch();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _textController,
      textInputAction: TextInputAction.search,
      onSubmitted: (_) {
        _search();
      },
      decoration: InputDecoration(
        hintText: 'Search recipes...',
        prefixIcon: const Icon(Icons.search),

        suffixIcon: Obx(
          () {
            if (controller.searchQuery.value.isEmpty) {
              return const SizedBox.shrink();
            }

            return IconButton(
              onPressed: _clear,
              icon: const Icon(Icons.clear),
            );
          },
        ),

        filled: true,

        fillColor: Theme.of(context)
            .colorScheme
            .surfaceContainerHighest,

        border: OutlineInputBorder(
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