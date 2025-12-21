class Worker {
  //final String id;
  final String name;
  final String phone;
  final String role; // Worker/Foreman/...

  const Worker({
    //required this.id,
    required this.name,
    required this.phone,
    required this.role,
  });

  Worker copyWith({
    //String? id,
    String? name,
    String? phone,
    String? role,
  }) {
    return Worker(
     // id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      role: role ?? this.role,
    );
  }
}
