import 'package:flutter/material.dart';
import 'package:blogapps/features/home/data/models/category_model.dart';

class CategoryTabs extends StatelessWidget {
  final List<Category> categories;
  final String? selectedCategoryId;
  final Function(String?) onCategorySelected;

  const CategoryTabs({
    super.key,
    required this.categories,
    required this.selectedCategoryId,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 52, // Slightly increased height
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: categories.length + 1,
        itemBuilder: (context, index) {
          final isAll = index == 0;
          final category = isAll ? null : categories[index - 1];
          final isSelected = isAll 
              ? selectedCategoryId == null 
              : selectedCategoryId == category?.id;
          
          return Padding(
            padding: const EdgeInsets.only(right: 8, bottom: 4), // Added slight bottom padding for shadow
            child: _CategoryChip(
              label: isAll ? 'All Topics' : category!.name,
              isSelected: isSelected,
              onTap: () => onCategorySelected(isAll ? null : category!.id),
            ),
          );
        },
      ),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _CategoryChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    // Warna background untuk state tidak terpilih
    final unselectedBg = isDark 
        ? Colors.white.withValues(alpha: 0.1)
        : Colors.white;
    
    final textColor = isDark
        ? (isSelected ? Colors.white : Colors.white.withValues(alpha: 0.9))
        : (isSelected ? Colors.white : theme.colorScheme.onSurface);

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque, // Ensure clicks are captured reliably
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? theme.colorScheme.primary : unselectedBg,
          borderRadius: BorderRadius.circular(25),
          border: Border.all(
            color: isSelected 
                ? theme.colorScheme.primary 
                : (isDark ? Colors.white.withValues(alpha: 0.1) : theme.colorScheme.outlineVariant),
            width: 1,
          ),
          boxShadow: isSelected ? [
            BoxShadow(
              color: theme.colorScheme.primary.withValues(alpha: 0.3),
              blurRadius: 10,
              offset: const Offset(0, 4),
            )
          ] : null,
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: textColor,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }
}
