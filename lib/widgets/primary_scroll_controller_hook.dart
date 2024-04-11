
import 'package:flutter/material.dart';
import 'package:flutter_github_app/utils/log_util.dart';

/// 拦截掉ScrollView通过PrimaryScrollController向上查找返回的ScrollController, 返回hook过的ScrollController，
/// 根据TapBarView子child显隐性控制ScrollController的attach/detach行为，解决NestScrollView下TabBarView同步滑动的问题.
/// 参考：https://www.jianshu.com/p/ab473fb8ceb0
class PrimaryScrollControllerHook extends StatefulWidget{

  const PrimaryScrollControllerHook({
    required this.key,
    required this.child
  });

  final Key key;

  final Widget child;

  @override
  State createState() => PrimaryScrollControllerHookState();
}

class PrimaryScrollControllerHookState extends State<PrimaryScrollControllerHook>{

  late _ScrollControllerHook _scrollControllerHook;

  void onVisibleChanged(bool isVisible){
    _scrollControllerHook.onVisibleChanged(isVisible);
  }

  @override
  void initState() {
    super.initState();
    _scrollControllerHook = _ScrollControllerHook();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _scrollControllerHook.base = PrimaryScrollController.of(context);
  }

  @override
  Widget build(BuildContext context) {
    return PrimaryScrollController(
      controller: _scrollControllerHook,
      child: widget.child
    );
  }

}

class _ScrollControllerHook implements ScrollController{

  static final tag = 'ScrollControllerHook';

  late ScrollController base;
  late ScrollPosition _position;
  bool _isVisible = true;

  void onVisibleChanged(bool isVisible){
    LogUtil.printString(tag, 'onVisibleChanged: $isVisible');
    _isVisible = isVisible;
    if(_isVisible){
      attach(_position);
    }else{
      detach(_position);
    }
  }

  @override
  void attach(ScrollPosition? position) {
    if(position == null || base.positions.contains(position)){
      return;
    }
    if(_isVisible){
      base.attach(position);
    }
    _position = position;
    LogUtil.printString(tag, 'attach: $position');
  }

  @override
  void detach(ScrollPosition? position){
    if(position == null || !base.positions.contains(position)){
      return;
    }
    base.detach(position);
    LogUtil.printString(tag, 'detach: $position');
  }

  @override
  ScrollControllerCallback? get onAttach => base.onAttach;
  
  @override
  ScrollControllerCallback? get onDetach => base.onDetach;

  @override
  void addListener(listener) => base.addListener(listener);

  @override
  Future<void> animateTo(double offset, {required Duration duration, required Curve curve}) => base.animateTo(offset, duration: duration, curve: curve);

  @override
  ScrollPosition createScrollPosition(ScrollPhysics physics, ScrollContext context, ScrollPosition? oldPosition) => base.createScrollPosition(physics, context, oldPosition);
  @override
  void debugFillDescription(List<String> description) => base.debugFillDescription(description);

  @override
  String? get debugLabel => base.debugLabel;

  @override
  void dispose() => base.dispose();

  @override
  bool get hasClients => base.hasClients;

  @override
  bool get hasListeners => base.hasListeners;

  @override
  double get initialScrollOffset => base.initialScrollOffset;

  @override
  void jumpTo(double value) => base.jumpTo(value);

  @override
  bool get keepScrollOffset => base.keepScrollOffset;

  @override
  void notifyListeners() => base.notifyListeners();

  @override
  double get offset => base.offset;

  @override
  ScrollPosition get position => base.position;

  @override
  Iterable<ScrollPosition> get positions => base.positions;

  @override
  void removeListener(listener) => base.removeListener(listener);

}