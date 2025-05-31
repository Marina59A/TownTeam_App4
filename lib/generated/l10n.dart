// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(
      _current != null,
      'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.',
    );
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(
      instance != null,
      'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?',
    );
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `HOME`
  String get home {
    return Intl.message('HOME', name: 'home', desc: '', args: []);
  }

  /// `MENS`
  String get mens {
    return Intl.message('MENS', name: 'mens', desc: '', args: []);
  }

  /// `KIDS`
  String get kids {
    return Intl.message('KIDS', name: 'kids', desc: '', args: []);
  }

  /// `SUMMER COLLECTION`
  String get summerCollection {
    return Intl.message(
      'SUMMER COLLECTION',
      name: 'summerCollection',
      desc: '',
      args: [],
    );
  }

  /// `WINTER COLLECTION`
  String get winterCollection {
    return Intl.message(
      'WINTER COLLECTION',
      name: 'winterCollection',
      desc: '',
      args: [],
    );
  }

  /// `PERFUMES`
  String get perfumes {
    return Intl.message('PERFUMES', name: 'perfumes', desc: '', args: []);
  }

  /// `ACCESSORIES`
  String get accessories {
    return Intl.message('ACCESSORIES', name: 'accessories', desc: '', args: []);
  }

  /// `PROMOTIONS`
  String get promotions {
    return Intl.message('PROMOTIONS', name: 'promotions', desc: '', args: []);
  }

  /// `MY ACCOUNT`
  String get myAccount {
    return Intl.message('MY ACCOUNT', name: 'myAccount', desc: '', args: []);
  }

  /// `CUSTOMER SERVICE`
  String get customerService {
    return Intl.message(
      'CUSTOMER SERVICE',
      name: 'customerService',
      desc: '',
      args: [],
    );
  }

  /// `CONTACT US`
  String get contactUs {
    return Intl.message('CONTACT US', name: 'contactUs', desc: '', args: []);
  }

  /// `HOW TO PURCHASE`
  String get howToPurchase {
    return Intl.message(
      'HOW TO PURCHASE',
      name: 'howToPurchase',
      desc: '',
      args: [],
    );
  }

  /// `DELIVERY AND RETURNS`
  String get deliveryAndReturns {
    return Intl.message(
      'DELIVERY AND RETURNS',
      name: 'deliveryAndReturns',
      desc: '',
      args: [],
    );
  }

  /// `FACEBOOK`
  String get facebook {
    return Intl.message('FACEBOOK', name: 'facebook', desc: '', args: []);
  }

  /// `EMAIL`
  String get email {
    return Intl.message('EMAIL', name: 'email', desc: '', args: []);
  }

  /// `Change`
  String get change {
    return Intl.message('Change', name: 'change', desc: '', args: []);
  }

  /// `Language`
  String get language {
    return Intl.message('Language', name: 'language', desc: '', args: []);
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'ar'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
