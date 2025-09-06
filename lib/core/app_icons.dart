import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

/// Класс для централизованного управления иконками
class AppIcons {
  // Используем Material Design Icons вместо стандартных Material Icons
  static final IconData calculate = MdiIcons.calculator;
  static final IconData history = MdiIcons.history;
  static final IconData edit = MdiIcons.pencil;
  static final IconData close = MdiIcons.close;
  static final IconData play = MdiIcons.play;
  static final IconData result = MdiIcons.check;
  
  // Запасные иконки из Font Awesome
  static IconData faCalculate = FontAwesomeIcons.calculator;
  static IconData faHistory = FontAwesomeIcons.clockRotateLeft;
  static IconData faEdit = FontAwesomeIcons.pen;
  static IconData faClose = FontAwesomeIcons.xmark;
  static IconData faPlay = FontAwesomeIcons.play;
  static IconData faResult = FontAwesomeIcons.checkDouble;
}
