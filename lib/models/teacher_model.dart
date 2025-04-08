// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

class TeacherModel {
  final int id;
  final String name;
  final String phone;
  final String email;
  String? address;
  String? city;
  String? qualification;
  int? total_experience;
  String? experience_details;
  int? is_verified;
  String? profile_photo;
  List<dynamic>? course;
  String? upi_id;
  TeacherModel({
    required this.id,
    required this.name,
    required this.phone,
    required this.email,
    this.address,
    this.city,
    this.qualification,
    this.total_experience,
    this.experience_details,
    this.is_verified,
    this.profile_photo,
    this.course,
    this.upi_id,
  });

  TeacherModel copyWith({
    int? id,
    String? name,
    String? phone,
    String? email,
    String? address,
    String? city,
    String? qualification,
    int? total_experience,
    String? experience_details,
    int? is_verified,
    String? profile_photo,
    List<String>? course,
    String? upi_id,
  }) {
    return TeacherModel(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      address: address ?? this.address,
      city: city ?? this.city,
      qualification: qualification ?? this.qualification,
      total_experience: total_experience ?? this.total_experience,
      experience_details: experience_details ?? this.experience_details,
      is_verified: is_verified ?? this.is_verified,
      profile_photo: profile_photo ?? this.profile_photo,
      course: course ?? this.course,
      upi_id: upi_id ?? this.upi_id,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'phone': phone,
      'email': email,
      'address': address,
      'city': city,
      'qualification': qualification,
      'total_experience': total_experience,
      'experience_details': experience_details,
      'is_verified': is_verified,
      'profile_photo': profile_photo,
      'course': course,
      'upi_id': upi_id,
    };
  }

  factory TeacherModel.fromMap(Map<String, dynamic> map) {
    return TeacherModel(
      id: map['id'] as int,
      name: map['name'] as String,
      phone: map['phone'] as String,
      email: map['email'] as String,
      address: map['address'] != null ? map['address'] as String : null,
      city: map['city'] != null ? map['city'] as String : null,
      qualification:
          map['qualification'] != null ? map['qualification'] as String : null,
      total_experience: map['total_experience'] != null
          ? map['total_experience'] as int
          : null,
      experience_details: map['experience_details'] != null
          ? map['experience_details'] as String
          : null,
      is_verified:
          map['is_verified'] != null ? map['is_verified'] as int : null,
      profile_photo:
          map['profile_photo'] != null ? map['profile_photo'] as String : null,
      course: map['course'],
      upi_id: map['upi_id'] != null ? map['upi_id'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory TeacherModel.fromJson(String source) =>
      TeacherModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'TeacherModel(id: $id, name: $name, phone: $phone, email: $email, address: $address, city: $city, qualification: $qualification, total_experience: $total_experience, experience_details: $experience_details, is_verified: $is_verified, profile_photo: $profile_photo, course: $course, upi_id: $upi_id)';
  }

  @override
  bool operator ==(covariant TeacherModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.name == name &&
        other.phone == phone &&
        other.email == email &&
        other.address == address &&
        other.city == city &&
        other.qualification == qualification &&
        other.total_experience == total_experience &&
        other.experience_details == experience_details &&
        other.is_verified == is_verified &&
        other.profile_photo == profile_photo &&
        listEquals(other.course, course) &&
        other.upi_id == upi_id;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        phone.hashCode ^
        email.hashCode ^
        address.hashCode ^
        city.hashCode ^
        qualification.hashCode ^
        total_experience.hashCode ^
        experience_details.hashCode ^
        is_verified.hashCode ^
        profile_photo.hashCode ^
        course.hashCode ^
        upi_id.hashCode;
  }
}
