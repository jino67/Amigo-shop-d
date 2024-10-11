import 'package:e_com/core/core.dart';
import 'package:e_com/feature/check_out/providers/provider.dart';
import 'package:e_com/feature/payment/payment_gateway/payment_gateway.dart';
import 'package:e_com/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:get/get.dart';
import 'package:cinetpay/cinetpay.dart';



class FlutterWaveWebviewPage extends HookConsumerWidget {
  const FlutterWaveWebviewPage({super.key, required this.url});
  
  final String url;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    TextEditingController amountController = TextEditingController();
    final paymentMethod = ref.watch(
        checkoutStateProvider.select((value) => value?.paymentLog.method));

    if (paymentMethod == null) {
      return ErrorView.withScaffold('Failed to load Instamojo Information');
    }

    final flutterWaveCtrl = useCallback(
        () => ref.read(flutterWaveCtrlProvider(paymentMethod).notifier));



    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
       theme: ThemeData(
        primarySwatch: Colors.red,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Scaffold(
        
            appBar: AppBar(
              title: const Text("Paiement de la commande"),
              centerTitle: true,
            ),
            body: SafeArea(
                child: Center(
                    child: ListView(
                      shrinkWrap: true,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(height: 40.0),
                            if(flutterWaveCtrl().isPerSlice)
                            Text(
                            "Montant à payer",
                            style: Theme.of(context).textTheme.displayLarge,
                          ),
                          if(flutterWaveCtrl().isPerSlice)
                          const SizedBox(height: 50.0),
                          if(flutterWaveCtrl().isPerSlice)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 20.0),
                            margin: const EdgeInsets.symmetric(horizontal: 50.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12.0),
                              border: Border.all(color: Colors.green),
                            ),
                            child: TextField(
                              controller: amountController,
                              decoration: const InputDecoration(
                                hintText: "La somme à payer",
                                border: InputBorder.none,
                              ),
                              keyboardType: TextInputType.number,
                            ),
                          ),
                           const SizedBox(height: 40.0),
                            ElevatedButton(
                              child: const Text("Procéder au paiement"),
                              onPressed: () async {
                                dynamic amount;
                                int totalPrice;
                                if(flutterWaveCtrl().isPerSlice) {
                                      amount = amountController.text ;
                                totalPrice = int.parse(flutterWaveCtrl().amount);
                                } else {
                                  amount = flutterWaveCtrl().amount;
                                  totalPrice = int.parse(amount);
                                }
                             
                                double _amount;
                                try {
                                  _amount = double.parse(amount);
                                  if (_amount < 100 || _amount > totalPrice )
                                  {
                                    return;
                                  }
                                } catch (exception) {
                                  return;
                                }
      
                               
      
                                final String transactionId = flutterWaveCtrl().transactionId; // Mettre en place un endpoint à contacter côté serveur pour générer des ID unique dans votre BD
      
                                await Get.to(CinetPayCheckout(
                                  title: 'Paiement',
                                  titleStyle: const TextStyle(
                                      fontSize: 20, fontWeight: FontWeight.bold),
                                  titleBackgroundColor: Colors.green,
                                  configData: <String, dynamic>{
                                    'apikey': '40213724963133d80097d41.42716647',
                                    'site_id': int.parse("633966"),
                                    'notify_url': 'https://goaicorporation/notify'
                                  },
                                  paymentData: <String, dynamic>{
                                    'transaction_id': transactionId,
                                    'amount': _amount,
                                    'currency': 'XOF',
                                    'channels': 'ALL',
                                    'description': 'Paiement de commande',
                                  },
                                  waitResponse: (data) {
                                    
                                      
                                        if (data['status'] == "ACCEPTED")
                                        {
                                          if (flutterWaveCtrl().isPerSlice) {
                                            flutterWaveCtrl().addSlice(context, amount, flutterWaveCtrl().transactionId);
                                          } else {
                                            flutterWaveCtrl().confirmPayment(context, transactionId);
                                          }

                                        } else {
                                          flutterWaveCtrl().declinePayment(context);
                                        }
                                      
                                    
                                  },
                                  onError: (data) {
                                 
                                        dynamic response = data;
                                     
                                        Get.back();
                                      
                                    
                                  },
                                ));
                              },
                            )
                          ],
                        ),
                      ],
                    )))),
    );
  }
}
