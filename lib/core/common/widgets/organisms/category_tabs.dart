import 'package:flutter/material.dart';
import 'package:blogapps/core/common/entities/category.dart';

class CategoryTabs extends StatefulWidget {
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
  State<CategoryTabs> createState() => _CategoryTabsState();
}

class _CategoryTabsState extends State<CategoryTabs> {
  final ScrollController _scrollController = ScrollController();
  final Map<int, GlobalKey> _itemKeys = {};

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToSelected(int index) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final key = _itemKeys[index];
      if (key == null) return;

      final context = key.currentContext;
      if (context == null) return;

      final RenderBox box = context.findRenderObject() as RenderBox;
      final position = box.localToGlobal(Offset.zero, ancestor: null);
      final widgetWidth = box.size.width;

      final screenWidth = MediaQuery.of(this.context).size.width;
      final currentScroll = _scrollController.offset;

      // Hitung target agar chip berada di tengah layar
      final targetScroll = currentScroll + (position.dx - (screenWidth / 2) + (widgetWidth / 2));

      _scrollController.animateTo(
        targetScroll.clamp(0.0, _scrollController.position.maxScrollExtent),
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOutCubic,
      );
    });
  }

  @override
  void didUpdateWidget(CategoryTabs oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedCategoryId != oldWidget.selectedCategoryId) {
      final index = _getSelectedIndex();
      _scrollToSelected(index);
    }
  }

  int _getSelectedIndex() {
    if (widget.selectedCategoryId == null) return 0;
    final catIndex = widget.categories.indexWhere((c) => c.id == widget.selectedCategoryId);
    return catIndex != -1 ? catIndex + 1 : 0;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 52,
      child: ListView.builder(
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: widget.categories.length + 1,
        itemBuilder: (context, index) {
          final isAll = index == 0;
          final category = isAll ? null : widget.categories[index - 1];
          final isSelected = isAll
              ? widget.selectedCategoryId == null
              : widget.selectedCategoryId == category?.id;

          _itemKeys[index] = GlobalKey();

          return Padding(
            key: _itemKeys[index],
            padding: const EdgeInsets.only(right: 8, bottom: 4),
            child: _CategoryChip(
              label: isAll ? 'All Topics' : category!.name,
              isSelected: isSelected,
              onTap: () {
                widget.onCategorySelected(isAll ? null : category!.id);
                _scrollToSelected(index);
              },
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

    final unselectedBg = isDark
        ? Colors.white.withValues(alpha: 0.1)
        : Colors.white;

    final textColor = isDark
        ? (isSelected ? Colors.white : Colors.white.withValues(alpha: 0.9))
        : (isSelected ? Colors.white : theme.colorScheme.onSurface);

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? theme.colorScheme.primary : unselectedBg,
          borderRadius: BorderRadius.circular(25),
          border: Border.all(
            color: isSelected
                ? theme.colorScheme.primary
                : (isDark
                      ? Colors.white.withValues(alpha: 0.1)
                      : theme.colorScheme.outlineVariant),
            width: 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: theme.colorScheme.primary.withValues(alpha: 0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
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
