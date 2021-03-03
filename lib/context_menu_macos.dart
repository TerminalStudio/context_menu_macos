library context_menu_macos;

import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MacosContextMenuItem extends StatefulWidget with PreferredSizeWidget {
  MacosContextMenuItem({
    required this.content,
    this.trailing,
    this.onTap,
    double height = 20,
  }) : preferredSize = Size.fromHeight(height);

  final Widget content;
  final Widget? trailing;
  final void Function()? onTap;
  final Size preferredSize;

  @override
  _MacosContextMenuItemState createState() => _MacosContextMenuItemState();
}

class _MacosContextMenuItemState extends State<MacosContextMenuItem> {
  var isHovering = false;
  var isBlinking = false;

  @override
  Widget build(BuildContext context) {
    final trailing = widget.trailing;

    return GestureDetector(
      onTapUp: (details) {
        onTap();
      },
      onSecondaryTapUp: (details) {
        onTap();
      },
      child: MouseRegion(
        onEnter: (event) {
          setState(() => isHovering = true);
        },
        onExit: (event) {
          setState(() => isHovering = false);
        },
        child: Container(
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(4),
          ),
          padding: EdgeInsets.symmetric(
            vertical: 3,
            horizontal: 10,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              DefaultTextStyle(
                child: widget.content,
                style: TextStyle(
                  fontSize: 13,
                  color: textColor,
                ),
              ),
              if (trailing != null)
                DefaultTextStyle(
                  child: trailing,
                  style: TextStyle(
                    fontSize: 13,
                    color: trailingTextColor,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Color get backgroundColor {
    return isHovering && !isBlinking
        ? CupertinoColors.activeBlue.withAlpha(190)
        : Colors.transparent;
  }

  Color get textColor {
    return isHovering && !isBlinking
        ? CupertinoColors.white
        : CupertinoColors.black;
  }

  Color get trailingTextColor {
    return isHovering && !isBlinking
        ? CupertinoColors.white
        : Color(0x706A6A6A);
  }

  void onTap() async {
    setState(() => isBlinking = true);
    await Future.delayed(Duration(milliseconds: 70));
    setState(() => isBlinking = false);
    await Future.delayed(Duration(milliseconds: 70));
    widget.onTap?.call();
  }
}

class MacosContextMenuDivider extends StatelessWidget with PreferredSizeWidget {
  MacosContextMenuDivider();

  @override
  final preferredSize = Size.fromHeight(9);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 1,
      constraints: BoxConstraints(
        minWidth: double.infinity,
      ),
      margin: EdgeInsets.symmetric(
        vertical: 4,
        horizontal: 10,
      ),
      decoration: BoxDecoration(
        color: Color(0x60969798),
      ),
    );
  }
}

class MacosContextMenuSurface extends StatelessWidget {
  MacosContextMenuSurface({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(6),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Color(0x77B0B0B0)),
            color: Color(0xCCF2F2F2), // dark Color(0xBF1E1E1E)
            borderRadius: BorderRadius.circular(6),
          ),
          child: child,
        ),
      ),
    );
  }
}

class MacosContextMenu extends StatelessWidget {
  MacosContextMenu({
    required this.globalPosition,
    required this.children,
    required this.width,
  });

  static const padding = 4.0;

  final Offset globalPosition;
  final List<PreferredSizeWidget> children;
  final double width;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constrains) {
      // show at left top by default
      double? left = globalPosition.dx;
      double? top = globalPosition.dy;
      double? right;
      double? bottom;

      if (left + width > constrains.maxWidth) {
        if (left > width) {
          right = constrains.maxWidth - left;
          left = null;
        } else {
          left = constrains.maxWidth - width;
          if (left < 0) {
            left = 0;
          }
        }
      }

      final height = rawHeight;
      if (top + height > constrains.maxHeight) {
        if (top > height) {
          bottom = constrains.maxHeight - top;
          top = null;
        } else {
          top = constrains.maxHeight - height;
          if (top < 0) {
            top = 0;
          }
        }
      }

      return Stack(
        children: [
          Positioned(
            left: left,
            top: top,
            right: right,
            bottom: bottom,
            child: MacosContextMenuSurface(
              child: SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.all(padding),
                  constraints: BoxConstraints(
                    maxWidth: width,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: children,
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    });
  }

  double get rawHeight {
    var height = padding * 2;

    for (var child in children) {
      height += child.preferredSize.height;
    }

    return height;
  }
}

Future<T?> showMacosContextMenu<T>({
  required BuildContext context,
  required Offset globalPosition,
  required List<PreferredSizeWidget> children,
  double width = 150,
}) {
  return showGeneralDialog(
    barrierColor: Colors.transparent,
    barrierDismissible: true,
    barrierLabel: 'Dismiss',
    context: context,
    transitionDuration: Duration(milliseconds: 100),
    transitionBuilder: (context, animation, __, child) {
      // show instantly
      if (animation.status == AnimationStatus.forward) {
        return child;
      }

      // fade transition on quit
      return FadeTransition(
        opacity: animation,
        child: child,
      );
    },
    pageBuilder: (context, _, __) {
      return MacosContextMenu(
        globalPosition: globalPosition,
        children: children,
        width: width,
      );
    },
  );
}
