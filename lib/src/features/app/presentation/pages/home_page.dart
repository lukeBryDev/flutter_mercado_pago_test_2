import 'package:flutter/material.dart';
import 'package:mercado_pago_example_2/src/core/env/env.dart';
import 'package:mercado_pago_example_2/src/core/settings/app_assets.dart';
import 'package:mercado_pago_example_2/src/features/domain/entities/enums/enum_mp_payment_status_detail_type.dart';
import 'package:mercado_pago_example_2/src/features/domain/entities/enums/enum_mp_payment_status_type.dart';
import 'package:mercado_pago_example_2/src/features/domain/entities/mp_payment_result_entity.dart';

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
  MPPaymentResultEntity? mpPaymentResult;

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
        return SizedBox(
          height: 250,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const Text('Test Payment Method'),
                const SizedBox(height: 50),
                Column(
                  children: [
                    const Text('Copy card number'),
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

  Future<void> _pay() async {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Builder(
        builder: (BuildContext context) {
          if (mpPaymentResult == null) {
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
                        child: Text(mpPaymentResult?.status?.label ?? ''),
                      ),
                    ),
                    Flexible(
                      child: SizedBox(
                        child:
                            Text(mpPaymentResult?.statusDetail?.message ?? ''),
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
