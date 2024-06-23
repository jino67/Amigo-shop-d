// import 'package:e_com/core/core.dart';
// import 'package:e_com/feature/region_settings/controller/region_ctrl.dart';
// import 'package:e_com/feature/settings/provider/settings_provider.dart';
// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
// import 'package:hooks_riverpod/hooks_riverpod.dart';

// import '../../../widgets/widgets.dart';

// class CurrencyView extends ConsumerWidget {
//   const CurrencyView({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final config = ref.watch(settingsProvider);
//     final savedRegion = ref.watch(regionCtrlProvider);
//     final regionCtrl = ref.read(regionCtrlProvider.notifier);
//     return Scaffold(
//       appBar: KAppBar(
//         leading: SquareButton.backButton(
//           onPressed: () => context.pop(),
//         ),
//         title: Text(Translator.currency(context)),
//       ),
//       body: config == null
//           ? EmptyWidget.onError(
//               onReload: () => regionCtrl.reload(),
//             )
//           : Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 20),
//               child: savedRegion.when(
//                 error: (error, _) => ErrorView.reload(
//                   error,
//                   () => regionCtrl.reload(),
//                 ),
//                 loading: Loader.loading,
//                 data: (region) {
//                   return RefreshIndicator(
//                     onRefresh: () => regionCtrl.reload(),
//                     child: SingleChildScrollView(
//                       physics: defaultScrollPhysics,
//                       child: SizedBox(
//                         height: context.height,
//                         child: Column(
//                           children: [
//                             const SizedBox(height: 10),
//                             ...config.currency.currencyData.map(
//                               (currency) => Padding(
//                                 padding:
//                                     const EdgeInsets.symmetric(vertical: 5),
//                                 child: Container(
//                                   decoration: BoxDecoration(
//                                     color: context.colorTheme.secondaryContainer
//                                         .withOpacity(0.03),
//                                     borderRadius: BorderRadius.circular(10),
//                                   ),
//                                   child: RadioListTile(
//                                     groupValue: region.currencyUid,
//                                     value: currency.uid,
//                                     onChanged: (value) {
//                                       regionCtrl.setCurrencyCode(currency.uid);
//                                     },
//                                     subtitle: Text('Rate : ${currency.rate}'),
//                                     title: Text.rich(
//                                       TextSpan(
//                                         text: currency.name,
//                                         style: context.textTheme.bodyLarge!
//                                             .copyWith(
//                                           fontWeight: FontWeight.bold,
//                                         ),
//                                         children: [
//                                           TextSpan(
//                                             text: ' (${currency.symbol})',
//                                             style: context.textTheme.bodyMedium!
//                                                 .copyWith(
//                                               fontWeight: FontWeight.w300,
//                                             ),
//                                           )
//                                         ],
//                                       ),
//                                     ),
//                                     controlAffinity:
//                                         ListTileControlAffinity.trailing,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             ),
//     );
//   }
// }
