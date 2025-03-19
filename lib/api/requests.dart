import 'dart:convert';
import 'package:doramed/api/models.dart';
import 'package:http/http.dart' as http;

class UserService {
  final String baseUrl;

  UserService({
    this.baseUrl = 'http://192.168.1.18:8000/accounts',
  });

  // login
  Future<UserAuthResponseModel> login(
    String username,
    String password,
  ) async {
    final url = Uri.parse('$baseUrl/auth/login/');
    final response = await http.post(
      url,
      body: {
        'username': username,
        'password': password,
      },
    );

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      return UserAuthResponseModel.fromJson(jsonResponse);
    } else {
      throw Exception('Failed to login');
    }
  }

  // user sign up
  Future<UserAuthResponseModel> signUp(
    String username,
    String email,
    String password,
    String password2,
  ) async {
    final url = Uri.parse('$baseUrl/register/');
    final response = await http.post(
      url,
      body: {
        'username': username,
        'email': email,
        'password': password,
        'password2': password2,
      },
    );

    if (response.statusCode == 201) {
      final jsonResponse = json.decode(response.body);
      return UserAuthResponseModel.fromJson(jsonResponse);
    } else {
      throw Exception('Failed to signup');
    }
  }

  // logout user
  Future<bool> logout(
    JwtModel jwt,
  ) async {
    final url = Uri.parse('$baseUrl/logout/');
    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer ${jwt.accessToken}',
      },
      body: {
        'refresh_token': jwt.refreshToken,
      },
    );

    if (response.statusCode == 204) {
      return true;
    } else {
      throw Exception('Failed to logout');
    }
  }
}

class TaskService {
  final String? baseUrl;
  final JwtModel jwt;

  TaskService({
    required this.jwt,
    this.baseUrl = 'http://192.168.1.18:8000',
  });

  // List all tasks
  Future<List<TaskModel?>> listTasks() async {
    final url = Uri.parse('$baseUrl/tasks/');
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer ${jwt.accessToken}',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => TaskModel.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load tasks');
    }
  }

  // Create a new task
  Future<TaskModel> createTask(Map<String, dynamic> data) async {
    final url = Uri.parse('$baseUrl/tasks/create/');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${jwt.accessToken}',
      },
      body: json.encode(data),
    );

    if (response.statusCode == 201) {
      return TaskModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to create task');
    }
  }

  // Update an existing task
  Future<TaskModel> updateTask(int taskId, Map<String, dynamic> data) async {
    final url = Uri.parse('$baseUrl/tasks/$taskId/update/');
    final response = await http.put(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${jwt.accessToken}',
      },
      body: json.encode(data),
    );

    if (response.statusCode == 200) {
      return TaskModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to update task');
    }
  }

  // Delete a task
  Future<bool> deleteTask(int taskId) async {
    final url = Uri.parse('$baseUrl/tasks/$taskId/delete/');
    final response = await http.delete(
      url,
      headers: {
        'Authorization': 'Bearer ${jwt.accessToken}',
      },
    );

    if (response.statusCode == 204) {
      return true;
    } else {
      throw Exception('Failed to delete task');
    }
  }
}
