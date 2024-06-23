import 'package:flutter/material.dart';

const AlwaysScrollableScrollPhysics defaultScrollPhysics =
    AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics());

const EdgeInsets defaultPadding = EdgeInsets.symmetric(horizontal: 10);
const EdgeInsets defaultPaddingAll = EdgeInsets.all(10);
const Duration defaultDuration = Duration(milliseconds: 250);
BorderRadius defaultRadius = BorderRadius.circular(Corners.med);
BorderRadius defaultRadiusOnlyTop = const BorderRadius.only(
  topLeft: Radius.circular(5),
  topRight: Radius.circular(5),
);

BorderRadius defaultRadiusPercentage = const BorderRadius.only(
  topRight: Radius.circular(5),
  bottomLeft: Radius.circular(5),
);

class AppDefaults {
  const AppDefaults._();
  static const appName = 'Amigo Shop';
  static const defErrorMsg = 'Something went wrong';
}

class DefImgSize {
  const DefImgSize._();

  static const Size todaysDeaImgSize = Size(750, 300);
  static const Size featureImgSize = Size(420, 170);
  static const Size sliderImgSize = Size(750, 300);
}

class AppLayout {
  const AppLayout._();

  static const double maxMobile = 600.0;
  static const double maxTab = 1200.0;
}

class Times {
  const Times._();

  static const Duration fastest = Duration(milliseconds: 150);
  static const fast = Duration(milliseconds: 250);
  static const medium = Duration(milliseconds: 350);
  static const slow = Duration(milliseconds: 700);
  static const slower = Duration(milliseconds: 1000);
}

class Insets {
  const Insets._();

  /// 4 px
  static const double xs = 4;

  /// 8 px
  static const double sm = 8;

  /// 12 px
  static const double med = 10;

  /// 16 px
  static const double lg = 16;

  /// 32 px
  static const double xl = 32;

  /// 40 px
  static const double offset = 40;
}

class Corners {
  const Corners._();

  /// 3
  static const BorderRadius smBorder = BorderRadius.all(smRadius);
  static const double sm = 3;
  static const Radius smRadius = Radius.circular(sm);

  /// 5
  static const BorderRadius medBorder = BorderRadius.all(medRadius);
  static const double med = 5;
  static const Radius medRadius = Radius.circular(med);

  /// 10
  static const BorderRadius lgBorder = BorderRadius.all(lgRadius);
  static const double lg = 10;
  static const Radius lgRadius = Radius.circular(lg);
}

class LocalPath {
  const LocalPath._();

  static String androidDownloadDir = '/storage/emulated/0/Download/';
}
