import 'package:e_com/core/core.dart';
import 'package:e_com/feature/user_profile/controller/user_profile_ctrl.dart';
import 'package:e_com/models/models.dart';
import 'package:e_com/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';

class UserProfileEditingView extends HookConsumerWidget {
  const UserProfileEditingView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userCtrl = useCallback(() => ref.read(userProfileProvider.notifier));
    final user = ref.watch(userProfileProvider);

    final formKey = useMemoized(GlobalKey<FormBuilderState>.new);
    final nameCtrl = useTextEditingController();
    final phoneCtrl = useTextEditingController();
    final emailCtrl = useTextEditingController();
    final cityCtrl = useTextEditingController();
    final stateCtrl = useTextEditingController();
    final addressCtrl = useTextEditingController();
    final zipCodeCtrl = useTextEditingController();
    final isLoading = useState(false);

    useEffect(() {
      nameCtrl.text = user.name;
      phoneCtrl.text = user.phone;
      emailCtrl.text = user.email;
      cityCtrl.text = user.address.city;
      stateCtrl.text = user.address.state;
      addressCtrl.text = user.address.address;
      zipCodeCtrl.text = user.address.zip;

      return null;
    }, const []);

    return Scaffold(
      appBar: KAppBar(
        title: Text(Translator.profile(context)),
        leading: SquareButton.backButton(
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: defaultPaddingAll,
        physics: defaultScrollPhysics,
        child: FormBuilder(
          key: formKey,
          child: Column(
            children: [
              Center(
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    if (user.imageFile == null)
                      CircleAvatar(
                        backgroundColor:
                            context.colorTheme.secondary.withOpacity(.5),
                        radius: 45,
                        backgroundImage: user.image.isEmpty
                            ? null
                            : HostedImage.provider(user.image),
                        child: user.image.isEmpty
                            ? const Icon(Icons.person_rounded, size: 45)
                            : null,
                      )
                    else
                      CircleAvatar(
                        backgroundColor:
                            context.colorTheme.secondary.withOpacity(.5),
                        radius: 45,
                        backgroundImage: FileImage(user.imageFile!),
                      ),
                    Positioned(
                      bottom: -10,
                      right: 0,
                      child: CircularButton.filled(
                        height: 40,
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (c) {
                              return ImagePickerDialog(
                                onPick: (s) async {
                                  await userCtrl().pickAndSetImage(s);
                                  if (context.mounted) context.nPOP();
                                },
                              );
                            },
                          );
                        },
                        fillColor: context.colorTheme.primary,
                        iconColor: context.colorTheme.onPrimary,
                        icon: const Icon(Icons.photo_camera_outlined),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 50),
              Container(
                decoration: BoxDecoration(
                  borderRadius: defaultRadius,
                  color: context.colorTheme.surface,
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 6,
                      color: context.colorTheme.primaryContainer
                          .withOpacity(context.isDark ? 0.3 : 0.06),
                      offset: const Offset(0, 0),
                    ),
                  ],
                ),
                child: Padding(
                  padding: defaultPaddingAll,
                  child: Column(
                    children: [
                      KTextField(
                        name: 'name',
                        controller: nameCtrl,
                        textInputAction: TextInputAction.next,
                        autofillHints: AutoFillHintList.name,
                        keyboardType: TextInputType.name,
                        validator: FormBuilderValidators.required(),
                        hinText: Translator.fullName(context),
                        title: Translator.fullName(context),
                      ),
                      const SizedBox(height: 15),
                      KTextField(
                        name: 'phone',
                        isPhone: true,
                        controller: phoneCtrl,
                        textInputAction: TextInputAction.next,
                        title: Translator.phone(context),
                        hinText: Translator.phone(context),
                        autofillHints: AutoFillHintList.phone,
                        keyboardType: TextInputType.phone,
                        validator: FormBuilderValidators.compose(
                          [
                            FormBuilderValidators.required(),
                            FormBuilderValidators.minLength(11),
                            FormBuilderValidators.maxLength(14),
                          ],
                        ),
                      ),
                      const SizedBox(height: 15),
                      KTextField(
                        name: 'email',
                        title: Translator.email(context),
                        hinText: Translator.email(context),
                        textInputAction: TextInputAction.next,
                        autofillHints: AutoFillHintList.email,
                        controller: emailCtrl,
                        keyboardType: TextInputType.emailAddress,
                        validator: FormBuilderValidators.compose(
                          [
                            FormBuilderValidators.required(),
                            FormBuilderValidators.email(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 15),
              Container(
                decoration: BoxDecoration(
                  borderRadius: defaultRadius,
                  color: context.colorTheme.surface,
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 6,
                      color: context.colorTheme.primaryContainer
                          .withOpacity(context.isDark ? 0.3 : 0.06),
                      offset: const Offset(0, 0),
                    ),
                  ],
                ),
                child: Padding(
                  padding: defaultPaddingAll,
                  child: Column(
                    children: [
                      KTextField(
                        name: 'address',
                        title: Translator.address(context),
                        hinText: Translator.address(context),
                        textInputAction: TextInputAction.next,
                        autofillHints: AutoFillHintList.address,
                        controller: addressCtrl,
                        keyboardType: TextInputType.streetAddress,
                        validator: FormBuilderValidators.required(),
                      ),
                      const SizedBox(height: 15),
                      KTextField(
                        name: 'state',
                        title: Translator.stateName(context),
                        hinText: Translator.stateName(context),
                        textInputAction: TextInputAction.next,
                        autofillHints: AutoFillHintList.state,
                        controller: stateCtrl,
                        keyboardType: TextInputType.streetAddress,
                        validator: FormBuilderValidators.required(),
                      ),
                      const SizedBox(height: 15),
                      KTextField(
                        name: 'city',
                        title: Translator.cityName(context),
                        hinText: Translator.cityName(context),
                        textInputAction: TextInputAction.next,
                        autofillHints: AutoFillHintList.city,
                        controller: cityCtrl,
                        keyboardType: TextInputType.streetAddress,
                        validator: FormBuilderValidators.required(),
                      ),
                      const SizedBox(height: 15),
                      KTextField(
                        name: 'zip',
                        title: Translator.zipCode(context),
                        hinText: Translator.zipCode(context),
                        textInputAction: TextInputAction.next,
                        autofillHints: AutoFillHintList.zip,
                        controller: zipCodeCtrl,
                        keyboardType: TextInputType.streetAddress,
                        validator: FormBuilderValidators.required(),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 150),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: defaultPadding,
        child: SubmitButton(
          width: context.width,
          isLoading: isLoading.value,
          onPressed: () async {
            final isValid = formKey.currentState?.saveAndValidate();
            if (isValid == false) return;
            final data = formKey.currentState?.value;
            final profile = UserModel.fromFlatMap(data!);

            userCtrl().setUser(profile);

            isLoading.value = true;
            await userCtrl().updateProfile();
            isLoading.value = false;
          },
          child: Text(Translator.update(context)),
        ),
      ),
    );
  }
}

class ImagePickerDialog extends StatelessWidget {
  const ImagePickerDialog({
    super.key,
    required this.onPick,
  });

  final Function(ImageSource source) onPick;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Pick Image'),
      actionsAlignment: MainAxisAlignment.center,
      actions: [
        ...ImageSource.values.map(
          (e) => Container(
            constraints: const BoxConstraints(
              minWidth: 100,
            ),
            decoration: BoxDecoration(
              color: context.colorTheme.secondary.withOpacity(.05),
              borderRadius: Corners.medBorder,
              border: Border.all(color: context.colorTheme.secondary),
            ),
            padding: const EdgeInsets.all(10),
            margin: const EdgeInsets.all(5),
            child: InkWell(
              onTap: () => onPick(e),
              child: Column(
                children: [
                  Icon(
                    e.icon,
                    color: context.colorTheme.secondary,
                  ),
                  const SizedBox(height: 5),
                  Text(
                    e.name.toTitleCase,
                    style: context.textTheme.labelMedium?.copyWith(
                      color: context.colorTheme.secondary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
