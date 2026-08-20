
import 'package:flutter/material.dart';

class SearchSuggestion extends StatelessWidget {
  final List<String> suggestions;
  final ValueChanged<String> onTap;

  const SearchSuggestion({
    super.key,
    required this.suggestions,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        final item = suggestions[index];
        return ListTile(
          leading: const Icon(Icons.north_west, size: 18),
          title: Text(item),
          onTap: () => onTap(item),
        );
      },
    );
  }
}