import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class CategoryChip extends StatelessWidget {
  final String label;
  final IconData? icon;
  final bool isSelected;
  final VoidCallback? onTap;

  const CategoryChip({
    super.key,
    required this.label,
    this.icon,
    this.isSelected = false,
    this.onTap,
  });

  IconData _getCategoryIcon(String cat) {
    if (icon != null) return icon!;
    switch (cat.toLowerCase().trim()) {
      case 'all':
        return Icons.grid_view_rounded;
      case 'electronics':
        return Icons.devices_rounded;
      case 'wallets':
        return Icons.account_balance_wallet_rounded;
      case 'pets':
        return Icons.pets_rounded;
      case 'documents':
        return Icons.description_rounded;
      case 'clothing':
        return Icons.checkroom_rounded;
      case 'keys':
        return Icons.key_rounded;
      default:
        return Icons.category_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final catIcon = _getCategoryIcon(label);

    return AnimatedScale(
      scale: isSelected ? 1.03 : 1.0,
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOutCubic,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(30),
          splashColor: AppColors.primary.withValues(alpha: 0.15),
          highlightColor: Colors.transparent,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeOutCubic,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
            decoration: BoxDecoration(
              gradient: isSelected
                  ? const LinearGradient(
                      colors: [AppColors.primary, Color(0xFF2563EB)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    )
                  : null,
              color: isSelected
                  ? null
                  : (isDark
                        ? AppColors.darkSurfaceVariant.withValues(alpha: 0.7)
                        : Colors.white),
              borderRadius: BorderRadius.circular(30),
              border: Border.all(
                color: isSelected
                    ? AppColors.primaryContainer.withValues(alpha: 0.5)
                    : (isDark
                          ? AppColors.outlineVariant.withValues(alpha: 0.15)
                          : AppColors.outlineVariant.withValues(alpha: 0.35)),
                width: isSelected ? 1.2 : 1.0,
              ),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.35),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ]
                  : [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.03),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  catIcon,
                  size: 16,
                  color: isSelected
                      ? Colors.white
                      : (isDark ? AppColors.darkOnSurface : AppColors.primary),
                ),
                const SizedBox(width: 7),
                Text(
                  label,
                  style: TextStyle(
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                    fontSize: 13,
                    color: isSelected
                        ? Colors.white
                        : (isDark
                              ? AppColors.darkOnSurface
                              : AppColors.onSurfaceVariant),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
