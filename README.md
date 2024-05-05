# Roflit app

Roflit project for test S3 by Yandex Cloud Api

## Project settings

- If you are using VS Code, consider using [Flutter Riverpod Snippets](https://riverpod.dev/assets/images/greetingProvider-47179931ef18184e7ab68f4e701ca916.gif)
- Localizations - [easy_localization ](https://pub.dev/packages/easy_localization/example):

  - Directory: `assets/translations`
  - **Generated** in terminal: `dart run easy_localization:generate -f keys -S assets/translations -o locale_keys.g.dart`
  - Change localization: `context.setLocale(Locale('en', 'US'));`
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
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'service.g.dart';

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
    final helloWorldNotifierProvider = ref.watch(helloWorldNotifierProvider); // state
    final helloWorldBlocProvider = ref.watch(helloWorldNotifierProvider.notifier); // methods

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

#### Rules for using a riverpod provider (good and bad practice):
- Good
  - providers should be created globally, not in class methods or field of class.
- Good
  - **read.watch** should only be used at the build stage of Providers - declaratively!.
    **Do not use** imperative for obtaining a state or accessing a method!
    **read.watch** - can be considered as an example of creating a subscription to a stream in initState.

- Good
  - ref.listen/listenSelf can be used instead **read.watch** according to the same principles.
    ref.listen/listenSelf - allows you to access the previous and next status of the provider.
- Good
  - **read.read** - a way to access the provider imperatively (where **read.watch** cannot be used).
- Good
  - **read.read** - use for service providers.
  - **read.watch** - use for state providers only if you need to access methods of the state provider `ref.watch(provider.notifier)`.
  - **read.watch** - use for other state providers.
- Good
  - `@Riverpod(keepAlive: true)` or `ref.keepAlive()` in body - if the provider should not be removed when there is no listener widget.
- Bad
  - usage `ref.read(provider).init()` in initState.
- Bad
  - saving form state in provider.
  - saving state in local variable of provider.
  - saving different controllers in provider.
- Bad  
  - [running side effects during provider initialization](https://riverpod.dev/docs/essentials/do_dont).  
- Bad 
  - using the providers that come with DI in the build method of the state provider.  
- Attention
  - All providers are initialized lazily.
    To initialize a provider right away, you need to listen to it [immediately in the root after ProviderScope](https://riverpod.dev/docs/essentials/eager_initialization).
  - Provider is created when it starts listening (in a widget or other provider) and is deleted when the listener is deleted. 
  - The provider state with arguments is recreated if the arguments passed are not constant.
    `ref.watch(provider([1,2])) != ref.watch(provider([1,2])) - recreated provider([1,2])`.
  - `ref.watch(provider(1))` and `ref.watch(provider(2))` - will create two independent calculations by one or more provider.
  - calling `ref.watch(provider(1))` in one widget or in two independent widgets creates only one calculation.
  - `ref.onDispose` - should not cause a state change, but can be used e.g. how `ref.onDispose(streamController.close)`.
  - `ref.onCancel` - called when the last listener of the provider is removed.
  - `ref.onResume` - called when a new listener is added after onCancel.
  - `ref.invalidate(provider)` or `ref.invalidate(provider(arg))` - forced deletion/re-creation of the specific provider.
  - Instead of comparing state with `==`, providers use `identical` (two object references to the same object.). This behavior can be changed by overriding the updateShouldNotify method in notifications.
  - It is not possible to reset all providers at the same time.
  - Using `ref` in asynchronous widget methods requires checking `context.mounted`.
