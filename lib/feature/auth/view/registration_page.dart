import 'package:e_com/core/core.dart';
import 'package:e_com/feature/auth/controller/auth_ctrl.dart';
import 'package:e_com/feature/auth/view/social_login_buttons.dart';
import 'package:e_com/feature/auth/view/tnc_accept_view.dart';
import 'package:e_com/feature/settings/controller/settings_ctrl.dart';
import 'package:e_com/feature/settings/provider/settings_provider.dart';
import 'package:e_com/routes/routes.dart';
import 'package:e_com/widgets/widgets.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class RegistrationPage extends HookConsumerWidget {
  const RegistrationPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authCtrl = useCallback(() => ref.read(authCtrlProvider.notifier));
    final config = ref.watch(settingsProvider);

    final scrollCtrl = useScrollController();
    final nameCtrl = useTextEditingController();
    final emailCtrl = useTextEditingController();
    final phoneCtrl = useTextEditingController();
    final passCtrl = useTextEditingController();
    final confirmPassCtrl = useTextEditingController();
    final otpCtrl = useTextEditingController();
    final isLoading = useState(false);

    final formKey = useMemoized(GlobalKey<FormBuilderState>.new);
    final showOTPBox = useState(false);
    if (config == null) {
      return ErrorView.reload(
        'No config found',
        () => ref.read(settingsCtrlProvider.notifier).reload(),
        null,
      );
    }

    final tncPage = config.tncPage;

    final useEmailOTP = config.settings.emailOTP;
    final usePhoneOTP = config.settings.phoneOTP;

    bool validateField() {
      final isValid = formKey.currentState?.saveAndValidate() ?? false;
      return isValid;
    }

    Future<void> startSigningUp() async {
      if (!validateField()) return;

      isLoading.value = true;
      final value = await authCtrl().signUp(
        name: nameCtrl.text,
        email: emailCtrl.text,
        phone: phoneCtrl.text,
        pass: passCtrl.text,
        confirmPass: confirmPassCtrl.text,
      );
      isLoading.value = false;
      showOTPBox.value = value;
      await scrollCtrl.animateTo(
        0,
        duration: Times.fastest,
        curve: Curves.easeIn,
      );
    }

    Future<void> verifyOtp() async {
      if (!validateField()) return;

      isLoading.value = true;
      await authCtrl().verifyOTP(otpCtrl.text);
      showOTPBox.value = false;
      isLoading.value = false;
      otpCtrl.clear();
    }

    return Scaffold(
      appBar: KAppBar(
        color: context.colorTheme.primary,
        leading: SquareButton.backButton(
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        controller: scrollCtrl,
        child: SizedBox(
          height: 1200,
          width: context.width,
          child: Stack(
            children: [
              Positioned(
                top: 0,
                child: Container(
                  width: context.width,
                  height: 200,
                  decoration: BoxDecoration(
                    color: context.colorTheme.primary,
                    borderRadius: const BorderRadius.only(
                      bottomRight: Radius.circular(40),
                      bottomLeft: Radius.circular(40),
                    ),
                  ),
                  child: Padding(
                    padding: context.onMobile
                        ? defaultPadding
                        : const EdgeInsets.symmetric(
                            horizontal: 100,
                          ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          Translator.createAccount(context),
                          style: context.textTheme.headlineMedium!
                              .copyWith(color: context.colorTheme.onPrimary),
                        ),
                        Text(
                          Translator.regSubtitle(context),
                          style: context.textTheme.bodyLarge!
                              .copyWith(color: context.colorTheme.onPrimary),
                        ),
                        const SizedBox(height: 30),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned.fill(
                child: SingleChildScrollView(
                  physics: const NeverScrollableScrollPhysics(),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: context.onMobile ? 0 : 100,
                    ),
                    child: Column(
                      children: [
                        Container(height: 150),
                        Container(
                          width: context.width / 1.1,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: context.colorTheme.surface,
                            boxShadow: [
                              BoxShadow(
                                color:
                                    context.colorTheme.outline.withOpacity(0.4),
                                spreadRadius: 5,
                                blurRadius: 7,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          padding: const EdgeInsets.all(20),
                          child: FormBuilder(
                            key: formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Center(
                                  child: Text(
                                    Translator.registration(context),
                                    style: context.textTheme.titleLarge,
                                  ),
                                ),
                                const SizedBox(height: 10),

                                //! Name field
                                if (!showOTPBox.value) ...[
                                  Text(
                                    Translator.fullName(context),
                                    style: context.textTheme.titleSmall,
                                  ),
                                  const SizedBox(height: 8),
                                  FormBuilderTextField(
                                    name: 'name',
                                    controller: nameCtrl,
                                    autofillHints: AutoFillHintList.name,
                                    keyboardType: TextInputType.name,
                                    textInputAction: TextInputAction.next,
                                    decoration: InputDecoration(
                                      prefixIcon: const Icon(Icons.person),
                                      hintText: Translator.enterName(context),
                                    ),
                                    validator: FormBuilderValidators.required(),
                                  ),
                                  const SizedBox(height: 10)
                                ],

                                //! Email field
                                if (!showOTPBox.value) ...[
                                  Text(
                                    Translator.email(context),
                                    style: context.textTheme.titleSmall,
                                  ),
                                  const SizedBox(height: 8),
                                  FormBuilderTextField(
                                    name: 'email',
                                    controller: emailCtrl,
                                    autofillHints: AutoFillHintList.email,
                                    keyboardType: TextInputType.emailAddress,
                                    textInputAction: TextInputAction.next,
                                    decoration: const InputDecoration(
                                      prefixIcon:
                                          Icon(Icons.mail_outline_rounded),
                                      hintText: 'example@email.com',
                                    ),
                                    validator: FormBuilderValidators.compose(
                                      [
                                        if ((!useEmailOTP && !usePhoneOTP) ||
                                            useEmailOTP)
                                          FormBuilderValidators.required(),
                                        FormBuilderValidators.email(),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                ],

                                //! Phone field
                                if (!showOTPBox.value) ...[
                                  Text(
                                    Translator.phone(context),
                                    style: context.textTheme.titleSmall,
                                  ),
                                  const SizedBox(height: 8),
                                  FormBuilderTextField(
                                    name: 'phone',
                                    controller: phoneCtrl,
                                    autofillHints: AutoFillHintList.phone,
                                    keyboardType: TextInputType.phone,
                                    textInputAction: TextInputAction.next,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly,
                                    ],
                                    decoration: const InputDecoration(
                                      prefixIcon: Icon(Icons.phone_rounded),
                                      hintText: '0xxxxxxxxxx',
                                    ),
                                    validator: FormBuilderValidators.compose(
                                      [
                                        if (usePhoneOTP)
                                          FormBuilderValidators.required(),
                                        FormBuilderValidators.numeric(),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                ],

                                //! Password field
                                if (!showOTPBox.value) ...[
                                  Text(
                                    Translator.password(context),
                                    style: context.textTheme.titleSmall,
                                  ),
                                  const SizedBox(height: 8),
                                  PassField(
                                    name: 'password',
                                    ctrl: passCtrl,
                                  ),
                                  const SizedBox(height: 10),
                                ],

                                //! Confirm password field
                                if (!showOTPBox.value) ...[
                                  Text(
                                    Translator.confirmPassword(context),
                                    style: context.textTheme.titleSmall,
                                  ),
                                  const SizedBox(height: 8),
                                  PassField(
                                    name: 'confirm_password',
                                    ctrl: confirmPassCtrl,
                                
                                  ),
                                ],

                                //! OTP box
                                if (showOTPBox.value) ...[
                                  const SizedBox(height: 20),
                                  Text(
                                    Translator.otp(context),
                                    style: context.textTheme.titleSmall,
                                  ),
                                  const SizedBox(height: 10),
                                  FormBuilderTextField(
                                    name: 'otp',
                                    controller: otpCtrl,
                                    keyboardType: TextInputType.number,
                                    textInputAction: TextInputAction.done,
                                    decoration: const InputDecoration(
                                      hintText: 'Enter your otp',
                                    ),
                                    validator: FormBuilderValidators.required(),
                                  ),
                                ],

                                //! TNC
                                if (tncPage != null && !showOTPBox.value)
                                  TNCCheckWidget(tncPage)
                                else
                                  const SizedBox(height: 20),

                                //! Submit Button
                                SubmitButton(
                                  isLoading: isLoading.value,
                                  onPressed: () async {
                                    hideSoftKeyboard();
                                    showOTPBox.value
                                        ? verifyOtp()
                                        : startSigningUp();
                                  },
                                  child: Text(
                                    showOTPBox.value
                                        ? Translator.verifyOTP(context)
                                        : Translator.registration(context),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        //! social login
                        const SizedBox(height: 30),
                        SocialLoginButtons(config),

                        //! to login page
                        const SizedBox(height: 30),
                        Text.rich(
                          TextSpan(
                            text: Translator.alreadyHaveAccount(context),
                            children: [
                              TextSpan(
                                text: Translator.loginNow(context),
                                style: context.textTheme.labelLarge?.copyWith(
                                    color: context.colorTheme.primary),
                                recognizer: TapGestureRecognizer()
                                  ..onTap =
                                      () => RouteNames.login.goNamed(context),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 30),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class PassField extends HookConsumerWidget {
  const PassField({
    super.key,
    this.ctrl,
    required this.name,
    this.matchPass,
  });
  final String name;
  final TextEditingController? ctrl;
  final String? matchPass;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hidePass = useState(false);
    return FormBuilderTextField(
      name: name,
      controller: ctrl,
      autofillHints: AutoFillHintList.password,
      keyboardType: TextInputType.visiblePassword,
      textInputAction: TextInputAction.next,
      obscureText: !hidePass.value,
      decoration: InputDecoration(
        hintText: '*' * 8,
        prefixIcon: const Icon(Icons.lock_outline_rounded),
        suffixIcon: IconButton(
          focusNode: FocusNode(skipTraversal: true),
          onPressed: () {
            hidePass.value = !hidePass.value;
          },
          icon: hidePass.value
              ? const Icon(Icons.visibility_rounded)
              : const Icon(Icons.visibility_off_rounded),
        ),
      ),
      validator: FormBuilderValidators.compose(
        [
          FormBuilderValidators.required(),
          FormBuilderValidators.minLength(6),
          if (matchPass != null)
            FormBuilderValidators.equal(
              matchPass!,
              errorText: Translator.passNotMatch(context),
            ),
        ],
      ),
    );
  }
}
