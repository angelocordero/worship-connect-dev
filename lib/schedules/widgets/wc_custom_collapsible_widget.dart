import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:worship_connect/schedules/utils/schedules_providers_definition.dart';

class WCCustomCollapsibleWidget extends ConsumerStatefulWidget {
  const WCCustomCollapsibleWidget({Key? key, required this.child, required this.axisAlignment}) : super(key: key);

  final Widget child;
  final double axisAlignment;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => WCCustomCollapsibleWidgetState();
}

class WCCustomCollapsibleWidgetState extends ConsumerState<WCCustomCollapsibleWidget> with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    _controller = AnimationController(
      duration: const Duration(milliseconds: 250),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.linear,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<bool>(isEditingProvider, (_, next) async {
      if (next == true) {
        await _controller.forward();
      } else {
        await _controller.reverse();
      }
    });

    return SizeTransition(
      axisAlignment: widget.axisAlignment,
      sizeFactor: _animation,
      axis: Axis.vertical,
      child: widget.child,
    );
  }
}
