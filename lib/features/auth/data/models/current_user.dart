class CurrentUser {
  final String fullName;
  final String phoneNumber;
  final List<String> roles;

  final bool isAdmin;
  final bool isWorker;
  final bool isForeman;
  final bool isProductionPlanner;
  final bool isPurchasing;

  CurrentUser({
    required this.fullName,
    required this.phoneNumber,
    required this.roles,
    required this.isAdmin,
    required this.isWorker,
    required this.isForeman,
    required this.isProductionPlanner,
    required this.isPurchasing,
  });

  factory CurrentUser.fromMap(Map<String, dynamic> json) {
    return CurrentUser(
      fullName: json['fullName'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      roles: List<String>.from(json['roles'] ?? []),

      isAdmin: json['isAdmin'] ?? false,
      isWorker: json['isWorker'] ?? false,
      isForeman: json['isForeman'] ?? false,
      isProductionPlanner: json['isProductionPlanner'] ?? false,
      isPurchasing: json['isPurchasing'] ?? false,
    );
  }
}
