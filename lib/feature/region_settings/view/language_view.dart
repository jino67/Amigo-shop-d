// import 'package:e_com/core/core.dart';
// import 'package:e_com/feature/region_settings/controller/region_ctrl.dart';
// import 'package:e_com/feature/settings/provider/settings_provider.dart';
// import 'package:e_com/models/models.dart';
// import 'package:e_com/routes/routes.dart';
// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
// import 'package:hooks_riverpod/hooks_riverpod.dart';

// import '../../../widgets/widgets.dart';

// class LanguageView extends ConsumerWidget {
//   const LanguageView({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final config = ref.watch(settingsProvider);
//     final savedRegion = ref.watch(regionCtrlProvider);
//     final regionCtrl = ref.read(regionCtrlProvider.notifier);

//     return Scaffold(
//         appBar: KAppBar(
//           leading: SquareButton.backButton(
//             onPressed: () => context.pop(),
//           ),
//           title: Text(Translator.language(context)),
//         ),
//         body: config == null
//             ? EmptyWidget.onError(
//                 onReload: () => regionCtrl.reload(),
//               )
//             : Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 20),
//                 child: savedRegion.when(
//                   error: (error, _) => ErrorView.reload(
//                     error,
//                     regionCtrl.reload,
//                   ),
//                   loading: Loader.loading,
//                   data: (region) {
//                     return RefreshIndicator(
//                       onRefresh: () => regionCtrl.reload(),
//                       child: SingleChildScrollView(
//                         physics: defaultScrollPhysics,
//                         child: SizedBox(
//                           height: context.height,
//                           child: Column(
//                             children: [
//                               const SizedBox(height: 10),
//                               ...config.languages.languagesData.map(
//                                 (language) => LanguageTile(
//                                   language: language,
//                                   region: region,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//               ));
//   }
// }

// class LanguageTile extends ConsumerWidget {
//   const LanguageTile({
//     super.key,
//     required this.language,
//     required this.region,
//   });

//   final LanguagesData language;
//   final RegionModel region;

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final regionCtrl = ref.read(regionCtrlProvider.notifier);
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 5),
//       child: Container(
//         decoration: BoxDecoration(
//           color: context.colorTheme.secondary.withOpacity(0.04),
//           borderRadius: BorderRadius.circular(10),
//         ),
//         child: RadioListTile(
//           groupValue: region.langCode,
//           value: language.code,
//           onChanged: (value) {
//             regionCtrl.setLangCode(language.code);
//             RouteNames.home.goNamed(context);
//           },
//           secondary: Text(
//             language.code.toUpperCase(),
//             style: context.textTheme.titleLarge,
//           ),
//           title: Text(
//             language.name,
//             style: context.textTheme.bodyLarge,
//           ),
//           controlAffinity: ListTileControlAffinity.trailing,
//         ),
//       ),
//     );
//   }
// }
