class UserModel {
  final int id;
  final String username;
  final String email;
  final DateTime created;
  final DateTime updated;

  UserModel({
    required this.id,
    required this.username,
    required this.email,
    required this.created,
    required this.updated,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      username: json['username'],
      email: json['email'],
      created: DateTime.parse(json['created']),
      updated: DateTime.parse(json['updated']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'created': created.toIso8601String(),
      'updated': updated.toIso8601String(),
    };
  }
}

class JwtModel {
  final String accessToken;
  final String refreshToken;

  JwtModel({
    required this.accessToken,
    required this.refreshToken,
  });

  factory JwtModel.fromJson(Map<String, dynamic> json) {
    return JwtModel(
      accessToken: json['access_token'],
      refreshToken: json['refresh_token'],
    );
  }
}

class UserAuthResponseModel {
  final UserModel user;
  final JwtModel jwt;

  UserAuthResponseModel({
    required this.user,
    required this.jwt,
  });

  factory UserAuthResponseModel.fromJson(Map<String, dynamic> json) {
    return UserAuthResponseModel(
      user: UserModel.fromJson(json['user_data']),
      jwt: JwtModel.fromJson(json['jwt_token']),
    );
  }
}

class TaskModel {
  final int id;
  final int userId;
  final String title;
  final String? description;
  final DateTime dueDate;
  final String status;
  final List<int> assignedUserIds;
  final DateTime created;
  final DateTime updated;

  TaskModel({
    required this.id,
    required this.userId,
    required this.title,
    this.description,
    required this.dueDate,
    required this.status,
    required this.assignedUserIds,
    required this.created,
    required this.updated,
  });

  // Factory constructor to create a TaskModel from a JSON map
  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      id: json['id'],
      userId: json['user'],
      title: json['title'],
      description: json['description'],
      dueDate: DateTime.parse(json['due_date']),
      status: json['status'],
      assignedUserIds: List<int>.from(json['assigned_users'] ?? []),
      created: DateTime.parse(json['created']),
      updated: DateTime.parse(json['updated']),
    );
  }

  // Method to convert TaskModel to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user': userId,
      'title': title,
      'description': description,
      'due_date': dueDate.toIso8601String(),
      'status': status,
      'assigned_users': assignedUserIds,
    };
  }
}
