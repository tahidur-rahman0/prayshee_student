// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class UserModel {
  final int id;
  final String token;
  final String name;
  final String phone;
  String? standard;
  String? subject;
  String? course;
  int? teacherId;
  UserModel({
    required this.id,
    required this.token,
    required this.name,
    required this.phone,
    this.standard,
    this.subject,
    this.course,
    this.teacherId,
  });

  UserModel copyWith({
    int? id,
    String? token,
    String? name,
    String? phone,
    String? standard,
    String? subject,
    String? course,
    int? teacherId,
  }) {
    return UserModel(
      id: id ?? this.id,
      token: token ?? this.token,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      standard: standard ?? this.standard,
      subject: subject ?? this.subject,
      course: course ?? this.course,
      teacherId: teacherId ?? this.teacherId,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'token': token,
      'name': name,
      'phone': phone,
      'standard': standard,
      'subject': subject,
      'course': course,
      'teacher_id': teacherId,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] as int,
      token: map.containsKey('token') ? map['token'] as String : '',
      name: map['name'] as String,
      phone: map['phone'] as String,
      standard: map['standard'] != null ? map['standard'] as String : null,
      subject: map['subject'] != null ? map['subject'] as String : null,
      course: map['course'] != null ? map['course'] as String : null,
      teacherId: map['teacher_id'] != null ? map['teacher_id'] as int : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'UserModel(id: $id, token: $token, name: $name, phone: $phone, standard: $standard, subject: $subject, course: $course, teacherId: $teacherId)';
  }

  @override
  bool operator ==(covariant UserModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.token == token &&
        other.name == name &&
        other.phone == phone &&
        other.standard == standard &&
        other.subject == subject &&
        other.course == course &&
        other.teacherId == teacherId;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        token.hashCode ^
        name.hashCode ^
        phone.hashCode ^
        standard.hashCode ^
        subject.hashCode ^
        course.hashCode ^
        teacherId.hashCode;
  }
}
