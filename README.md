# beyond_setstate

### Joke Model
```dart
class Joke {
  final String setup;
  final String delivery;

  const Joke({
    required this.setup,
    required this.delivery,
  });

  factory Joke.fromAPI(Map<String, dynamic> json) {
    return Joke(
      setup: json['setup'],
      delivery: json['delivery'],
    );
  }
}

```

Future Provider for Joke

```dart
final jokeProvider = FutureProvider<Joke>((ref) async {
  var url = Uri.parse('https://v2.jokeapi.dev/joke/Any');
  var response = await http.get(url);
  // ignore: avoid_print
  print('Response status: ${response.statusCode}');
  var joke = Joke.fromAPI(jsonDecode(response.body));
  return joke;
});
```

Using it in app
`final joke = ref.watch(jokeProvider);`

```dart
 joke.when(
              data: (joke) => Column(
                children: [
                  Text(joke.setup),
                  Text(joke.delivery),
                ],
              ),
              error: (error, stack) => const Text('Oops'),
              loading: () => const CircularProgressIndicator(),
            )
```

# BLoC

### Events
```dart
abstract class CounterEvent {
  final String value;
  const CounterEvent(this.value);
}

class IncrementEvent extends CounterEvent {
  const IncrementEvent(String value) : super(value);
}

class DecrementEvent extends CounterEvent {
  const DecrementEvent(String value) : super(value);
}

```

### State
```dart
abstract class CounterState {
  final int value;
  const CounterState(this.value);
}

class CounterStateValid extends CounterState {
  CounterStateValid(int value) : super(value);
}

class CounterStateInvalidNumber extends CounterState {
  final String invalidValue;

  CounterStateInvalidNumber({
    required this.invalidValue,
    required int previousValue,
  }) : super(previousValue);
}
```

### bloc

```dart
import 'package:bloc/bloc.dart';
import 'counter_events.dart';
import 'counter_state.dart';

class CounterBloc extends Bloc<CounterEvent, CounterState> {
  CounterBloc(initialState) : super(CounterStateValid(0)) {
    on<IncrementEvent>((event, emit) {
      final integer = int.parse(event.value);
      if (integer == null) {
        emit(CounterStateInvalidNumber(
            invalidValue: event.value, previousValue: state.value));
      } else {
        emit(CounterStateValid(state.value + integer));
      }
    });
    on<DecrementEvent>((event, emit) {
      final integer = int.parse(event.value);
      if (integer == null) {
        emit(CounterStateInvalidNumber(
            invalidValue: event.value, previousValue: state.value));
      } else {
        emit(CounterStateValid(state.value - integer));
      }
    });
  }
}

```

### Home UI
```dart
import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late final TextEditingController _controller;

  @override
  void initState() {
    _controller = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Value = 0',
              style: TextStyle(fontSize: 20),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: TextField(
                controller: _controller,
                decoration: InputDecoration(hintText: 'Enter a number!'),
                keyboardType: TextInputType.number,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                    onPressed: () {},
                    child: Text('-', style: TextStyle(fontSize: 20))),
                ElevatedButton(
                    onPressed: () {},
                    child: Text('+', style: TextStyle(fontSize: 20))),
              ],
            )
          ],
        ),
      ),
    );
  }
}
```
