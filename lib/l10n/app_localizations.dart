import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;
  AppLocalizations(this.locale);

  static const supportedLocales = [
    Locale('en'),
    Locale('ps'),
    Locale('fa'),
  ];

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  static AppLocalizations of(BuildContext context) {
    final result = Localizations.of<AppLocalizations>(context, AppLocalizations);
    return result ?? AppLocalizations(const Locale('en'));
  }

  static const Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'home': 'Home',
      'booking': 'Booking',
      'services': 'Services',
      'support': 'Support',
      'profile': 'Profile',
      'welcomeTitle': 'Welcome to\nSafar Go App',
      'welcomeSubtitle': 'Your trusted travel partner across Afghanistan.',
      'language': 'Language',
      'english': 'English',
      'pashto': 'Pashto',
      'dari': 'Dari',
      'tripHistory': 'Trip History',
      'paymentMethods': 'Payment Methods',
      'settings': 'Settings',
      'logout': 'Logout',
      'loginWithEmail': 'Login with Email',
      'signupWithEmail': 'Sign Up with Email',
      'email': 'Email',
      'password': 'Password',
      'login': 'Login',
      'signup': 'Sign Up',
      'pleaseWait': 'Please wait...',
      'bookTrip': 'Book a Trip',
      'findRoute': 'Find the best route for your journey',
      'availableVehicles': 'Available Vehicles',
      'selectSeats': 'Select Seats',
      'estimatedPrice': 'Estimated Price',
      'bookNow': 'Book Now',
      'from': 'FROM',
      'to': 'TO',
      'selectDestination': 'Select destination',
      'travelDate': 'TRAVEL DATE',
      'passengers': 'PASSENGERS',
      'aiSuggested': 'AI Suggested',
      'bestMatch': 'Best Match',
      'loadMore': 'Load More',
      'loading': 'Loading...',
      'tripHistoryReport': 'Trip History Report',
      'revenue': 'Revenue',
      'trips': 'Trips',
      'day': 'Day',
      'week': 'Week',
      'month': 'Month',
      'year': 'Year',
      'exportExcel': 'Export Excel',
      'exportPdf': 'Export PDF',
      'print': 'Print',
      'noReportsFound': 'No reports found for this filter',
      'noDataExport': 'No booking data to export',
      'noDataPrint': 'No booking data to print',
      'supportCenter': 'Call Center',
      'liveChat': 'Live Chat',
      'helpCenter': 'Help Center',
      'reportIssue': 'Report an Issue',
      'emergencyContacts': 'Emergency Contacts',
      'servicesTitle': 'Services',
    },
    'ps': {
      'home': 'کور',
      'booking': 'بوکینګ',
      'services': 'خدمتونه',
      'support': 'مرسته',
      'profile': 'پروفایل',
      'welcomeTitle': 'سفرګو اپ ته\nښه راغلاست',
      'welcomeSubtitle': 'په افغانستان کې ستاسو باوري سفر ملګری.',
      'language': 'ژبه',
      'english': 'انګلیسي',
      'pashto': 'پښتو',
      'dari': 'دري',
      'tripHistory': 'د سفر تاریخ',
      'paymentMethods': 'د تادیې لارې',
      'settings': 'تنظیمات',
      'logout': 'وتل',
      'loginWithEmail': 'د ایمیل له لارې ننوتل',
      'signupWithEmail': 'د ایمیل له لارې ثبت نام',
      'email': 'ایمیل',
      'password': 'پاسورډ',
      'login': 'ننوتل',
      'signup': 'ثبت نام',
      'pleaseWait': 'مهرباني وکړئ انتظار وکړئ...',
      'bookTrip': 'سفر رزرف کړئ',
      'findRoute': 'د خپل سفر لپاره غوره لاره ومومئ',
      'availableVehicles': 'شته وسایط',
      'selectSeats': 'څوکۍ وټاکئ',
      'estimatedPrice': 'اټکلی قیمت',
      'bookNow': 'اوس رزرو کړئ',
      'from': 'له',
      'to': 'تر',
      'selectDestination': 'مقصد وټاکئ',
      'travelDate': 'د سفر نېټه',
      'passengers': 'مسافرین',
      'aiSuggested': 'د AI وړاندیز',
      'bestMatch': 'غوره انتخاب',
      'loadMore': 'نور ښکاره کړئ',
      'loading': 'لوډ کیږي...',
      'tripHistoryReport': 'د سفر راپور',
      'revenue': 'عاید',
      'trips': 'سفرونه',
      'day': 'ورځ',
      'week': 'اونۍ',
      'month': 'میاشت',
      'year': 'کال',
      'exportExcel': 'اکسل صادرول',
      'exportPdf': 'PDF صادرول',
      'print': 'چاپ',
      'noReportsFound': 'د دې فلټر لپاره راپور نشته',
      'noDataExport': 'د صادرولو لپاره معلومات نشته',
      'noDataPrint': 'د چاپ لپاره معلومات نشته',
      'supportCenter': 'د تماس مرکز',
      'liveChat': 'ژوندی چټ',
      'helpCenter': 'مرسته مرکز',
      'reportIssue': 'ستونزه راپور کړئ',
      'emergencyContacts': 'بیړني اړیکې',
      'servicesTitle': 'خدمتونه',
    },
    'fa': {
      'home': 'خانه',
      'booking': 'رزرو',
      'services': 'خدمات',
      'support': 'پشتیبانی',
      'profile': 'پروفایل',
      'welcomeTitle': 'به اپ سفرگو\nخوش آمدید',
      'welcomeSubtitle': 'همراه مطمئن سفر شما در افغانستان.',
      'language': 'زبان',
      'english': 'انگلیسی',
      'pashto': 'پشتو',
      'dari': 'دری',
      'tripHistory': 'تاریخچه سفرها',
      'paymentMethods': 'روش های پرداخت',
      'settings': 'تنظیمات',
      'logout': 'خروج',
      'loginWithEmail': 'ورود با ایمیل',
      'signupWithEmail': 'ثبت نام با ایمیل',
      'email': 'ایمیل',
      'password': 'رمز عبور',
      'login': 'ورود',
      'signup': 'ثبت نام',
      'pleaseWait': 'لطفا صبر کنید...',
      'bookTrip': 'رزرو سفر',
      'findRoute': 'بهترین مسیر را برای سفر خود پیدا کنید',
      'availableVehicles': 'وسایط موجود',
      'selectSeats': 'انتخاب چوکی',
      'estimatedPrice': 'قیمت تخمینی',
      'bookNow': 'همین حالا رزرو کن',
      'from': 'از',
      'to': 'به',
      'selectDestination': 'مقصد را انتخاب کنید',
      'travelDate': 'تاریخ سفر',
      'passengers': 'مسافرین',
      'aiSuggested': 'پیشنهاد هوشمند',
      'bestMatch': 'بهترین گزینه',
      'loadMore': 'نمایش بیشتر',
      'loading': 'در حال بارگیری...',
      'tripHistoryReport': 'گزارش تاریخچه سفر',
      'revenue': 'درآمد',
      'trips': 'سفرها',
      'day': 'روز',
      'week': 'هفته',
      'month': 'ماه',
      'year': 'سال',
      'exportExcel': 'صدور اکسل',
      'exportPdf': 'صدور PDF',
      'print': 'چاپ',
      'noReportsFound': 'برای این فیلتر گزارشی یافت نشد',
      'noDataExport': 'داده ای برای صدور وجود ندارد',
      'noDataPrint': 'داده ای برای چاپ وجود ندارد',
      'supportCenter': 'مرکز تماس',
      'liveChat': 'چت زنده',
      'helpCenter': 'مرکز راهنما',
      'reportIssue': 'گزارش مشکل',
      'emergencyContacts': 'تماس های اضطراری',
      'servicesTitle': 'خدمات',
    },
  };

  String t(String key) {
    return _localizedValues[locale.languageCode]?[key] ??
        _localizedValues['en']![key] ??
        key;
  }
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) =>
      AppLocalizations.supportedLocales.any((l) => l.languageCode == locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(covariant LocalizationsDelegate<AppLocalizations> old) => false;
}

class LocaleController {
  LocaleController._();
  static final ValueNotifier<Locale> locale = ValueNotifier(const Locale('en'));
}
