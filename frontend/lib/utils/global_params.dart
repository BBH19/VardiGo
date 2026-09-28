
import 'package:flutter/material.dart';

class GlobalParams {
  // ============================================================
  // API
  // ============================================================

  static const String baseUrl = 'http://localhost:8000/api/';

  // ============================================================
  // COLORS - PRIMARY
  // ============================================================

  static const Color primary = Color(0xFF335CFF);
  static const Color primarySoft = Color(0xFF3485FF);
  static const Color primaryLight = Color(0xFFD5E2FF);
  static const Color primaryLighter = Color(0xFFEBF1FF);
  static const Color primaryDarkest = Color(0xFF1F3BAD);

  // ============================================================
  // COLORS - TEXT / SLATE
  // ============================================================

  static const Color strong = Color(0xFF171717);
  static const Color slate700 = Color(0xFF2B303B);
  static const Color slate600 = Color(0xFF525866);
  static const Color slate500 = Color(0xFF717784);
  static const Color gray500 = Color(0xFF7B7B7B);
  static const Color sub = Color(0xFF5C5C5C);
  static const Color soft = Color(0xFFA3A3A3);
  static const Color soft400 = Color(0xFFA3A3A3);
  static const Color kOrange = Color(0xFFF07A1A);
  static const Color kPurple = Color(0xFF7B4FE0);
  static const Color kSalaryBg = Color(0xFFF5F7FB);


  // ============================================================
  // COLORS - BACKGROUNDS / BORDERS
  // ============================================================

  static const Color white = Color(0xFFFFFFFF);
  static const Color weak = Color(0xFFFBFBFB);
  static const Color weak50 = Color(0xFFF7F7F7);
  static const Color slate50 = Color(0xFFF5F7FA);
  static const Color slate100 = Color(0xFFF2F5F8);
  static const Color slate200 = Color(0xFFEAECF0);
  static const Color stroke = Color(0xFFEBEBEB);
  static const Color slate300 = Color(0xFFCACFD8);

  // ============================================================
  // COLORS - SEMANTIC
  // ============================================================

  static const Color green = Color(0xFF1DAF61);
  static const Color greenDark = Color(0xFF178C4E);
  static const Color greenLighter = Color(0xFFE3F7EC);

  static const Color error = Color(0xFFFB3748);

  // #FB37481A = rgba(251, 55, 72, 0.10)
  static const Color errorSoft = Color(0x1AFB3748);

  static const Color warning = Color(0xFFFA7319);

  // ============================================================
  // COLORS - PHONE FRAME
  // ============================================================

  static const Color bezel = Color(0xFF0B0B0D);
  static const Color island = Color(0xFF000000);
  static const Color islandLens = Color(0xFF1C1C1E);
  static const Color islandRing = Color(0xFF2A2A2C);
  static const Color homePill = Color(0xFFB9C0C9);

  // ============================================================
  // TYPOGRAPHY
  // ============================================================

  static const String fontFamily = 'Urbanist';

  // Font sizes
  static const double fontSize12 = 12;
  static const double fontSize13 = 13;
  static const double fontSize14 = 14;
  static const double fontSize16 = 16;
  static const double fontSize17 = 17;
  static const double fontSize18 = 18;
  static const double fontSize20 = 20;

  // Line heights
  static const double lineHeight16 = 16;
  static const double lineHeight20 = 20;
  static const double lineHeight22 = 22;
  static const double lineHeight24 = 24;
  static const double lineHeight28 = 28;

  // Letter spacing
  static const double tracking12 = 0;
  static const double tracking13 = -0.078;
  static const double tracking14 = -0.084;
  static const double tracking16 = -0.176;
  static const double tracking18 = -0.27;
  static const double trackingStatus = -0.3;

  // ============================================================
  // PHONE SIZE
  // ============================================================

  static const double phoneWidth = 390;
  static const double phoneHeight = 844;

  static const double phoneOuterRadius = 54;
  static const double phoneInnerRadius = 44;
  static const double bezelWidth = 11;

  static const double statusBarHeight = 54;

  // Dynamic Island
  static const double islandWidth = 126;
  static const double islandHeight = 37;
  static const double islandTop = 11;
  static const double islandRadius = 999;

