import 'package:e_com/core/core.dart';
import 'package:e_com/feature/auth/controller/auth_ctrl.dart';
import 'package:e_com/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class PasswordChangeView extends HookConsumerWidget {
  const PasswordChangeView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formKey = useMemoized(() => GlobalKey<FormBuilderState>());
    final isLoading = useState(false);
    final hideOld = useState(true);
    final hideNow = useState(true);
    final hideConfirm = useState(true);
    final newPass = useState('');

    return Scaffold(
      appBar: KAppBar(
        leading: SquareButton.backButton(
          onPressed: () => context.pop(),
        ),
        title: Text(Translator.updatePassword(context)),
      ),
      body: Padding(
        padding: defaultPaddingAll,
        child: SingleChildScrollView(
          child: FormBuilder(
            key: formKey,
            child: Column(
              children: [
                FormBuilderTextField(
                  name: 'current_password',
                  obscureText: hideOld.value,
                  decoration: InputDecoration(
                    labelText: Translator.currentPass(context),
                    suffixIcon: IconButton(
                      onPressed: () => hideOld.value = !hideOld.value,
                      icon: hideOld.value
                          ? const Icon(Icons.visibility_off)
                          : const Icon(Icons.visibility),
                    ),
                    helperText: Translator.canBeEmpty(context),
                  ),
                ),
                const SizedBox(height: 20),
                FormBuilderTextField(
                  name: 'password',
                  obscureText: hideNow.value,
                  onChanged: (value) => newPass.value = value ?? '',
                  decoration: InputDecoration(
                    labelText: Translator.newPass(context),
                    suffixIcon: IconButton(
                      onPressed: () => hideNow.value = !hideNow.value,
                      icon: hideNow.value
                          ? const Icon(Icons.visibility_off)
                          : const Icon(Icons.visibility),
                    ),
                  ),
                  validator: FormBuilderValidators.compose(
                    [
                      FormBuilderValidators.required(),
                      FormBuilderValidators.minLength(7),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                FormBuilderTextField(
                  name: 'password_confirmation',
                  obscureText: hideConfirm.value,
                  decoration: InputDecoration(
                    labelText: Translator.confirmPassword(context),
                    suffixIcon: IconButton(
                      onPressed: () => hideConfirm.value = !hideConfirm.value,
                      icon: hideConfirm.value
                          ? const Icon(Icons.visibility_off)
                          : const Icon(Icons.visibility),
                    ),
                  ),
                  validator: FormBuilderValidators.compose(
                    [
                      FormBuilderValidators.required(),
                      FormBuilderValidators.minLength(7),
                      FormBuilderValidators.equal(
                        newPass.value,
                        errorText: Translator.passNotMatch(context),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                SubmitButton(
                  isLoading: isLoading.value,
                  width: context.width,
                  onPressed: () async {
                    final isValid = formKey.currentState?.saveAndValidate();
                    if (isValid != true) return;
                    isLoading.value = true;
                    await ref
                        .read(authCtrlProvider.notifier)
                        .updatePassword(formKey.currentState!.value);
                    isLoading.value = false;
                    formKey.currentState!.reset();
                  },
                  child: Text(Translator.update(context)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
