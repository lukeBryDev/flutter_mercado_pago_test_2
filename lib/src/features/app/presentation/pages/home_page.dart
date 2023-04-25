import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:mercado_pago_example_2/src/core/env/env.dart';
import 'package:mercado_pago_example_2/src/core/settings/app_assets.dart';
import 'package:mercado_pago_example_2/src/features/data/dtos/address_dto.dart';
import 'package:mercado_pago_example_2/src/features/data/dtos/excluded_payment_dto.dart';
import 'package:mercado_pago_example_2/src/features/data/dtos/identification_dto.dart';
import 'package:mercado_pago_example_2/src/features/data/dtos/mp_payer_dto.dart';
import 'package:mercado_pago_example_2/src/features/data/dtos/mp_payment_methods_dto.dart';
import 'package:mercado_pago_example_2/src/features/data/dtos/mp_preference_dto.dart';
import 'package:mercado_pago_example_2/src/features/data/dtos/mp_preference_item_dto.dart';
import 'package:mercado_pago_example_2/src/features/data/dtos/phone_dto.dart';
import 'package:mercado_pago_example_2/src/features/data/models/mp_preference_model.dart';
import 'package:mercado_pago_example_2/src/features/domain/entities/enums/enum_identification_type.dart';
import 'package:mercado_pago_example_2/src/features/domain/entities/enums/enum_mp_currence_id_type.dart';
import 'package:mercado_pago_example_2/src/features/domain/entities/enums/enum_mp_payment_result_type.dart';
import 'package:mercado_pago_example_2/src/features/domain/entities/enums/enum_mp_payment_status_detail_type.dart';
import 'package:mercado_pago_example_2/src/features/domain/entities/enums/enum_mp_payment_status_type.dart';
import 'package:mercado_pago_example_2/src/features/domain/entities/enums/enum_mpcategory_id_type.dart';
import 'package:mercado_pago_example_2/src/features/domain/entities/mp_preference_entity.dart';
import 'package:mercado_pago_mobile_checkout/mercado_pago_mobile_checkout.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
  }

  double _counter = 0.0;
  bool _loading = false;
  PaymentResult? mpPaymentResult;

  void _incrementCounter() {
    if (mpPaymentResult != null) {
      /// reset example
      setState(() {
        _counter = 0.0;
        _loading = false;
        mpPaymentResult = null;
      });
    } else {
      setState(() => _counter = _counter + 1000.0);
    }
  }

  void _showInfoModal() {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const Text('Test Payment Method'),
                const SizedBox(height: 50),
                Column(
                  children: [
                    const Text('Copy card number and write on checkout'),
                    const SizedBox(height: 10),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Row(
                          children: [
                            const Text(
                              'Tarjeta: ',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(Env.mpPaymentCardTestName),
                          ],
                        ),
                        Row(
                          children: [
                            const Text(
                              'Número: ',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            SelectableText(Env.mpPaymentCardTestNumber),
                          ],
                        ),
                        Row(
                          children: [
                            const Text(
                              'Código de seguridad: ',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            SelectableText(
                                Env.mpPaymentCardTestExpirationSecurityCode),
                          ],
                        ),
                        Row(
                          children: [
                            const Text(
                              'Fecha de caducidad: ',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            SelectableText(Env.mpPaymentCardTestExpirationDate),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Row(
                          children: [
                            const Text(
                              'Tarjeta 2: ',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(Env.mpPaymentCardTestName2),
                          ],
                        ),
                        Row(
                          children: [
                            const Text(
                              'Número 2: ',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            SelectableText(Env.mpPaymentCardTestNumber2),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  child: const Text('Close BottomSheet'),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _mercadoPagoError(String? error) {
    log('$error', name: 'error emssage');
    showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error'),
            content: Text('Message: $error'),
            actions: <Widget>[
              TextButton(
                style: TextButton.styleFrom(
                  textStyle: Theme.of(context).textTheme.labelLarge,
                ),
                child: const Text('Accept'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  /// This reference should be generated by server
  Future<MPPreferenceEntity?> _getPreference() async {
    try {
      var params = MPPreferenceDTO(
        items: [
          MPPreferenceItemDTO(
            id: "item-ID-${math.Random().nextInt(100)}",
            title: "Test",
            categoryId: MPCategoryIdType.art,
            quantity: 1,
            currencyId: MPCurrencyIdType.cop,
            unitPrice: _counter,
          ),
        ],
        payer: MPPayerDTO(
          name: 'Elmo',
          surname: 'Toso',
          email: 'elmo_toso@gbp.com',
          address: AddressDTO(
            streetName: 'km4 - anillo vial',
            streetNumber: 44,
            zipCode: "681004",
          ),
          dateCreated: DateTime.now(),
          identification: IdentificationDTO(
              type: IdentificationType.cc, number: "1234567890"),
          phone: PhoneDTO(areaCode: 57, number: 3161984006),
        ),
        paymentMethods: MPPaymentMethodsDTO(
          excludedPaymentMethods: [
            ExcludedPaymentDTO(id: "atm"),
          ],
          excludedPaymentTypes: [
            ExcludedPaymentDTO(id: "ticket"),
          ],
        ),
        statementDescriptor: 'MINEGOCIO',
        externalReference: 'Reference_${math.Random().nextInt(100)}',
        expires: false,
      );

      final path =
          "https://api.mercadopago.com/checkout/preferences?access_token=${Env.mpAccessToken}";
      log(path, name: "POST");
      log(params.toJson().toString(), name: "POST-params");
      final res = await Dio().post(path, data: params.toJson());
      log(res.data.toString(), name: "POST-res");
      return MPPreferenceModel.fromJson(res.data);
    } on DioError catch (error) {
      log(error.toString(), name: 'Server error');
      return null;
    }
  }

  Future<void> _createOrder() async {
    /// Starting checkout
    final reference = await _getPreference();
    log('${reference?.id}', name: 'reference id');
    if (reference?.id == null) return;
    final PaymentResult res = await MercadoPagoMobileCheckout.startCheckout(
        Env.mpPublicKey, reference!.id!);
    mpPaymentResult = res;
    log('$mpPaymentResult', name: 'mpPaymentResult');

    switch (mpPaymentResult?.result.toMPPaymentResult) {
      case MPPaymentResultType.canceled:
      case MPPaymentResultType.undefined:
        return _mercadoPagoError(mpPaymentResult?.result);
      default:
    }
  }

  Future<void> _pay() async {
    setState(() {
      _loading = true;
    });
    await _createOrder();
    setState(() {
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Builder(
        builder: (BuildContext context) {
          if (mpPaymentResult?.status == null) {
            return _paymentBody();
          } else {
            return _paidBody();
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Widget _paymentBody() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          const Text(
            'You have to pay:',
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '\$$_counter',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              IconButton(
                  onPressed: () => _showInfoModal(),
                  icon: const Icon(Icons.info))
            ],
          ),
          IgnorePointer(
            ignoring: _loading || _counter <= 999.0,
            child: Opacity(
              opacity: (_loading || _counter <= 999.0) ? 0.5 : 1,
              child: MaterialButton(
                onPressed: () => _pay(),
                height: 44,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 3),
                color: const Color(0xff00B1EA),
                child: Row(
                  children: [
                    Image.asset(
                      AppAssets.mercadoPagoLogo,
                      height: 30,
                      fit: BoxFit.fitHeight,
                    ),
                    const SizedBox(width: 8.6),
                    const Text(
                      'Pagar con Mercado Pago',
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _paidBody() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Text(
            'You have paid:',
          ),
          const SizedBox(height: 5),
          Container(
            decoration: BoxDecoration(
              border: Border.all(),
              borderRadius: BorderRadius.circular(5),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: const [
                    SizedBox(
                      child: Text(
                        'Price',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(
                      child: Text(
                        'Status',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(
                      child: Text(
                        'Status detail',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                      child: SizedBox(
                        child: Text('\$$_counter'),
                      ),
                    ),
                    Flexible(
                      child: SizedBox(
                        child: Text(
                            mpPaymentResult?.status?.toMPStatus?.label ?? ''),
                      ),
                    ),
                    Flexible(
                      child: SizedBox(
                        child: Text(mpPaymentResult
                                ?.statusDetail?.toMPStatusDetail?.message ??
                            ''),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
