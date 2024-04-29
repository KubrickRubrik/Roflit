import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:roflit/feature/common/widgets/lines.dart';
import 'package:roflit/helper_remove/main/widgets/background.dart';

import 'content_section/content_section.dart';
import 'donwload_section/donwload_section.dart';
import 'loading_section/loading_section.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      child: MainBackgaround(
        child: Center(
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.7,
            child: AspectRatio(
              aspectRatio: 1.5,
              child: Container(
                // color: const Color.fromARGB(54, 33, 149, 243),
                child: Flex(
                  direction: Axis.horizontal,
                  children: [
                    const Flexible(
                      flex: 2,
                      child: DonwloadSection(),
                    ),
                    Lines.vertical(),
                    const Flexible(
                      flex: 5,
                      child: ContentSection(),
                    ),
                    Lines.vertical(),
                    const Flexible(
                      flex: 2,
                      child: LoadingSection(),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
