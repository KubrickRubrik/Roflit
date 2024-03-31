import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:roflit/feature/common/themes/colors.dart';
import 'package:roflit/feature/presentation/main/bloc/notifier.dart';

class ContentMainBuckets extends ConsumerWidget {
  const ContentMainBuckets({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(mainNotifierProvider);
    return state.maybeWhen(
      loading: () => const Center(child: CircularProgressIndicator()),
      orElse: SizedBox.shrink,
      loaded: (selectedBucket, buckets) {
        return Flexible(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Buckets
                Wrap(
                  spacing: 8,
                  children: List.generate(buckets.length, (index) {
                    return ContentMainBuckeTsItem(index);
                  }),
                ),
                // Objects
                const SizedBox(height: 16),
                if (buckets.isNotEmpty) const ContentMainBucketObjects(),
              ],
            ),
          ),
        );
      },
    );
  }
}

class ContentMainBuckeTsItem extends HookConsumerWidget {
  const ContentMainBuckeTsItem(this.index, {super.key});

  final int index;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bloc = ref.watch(mainNotifierProvider.notifier);
    final bucket = ref
        .watch(mainNotifierProvider.select((value) => (value as MainLoadedState).buckets[index]));

    final isHover = useState(false);
    final color = useMemoized(() {
      return index.isEven
          ? const Color(AppColors.bgDarkGray)
          : const Color(AppColors.bgDarkGray).withOpacity(0.2);
    });

    return InkWell(
      onTap: () {
        bloc.getBucketObjects(index);
      },
      onHover: (value) {
        isHover.value = value;
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 120,
            width: 120,
            child: Stack(
              children: [
                Positioned.fill(
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 350),
                    curve: Curves.ease,
                    decoration: BoxDecoration(
                      color: isHover.value ? const Color(AppColors.bgDarkGrayHover) : color,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
                if (bucket.loading)
                  Container(
                    alignment: Alignment.center,
                    color: const Color(AppColors.bgDarkGrayHover),
                    child: const CircularProgressIndicator(),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            bucket.name,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 12,
              color: Color(AppColors.grayText),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class ContentMainBucketObjects extends ConsumerWidget {
  const ContentMainBucketObjects({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final objects = ref.watch(mainNotifierProvider.select((value) {
      return (value as MainLoadedState).buckets[value.selectedBucket].objects;
    }));

    return Column(
      children: List.generate(objects.length, (index) {
        return ContentMainBucketObjectsItem(index);
      }),
    );
  }
}

class ContentMainBucketObjectsItem extends HookConsumerWidget {
  const ContentMainBucketObjectsItem(this.index, {super.key});

  final int index;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bloc = ref.watch(mainNotifierProvider.notifier);
    final object = ref.watch(mainNotifierProvider.select((value) {
      final list = (value as MainLoadedState).buckets[value.selectedBucket].objects;
      if (list.isEmpty) return null;
      return list[index];
    }));

    final isHover = useState(false);
    final color = useMemoized(() {
      return index.isEven
          ? const Color(AppColors.bgDarkGray).withOpacity(0.3)
          : const Color(AppColors.bgDarkGray).withOpacity(0.2);
    });

    String dateModify(String dateModify) {
      final date = DateTime.parse(dateModify);
      return '${date.hour}:${date.second.toString().padLeft(2, '0')} | ${date.day}.${date.month.toString().padLeft(2, '0')}.${date.year}';
    }

    return (object == null)
        ? const SizedBox.shrink()
        : InkWell(
            onTap: () {
              // bloc.getBucketObjects(index);
            },
            onHover: (value) {
              isHover.value = value;
            },
            child: AnimatedContainer(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              constraints: const BoxConstraints(minHeight: 40),
              duration: const Duration(milliseconds: 350),
              curve: Curves.ease,
              decoration: BoxDecoration(
                color: isHover.value ? const Color(AppColors.bgDarkGrayHover) : color,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Text(
                      object.key,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(AppColors.grayText),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Flexible(
                    child: Text(
                      '${(int.parse(object.size) / 1024).toStringAsFixed(2)} Kb | ${dateModify(object.lastModified)}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(AppColors.grayText),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}
