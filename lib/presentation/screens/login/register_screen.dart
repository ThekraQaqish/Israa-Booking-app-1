import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:isra_fields_booking/core/constants/app_constants.dart';
import 'package:isra_fields_booking/core/theme/app_colors.dart';
import 'package:isra_fields_booking/core/utils/validators.dart';
import 'package:isra_fields_booking/core/widgets/custom_button.dart';
import 'package:isra_fields_booking/presentation/providers/auth_provider.dart';
import 'package:isra_fields_booking/presentation/providers/auth_state.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _idCtrl = TextEditingController();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();

  String _selectedDepartment = AppConstants.departments.first;
  String _selectedYear = AppConstants.studyYears.first;
  bool _obscurePass = true;

  @override
  void dispose() {
    _idCtrl.dispose();
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();
    if (!(_formKey.currentState?.validate() ?? false)) return;

    ref.read(authProvider.notifier).clearError();
    await ref.read(authProvider.notifier).register(
          studentId: _idCtrl.text.trim(),
          name: _nameCtrl.text.trim(),
          email: _emailCtrl.text.trim().isEmpty
              ? '${_idCtrl.text.trim()}@isra.edu.jo'
              : _emailCtrl.text.trim(),
          department: _selectedDepartment,
          year: _selectedYear,
          password: _passCtrl.text,
        );
  }

  void _onAuthChanged(AuthState? prev, AuthState next) {
    if (next is AuthError) {
      ScaffoldMessenger.of(context)
        ..clearSnackBars()
        ..showSnackBar(SnackBar(
          content: Text(next.message),
          backgroundColor: AppColors.error,
          duration: const Duration(seconds: 4),
        ));
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AuthState>(authProvider, _onAuthChanged);
    final authState = ref.watch(authProvider);
    final isLoading = authState is AuthLoading;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(context),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    const SizedBox(height: 24),
                    _buildTitle(),
                    const SizedBox(height: 28),
                    _buildForm(isLoading),
                    const SizedBox(height: 24),
                    AppButton(
                      label: 'إنشاء حساب',
                      onPressed: isLoading ? null : _submit,
                      isLoading: isLoading,
                    ),
                    const SizedBox(height: 16),
                    _buildLoginLink(context),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Container(
      color: AppColors.primary,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios_new,
                color: Colors.white, size: 18),
            onPressed: () => context.pop(),
          ),
          const Text('حساب جديد',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }

  Widget _buildTitle() {
    return Column(
      children: [
        Container(
          width: 72,
          height: 72,
          decoration: BoxDecoration(
            color: AppColors.primaryContainer,
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Icon(Icons.person_add_outlined,
              color: AppColors.primary, size: 36),
        ),
        const SizedBox(height: 14),
        const Text('أنشئ حسابك الآن',
            style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary)),
        const SizedBox(height: 6),
        const Text('أدخل بياناتك لتسجيل حساب طالب جديد',
            style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
            textAlign: TextAlign.center),
      ],
    );
  }

  Widget _buildForm(bool isLoading) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: AppColors.shadow, blurRadius: 16,
              offset: const Offset(0, 4)),
        ],
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildFieldLabel('رقم الطالب *', Icons.badge_outlined),
            const SizedBox(height: 8),
            TextFormField(
              controller: _idCtrl,
              enabled: !isLoading,
              style: const TextStyle(
                  fontSize: 18, fontWeight: FontWeight.w700,
                  letterSpacing: 1.5, color: AppColors.primary),
              decoration: InputDecoration(
                hintText: AppConstants.studentIdHint,
                hintStyle: const TextStyle(
                    color: AppColors.textHint, letterSpacing: 1,
                    fontWeight: FontWeight.w400, fontSize: 15),
                prefixIcon: const Icon(Icons.badge_outlined,
                    color: AppColors.primary),
              ),
              validator: AppValidators.validateStudentId,
            ),
            const SizedBox(height: 18),

            _buildFieldLabel('الاسم الكامل بالعربي *', Icons.person_outline),
            const SizedBox(height: 8),
            TextFormField(
              controller: _nameCtrl,
              enabled: !isLoading,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                hintText: 'مثال: محمد أحمد العلي',
                prefixIcon: Icon(Icons.drive_file_rename_outline,
                    color: AppColors.primary),
              ),
              validator: AppValidators.validateName,
            ),
            const SizedBox(height: 18),

            _buildFieldLabel('البريد الإلكتروني (اختياري)', Icons.email_outlined),
            const SizedBox(height: 8),
            TextFormField(
              controller: _emailCtrl,
              enabled: !isLoading,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                hintText: '${AppConstants.studentIdHint}@isra.edu.jo',
                hintStyle: const TextStyle(color: AppColors.textHint, fontSize: 12),
                prefixIcon: const Icon(Icons.email_outlined,
                    color: AppColors.primary),
              ),
            ),
            const SizedBox(height: 18),

            _buildFieldLabel('التخصص *', Icons.school_outlined),
            const SizedBox(height: 8),
            _buildDropdown(
              value: _selectedDepartment,
              items: AppConstants.departments,
              icon: Icons.school_outlined,
              onChanged: isLoading ? null : (v) => setState(() => _selectedDepartment = v!),
            ),
            const SizedBox(height: 18),

            _buildFieldLabel('السنة الدراسية *', Icons.calendar_month_outlined),
            const SizedBox(height: 8),
            _buildDropdown(
              value: _selectedYear,
              items: AppConstants.studyYears,
              icon: Icons.calendar_month_outlined,
              onChanged: isLoading ? null : (v) => setState(() => _selectedYear = v!),
            ),
            const SizedBox(height: 18),

            _buildFieldLabel('كلمة المرور *', Icons.lock_outline),
            const SizedBox(height: 8),
            TextFormField(
              controller: _passCtrl,
              enabled: !isLoading,
              obscureText: _obscurePass,
              textInputAction: TextInputAction.done,
              onFieldSubmitted: (_) => isLoading ? null : _submit(),
              decoration: InputDecoration(
                hintText: '6 أحرف على الأقل',
                prefixIcon: const Icon(Icons.lock_outline,
                    color: AppColors.primary),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscurePass ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                    color: AppColors.textHint,
                  ),
                  onPressed: () => setState(() => _obscurePass = !_obscurePass),
                ),
              ),
              validator: AppValidators.validatePassword,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFieldLabel(String label, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 15, color: AppColors.primary),
        const SizedBox(width: 6),
        Text(label,
            style: const TextStyle(
                fontSize: 13, fontWeight: FontWeight.w600,
                color: AppColors.textSecondary)),
      ],
    );
  }

  Widget _buildDropdown({
    required String value,
    required List<String> items,
    required IconData icon,
    required void Function(String?)? onChanged,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      isExpanded: true,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: AppColors.primary),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      ),
      items: items
          .map((item) => DropdownMenuItem(
                value: item,
                child: Text(item,
                    style: const TextStyle(fontSize: 14),
                    overflow: TextOverflow.ellipsis),
              ))
          .toList(),
      onChanged: onChanged,
      validator: (v) => v == null ? 'الرجاء الاختيار' : null,
    );
  }

  Widget _buildLoginLink(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('لديك حساب مسبقاً؟',
            style: TextStyle(fontSize: 14, color: AppColors.textSecondary)),
        const SizedBox(width: 6),
        GestureDetector(
          onTap: () => context.pop(),
          child: const Text(
            'سجّل الدخول',
            style: TextStyle(
                fontSize: 14, fontWeight: FontWeight.w700,
                color: AppColors.primary),
          ),
        ),
      ],
    );
  }
}