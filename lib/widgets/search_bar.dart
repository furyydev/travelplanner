import 'package:flutter/material.dart';

class SearchBarWidget extends StatelessWidget {
  final String hintText;
  final Function(String) onSearch;
  final TextEditingController? controller;

  const SearchBarWidget({
    super.key,
    required this.hintText,
    required this.onSearch,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final searchController = controller ?? TextEditingController();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(30),
      ),
      child: TextField(
        controller: searchController,
        decoration: InputDecoration(
          hintText: hintText,
          border: InputBorder.none,
          icon: const Icon(Icons.search),
          suffixIcon: searchController.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    searchController.clear();
                    onSearch('');
                  },
                )
              : null,
        ),
        onSubmitted: onSearch,
      ),
    );
  }
}


