import 'package:e_com/core/core.dart';
import 'package:e_com/feature/auth/controller/auth_ctrl.dart';
import 'package:e_com/feature/auth/view/registration_page.dart';
import 'package:e_com/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ForgetPassDialog extends HookConsumerWidget {
  const ForgetPassDialog({
    super.key,
    required this.email,
  });

  final String email;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authCtrl = useCallback(() => ref.read(authCtrlProvider.notifier));
    final formKey = useMemoized(GlobalKey<FormBuilderState>.new);

    final emailCtrl = useTextEditingController();
    final otpCtrl = useTextEditingController();
    final passwordCtrl = useTextEditingController();
    final confirmPassCtrl = useTextEditingController();

    final isLoading = useState(false);
    final showPassBoxes = useState(false);
    final showOTPBox = useState(false);

    final isWorking = showOTPBox.value || showPassBoxes.value;

    void toggleLoading(bool v) => isLoading.value = v;

    useEffect(() {
      emailCtrl.text = email;
      return null;
    }, const []);

    String getButtonText() {
      if (showOTPBox.value) {
        return Translator.verifyOTP(context);
      }
      if (showPassBoxes.value) {
        return Translator.resetPass(context);
      }
      return Translator.sendOTP(context);
    }

    return AlertDialog(
      insetPadding: const EdgeInsets.all(30),
      title: Text(Translator.resetPass(context)),
      content: SingleChildScrollView(
        child: FormBuilder(
          key: formKey,
          child: SizedBox(
            width: context.width,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (!showOTPBox.value && !showPassBoxes.value) ...[
                  Text(Translator.sendToEmailText(context)),
                  const SizedBox(height: 10),
                  FormBuilderTextField(
                    name: 'email',
                    controller: emailCtrl,
                    autofillHints: AutoFillHintList.email,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(
                        Icons.mail_outline_rounded,
                      ),
                      hintText: 'Enter Email address',
                    ),
                    validator: FormBuilderValidators.compose(
                      [
                        FormBuilderValidators.required(),
                        FormBuilderValidators.email(),
                      ],
                    ),
                  ),
                ],
                if (showOTPBox.value) ...[
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
                if (showPassBoxes.value) ...[
                  Text(
                    Translator.password(context),
                    style: context.textTheme.titleSmall,
                  ),
                  const SizedBox(height: 10),
                  PassField(
                    name: 'password',
                    ctrl: passwordCtrl,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    Translator.confirmPassword(context),
                    style: context.textTheme.titleSmall,
                  ),
                  const SizedBox(height: 10),
                  PassField(
                    name: 'password_confirmation',
                    ctrl: confirmPassCtrl,
                    matchPass: passwordCtrl.text,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () async {
            if (!isWorking) return context.nPOP();

            final result = await showDialog(
              context: context,
              builder: (context) => const _Cancellation(),
            );
            if (context.mounted && result == true) context.nPOP();
          },
          child: Text(Translator.cancel(context)),
        ),
        SubmitButton(
          height: 40,
          isLoading: isLoading.value,
          onPressed: () async {
            final state = formKey.currentState;
            final isValid = state?.saveAndValidate() ?? false;
            if (showOTPBox.value) {
              if (!isValid) return;
              toggleLoading(true);

              final isOtpOk = await authCtrl()
                  .passwordResetVerification(email, otpCtrl.text);
              if (isOtpOk) {
                showPassBoxes.value = true;
                showOTPBox.value = false;
              }
            } else if (showPassBoxes.value) {
              if (!isValid) return;
              toggleLoading(true);

              final didSucceed = await authCtrl().resetPassword(
                email,
                otpCtrl.text,
                passwordCtrl.text,
                confirmPassCtrl.text,
              );

              if (context.mounted && didSucceed) {
                toggleLoading(false);
                context.nPOP();
              }
            } else {
              if (!isValid) return;
              toggleLoading(true);

              final didOtpSent = await authCtrl().forgetPassword(email);
              if (didOtpSent) showOTPBox.value = true;
            }
            toggleLoading(false);
          },
          child: Text(getButtonText()),
        ),
      ],
    );
  }
}

class _Cancellation extends StatelessWidget {
  const _Cancellation();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(Translator.areYouSure(context)),
      insetPadding: const EdgeInsets.all(15),
      content: Text(Translator.confirmCancel(context)),
      actions: [
        TextButton(
          onPressed: () => context.nPOP(),
          child: Text(Translator.no(context)),
        ),
        TextButton(
          style: TextButton.styleFrom(
            backgroundColor: context.colorTheme.error.withOpacity(.1),
          ),
          onPressed: () => context.nPOP(true),
          child: Text(Translator.yes(context)),
        ),
      ],
    );
  }
}
