import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';
import 'app_localizations_tr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
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

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
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
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
    Locale('tr'),
  ];

  /// No description provided for @addNewWorker.
  ///
  /// In en, this message translates to:
  /// **'Add New Account'**
  String get addNewWorker;

  /// No description provided for @workers.
  ///
  /// In en, this message translates to:
  /// **'Workers'**
  String get workers;

  /// No description provided for @searchByPhone.
  ///
  /// In en, this message translates to:
  /// **'Search by phone number'**
  String get searchByPhone;

  /// No description provided for @managerPanel.
  ///
  /// In en, this message translates to:
  /// **'Manager Panel'**
  String get managerPanel;

  /// No description provided for @foremanPanel.
  ///
  /// In en, this message translates to:
  /// **'Foreman Panel'**
  String get foremanPanel;

  /// No description provided for @profileTitle.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profileTitle;

  /// No description provided for @appSettings.
  ///
  /// In en, this message translates to:
  /// **'App Settings'**
  String get appSettings;

  /// No description provided for @languageSelection.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get languageSelection;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @phoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phoneNumber;

  /// No description provided for @role.
  ///
  /// In en, this message translates to:
  /// **'Role'**
  String get role;

  /// No description provided for @namePlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Full Name (Example User)'**
  String get namePlaceholder;

  /// No description provided for @languageChanged.
  ///
  /// In en, this message translates to:
  /// **'Language changed: {language}'**
  String languageChanged(Object language);

  /// No description provided for @recordOperations.
  ///
  /// In en, this message translates to:
  /// **'Worker Registration'**
  String get recordOperations;

  /// No description provided for @stockControl.
  ///
  /// In en, this message translates to:
  /// **'Stock Control'**
  String get stockControl;

  /// No description provided for @jobTracking.
  ///
  /// In en, this message translates to:
  /// **'Job Tracking'**
  String get jobTracking;

  /// No description provided for @operationReports.
  ///
  /// In en, this message translates to:
  /// **'Operation Reports'**
  String get operationReports;

  /// No description provided for @comingSoon.
  ///
  /// In en, this message translates to:
  /// **'{title} will be added soon.'**
  String comingSoon(Object title);

  /// No description provided for @workerList.
  ///
  /// In en, this message translates to:
  /// **'Worker List'**
  String get workerList;

  /// No description provided for @newRecord.
  ///
  /// In en, this message translates to:
  /// **'New Record'**
  String get newRecord;

  /// No description provided for @deleteRecord.
  ///
  /// In en, this message translates to:
  /// **'Delete Record'**
  String get deleteRecord;

  /// No description provided for @enterWorkerName.
  ///
  /// In en, this message translates to:
  /// **'Enter worker\'s full name'**
  String get enterWorkerName;

  /// No description provided for @status.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get status;

  /// No description provided for @enterPhone.
  ///
  /// In en, this message translates to:
  /// **'Enter worker\'s phone number'**
  String get enterPhone;

  /// No description provided for @phoneHint.
  ///
  /// In en, this message translates to:
  /// **'5xx xxx xx xx'**
  String get phoneHint;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @fillAllFields.
  ///
  /// In en, this message translates to:
  /// **'Please fill all fields'**
  String get fillAllFields;

  /// No description provided for @invalidPhone.
  ///
  /// In en, this message translates to:
  /// **'Invalid phone number. E.g.: 5xx xxx xx xx'**
  String get invalidPhone;

  /// No description provided for @savingWorker.
  ///
  /// In en, this message translates to:
  /// **'Saving worker...'**
  String get savingWorker;

  /// No description provided for @confirmSaveTitle.
  ///
  /// In en, this message translates to:
  /// **'Save Confirmation'**
  String get confirmSaveTitle;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @searchHint.
  ///
  /// In en, this message translates to:
  /// **'Search by phone/name 5xx xxxxxxx'**
  String get searchHint;

  /// No description provided for @noRecords.
  ///
  /// In en, this message translates to:
  /// **'No records found'**
  String get noRecords;

  /// No description provided for @deleting.
  ///
  /// In en, this message translates to:
  /// **'Deleting record...'**
  String get deleting;

  /// No description provided for @deleteConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete Confirmation'**
  String get deleteConfirmTitle;

  /// No description provided for @deleteConfirmMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this person?'**
  String get deleteConfirmMessage;

  /// No description provided for @yesDelete.
  ///
  /// In en, this message translates to:
  /// **'Yes, Delete'**
  String get yesDelete;

  /// No description provided for @recordDeleted.
  ///
  /// In en, this message translates to:
  /// **'Worker deleted successfully.'**
  String get recordDeleted;

  /// No description provided for @errorOccurred.
  ///
  /// In en, this message translates to:
  /// **'An error occurred'**
  String get errorOccurred;

  /// No description provided for @onlyAdmins.
  ///
  /// In en, this message translates to:
  /// **'Only admins can perform this action.'**
  String get onlyAdmins;

  /// No description provided for @statusManagement.
  ///
  /// In en, this message translates to:
  /// **'Management'**
  String get statusManagement;

  /// No description provided for @statusPurchasing.
  ///
  /// In en, this message translates to:
  /// **'Purchasing Department'**
  String get statusPurchasing;

  /// No description provided for @statusProductPlanning.
  ///
  /// In en, this message translates to:
  /// **'Product Planning Manager'**
  String get statusProductPlanning;

  /// No description provided for @statusCraftsman.
  ///
  /// In en, this message translates to:
  /// **'Craftsman'**
  String get statusCraftsman;

  /// No description provided for @statusForeman.
  ///
  /// In en, this message translates to:
  /// **'Foreman'**
  String get statusForeman;

  /// No description provided for @cutting.
  ///
  /// In en, this message translates to:
  /// **'Cutting'**
  String get cutting;

  /// No description provided for @drilling.
  ///
  /// In en, this message translates to:
  /// **'Drilling'**
  String get drilling;

  /// No description provided for @packaging.
  ///
  /// In en, this message translates to:
  /// **'Packaging'**
  String get packaging;

  /// No description provided for @welding.
  ///
  /// In en, this message translates to:
  /// **'Welding'**
  String get welding;

  /// No description provided for @workerNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get workerNameLabel;
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
      <String>['ar', 'en', 'tr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
    case 'tr':
      return AppLocalizationsTr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
