// import 'package:e_com/core/core.dart';
// import 'package:e_com/feature/check_out/providers/provider.dart';
// import 'package:e_com/feature/payment/payment_gateway/payment_gateway.dart';
// import 'package:e_com/widgets/widgets.dart';
// import 'package:flex_color_scheme/flex_color_scheme.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_hooks/flutter_hooks.dart';
// import 'package:flutter_stripe/flutter_stripe.dart';
// import 'package:go_router/go_router.dart';
// import 'package:hooks_riverpod/hooks_riverpod.dart';

// class StripePaymentView extends ConsumerStatefulWidget {
//   const StripePaymentView({super.key});

//   @override
//   ConsumerState<StripePaymentView> createState() => _StripePaymentViewState();
// }

// class _StripePaymentViewState extends ConsumerState<StripePaymentView> {
//   final controller = CardFormEditController();

//   @override
//   void initState() {
//     controller.addListener(update);

//     super.initState();
//   }

//   void update() => setState(() {});
//   @override
//   void dispose() {
//     controller.removeListener(update);
//     controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final paymentMethod = ref.watch(
//         checkoutStateProvider.select((value) => value?.paymentLog.method));

//     return Scaffold(
//       appBar: KAppBar(
//         leading: SquareButton.backButton(
//           onPressed: () => context.pop(),
//         ),
//         title: const Text('STRIPE'),
//       ),
//       body: SingleChildScrollView(
//         padding: defaultPaddingAll,
//         child: Column(
//           children: [
//             CardFormField(
//               style: CardFormStyle(
//                 backgroundColor: const Color(0xFF5433FF),
//                 placeholderColor: Colors.white.withOpacity(.7),
//                 borderColor: context.colorTheme.outline,
//                 borderRadius: Corners.lg.toInt(),
//                 borderWidth: 1,
//                 textColor: Colors.white,
//                 textErrorColor: context.colorTheme.error,
//               ),
//               controller: controller,
//             ),
//             const SizedBox(height: 10),
//             HookBuilder(
//               builder: (context) {
//                 final isLoading = useState(false);
//                 return SizedBox(
//                   width: double.infinity,
//                   height: 50,
//                   child: FilledButton(
//                     style: FilledButton.styleFrom(
//                       backgroundColor:
//                           const Color(0xFF5433FF).blend(Colors.white, 60),
//                       foregroundColor: Colors.black,
//                     ),
//                     onPressed: controller.details.complete
//                         ? () async {
//                             if (paymentMethod == null) return;

//                             isLoading.value = true;

//                             final ctrl = ref.read(
//                               stripePaymentCtrlProvider(paymentMethod).notifier,
//                             );

//                             await ctrl.confirmPayment(context);

//                             isLoading.value = false;
//                           }
//                         : null,
//                     child: isLoading.value
//                         ? const SizedBox.square(
//                             dimension: 20,
//                             child: CircularProgressIndicator(
//                               color: Color(0xFF5433FF),
//                             ),
//                           )
//                         : const Text('Pay with stripe'),
//                   ),
//                 );
//               },
//             ),
//             const SizedBox(height: 20),
//           ],
//         ),
//       ),
//     );
//   }
// }
