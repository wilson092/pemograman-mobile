import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pemob/project/app/core/constants/app_dimensions.dart';
import 'package:pemob/project/app/core/theme/app_colors.dart';
import 'package:pemob/project/app/core/theme/app_text_styles.dart';
import 'package:pemob/project/app/widgets/app_text_field.dart';
import 'package:pemob/project/app/widgets/primary_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _email = TextEditingController(text: 'alexander@insight.id');
  final _pwd = TextEditingController(text: '••••••••');
  bool _obscure = true;
  String? _err;

  @override
  void dispose() {
    _email.dispose();
    _pwd.dispose();
    super.dispose();
  }

  void _onAdminLogin() {
    if (_email.text.trim().isEmpty || _pwd.text.trim().isEmpty) {
      setState(() => _err = 'Email atau password tidak sesuai');
      return;
    }
    setState(() => _err = null);
    context.go('/admin');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: AppDimensions.screenPaddingH * 1.5),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: AppColors.surfaceTint,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(Icons.cloud_outlined, size: 38, color: AppColors.accentBlueLight),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'WeatherInsight',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: AppTextStyles.fontFamily,
                    fontSize: 26,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Pantau cuaca, analisis risiko, dan kualitas udara dalam satu aplikasi',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.body.copyWith(color: AppColors.textSecondary, height: 1.4),
                ),
                const SizedBox(height: 32),
                AppTextField(
                  label: 'Email',
                  hintText: 'alexander@insight.id',
                  controller: _email,
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Password', style: AppTextStyles.bodyStrong.copyWith(fontSize: 12)),
                    Text(
                      'Lupa kata sandi?',
                      style: AppTextStyles.caption.copyWith(color: AppColors.accentBlueLight, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                AppTextField(
                  hintText: '••••••••',
                  controller: _pwd,
                  obscureText: _obscure,
                  suffixIcon: IconButton(
                    icon: Icon(_obscure ? Icons.visibility_outlined : Icons.visibility_off_outlined, size: 20),
                    onPressed: () => setState(() => _obscure = !_obscure),
                  ),
                ),
                if (_err != null) ...[
                  const SizedBox(height: 8),
                  Text(_err!, style: AppTextStyles.caption.copyWith(color: AppColors.error, fontWeight: FontWeight.w500)),
                ],
                const SizedBox(height: 24),
                PrimaryButton(
                  text: 'Masuk →',
                  backgroundColor: AppColors.accentBlue,
                  onPressed: _onAdminLogin,
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    const Expanded(child: Divider()),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Text('atau', style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary)),
                    ),
                    const Expanded(child: Divider()),
                  ],
                ),
                const SizedBox(height: 20),
                PrimaryButton.outlined(
                  text: 'Masuk dengan Google',
                  leadingIcon: Text(
                    'G',
                    style: AppTextStyles.bodyStrong.copyWith(fontSize: 18, color: Colors.red[600]),
                  ),
                  onPressed: () => context.go('/home'),
                ),
                const SizedBox(height: 32),
                Text(
                  'Login wajib untuk mengakses fitur aplikasi',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
