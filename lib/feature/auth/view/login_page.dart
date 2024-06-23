import 'package:e_com/core/core.dart';
import 'package:e_com/feature/auth/controller/auth_ctrl.dart';
import 'package:e_com/feature/auth/view/forget_pass_dialog.dart';
import 'package:e_com/feature/auth/view/registration_page.dart';
import 'package:e_com/feature/auth/view/social_login_buttons.dart';
import 'package:e_com/feature/settings/controller/settings_ctrl.dart';
import 'package:e_com/routes/routes.dart';
import 'package:e_com/widgets/widgets.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class LoginPage extends HookConsumerWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authCtrl = useCallback(() => ref.read(authCtrlProvider.notifier));
    final config = ref.watch(settingsCtrlProvider);

    final emailCtrl = useTextEditingController(text: '');
    final passCtrl = useTextEditingController(text: '');
    final otpCtrl = useTextEditingController();
    final configLoaded = useState(false);

    final loadingManual = useState(false);

    final formKey = useMemoized(GlobalKey<FormBuilderState>.new);
    final showOTPBox = useState(false);
    useEffect(
      () {
        Future.delayed(0.ms, () async {
          await ref.read(settingsCtrlProvider.notifier).reloadSilently();
          configLoaded.value = true;
        });
        return null;
      },
      const [],
    );

    bool validateField() {
      final isValid = formKey.currentState?.saveAndValidate() ?? false;
      return isValid;
    }

    Future<void> doManualLogin() async {
      if (!validateField()) return;

      loadingManual.value = true;
      final value = await authCtrl().manualLogin(
        emailCtrl.text,
        passCtrl.text,
      );
      showOTPBox.value = value;
      loadingManual.value = false;
    }

    Future<void> verifyOtp() async {
      if (!validateField()) return;

      loadingManual.value = true;
      await authCtrl().verifyOTP(otpCtrl.text);
      showOTPBox.value = false;
      loadingManual.value = false;
      otpCtrl.clear();
    }

    return config.when(
      error: ErrorView.withScaffold,
      loading: () => const SplashView(),
      data: (config) {
        final useEmailOTP = config.settings.emailOTP;
        final usePhoneOTP = config.settings.phoneOTP;
        final usePassword = config.settings.isPasswordEnabled;
        String fieldText = Translator.email(context);

        if (useEmailOTP && usePhoneOTP) {
          fieldText =
              '${Translator.email(context)} / ${Translator.phone(context)}';
        } else if (usePhoneOTP) {
          fieldText = Translator.phone(context);
        }

        return Scaffold(
          appBar: KAppBar(
            color: context.colorTheme.primary,
            actions: [
              TextButton(
                onPressed: () {
                  RouteNames.home.goNamed(context);
                },
                child: Text(
                  Translator.skip(context),
                  style: context.textTheme.titleLarge!
                      .copyWith(color: context.colorTheme.onPrimary),
                ),
              ),
            ],
          ),
          body: SingleChildScrollView(
            child: SizedBox(
              height: 800,
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
                        borderRadius: const BorderRadius.vertical(
                          bottom: Radius.circular(40),
                        ),
                      ),
                      padding: context.onMobile
                          ? defaultPadding
                          : const EdgeInsets.symmetric(horizontal: 100),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            Translator.welcome(context),
                            style: context.textTheme.headlineMedium?.copyWith(
                              color: context.colorTheme.onPrimary,
                            ),
                          ),
                          Text(
                            Translator.loginSubtitle(context),
                            style: context.textTheme.bodyLarge?.copyWith(
                              color: context.colorTheme.onPrimary,
                            ),
                          ),
                          const SizedBox(height: 30),
                        ],
                      ),
                    ),
                  ),
                  Positioned.fill(
                    child: SingleChildScrollView(
                      physics: const NeverScrollableScrollPhysics(),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: context.onMobile ? 0 : context.width / 5,
                        ),
                        child: Column(
                          children: [
                            Container(height: 150),
                            Container(
                              width: context.width * .9,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: context.colorTheme.surface,
                                boxShadow: [
                                  BoxShadow(
                                    color: context.colorTheme.outline
                                        .withOpacity(0.4),
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
                                  children: [
                                    Center(
                                      child: Text(
                                        Translator.login(context),
                                        style: context.textTheme.titleLarge,
                                      ),
                                    ),
                                    const SizedBox(height: 30),

                                    //! Email field
                                    if (!showOTPBox.value) ...[
                                      Text(
                                        fieldText,
                                        style: context.textTheme.titleSmall,
                                      ),
                                      const SizedBox(height: 10),
                                      FormBuilderTextField(
                                        name: 'email',
                                        controller: emailCtrl,
                                        autofillHints: AutoFillHintList.email,
                                        keyboardType:
                                            TextInputType.emailAddress,
                                        textInputAction: TextInputAction.next,
                                        inputFormatters: [
                                          if (!useEmailOTP && usePhoneOTP)
                                            FilteringTextInputFormatter
                                                .digitsOnly
                                        ],
                                        decoration: InputDecoration(
                                          prefixIcon: const Icon(
                                            Icons.mail_outline_rounded,
                                          ),
                                          hintText: '',
                                        ),
                                        validator:
                                            FormBuilderValidators.compose(
                                          [
                                            FormBuilderValidators.required(),
                                            if ((!usePhoneOTP && useEmailOTP))
                                              FormBuilderValidators.email(),
                                            if (!useEmailOTP && usePhoneOTP)
                                              FormBuilderValidators.numeric(),
                                          ],
                                        ),
                                      ),
                                    ],

                                    //! password field
                                    if (usePassword && !showOTPBox.value) ...[
                                      const SizedBox(height: 20),
                                      Text(
                                        Translator.password(context),
                                        style: context.textTheme.titleSmall,
                                      ),
                                      const SizedBox(height: 10),
                                      PassField(
                                        ctrl: passCtrl,
                                        name: 'password',
                                      )
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
                                      ),
                                    ],
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: TextButton(
                                        onPressed: () {
                                          showDialog(
                                            context: context,
                                            barrierDismissible: false,
                                            builder: (context) =>
                                                ForgetPassDialog(
                                              email: emailCtrl.text,
                                            ),
                                          );
                                        },
                                        child: Text(
                                          Translator.forgetPass(context),
                                        ),
                                      ),
                                    ),

                                    //! submit button
                                    SubmitButton(
                                      isLoading: loadingManual.value ||
                                          !configLoaded.value,
                                      onPressed: configLoaded.value
                                          ? () async {
                                              hideSoftKeyboard();
                                              showOTPBox.value
                                                  ? verifyOtp()
                                                  : doManualLogin();
                                            }
                                          : null,
                                      child: Text(
                                        showOTPBox.value
                                            ? Translator.verifyOTP(context)
                                            : Translator.login(context),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              height: context.onMobile ? 50 : 100,
                            ),

                            //! social login
                            SocialLoginButtons(config),
                            const SizedBox(height: 20),

                            //! resister page
                            Text.rich(
                              TextSpan(
                                text: Translator.donotHaveAccount(context),
                                children: [
                                  TextSpan(
                                    text: Translator.createAccount(context),
                                    style: context.textTheme.labelLarge
                                        ?.copyWith(
                                            color: context.colorTheme.primary),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () =>
                                          RouteNames.register.goNamed(context),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 40),
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
      },
    );
  }
}
