// Copyright 2015 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:sky/framework/components/popup_menu.dart';
import 'package:sky/framework/fn.dart';
import 'package:sky/framework/theme/view-configuration.dart';

class PopoverMenu extends Component {
  static final Style _style = new Style('''
    position: absolute;
    right: 8px;
    top: ${8 + kStatusBarHeight}px;''');

  PopupMenuController controller;

  PopoverMenu({Object key, this.controller}) : super(key: key);

  UINode build() {
    return new StyleNode(
      new PopupMenu(
        controller: controller,
        items: [
          [new Text('Account Info')],
          [new Text('Log Out')],
          [new Text('Help & feeback')],
        ],
        level: 4),
        _style
    );
  }
}
