// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get addNewWorker => 'Add New Account';

  @override
  String get workers => 'Workers';

  @override
  String get searchByPhone => 'Search by phone number';

  @override
  String get managerPanel => 'Manager Panel';

  @override
  String get foremanPanel => 'Foreman Panel';

  @override
  String get profileTitle => 'Profile';

  @override
  String get appSettings => 'App Settings';

  @override
  String get languageSelection => 'Language';

  @override
  String get logout => 'Logout';

  @override
  String get home => 'Home';

  @override
  String get profile => 'Profile';

  @override
  String get phoneNumber => 'Phone Number';

  @override
  String get role => 'Role';

  @override
  String get namePlaceholder => 'Full Name (Example User)';

  @override
  String languageChanged(Object language) {
    return 'Language changed: $language';
  }

  @override
  String get workerPanel => 'Worker Panel';

  @override
  String get recordOperations => 'Worker Registration';

  @override
  String get stockControl => 'Stock Control';

  @override
  String get jobTracking => 'Job Tracking';

  @override
  String get operationReports => 'Operation Reports';

  @override
  String comingSoon(Object title) {
    return '$title will be added soon.';
  }

  @override
  String get workerList => 'Worker List';

  @override
  String get newRecord => 'New Record';

  @override
  String get deleteRecord => 'Delete Record';

  @override
  String get enterWorkerName => 'Enter worker\'s full name';

  @override
  String get status => 'Status';

  @override
  String get enterPhone => 'Enter worker\'s phone number';

  @override
  String get phoneHint => '5xx xxx xx xx';

  @override
  String get save => 'Save';

  @override
  String get fillAllFields => 'Please fill all fields';

  @override
  String get invalidPhone => 'Invalid phone number. E.g.: 5xx xxx xx xx';

  @override
  String get savingWorker => 'Saving worker...';

  @override
  String get confirmSaveTitle => 'Save Confirmation';

  @override
  String get cancel => 'Cancel';

  @override
  String get ok => 'OK';

  @override
  String get searchHint => 'Search by phone/name 5xx xxxxxxx';

  @override
  String get noRecords => 'No records found';

  @override
  String get deleting => 'Deleting record...';

  @override
  String get deleteConfirmTitle => 'Delete Confirmation';

  @override
  String get deleteConfirmMessage =>
      'Are you sure you want to delete this person?';

  @override
  String get yesDelete => 'Yes, Delete';

  @override
  String get recordDeleted => 'Worker deleted successfully.';

  @override
  String get errorOccurred => 'An error occurred';

  @override
  String get onlyAdmins => 'Only admins can perform this action.';

  @override
  String get statusManagement => 'Management';

  @override
  String get statusPurchasing => 'Purchasing Department';

  @override
  String get statusProductPlanning => 'Product Planning Manager';

  @override
  String get statusCraftsman => 'Craftsman';

  @override
  String get statusForeman => 'Foreman';

  @override
  String get cutting => 'Cutting';

  @override
  String get drilling => 'Drilling';

  @override
  String get packaging => 'Packaging';

  @override
  String get welding => 'Welding';

  @override
  String get workerNameLabel => 'Name';
}
