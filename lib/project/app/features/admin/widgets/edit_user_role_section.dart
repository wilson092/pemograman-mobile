import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pemob/project/app/core/constants/app_dimensions.dart';
import 'package:pemob/project/app/core/theme/app_colors.dart';
import 'package:pemob/project/app/core/theme/app_text_styles.dart';
import 'package:pemob/project/app/data/models/activity_log.dart';
import 'package:pemob/project/app/data/models/app_user.dart';
import 'package:pemob/project/app/data/providers.dart';
import 'package:pemob/project/app/widgets/primary_button.dart';

class EditUserRoleSection extends ConsumerStatefulWidget {
  const EditUserRoleSection({super.key});

  @override
  ConsumerState<EditUserRoleSection> createState() => _EditUserRoleSectionState();
}

class _EditUserRoleSectionState extends ConsumerState<EditUserRoleSection> {
  int? _selectedUserId;
  UserRole _selectedRole = UserRole.user;

  void _onUserChanged(int? newId, List<AppUser> users) {
    if (newId == null) return;
    final user = users.firstWhere((u) => u.id == newId);
    setState(() {
      _selectedUserId = newId;
      _selectedRole = user.role;
    });
  }

  void _saveRole(List<AppUser> users) {
    final messenger = ScaffoldMessenger.of(context);
    if (_selectedUserId == null) {
      messenger
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(content: Text('Pilih pengguna terlebih dahulu')),
        );
      return;
    }

    final user = users.firstWhere((u) => u.id == _selectedUserId);
    final oldRole = user.role;
    final newRole = _selectedRole;

    ref.read(adminUsersProvider.notifier).state = users.map((u) {
      return u.id == _selectedUserId ? u.copyWith(role: newRole) : u;
    }).toList();

    final now = DateTime.now();
    final timeStr =
        '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
    final log = ActivityLog(
      id: now.millisecondsSinceEpoch.toString(),
      actionCode: 'USER_ROLE_CHANGE',
      badgeText: 'Role',
      badgeStyle: ActivityBadgeStyle.neutral,
      message: 'Mengubah peran ${user.name}: ${oldRole.label} -> ${newRole.label}',
      userId: 'Admin',
      ipAddress: '127.0.0.1',
      time: timeStr,
      category: ActivityCategory.admin,
    );
    ref.read(activityLogsProvider.notifier).state = [log, ...ref.read(activityLogsProvider)];

    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text('Peran ${user.name} berhasil diubah menjadi ${newRole.label}')),
      );
  }

  @override
  Widget build(BuildContext context) {
    final users = ref.watch(adminUsersProvider);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.cardPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Ubah Peran Pengguna', style: AppTextStyles.titleCard.copyWith(fontSize: 15)),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceMuted,
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Text(
                    'FORM EDIT',
                    style: AppTextStyles.caption.copyWith(
                      fontSize: 9,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Text('Pengguna', style: AppTextStyles.label.copyWith(color: AppColors.textSecondary)),
            const SizedBox(height: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(AppDimensions.radiusInput),
                border: Border.all(color: AppColors.border, width: AppDimensions.borderWidth),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<int>(
                  value: _selectedUserId,
                  isExpanded: true,
                  hint: const Text('Pilih pengguna'),
                  icon: const Icon(Icons.arrow_drop_down, color: AppColors.textSecondary),
                  style: AppTextStyles.body.copyWith(color: AppColors.textPrimary, fontSize: 13),
                  onChanged: (id) => _onUserChanged(id, users),
                  items: users.map((u) {
                    return DropdownMenuItem<int>(
                      value: u.id,
                      child: Text('${u.name} (${u.role.label})'),
                    );
                  }).toList(),
                ),
              ),
            ),
            const SizedBox(height: 14),
            Text('Peran', style: AppTextStyles.label.copyWith(color: AppColors.textSecondary)),
            Row(
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Radio<UserRole>(
                      value: UserRole.admin,
                      groupValue: _selectedRole,
                      activeColor: AppColors.primary,
                      onChanged: (v) => v != null ? setState(() => _selectedRole = v) : null,
                    ),
                    const Text('Admin', style: TextStyle(fontSize: 13)),
                  ],
                ),
                const SizedBox(width: 20),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Radio<UserRole>(
                      value: UserRole.user,
                      groupValue: _selectedRole,
                      activeColor: AppColors.primary,
                      onChanged: (v) => v != null ? setState(() => _selectedRole = v) : null,
                    ),
                    const Text('User', style: TextStyle(fontSize: 13)),
                  ],
                ),
              ],
            ),
            Text(
              'Setiap pengguna memiliki tepat satu peran.',
              style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary, fontSize: 11),
            ),
            const SizedBox(height: 14),
            PrimaryButton(
              text: 'Simpan Peran',
              leadingIcon: const Icon(Icons.save_outlined, size: 18, color: AppColors.onPrimary),
              onPressed: () => _saveRole(users),
            ),
          ],
        ),
      ),
    );
  }
}
