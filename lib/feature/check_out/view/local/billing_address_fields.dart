import 'package:e_com/core/core.dart';
import 'package:e_com/feature/check_out/controller/checkout_ctrl.dart';
import 'package:e_com/feature/settings/provider/settings_provider.dart';
import 'package:e_com/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class BillingAddressFields extends HookConsumerWidget {
  const BillingAddressFields({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final checkout = ref.watch(checkoutCtrlProvider);
    final countries =
        ref.watch(settingsProvider.select((v) => v?.countries ?? []));
    final firstNameCtrl = useTextEditingController();
    final lastNameCtrl = useTextEditingController();
    final phoneCtrl = useTextEditingController();
    final emailCtrl = useTextEditingController();
    final cityCtrl = useTextEditingController();
    final stateCtrl = useTextEditingController();
    final addressCtrl = useTextEditingController();
    final zipCodeCtrl = useTextEditingController();

    useEffect(
      () {
        firstNameCtrl.text = checkout.billingAddress?.firstName ?? '';
        lastNameCtrl.text = checkout.billingAddress?.lastName ?? '';
        phoneCtrl.text = checkout.billingAddress?.phone ?? '';
        emailCtrl.text = checkout.billingAddress?.email ?? '';
        cityCtrl.text = checkout.billingAddress?.city ?? '';
        stateCtrl.text = checkout.billingAddress?.state ?? '';
        addressCtrl.text = checkout.billingAddress?.address ?? '';
        zipCodeCtrl.text = checkout.billingAddress?.zipCode ?? '';

        return null;
      },
      const [],
    );
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: defaultRadius,
            color: context.colorTheme.surface,
            boxShadow: [
              BoxShadow(
                blurRadius: 6,
                color: context.colorTheme.primaryContainer.withOpacity(
                  context.isDark ? 0.3 : 0.1,
                ),
                offset: const Offset(0, 0),
              ),
            ],
          ),
          padding: defaultPaddingAll,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                Translator.basicInfo(context),
                style: context.textTheme.titleLarge,
              ),
              const SizedBox(height: 15),
              KTextField(
                name: 'first_name',
                controller: firstNameCtrl,
                keyboardType: TextInputType.name,
                autofillHints: AutoFillHintList.firstName,
                textInputAction: TextInputAction.next,
                validator: FormBuilderValidators.required(),
                hinText: Translator.firstName(context),
                title: Translator.firstName(context),
              ),
              const SizedBox(height: 15),
              KTextField(
                name: 'last_name',
                title: Translator.lastName(context),
                hinText: Translator.lastName(context),
                controller: lastNameCtrl,
                keyboardType: TextInputType.name,
                autofillHints: AutoFillHintList.lastName,
                textInputAction: TextInputAction.next,
                validator: FormBuilderValidators.required(),
              ),
              const SizedBox(height: 15),
              KTextField(
                name: 'phone',
                isPhone: true,
                title: Translator.phone(context),
                hinText: Translator.phone(context),
                controller: phoneCtrl,
                keyboardType: TextInputType.phone,
                autofillHints: AutoFillHintList.phone,
                textInputAction: TextInputAction.next,
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
                controller: emailCtrl,
                keyboardType: TextInputType.emailAddress,
                autofillHints: AutoFillHintList.email,
                textInputAction: TextInputAction.next,
                validator: FormBuilderValidators.compose(
                  [
                    FormBuilderValidators.required(),
                    FormBuilderValidators.email(),
                  ],
                ),
              ),
              const SizedBox(height: 10),
            ],
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  Translator.address(context),
                  style: context.textTheme.titleLarge,
                ),
                const SizedBox(height: 15),
                FormBuilderTextField(
                  name: 'address',
                  controller: addressCtrl,
                  keyboardType: TextInputType.streetAddress,
                  decoration: InputDecoration(
                    labelText: Translator.address(context),
                    hintText: Translator.address(context),
                  ),
                  autofillHints: AutoFillHintList.address,
                  textInputAction: TextInputAction.next,
                  validator: FormBuilderValidators.required(),
                ),
                const SizedBox(height: 15),
                Row(
                  children: [
                    Flexible(
                      child: FormBuilderTextField(
                        name: 'state',
                        controller: stateCtrl,
                        keyboardType: TextInputType.streetAddress,
                        decoration: InputDecoration(
                          labelText: Translator.stateName(context),
                          hintText: Translator.stateName(context),
                        ),
                        autofillHints: AutoFillHintList.state,
                        textInputAction: TextInputAction.next,
                        validator: FormBuilderValidators.required(),
                      ),
                    ),
                    const SizedBox(width: 15),
                    Flexible(
                      child: FormBuilderTextField(
                        name: 'city',
                        controller: cityCtrl,
                        keyboardType: TextInputType.streetAddress,
                        decoration: InputDecoration(
                          labelText: Translator.cityName(context),
                          hintText: Translator.cityName(context),
                        ),
                        autofillHints: AutoFillHintList.city,
                        textInputAction: TextInputAction.next,
                        validator: FormBuilderValidators.required(),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                FormBuilderDropdown(
                  name: 'country',
                  initialValue: checkout.billingAddress?.country,
                  decoration: const InputDecoration(
                    hintText: 'Select Country',
                  ),
                  items: [
                    ...countries.map(
                      (e) => DropdownMenuItem(
                        value: e.name,
                        child: Text(e.name),
                      ),
                    ),
                  ],
                  validator: FormBuilderValidators.required(),
                ),
                const SizedBox(height: 15),
                FormBuilderTextField(
                  name: 'zip',
                  controller: zipCodeCtrl,
                  keyboardType: TextInputType.streetAddress,
                  decoration: InputDecoration(
                    hintText: Translator.zipCode(context),
                    labelText: Translator.zipCode(context),
                  ),
                  autofillHints: AutoFillHintList.zip,
                  textInputAction: TextInputAction.next,
                  validator: FormBuilderValidators.required(),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
