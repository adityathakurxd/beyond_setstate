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
