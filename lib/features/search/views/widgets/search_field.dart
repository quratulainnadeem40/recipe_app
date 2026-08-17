import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:recipe_app/features/search/controllers/search_controller.dart'
    as search_controller;

class SearchField extends StatefulWidget {
  const SearchField({
    super.key,
  });

  @override
  State<SearchField> createState() => _SearchFieldState();
}

class _SearchFieldState extends State<SearchField> {
  late final TextEditingController _textController;
  late final FocusNode _focusNode;

  final search_controller.SearchController controller =
      Get.find<search_controller.SearchController>();

  @override
  void initState() {
    super.initState();

    _textController = TextEditingController(
      text: controller.searchQuery.value,
    );

    _focusNode = FocusNode();

    _focusNode.addListener(() {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  // =========================================================
  // TEXT CHANGE
  // =========================================================

  void _onChanged(String value) {
    controller.onSearchTextChanged(value);

    if (mounted) {
      setState(() {});
    }
  }

  // =========================================================
  // NORMAL SEARCH
  // =========================================================

  void _search() {
    final query = _textController.text.trim();

    if (query.isEmpty) {
      return;
    }

    controller.searchRecipes(query);

    _focusNode.unfocus();

    if (mounted) {
      setState(() {});
    }
  }

  // =========================================================
  // CLEAR SEARCH
  // =========================================================

  void _clear() {
    _textController.clear();

    controller.clearSearch();

    _focusNode.requestFocus();

    if (mounted) {
      setState(() {});
    }
  }

  // =========================================================
  // BUILD
  // =========================================================

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return TextField(
      controller: _textController,
      focusNode: _focusNode,
      textInputAction: TextInputAction.search,

      onChanged: _onChanged,

      onSubmitted: (_) {
        _search();
      },

      decoration: InputDecoration(
        hintText: 'Search recipes...',

        prefixIcon: const Icon(
          Icons.search_rounded,
        ),

        suffixIcon: _textController.text.isEmpty
            ? null
            : IconButton(
                onPressed: _clear,
                tooltip: 'Clear search',
                icon: const Icon(
                  Icons.clear_rounded,
                ),
              ),

        filled: true,

        fillColor:
            theme.colorScheme.surfaceContainerHighest,

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

        contentPadding:
            const EdgeInsets.symmetric(
          vertical: 14,
          horizontal: 16,
        ),
      ),
    );
  }
}