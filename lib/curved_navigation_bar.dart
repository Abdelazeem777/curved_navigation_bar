import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'src/nav_button.dart';
import 'src/nav_custom_painter.dart';

typedef _LetIndexPage = bool Function(int value);

class CurvedNavigationBar extends StatefulWidget {
  final List<Widget>? icons;
  final List<Widget Function(int)>? iconsBuilder;
  final List<String>? labels;
  final int index;
  final Color color;
  final Color? buttonBackgroundColor;
  final Color backgroundColor;
  final ValueChanged<int>? onTap;
  final _LetIndexPage letIndexChange;
  final Curve animationCurve;
  final Duration animationDuration;
  final double height;
  final Color selectedItemColor;
  final double bottomMargin;

  CurvedNavigationBar({
    Key? key,
    this.iconsBuilder,
    this.icons,
    this.index = 0,
    this.color = Colors.white,
    this.buttonBackgroundColor,
    this.backgroundColor = Colors.blueAccent,
    this.onTap,
    _LetIndexPage? letIndexChange,
    this.animationCurve = Curves.easeOut,
    this.animationDuration = const Duration(milliseconds: 600),
    this.height = 75.0,
    this.labels,
    this.selectedItemColor = Colors.black,
    this.bottomMargin = 0.0,
  })  : letIndexChange = letIndexChange ?? ((_) => true),
        assert(!(iconsBuilder == null && icons == null) &&
            !(iconsBuilder != null && icons != null)),
        assert((iconsBuilder?.length ?? 0) >= 1 || (icons?.length ?? 0) >= 1),
        assert((0 <= index && index < (iconsBuilder?.length ?? 0)) ||
            (0 <= index && index < (icons?.length ?? 0))),
        assert(0 <= height && height <= 75.0),
        super(key: key);

  @override
  CurvedNavigationBarState createState() => CurvedNavigationBarState();
}

class CurvedNavigationBarState extends State<CurvedNavigationBar>
    with SingleTickerProviderStateMixin {
  late double _startingPos;
  int _endingIndex = 0;
  late double _pos;
  num _buttonHide = 0;
  Widget Function(int)? _iconBuilder;
  Widget? _icon;
  late AnimationController _animationController;
  late int _length;

  @override
  void initState() {
    super.initState();
    if (widget.iconsBuilder != null)
      _iconBuilder = widget.iconsBuilder![widget.index];
    if (widget.icons != null) _icon = widget.icons![widget.index];
    if (widget.iconsBuilder != null)
      _length = widget.iconsBuilder!.length;
    else
      _length = widget.icons!.length;
    _pos = widget.index / _length;
    _startingPos = widget.index / _length;
    _animationController = AnimationController(vsync: this, value: _pos);
    _animationController.addListener(() {
      setState(() {
        _pos = _animationController.value;
        final endingPos;
        if (widget.iconsBuilder != null)
          endingPos = _endingIndex / widget.iconsBuilder!.length;
        else
          endingPos = _endingIndex / widget.icons!.length;

        final middle = (endingPos + _startingPos) / 2;
        if ((endingPos - _pos).abs() < (_startingPos - _pos).abs()) {
          if (_iconBuilder != null)
            _iconBuilder = widget.iconsBuilder![_endingIndex];
          else
            _icon = widget.icons![_endingIndex];
        }
        _buttonHide =
            (1 - ((middle - _pos) / (_startingPos - middle)).abs()).abs();
      });
    });
  }

  @override
  void didUpdateWidget(CurvedNavigationBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.index != widget.index) {
      final newPosition = widget.index / _length;
      _startingPos = _pos;
      _endingIndex = widget.index;
      _animationController.animateTo(newPosition,
          duration: widget.animationDuration, curve: widget.animationCurve);
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SizedBox(
      height: widget.height,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.bottomCenter,
        children: <Widget>[
          Positioned(
            bottom: widget.bottomMargin - 40.0 - (75.0 - widget.height),
            left: Directionality.of(context) == TextDirection.rtl
                ? null
                : _pos * (size.width - 32.0),
            right: Directionality.of(context) == TextDirection.rtl
                ? _pos * (size.width - 32.0)
                : null,
            width: (size.width - 32.0) / _length,
            child: Center(
              child: Transform.translate(
                offset: Offset(
                  Directionality.of(context) == TextDirection.rtl
                      ? -16.0
                      : 16.0,
                  -(1 - _buttonHide) * 95,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: widget.iconsBuilder != null
                      ? _iconBuilder!(widget.index)
                      : _icon,
                ),
              ),
            ),
          ),
          Positioned(
            left: 0.0,
            right: 0.0,
            bottom: widget.bottomMargin,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                child: CustomPaint(
                  painter: NavCustomPainter(
                    _pos,
                    _length,
                    widget.color,
                    Directionality.of(context),
                  ),
                  child: SizedBox(height: widget.height - 10),
                ),
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: widget.bottomMargin - (75.0 - widget.height),
            child: SizedBox(
                height: 100.0,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: widget.iconsBuilder != null
                      ? Row(
                          children:
                              widget.iconsBuilder!.mapIndexed((index, item) {
                          return NavButton(
                            onTap: _buttonTap,
                            position: _pos,
                            length: _length,
                            label: widget.labels == null
                                ? null
                                : widget.labels![index],
                            index: widget.iconsBuilder!.indexOf(item),
                            child: item(index),
                            labelColor: widget.selectedItemColor,
                          );
                        }).toList())
                      : Row(
                          children: widget.icons!.mapIndexed((index, item) {
                          return NavButton(
                            onTap: _buttonTap,
                            position: _pos,
                            length: _length,
                            label: widget.labels == null
                                ? null
                                : widget.labels![index],
                            index: widget.icons!.indexOf(item),
                            child: item,
                            labelColor: widget.selectedItemColor,
                          );
                        }).toList()),
                )),
          ),
        ],
      ),
    );
  }

  void setPage(int index) {
    _buttonTap(index);
  }

  void _buttonTap(int index) {
    if (!widget.letIndexChange(index)) {
      return;
    }
    if (widget.onTap != null) {
      widget.onTap!(index);
    }
    final newPosition = index / _length;
    setState(() {
      _startingPos = _pos;
      _endingIndex = index;
      _animationController.animateTo(newPosition,
          duration: widget.animationDuration, curve: widget.animationCurve);
    });
  }
}
