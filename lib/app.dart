import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:materialbasic/category_menu_page.dart';
import 'package:materialbasic/colors.dart';
import 'package:materialbasic/login.dart';
import 'supplemental/cut_corners_border.dart';

import 'home.dart';
import 'colors.dart';
import 'backdrop.dart';
import 'model/product.dart';

class ShrineApp extends StatefulWidget {
  @override
  _ShrineAppState createState() => _ShrineAppState();
}

class _ShrineAppState extends State<ShrineApp> {
  Category _currentCategory = Category.all;

  void _onCategoryTap(Category category) {
    setState(() {
      _currentCategory = category;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: MaterialApp(
        title: 'Shrine',
        home: Backdrop(
          currentCategory: _currentCategory,
          frontLayer: HomePage(category: _currentCategory,),
          backLayer: CategoryMenuPage(
            currentCategory: _currentCategory,
            onCategoryTap: _onCategoryTap,
          ),
          frontTitle: Text('SHRINE'),
          backTitle: Text('MENU'),
        ),
        initialRoute: '/login',
        onGenerateRoute: _getRoute,
        theme: _kShrineTheme,
      ),
    );
  }
}

Route<dynamic> _getRoute(RouteSettings settings) {
  if (settings.name != '/login') {
    return null;
  }

  return MaterialPageRoute<void>(
    settings: settings,
    builder: (context) => LoginPage(),
    fullscreenDialog: true,
  );
}

final ThemeData _kShrineTheme = _buildShrineTheme();

ThemeData _buildShrineTheme() {
  final ThemeData base = ThemeData.light();
  return base.copyWith(
      accentColor: kShrineBrown900,
      primaryColor: kShrinePink100,
      buttonTheme: base.buttonTheme.copyWith(
          buttonColor: kShrinePink100,
          colorScheme: base.colorScheme.copyWith(secondary: kShrineBrown900)),
      buttonBarTheme:
          base.buttonBarTheme.copyWith(buttonTextTheme: ButtonTextTheme.accent),
      scaffoldBackgroundColor: kShrineBackgroundWhite,
      cardColor: kShrineBackgroundWhite,
      textSelectionColor: kShrinePink100,
      errorColor: kShrineErrorRed,
      textTheme: _buildShrineTextTheme(base.textTheme),
      primaryTextTheme: _buildShrineTextTheme(base.primaryTextTheme),
      accentTextTheme: _buildShrineTextTheme(base.accentTextTheme),
      primaryIconTheme: base.iconTheme.copyWith(color: kShrineBrown900),
      inputDecorationTheme: InputDecorationTheme(border: CutCornersBorder()));
}

TextTheme _buildShrineTextTheme(TextTheme base) {
  return base
      .copyWith(
        headline5: base.headline5.copyWith(fontWeight: FontWeight.w500),
        headline6: base.headline6.copyWith(fontSize: 18.0),
        caption:
            base.caption.copyWith(fontWeight: FontWeight.w400, fontSize: 14.0),
      )
      .apply(
          fontFamily: 'Rubik',
          displayColor: kShrineBrown900,
          bodyColor: kShrineBrown900);
}
