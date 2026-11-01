import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pemob/project/app/core/theme/app_colors.dart';
import 'package:pemob/project/app/core/theme/app_text_styles.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppColors.background,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: AppColors.surfaceTint,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.cloud_outlined,
                      color: AppColors.accentBlueLight,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'WeatherInsight',
                    style: AppTextStyles.titleCard.copyWith(
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout, color: AppColors.error),
              title: Text(
                'Keluar',
                style: AppTextStyles.bodyStrong.copyWith(color: AppColors.error),
              ),
              onTap: () {
                Navigator.of(context).pop();
                context.go('/login');
              },
            ),
          ],
        ),
      ),
    );
  }
}
