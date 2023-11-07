import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: Scaffold(appBar: AppBar(), body: NestedContainerWidget()));
  }
}

class NestedContainerWidget extends StatefulWidget {
  @override
  _NestedContainerWidgetState createState() => _NestedContainerWidgetState();
}

class _NestedContainerWidgetState extends State<NestedContainerWidget> {
  late PageController _pageController;
  late ScrollController _listScrollController1;
  late ScrollController _listScrollController2;
  late ScrollController _listScrollController3;

  late ScrollController _activeScrollController;
  late Drag? _drag;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _listScrollController1 = ScrollController();
    _listScrollController2 = ScrollController();
    _listScrollController3 = ScrollController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _listScrollController1.dispose();
    _listScrollController2.dispose();
    _listScrollController3.dispose();
    super.dispose();
  }

  void _handleDragStart(DragStartDetails details) {
    if (_listScrollController1.hasClients ) {
      final RenderBox renderBox =
      _listScrollController1.position.context.storageContext.findRenderObject() as RenderBox;
      if (renderBox.paintBounds
          .shift(renderBox.localToGlobal(Offset.zero))
          .contains(details.globalPosition)) {
        _activeScrollController = _listScrollController1;
        _drag = _activeScrollController.position.drag(details, _disposeDrag);
        return;
      }
    }
    if (_listScrollController2.hasClients ) {
      final RenderBox renderBox =
      _listScrollController2.position.context.storageContext.findRenderObject() as RenderBox;
      if (renderBox.paintBounds
          .shift(renderBox.localToGlobal(Offset.zero))
          .contains(details.globalPosition)) {
        _activeScrollController = _listScrollController2;
        _drag = _activeScrollController.position.drag(details, _disposeDrag);
        return;
      }
    }
    if (_listScrollController3.hasClients) {
      final RenderBox renderBox =
      _listScrollController3.position.context.storageContext.findRenderObject() as RenderBox;
      if (renderBox.paintBounds
          .shift(renderBox.localToGlobal(Offset.zero))
          .contains(details.globalPosition)) {
        _activeScrollController = _listScrollController3;
        _drag = _activeScrollController.position.drag(details, _disposeDrag);
        return;
      }
    }
    _activeScrollController = _pageController;
    _drag = _pageController.position.drag(details, _disposeDrag);
  }


  /*
   * If the listView is on Page 1, then change the condition as "details.primaryDelta < 0" and
   * "_activeScrollController.position.pixels ==  _activeScrollController.position.maxScrollExtent"
   */
  void _handleDragUpdate(DragUpdateDetails details) {
    if ((_activeScrollController == _listScrollController1 || _activeScrollController == _listScrollController2 || _activeScrollController == _listScrollController3 )
         // && (details.primaryDelta! < 0)
        && (_activeScrollController.position.pixels.roundToDouble() >= _activeScrollController.position.maxScrollExtent.roundToDouble()
            || _activeScrollController.position.pixels <= _activeScrollController.position.minScrollExtent.roundToDouble() )) {
      _activeScrollController = _pageController;
      _drag?.cancel();
      _drag = _pageController.position.drag(
          DragStartDetails(
              globalPosition: details.globalPosition,
              localPosition: details.localPosition
          ),
          _disposeDrag
      );
    }
    _drag?.update(details);
  }

  void _handleDragEnd(DragEndDetails details) {
    _drag?.end(details);
  }

  void _handleDragCancel() {
    _drag?.cancel();
  }

  void _disposeDrag() {
    _drag = null;
  }

  @override
  Widget build(BuildContext context) {
    return RawGestureDetector(
      gestures: <Type, GestureRecognizerFactory>{
        VerticalDragGestureRecognizer:
        GestureRecognizerFactoryWithHandlers<VerticalDragGestureRecognizer>(
                () => VerticalDragGestureRecognizer(), (VerticalDragGestureRecognizer instance) {
          instance
            ..onStart = _handleDragStart
            ..onUpdate = _handleDragUpdate
            ..onEnd = _handleDragEnd
            ..onCancel = _handleDragCancel;
        })
      },
      behavior: HitTestBehavior.opaque,
      child: PageView(
        controller: _pageController,
        scrollDirection: Axis.vertical,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          const Center(child: Text('Page 1')),
          ListView(
            controller: _listScrollController1,
            physics: const NeverScrollableScrollPhysics(),
            children: List.generate(
              20,
                  (int index) {
                return ListTile(title: Text('Item $index'));
              },
            ),
          ),
          ListView(
            controller: _listScrollController2,
            physics: const NeverScrollableScrollPhysics(),
            children: List.generate(
              20,
                  (int index) {
                return ListTile(title: Text('Item $index'));
              },
            ),
          ),
          ListView(
            controller: _listScrollController3,
            physics: const NeverScrollableScrollPhysics(),
            children: List.generate(
              20,
                  (int index) {
                return ListTile(title: Text('Item $index'));
              },
            ),
          ),
        ],
      ),
    );
  }
}