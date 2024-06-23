import 'package:e_com/core/core.dart';
import 'package:e_com/feature/address/controller/address_ctrl.dart';
import 'package:e_com/feature/settings/provider/settings_provider.dart';
import 'package:e_com/models/user_content/billing_address.dart';
import 'package:e_com/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AddAddressView extends HookConsumerWidget {
  const AddAddressView({this.address, super.key});

  final BillingAddress? address;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final billAddressCtrl =
        useCallback(() => ref.read(addressCtrlProvider(address).notifier));

    final countries =
        ref.watch(settingsProvider.select((v) => v?.countries ?? []));

    final firstNameCtrl = useTextEditingController();
    final lastNameCtrl = useTextEditingController();
    final phoneCtrl = useTextEditingController();
    final emailCtrl = useTextEditingController();
    final addressCtrl = useTextEditingController();
    final cityCtrl = useTextEditingController();
    final stateCtrl = useTextEditingController();
    final zipCtrl = useTextEditingController();
    final addressNameCtrl = useTextEditingController();
    final formKey = useMemoized(GlobalKey<FormBuilderState>.new);

    final isLoading = useState(false);

    useEffect(
      () {
        if (address != null) {
          firstNameCtrl.text = address!.firstName;
          lastNameCtrl.text = address!.lastName;
          phoneCtrl.text = address!.phone;
          emailCtrl.text = address!.email;
          addressCtrl.text = address!.address;
          cityCtrl.text = address!.city;
          stateCtrl.text = address!.state;
          zipCtrl.text = address!.zipCode;
          addressNameCtrl.text = address!.key;
        }
        return null;
      },
      const [],
    );

    onAddressSubmit() async {
      final isValid = formKey.currentState
              ?.saveAndValidate(autoScrollWhenFocusOnInvalid: true) ??
          false;

      if (isValid) {
        isLoading.value = true;
        final data = formKey.currentState!.value;

        await billAddressCtrl()
            .saveAddress(BillingAddress.fromMap(data), address?.key);

        await billAddressCtrl().submitAddress();

        isLoading.value = false;
        if (context.mounted) context.pop();
      }
    }

    return Scaffold(
      appBar: KAppBar(
        leading: SquareButton.backButton(
          onPressed: () => context.pop(),
        ),
        title: Text(Translator.createBilling(context)),
      ),
      body: SingleChildScrollView(
        physics: defaultScrollPhysics,
        padding: defaultPaddingAll,
        child: FormBuilder(
          key: formKey,
          child: Column(
            children: [
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
                padding: defaultPadding,
                child: Column(
                  children: [
                    KTextField(
                      textInputAction: TextInputAction.next,
                      autofillHints: AutoFillHintList.firstName,
                      keyboardType: TextInputType.name,
                      title: Translator.firstName(context),
                      hinText: Translator.firstName(context),
                      name: 'first_name',
                      controller: firstNameCtrl,
                      validator: FormBuilderValidators.required(),
                    ),
                    const SizedBox(height: 15),
                    KTextField(
                      textInputAction: TextInputAction.next,
                      autofillHints: AutoFillHintList.lastName,
                      keyboardType: TextInputType.name,
                      title: Translator.lastName(context),
                      hinText: Translator.lastName(context),
                      name: 'last_name',
                      controller: lastNameCtrl,
                      validator: FormBuilderValidators.required(),
                    ),
                    const SizedBox(height: 15),
                    KTextField(
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.phone,
                      autofillHints: AutoFillHintList.phone,
                      isPhone: true,
                      title: Translator.phone(context),
                      hinText: Translator.phone(context),
                      name: 'phone',
                      controller: phoneCtrl,
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
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.emailAddress,
                      autofillHints: AutoFillHintList.email,
                      title: Translator.email(context),
                      hinText: Translator.email(context),
                      controller: emailCtrl,
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
              const SizedBox(height: 20),
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
                padding: defaultPadding,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    KTextField(
                      textInputAction: TextInputAction.next,
                      autofillHints: AutoFillHintList.address,
                      keyboardType: TextInputType.streetAddress,
                      title: Translator.address(context),
                      hinText: Translator.address(context),
                      controller: addressCtrl,
                      validator: FormBuilderValidators.required(),
                      name: 'address',
                    ),
                    const SizedBox(height: 15),
                    KTextField(
                      textInputAction: TextInputAction.next,
                      autofillHints: AutoFillHintList.city,
                      keyboardType: TextInputType.streetAddress,
                      title: Translator.cityName(context),
                      hinText: Translator.cityName(context),
                      controller: cityCtrl,
                      validator: FormBuilderValidators.required(),
                      name: 'city',
                    ),
                    const SizedBox(height: 15),
                    KTextField(
                      textInputAction: TextInputAction.next,
                      autofillHints: AutoFillHintList.state,
                      keyboardType: TextInputType.streetAddress,
                      title: Translator.stateName(context),
                      hinText: Translator.stateName(context),
                      controller: stateCtrl,
                      validator: FormBuilderValidators.required(),
                      name: 'state',
                    ),
                    const SizedBox(height: 15),
                    FormBuilderDropdown(
                      name: 'country',
                      initialValue: address?.country,
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
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Container(
                decoration: BoxDecoration(
                  borderRadius: defaultRadius,
                  color: context.colorTheme.surface,
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 6,
                      color: context.colorTheme.primaryContainer
                          .withOpacity(context.isDark ? 0.3 : 0.1),
                      offset: const Offset(0, 0),
                    ),
                  ],
                ),
                padding: defaultPaddingAll,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      Translator.addressName(context),
                    ),
                    const SizedBox(height: 10),
                    FormBuilderTextField(
                      controller: addressNameCtrl,
                      validator: FormBuilderValidators.required(),
                      textInputAction: TextInputAction.done,
                      name: 'address_name',
                      decoration: const InputDecoration(
                        hintText: 'e.g home, office',
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: defaultPaddingAll,
        child: SubmitButton(
          width: context.width,
          onPressed: onAddressSubmit,
          isLoading: isLoading.value,
          child: address != null
              ? Text(Translator.update(context))
              : Text(Translator.addAddress(context)),
        ),
      ),
    );
  }
}