  // Home indicator
  static const double homeAreaHeight = 30;
  static const double homePillWidth = 135;
  static const double homePillHeight = 5;
  static const double homePillRadius = 999;
  static const double homePillBottom = 8;

  // ============================================================
  // COMMON SPACING
  // ============================================================

  static const double pageHorizontalPadding = 20;
  static const double pageHorizontalPaddingFooter = 24;

  static const double spacing2 = 2;
  static const double spacing4 = 4;
  static const double spacing8 = 8;
  static const double spacing10 = 10;
  static const double spacing12 = 12;
  static const double spacing16 = 16;
  static const double spacing20 = 20;
  static const double spacing24 = 24;

  // ============================================================
  // COMMON CONTROLS
  // ============================================================

  // Back / Help button
  static const double squareButtonSize = 44;
  static const double squareButtonRadius = 12;
  static const double squareButtonIconSize = 20;

  // Checkbox
  static const double checkboxSize = 20;
  static const double checkboxRadius = 6;

  // Sort chip
  static const double sortChipHeight = 36;
  static const double sortChipRadius = 12;
  static const double sortChipIconSize = 20;

  // Avatar / Logo
  static const double avatarSize = 56;
  static const double logoSize = 56;

  // Icons
  static const double icon16 = 16;
  static const double icon20 = 20;
  static const double icon24 = 24;

  // ============================================================
  // CARDS
  // ============================================================

  static const double cardRadius = 20;

  // Candidate card
  static const double candidateCardHorizontalPadding = 16;
  static const double candidateCardVerticalPadding = 12;

  // Offer card
  static const double offerCardPadding = 16;

  // ============================================================
  // TABS
  // ============================================================

  static const double tabRadius = 999;
  static const double tabPadding = 4;

  // Candidate tabs
  static const double candidateTabVerticalPadding = 10;

  // Offer tabs
  static const double offerTabRadius = 26;
  static const double offerTabVerticalPadding = 12;

  // ============================================================
  // BUTTONS
  // ============================================================

  static const double ctaHeight = 44;
  static const double ctaRadius = 10;

  static const double offerButtonHeight = 36;
  static const double offerButtonRadius = 8;

  // ============================================================
  // SHADOWS
  // ============================================================

  static List<BoxShadow> get cardShadow => [
        const BoxShadow(
          color: Color(0x0A243D82),
          blurRadius: 4,
          offset: Offset(0, 2),
        ),
      ];

  static List<BoxShadow> get cardSelectedShadow => [
        const BoxShadow(
          color: Color(0x0A243D82),
          blurRadius: 8,
          offset: Offset(0, 2),
        ),
      ];

  static List<BoxShadow> get buttonShadow => [
        const BoxShadow(
          color: Color(0x140A0D14),
          blurRadius: 2,
          offset: Offset(0, 1),
        ),
      ];

  static List<BoxShadow> get sortShadow => [
        const BoxShadow(
          color: Color(0x0A000000),
          blurRadius: 4,
          offset: Offset(0, 2),
        ),
      ];

  static List<BoxShadow> get candidateTabActiveShadow => [
        const BoxShadow(
          color: Color(0x0F0E121B),
          blurRadius: 5,
          offset: Offset(0, 6),
        ),
        const BoxShadow(
          color: Color(0x080E121B),
          blurRadius: 2,
          offset: Offset(0, 2),
        ),
      ];

  static List<BoxShadow> get offerTabActiveShadow => [
        const BoxShadow(
          color: Color(0x0F0E121B),
          blurRadius: 10,
          offset: Offset(0, 6),
        ),
        const BoxShadow(
          color: Color(0x080E121B),
          blurRadius: 4,
          offset: Offset(0, 2),
        ),
      ];

  // ============================================================
  // OPACITY
  // ============================================================

  static const double disabledOpacity = 0.45;
  static const double subtitleOpacity = 0.80;

  // ============================================================
  // CARD SELECTION
  // ============================================================

  static const double selectedStripeWidth = 4;

  // ============================================================
  // ONLINE BADGE
  // ============================================================

  static const double onlineBadgeSize = 24;
}

