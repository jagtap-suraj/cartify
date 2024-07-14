import 'dart:convert';

class User {
  final String? id;
  final String name;
  final String email;
  final String password;
  final String? address;
  final String? type;
  final String? token;
  final List<dynamic>? cart;

  User({
    this.id,
    required this.name,
    required this.email,
    required this.password,
    this.address,
    this.type,
    this.token,
    this.cart,
  });

  /// Converts the User object to a map of key-value pairs
  /// to store in the local storage or to send it over the network.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'password': password,
      'address': address,
      'type': type,
      'token': token,
      'cart': cart,
    };
  }

  /// Converts the map of key-value pairs to a User object to use in the app.
  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['_id'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      password: map['password'] ?? '',
      address: map['address'] ?? '',
      type: map['type'] ?? '',
      token: map['token'] ?? '',
      cart: List<Map<String, dynamic>>.from(
        map['cart']?.map(
          (x) => Map<String, dynamic>.from(x),
        ),
      ),
    );
  }

  /// Converts a map of key-value pairs from a SQL database to a User object.
  factory User.fromSqlMap(Map<String, dynamic> map) {
    return User(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      password: map['password'] ?? '',
      address: map['address'] ?? '',
      type: map['type'] ?? '',
      token: map['token'] ?? '',
    );
  }

  /// toMap(): Converts the User object to a map of key-value pairs
  /// json.encode(toMap()): Converts the map of key-value pairs to a JSON string
  /// toJson(): First calls toMap() that returns a map and then json.encode() that converts it to a JSON string
  String toJson() => json.encode(toMap());

  /// json.decode(source): Converts the JSON string to a map of key-value pairs
  /// fromMap(json.decode(source)): Converts the map of key-value pairs to a User object
  /// User.fromJson(source): First calls json.decode() that returns a map and then fromMap() that converts it to a User object
  factory User.fromJson(String source) => User.fromMap(json.decode(source));

  /// copyWith(): Updates the User object with the new values
  User copyWith({
    String? id,
    String? name,
    String? email,
    String? password,
    String? address,
    String? type,
    String? token,
    List<dynamic>? cart,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
      address: address ?? this.address,
      type: type ?? this.type,
      token: token ?? this.token,
      cart: cart ?? this.cart,
    );
  }
}
