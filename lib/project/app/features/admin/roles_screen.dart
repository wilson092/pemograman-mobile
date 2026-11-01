import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pemob/project/app/core/constants/app_dimensions.dart';
import 'package:pemob/project/app/core/theme/app_colors.dart';
import 'package:pemob/project/app/data/models/app_user.dart';
import 'package:pemob/project/app/data/providers.dart';
import 'package:pemob/project/app/features/admin/widgets/edit_user_role_section.dart';
import 'package:pemob/project/app/features/admin/widgets/role_card.dart';
import 'package:pemob/project/app/widgets/admin_top_bar.dart';

class RolesScreen extends ConsumerWidget {
  const RolesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final roles = ref.watch(adminRolesProvider);
    final users = ref.watch(adminUsersProvider);

    final adminCount = users.where((u) => u.role == UserRole.admin).length;
    final userCount = 148 - adminCount;

    final adminRole = roles.firstWhere((r) => r.id == 1, orElse: () => roles[0]);
    final userRole = roles.firstWhere((r) => r.id == 2, orElse: () => roles[1]);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AdminTopBar(
        title: 'Manajemen Peran',
        actions: [
          IconButton(
            icon: const Icon(Icons.person_outline, color: AppColors.textPrimary, size: 22),
            onPressed: () {},
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.screenPaddingH,
          vertical: AppDimensions.space16,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Admin Role Card
            RoleCardWidget(
              role: adminRole,
              userCount: adminCount,
            ),
            const SizedBox(height: AppDimensions.space12),

            // User Role Card
            RoleCardWidget(
              role: userRole,
              userCount: userCount,
            ),
            const SizedBox(height: AppDimensions.space20),

            // Edit User Role Form Section
            const EditUserRoleSection(),
            const SizedBox(height: AppDimensions.space24),
          ],
        ),
      ),
    );
  }
}

