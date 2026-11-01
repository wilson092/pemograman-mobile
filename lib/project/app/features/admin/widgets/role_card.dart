import 'package:flutter/material.dart';
import 'package:pemob/project/app/core/constants/app_dimensions.dart';
import 'package:pemob/project/app/core/theme/app_colors.dart';
import 'package:pemob/project/app/core/theme/app_text_styles.dart';
import 'package:pemob/project/app/data/models/role.dart';

class RoleCardWidget extends StatelessWidget {
  final Role role;
  final int userCount;

  const RoleCardWidget({
    super.key,
    required this.role,
    required this.userCount,
  });

  @override
  Widget build(BuildContext context) {
    final isAdmin = role.id == 1;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.cardPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Row: Role Name + Badge & User Count + role_id
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      role.name,
                      style: AppTextStyles.titleCard.copyWith(fontSize: 16),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: isAdmin ? AppColors.primary : AppColors.riskLowBg,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        role.badge,
                        style: AppTextStyles.caption.copyWith(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: isAdmin ? AppColors.onPrimary : AppColors.riskLow,
                        ),
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '$userCount pengguna',
                      style: AppTextStyles.bodyStrong.copyWith(fontSize: 13),
                    ),
                    Text(
                      'role_id: ${role.id}',
                      style: AppTextStyles.caption.copyWith(
                        fontFamily: 'monospace',
                        color: AppColors.textSecondary,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Description
            Text(
              role.description,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.textSecondary,
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 12),
            const Divider(height: 1),
            const SizedBox(height: 10),

            // Bottom Row: Avatars & Permission
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Avatar pile
                Row(
                  children: [
                    _buildMiniAvatar(isAdmin ? 'AU' : 'AP'),
                    Transform.translate(
                      offset: const Offset(-8, 0),
                      child: _buildMiniAvatar(isAdmin ? 'RM' : 'SR'),
                    ),
                    if (!isAdmin)
                      Transform.translate(
                        offset: const Offset(-16, 0),
                        child: _buildMiniAvatar('+144', isMore: true),
                      ),
                  ],
                ),

                // Permission label
                Row(
                  children: [
                    Icon(
                      isAdmin ? Icons.verified_user_outlined : Icons.visibility_outlined,
                      size: 15,
                      color: AppColors.textSecondary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      role.permissionLabel,
                      style: AppTextStyles.caption.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMiniAvatar(String text, {bool isMore = false}) {
    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        color: isMore ? AppColors.surfaceMuted : AppColors.border,
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.background, width: 1.5),
      ),
      child: Center(
        child: Text(
          text,
          style: TextStyle(
            fontSize: isMore ? 8 : 9,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
      ),
    );
  }
}
