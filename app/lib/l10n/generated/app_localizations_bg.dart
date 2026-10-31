// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Bulgarian (`bg`).
class AppLocalizationsBg extends AppLocalizations {
  AppLocalizationsBg([String locale = 'bg']) : super(locale);

  @override
  String get appName => 'Squad Manager';

  @override
  String get appTagline => 'Отборът ти. На едно място.';

  @override
  String get introMatchesTitle => 'Всички мачове';

  @override
  String get introMatchesBody =>
      'Предстоящите срещи с гербове, място и час, по първенства.';

  @override
  String get introAttendanceTitle => 'Идваш ли?';

  @override
  String get introAttendanceBody =>
      'Един клик за присъствие. Ако не можеш, пишеш защо.';

  @override
  String get introLineupTitle => 'Съставът на живо';

  @override
  String get introLineupBody =>
      'Треньорът нарежда титулярите и всички го виждат веднага.';

  @override
  String get introRemindersTitle => 'Нищо не пропускаш';

  @override
  String get introRemindersBody =>
      'Напомняния преди мача, само ако още не си отговорил.';

  @override
  String get introPrevious => 'Предишен';

  @override
  String get introNext => 'Следващ';

  @override
  String introSlideIndicator(int current, int total) {
    return 'Слайд $current от $total';
  }

  @override
  String get logoDescription => 'Лого Squad Manager';

  @override
  String get signIn => 'Вход';

  @override
  String get noAccount => 'Нямаш акаунт?';

  @override
  String get contactUs => 'Свържи се с нас';

  @override
  String get teams => 'Отбори';

  @override
  String get profile => 'Профил';

  @override
  String get contacts => 'Контакти';

  @override
  String get lineupTitle => 'Състав за мача';

  @override
  String get setPasswordTitle => 'Задаване на парола';

  @override
  String get consentTitle => 'Съгласие';

  @override
  String get matchesTitle => 'Мачове';

  @override
  String get matchDetailTitle => 'Мач';

  @override
  String get organizationTitle => 'Организация';

  @override
  String get adminTitle => 'Администрация';

  @override
  String get placeholderComingSoon => 'Този екран предстои.';

  @override
  String get routeNotFound => 'Страницата не е намерена.';
}
