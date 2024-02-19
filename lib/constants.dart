class Constants {
  // ***************** Basic ********************
  // Names
  static const String appName = 'Tree Notes';
  static const String dataBaseFileName = 'treenotes.db';

  // ***************** UI ***********************
  // size fractions
  static const double nodesListHeightFraction = 0.75;

  static const double headerNoteWidthFraction = 0.135;
  static const double headerChildrenWidthFraction = 0.64;
  static const double headerGoWidthFraction = 0.08;

  static const double nodeTitleWidthFraction = 0.55;
  static const double nodeChildrenWidthFraction = 0.1;

  // sizes
  static const double contentInputFieldHeight = 250;
  static const int infoHeaderFlex = 1;
  static const int infoContentFlex = 6;

  // colors
  static const double loadingOpacity = 0.7;
  static const double fadeOpacity = 0.3;

  // font
  static const double fontSizeHuge = 32;
  static const double fontSizeBig = 24;
  static const double fontSizeMedium = 20;
  static const double fontSizeSmall = 16;

  // icon
  static const double iconSizeHuge = 48;
  static const double iconSizeMedium = 24;
  
  // appearance
  static const int contentMinLines = 3;
  static const double progressFade = 0.05;


  // ***************** Times ********************
  static const Duration confirmationUpdateInterval = Duration(milliseconds: 10);

  static const int confirmationEditDelay = 1000;
  static const int confirmationSingleDeleteDelay = 3000;
  static const int confirmationMultipleDeleteDelay = 3000;
}