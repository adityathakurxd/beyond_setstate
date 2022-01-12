import 'package:beyond_setstate/riverpod/providers/counter_app_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CounterAppExample extends StatelessWidget {
  const CounterAppExample({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Consumer(
        builder: (context, WidgetRef ref, child) {
          final counterValue = ref.watch(counterProvider);
          return Text(
              counterValue.toString(),
          );
        }
      ),
    );
  }
}
