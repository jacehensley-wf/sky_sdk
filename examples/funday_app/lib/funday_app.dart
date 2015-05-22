import 'package:sky/framework/animation/animated_value.dart';
import 'package:sky/framework/animation/curves.dart';
import 'package:sky/framework/animation/fling_curve.dart';
import 'package:sky/framework/animation/generators.dart';
import 'package:sky/framework/animation/mechanics.dart';
import 'package:sky/framework/animation/scroll_behavior.dart';
import 'package:sky/framework/components/action_bar.dart';
import 'package:sky/framework/components/animated_component.dart';
import 'package:sky/framework/components/button.dart';
import 'package:sky/framework/components/button_base.dart';
import 'package:sky/framework/components/checkbox.dart';
import 'package:sky/framework/components/drawer.dart';
import 'package:sky/framework/components/drawer_header.dart';
import 'package:sky/framework/components/fixed_height_scrollable.dart';
import 'package:sky/framework/components/floating_action_button.dart';
import 'package:sky/framework/components/icon.dart';
import 'package:sky/framework/components/icon_button.dart';
import 'package:sky/framework/components/ink_splash.dart';
import 'package:sky/framework/components/ink_well.dart';
import 'package:sky/framework/components/input.dart';
import 'package:sky/framework/components/material.dart';
import 'package:sky/framework/components/menu_divider.dart';
import 'package:sky/framework/components/menu_item.dart';
import 'package:sky/framework/components/modal_overlay.dart';
import 'package:sky/framework/components/popup_menu.dart';
import 'package:sky/framework/components/popup_menu_item.dart';
import 'package:sky/framework/components/radio.dart';
import 'package:sky/framework/components/scaffold.dart';
import 'package:sky/framework/components/scrollable.dart';
import 'package:sky/framework/debug/tracing.dart';
import 'package:sky/framework/editing/editable_string.dart';
import 'package:sky/framework/editing/editable_text.dart';
import 'package:sky/framework/editing/keyboard.dart';
import 'package:sky/framework/elements/animation/controller.dart';
import 'package:sky/framework/elements/animation/timer.dart';
import 'package:sky/framework/embedder.dart';
import 'package:sky/framework/fn.dart';
import 'package:sky/framework/net/fetch.dart';
import 'package:sky/framework/reflect.dart';
import 'package:sky/framework/shell.dart';
import 'package:sky/framework/theme/colors.dart';
import 'package:sky/framework/theme/shadows.dart';
import 'package:sky/framework/theme/typography.dart' as typography;
import 'package:sky/framework/theme/view-configuration.dart';
import 'package:sky/services/keyboard/keyboard.mojom.dart';
import 'package:sky/services/sensors/sensors.mojom.dart';
import 'package:sky/services/testing/test_harness.mojom.dart';
import 'package:sky/services/viewport/input_event.mojom.dart';
import 'package:sky/services/viewport/viewport_observer.mojom.dart';
import "dart:sky";
import 'popover_menu.dart';


class FundayApp extends App {
  DrawerController _drawerController = new DrawerController();
  PopupMenuController _menuController;


  static final Style _titleStyle = new Style('''
    ${typography.white.title};''');

  static final Style _containerStyle = new Style('''
    font-size: 50px;
    color: #66cc00;
    opacity: .5;
    left: 100px;
    text-align: center''');

  static final Style _actionBarStyle = new Style('''
    background-color: #66cc00;''');

  bool _isSearching = false;
  bool _isShowingMenu = false;
  String _searchQuery;

  void _handleSearchBegin(_) {
    setState(() {
      _isSearching = true;
    });
  }

  void _handleSearchEnd(_) {
    setState(() {
      _isSearching = false;
      _searchQuery = null;
    });
  }

  void _handleMenuShow(_) {
    setState(() {
      _menuController = new PopupMenuController();
      _menuController.open();
    });
  }

  void _handleMenuHide(_) {
    setState(() {
      _menuController.close().then((_) {
        setState(() {
          _menuController = null;
        });
      });
    });
  }

  Drawer buildDrawer() {
    return new Drawer(
        controller: _drawerController,
        level: 3,
        children: [
          new DrawerHeader(children: [new Text('Workiva')]),
          new MenuItem(
              key: 'Drafts',
              icon: 'content/inbox',
              children: [new Text('Inbox')]),
          new MenuDivider(),
          new MenuItem(
              key: 'Assessment',
              icon: 'action/assessment',
              children: [new Text('Jira')]),
          new MenuItem(
              key: 'Alarm',
              icon: 'action/alarm',
              children: [new Text('ADP')]),
          new MenuItem(
              key: 'Settings',
              icon: 'action/settings',
              children: [new Text('Settings')]),
          new MenuItem(
              key: 'Help & Feedback',
              icon: 'action/help',
              children: [new Text('Help & Feedback')])
        ]
    );
  }

  UINode buildActionBar() {
    return new StyleNode(
        new ActionBar(
            left: new IconButton(
                icon: 'navigation/menu_white',
                onGestureTap: _drawerController.toggle),
            center: new Container(
                style: _titleStyle,
                children: [new Text('Workiva')]),
            right: [
              new IconButton(
                  icon: 'navigation/more_vert_white',
                  onGestureTap: _handleMenuShow)
            ]),
        _actionBarStyle);
  }

  UINode buildText() {
    return new Text('Hello World');
  }

  UINode buildButton() {
    return new Button(
      content: new Text('X'),
      level: 1
    );
  }

  UINode buildMenu() {
    return new MenuItem(
      icon: 'content/add_white'
    );
  }

  UINode buildContainer() {
    return new Container(
        style: _containerStyle,
        children: [new Text('No Notifications')]
    );
  }

  void addMenuToOverlays(List<UINode> overlays) {
    if (_menuController == null)
      return;
    overlays.add(new ModalOverlay(
        children: [new PopoverMenu(controller: _menuController)],
        onDismiss: _handleMenuHide));
  }

  UINode build() {
    List<UINode> overlays = [];
    addMenuToOverlays(overlays);

    return new Scaffold(
      header: buildActionBar(),
      content: buildContainer(),
      drawer: buildDrawer(),
      overlays: overlays
    );
  }
}