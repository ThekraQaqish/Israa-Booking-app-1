import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:isra_fields_booking/core/constants/app_constants.dart';
import 'package:isra_fields_booking/core/constants/route_constants.dart';
import 'package:isra_fields_booking/core/theme/app_colors.dart';
import 'package:isra_fields_booking/core/utils/validators.dart';
import 'package:isra_fields_booking/core/widgets/custom_button.dart';
import 'package:isra_fields_booking/presentation/providers/auth_provider.dart';
import 'package:isra_fields_booking/presentation/providers/auth_state.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _idController = TextEditingController();

  late AnimationController _shakeCtrl;
  late Animation<double> _shakeAnim;

  @override
  void initState() {
    super.initState();
    _shakeCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 400));
    _shakeAnim = Tween<double>(begin: 0, end: 1).animate(_shakeCtrl);
  }

  @override
  void dispose() {
    _idController.dispose();
    _shakeCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();
    if (!(_formKey.currentState?.validate() ?? false)) {
      _shakeCtrl.forward(from: 0);
      return;
    }
    ref.read(authProvider.notifier).clearError();
    await ref.read(authProvider.notifier).login(_idController.text.trim());
  }

  void _onAuthChanged(AuthState? prev, AuthState next) {
    if (next is AuthError) {
      _shakeCtrl.forward(from: 0);
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
            _buildTopBar(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    const SizedBox(height: 24),
                    _buildSportsHero(),
                    const SizedBox(height: 28),
                    AnimatedBuilder(
                      animation: _shakeAnim,
                      builder: (_, child) => Transform.translate(
                        offset: Offset(
                            _shakeAnim.value * 10 * (1 - _shakeAnim.value), 0),
                        child: child,
                      ),
                      child: _buildForm(isLoading),
                    ),
                    const SizedBox(height: 20),
                    AppButton(
                      label: 'تسجيل الدخول',
                      onPressed: isLoading ? null : _submit,
                      isLoading: isLoading,
                    ),
                    const SizedBox(height: 16),
                    _buildRegisterLink(),
                    const SizedBox(height: 20),
                    _buildDevHint(),
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

  /// شريط علوي: لوغو الجامعة على اليسار + اسم التطبيق
  Widget _buildTopBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // لوغو الجامعة
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.asset(
              'assets/images/IsraaLogo.jpg',
              width: 46,
              height: 46,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Center(
                  child: Text(
                    'IU',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                'جامعة الإسراء',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              Text(
                'نظام حجز الملاعب الرياضية',
                style: TextStyle(
                  fontSize: 11,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// هيرو الملاعب: كرة + نص ترحيبي
  Widget _buildSportsHero() {
    return Column(
      children: [
        // كرة متحركة مع تأثير نبض
        _BouncingBall(),
        const SizedBox(height: 18),
        const Text(
          'أهلاً وسهلاً!',
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 6),
        const Text(
          'سجّل دخولك برقم طالبك للمتابعة',
          style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildForm(bool isLoading) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
              color: AppColors.shadow,
              blurRadius: 16,
              offset: const Offset(0, 4)),
        ],
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('رقم الطالب',
                style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSecondary)),
            const SizedBox(height: 8),
            TextFormField(
              controller: _idController,
              enabled: !isLoading,
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.done,
              textCapitalization: TextCapitalization.none,
              style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 2,
                  color: AppColors.primary),
              decoration: InputDecoration(
                hintText: AppConstants.studentIdHint,
                hintStyle: const TextStyle(
                    letterSpacing: 1,
                    color: AppColors.textHint,
                    fontSize: 16,
                    fontWeight: FontWeight.w400),
                counterText: '',
                prefixIcon: const Icon(Icons.badge_outlined,
                    color: AppColors.primary),
              ),
              onChanged: (_) {
                if (ref.read(authProvider) is AuthError) {
                  ref.read(authProvider.notifier).clearError();
                }
              },
              onFieldSubmitted: (_) => _submit(),
              validator: AppValidators.validateStudentId,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRegisterLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('ليس لديك حساب؟',
            style: TextStyle(fontSize: 14, color: AppColors.textSecondary)),
        const SizedBox(width: 6),
        GestureDetector(
          onTap: () => context.push(RouteConstants.register),
          child: const Text(
            'سجّل الآن',
            style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: AppColors.primary),
          ),
        ),
      ],
    );
  }

  Widget _buildDevHint() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.infoContainer,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.info.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.science_outlined, color: AppColors.info, size: 15),
              SizedBox(width: 6),
              Text('أرقام تجريبية',
                  style: TextStyle(
                      color: AppColors.info,
                      fontWeight: FontWeight.w700,
                      fontSize: 13)),
            ],
          ),
          const SizedBox(height: 6),
          ...AppConstants.mockValidStudentIds.take(4).map(
                (id) => Text('• $id  (كلمة المرور: 123456)',
                    style: const TextStyle(
                        color: AppColors.info, fontSize: 11)),
              ),
          const SizedBox(height: 3),
          const Text('أو سجّل حساباً جديداً من زر "سجّل الآن"',
              style: TextStyle(color: AppColors.info, fontSize: 11)),
        ],
      ),
    );
  }
}

/// ويدجت الكرة المتحركة
class _BouncingBall extends StatefulWidget {
  @override
  State<_BouncingBall> createState() => _BouncingBallState();
}

class _BouncingBallState extends State<_BouncingBall>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _bounce;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);
    _bounce = Tween<double>(begin: -8, end: 8).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _bounce,
      builder: (_, child) => Transform.translate(
        offset: Offset(0, _bounce.value),
        child: child,
      ),
      child: Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.primary,
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withOpacity(0.25),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: const Center(
          child: Text(
            '⚽',
            style: TextStyle(fontSize: 48),
          ),
        ),
      ),
    );
  }
}