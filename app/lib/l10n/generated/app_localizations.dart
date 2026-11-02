import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_bg.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[Locale('bg')];

  /// No description provided for @appName.
  ///
  /// In bg, this message translates to:
  /// **'Squad Manager'**
  String get appName;

  /// No description provided for @appTagline.
  ///
  /// In bg, this message translates to:
  /// **'Отборът ти. На едно място.'**
  String get appTagline;

  /// No description provided for @introMatchesTitle.
  ///
  /// In bg, this message translates to:
  /// **'Всички мачове'**
  String get introMatchesTitle;

  /// No description provided for @introMatchesBody.
  ///
  /// In bg, this message translates to:
  /// **'Предстоящите срещи с гербове, място и час, по първенства.'**
  String get introMatchesBody;

  /// No description provided for @introAttendanceTitle.
  ///
  /// In bg, this message translates to:
  /// **'Идваш ли?'**
  String get introAttendanceTitle;

  /// No description provided for @introAttendanceBody.
  ///
  /// In bg, this message translates to:
  /// **'Един клик за присъствие. Ако не можеш, пишеш защо.'**
  String get introAttendanceBody;

  /// No description provided for @introLineupTitle.
  ///
  /// In bg, this message translates to:
  /// **'Съставът на живо'**
  String get introLineupTitle;

  /// No description provided for @introLineupBody.
  ///
  /// In bg, this message translates to:
  /// **'Треньорът нарежда титулярите и всички го виждат веднага.'**
  String get introLineupBody;

  /// No description provided for @introRemindersTitle.
  ///
  /// In bg, this message translates to:
  /// **'Нищо не пропускаш'**
  String get introRemindersTitle;

  /// No description provided for @introRemindersBody.
  ///
  /// In bg, this message translates to:
  /// **'Напомняния преди мача, само ако още не си отговорил.'**
  String get introRemindersBody;

  /// No description provided for @introPrevious.
  ///
  /// In bg, this message translates to:
  /// **'Предишен'**
  String get introPrevious;

  /// No description provided for @introNext.
  ///
  /// In bg, this message translates to:
  /// **'Следващ'**
  String get introNext;

  /// No description provided for @introSlideIndicator.
  ///
  /// In bg, this message translates to:
  /// **'Слайд {current} от {total}'**
  String introSlideIndicator(int current, int total);

  /// No description provided for @logoDescription.
  ///
  /// In bg, this message translates to:
  /// **'Лого Squad Manager'**
  String get logoDescription;

  /// No description provided for @signIn.
  ///
  /// In bg, this message translates to:
  /// **'Вход'**
  String get signIn;

  /// No description provided for @noAccount.
  ///
  /// In bg, this message translates to:
  /// **'Нямаш акаунт?'**
  String get noAccount;

  /// No description provided for @contactUs.
  ///
  /// In bg, this message translates to:
  /// **'Свържи се с нас'**
  String get contactUs;

  /// No description provided for @teams.
  ///
  /// In bg, this message translates to:
  /// **'Отбори'**
  String get teams;

  /// No description provided for @profile.
  ///
  /// In bg, this message translates to:
  /// **'Профил'**
  String get profile;

  /// No description provided for @contacts.
  ///
  /// In bg, this message translates to:
  /// **'Контакти'**
  String get contacts;

  /// No description provided for @lineupTitle.
  ///
  /// In bg, this message translates to:
  /// **'Състав за мача'**
  String get lineupTitle;

  /// No description provided for @setPasswordTitle.
  ///
  /// In bg, this message translates to:
  /// **'Задаване на парола'**
  String get setPasswordTitle;

  /// No description provided for @consentTitle.
  ///
  /// In bg, this message translates to:
  /// **'Съгласие'**
  String get consentTitle;

  /// No description provided for @matchesTitle.
  ///
  /// In bg, this message translates to:
  /// **'Мачове'**
  String get matchesTitle;

  /// No description provided for @matchDetailTitle.
  ///
  /// In bg, this message translates to:
  /// **'Мач'**
  String get matchDetailTitle;

  /// No description provided for @organizationTitle.
  ///
  /// In bg, this message translates to:
  /// **'Организация'**
  String get organizationTitle;

  /// No description provided for @adminTitle.
  ///
  /// In bg, this message translates to:
  /// **'Администрация'**
  String get adminTitle;

  /// No description provided for @placeholderComingSoon.
  ///
  /// In bg, this message translates to:
  /// **'Този екран предстои.'**
  String get placeholderComingSoon;

  /// No description provided for @startupFailureTitle.
  ///
  /// In bg, this message translates to:
  /// **'Приложението не може да стартира'**
  String get startupFailureTitle;

  /// No description provided for @startupFailureBody.
  ///
  /// In bg, this message translates to:
  /// **'Възникна проблем при зареждането. Опитай да презаредиш страницата или опитай отново по-късно.'**
  String get startupFailureBody;

  /// No description provided for @routeNotFound.
  ///
  /// In bg, this message translates to:
  /// **'Страницата не е намерена.'**
  String get routeNotFound;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['bg'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'bg':
      return AppLocalizationsBg();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
