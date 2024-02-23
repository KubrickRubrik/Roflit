# Roflit app

Roflit project for test S3 by Yandex Cloud Api

## Project settings

- If you are using VS Code, consider using [Flutter Riverpod Snippets](https://riverpod.dev/assets/images/greetingProvider-47179931ef18184e7ab68f4e701ca916.gif)
- Localizations - [easy_localization ](https://pub.dev/packages/easy_localization/example):
  - Directory: ```assets/translations```
  - **Generated** in terminal: ```dart run easy_localization:generate -f keys -S assets/translations -o locale_keys.g.dart```
  - Change localization: ```context.setLocale(Locale('en', 'US'));```
  - Translate: 
  ```
    LocaleKeys.title.tr() // - preferred use. 
    context.tr('title');
    context.plural('money', 10.23);
    plural('money_args', 10.23, args: ['John', '10.23']);
    'example.emptyNameError'.tr();
  ```

 - Generate/Regenerate all generated files of the project:
```
- dart run build_runner build 
- dart run build_runner build --delete-conflicting-outputs

- dart run build_runner watch
- dart run build_runner watch --delete-conflicting-outputs
```
Directory generated: **lib/generated**
## Riverpod

If you want to check those warnings in the CI/terminal, you can run the following:

```
dart run custom_lint
```

##### Example

- Simple service provider riverpod:

```
@riverpod
HelloWorldService helloWorldService(helloWorldServiceRef ref) {
  return HelloWorldService();
}

final class HelloWorldService{}
```

- Notifier provider riverpod (with state):

```
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'state.dart';
part 'notifier.g.dart';

@riverpod
final class HelloWorldNotifier extends _$HelloWorldNotifier {
  @override
  HelloWorldState build() {
    return const HelloWorldState();
  }

  void setTab(int index) {
    state = state.copyWith(indexPageTab: index);
  }
}
```

- State for provider riverpod:

```
import 'package:freezed_annotation/freezed_annotation.dart';

part 'activity.freezed.dart';
part 'activity.g.dart'; // only if use fromJson()

@freezed
class HelloWorldState with _$HelloWorldState {
  factory HelloWorldState({
    required String key,
    required String activity,
    required String type,
    required int participants,
    required double price,
  }) = _HelloWorldState_;

  factory HelloWorldState.fromJson(Map<String, dynamic> json) =>
      _$HelloWorldStateFromJson(json);
}
```

- Adding a ScopeContainer Riverpod to a tree context:

```
void main() {
 // This should not be inside "MyApp" but as direct parameter to "runApp".
  runApp(
    ProviderScope(
      child: MyApp(),
    ),
  );
}
```

- Listening to the provider in the widget:

```
class Home extends ConsumerWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final helloWorldServiceProvider = ref.watch(helloWorldServiceProvider); // service
    final helloWorldNotifierProvider = ref.watch(HelloWorldNotifierProvider); // state
    final helloWorldBlocProvider = ref.watch(HelloWorldNotifierProvider.notifier); // methods

    return Center(
        /// We could alternatively use `if (activity.isLoading) { ... }
        child: switch (activity) {
        AsyncData(:final value) => Text('Activity: ${value.activity}'),
        AsyncError() => const Text('Oops, something unexpected happened'),
        _ => const CircularProgressIndicator(),
        },
    );
  }
}
```

- Widgets for listening to providers without and with hooks:
```
StatelessWidget -> ConsumerWidget -> HookConsumerWidget (HookWidget - only hooks)
StatefulWidget  -> ConsumerStatefulWidget -> StatefulHookConsumerWidget (HookStatefulWidget - only hooks) 
```


