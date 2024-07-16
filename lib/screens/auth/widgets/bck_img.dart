import 'package:flutter/material.dart';
import 'package:meal_planning/utils/styles.dart';

class KBackgorundImageWidget extends StatelessWidget {
  const KBackgorundImageWidget({
    super.key,
    required this.sizeConfig,
  });

  final SizeConfig sizeConfig;

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) => const LinearGradient(
        colors: [Colors.black45, Colors.black87],
        begin: Alignment.center,
        end: Alignment.bottomCenter,
      ).createShader(bounds),
      blendMode: BlendMode.darken,
      child: Container(
        width: sizeConfig.screenWidth,
        height: sizeConfig.screenHeight,
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/images/login_scrn.jpg'),
              fit: BoxFit.cover),
        ),
      ),
    );
  }
}
