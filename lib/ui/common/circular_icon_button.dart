import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../core/styles/app_colors.dart';
import '../../utils/extension_functions.dart';

/// Icon Image Sources
///
enum IconImageSource {
  local,
  network,
}

/// NaxaCircularIconButton
///
class CircularIconButton extends StatelessWidget {
  final String urlOrName;
  final VoidCallback? onClick;
  final bool loading;
  final IconImageSource imageSource;

  const CircularIconButton({
    super.key,
    required this.urlOrName,
    this.loading = false,
    this.onClick,
    this.imageSource = IconImageSource.local,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: !loading ? onClick : null,
      borderRadius: BorderRadius.circular(50.0),
      splashColor: context.theme.primaryColor.withOpacity(0.5),
      child: Container(
        width: 50.0,
        height: 50.0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50.0),
          border: Border.all(
            width: 1.0,
            color: AppColors.greyLight,
          ),
        ),
        child: Stack(
          children: [
            Center(
              child: imageSource == IconImageSource.local
                  ? urlOrName.endsWith(".svg")
                      ? SvgPicture.asset(
                          urlOrName,
                          width: 24.0,
                          height: 24.0,
                        )
                      : Image.asset(
                          urlOrName,
                          width: 24.0,
                          height: 24.0,
                          errorBuilder: (_, err, trace) => const SizedBox(),
                        )
                  : urlOrName.isUrl
                      ? urlOrName.contains(".svg")
                          ? SvgPicture.network(
                              urlOrName,
                              width: 24.0,
                              height: 24.0,
                            )
                          : Image.network(
                              urlOrName,
                              width: 24.0,
                              height: 24.0,
                              errorBuilder: (_, err, trace) => const SizedBox(),
                            )
                      : const SizedBox(),
            ),
            if (loading)
              Center(
                child: SizedBox(
                  width: double.maxFinite,
                  height: double.maxFinite,
                  child: CircularProgressIndicator(
                    color: context.theme.primaryColor,
                    strokeWidth: 1.0,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
