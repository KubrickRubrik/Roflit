import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
// import 'package:raids/features/components/themes/pattern/params/colors.dart';
// import 'package:raids/features/components/themes/pattern/params/effect.dart';
// import 'package:raids/features/components/themes/pattern/params/gradients.dart';
// import 'package:raids/features/components/themes/pattern/params/text.dart';

void useInitState({
  // Before building the widget tree.
  Dispose? Function()? initState,
  // After building the widget tree.
  Function? onBuild,
  // Update when key is changed
  List<Object?>? keys,
}) {
  useEffect(() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      onBuild?.call();
    });
    final dispose = initState?.call();
    return () {
      dispose?.call();
    };
  }, keys ?? []);
}

// TextThemes useTextThemeExt() => Theme.of(useContext()).extension<TextThemes>() as TextThemes;
// ColorsThemes useColorsThemeExt() => Theme.of(useContext()).extension<ColorsThemes>() as ColorsThemes;
// EffectStyles useEffectThemeExt() => Theme.of(useContext()).extension<EffectStyles>() as EffectStyles;
// GradientsThemes useGradientsThemeExt() => Theme.of(useContext()).extension<GradientsThemes>() as GradientsThemes;

// ({TextThemes text, ColorsThemes colors, GradientsThemes gradients, EffectStyles effect}) useThemeExt() {
//   final theme = Theme.of(useContext());
//   return (
//     text: theme.extension<TextThemes>() as TextThemes,
//     colors: theme.extension<ColorsThemes>() as ColorsThemes,
//     gradients: theme.extension<GradientsThemes>() as GradientsThemes,
//     effect: theme.extension<EffectStyles>() as EffectStyles,
//   );
// }
