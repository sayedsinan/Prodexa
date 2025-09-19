import 'package:flutter/material.dart';
import 'package:task_management_app/core/constants.dart' show AppConstants;

class SearchAndFilterBar extends StatelessWidget {
  final TextEditingController searchController;
  final Function(String) onSearch;
  final VoidCallback onFilter;

  const SearchAndFilterBar({
    super.key,
    required this.searchController,
    required this.onSearch,
    required this.onFilter,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'Search tasks...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppConstants.borderRadius),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: AppConstants.defaultPadding,
                  vertical: 12,
                ),
              ),
              onChanged: onSearch,
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            onPressed: onFilter,
            icon: const Icon(Icons.filter_list),
          ),
        ],
      ),
    );
  }
}