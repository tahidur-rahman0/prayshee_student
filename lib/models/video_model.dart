// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class VideoModel {
  final int id;
  final int teacher_id;
  String? teacher_name;
  final int course_id;
  String? course_name;
  final String subject_name;
  final String title;
  final String description;
  final String youtube_url;
  final int is_paid;
  final int download_able;
  String? image;
  VideoModel({
    required this.id,
    required this.teacher_id,
    this.teacher_name,
    required this.course_id,
    this.course_name,
    required this.subject_name,
    required this.title,
    required this.description,
    required this.youtube_url,
    required this.is_paid,
    required this.download_able,
    this.image,
  });

  VideoModel copyWith({
    int? id,
    int? teacher_id,
    String? teacher_name,
    int? course_id,
    String? course_name,
    String? subject_name,
    String? title,
    String? description,
    String? youtube_url,
    int? is_paid,
    int? download_able,
    String? image,
  }) {
    return VideoModel(
      id: id ?? this.id,
      teacher_id: teacher_id ?? this.teacher_id,
      teacher_name: teacher_name ?? this.teacher_name,
      course_id: course_id ?? this.course_id,
      course_name: course_name ?? this.course_name,
      subject_name: subject_name ?? this.subject_name,
      title: title ?? this.title,
      description: description ?? this.description,
      youtube_url: youtube_url ?? this.youtube_url,
      is_paid: is_paid ?? this.is_paid,
      download_able: download_able ?? this.download_able,
      image: image ?? this.image,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'teacher_id': teacher_id,
      'teacher_name': teacher_name,
      'course_id': course_id,
      'course_name': course_name,
      'subject_name': subject_name,
      'title': title,
      'description': description,
      'youtube_url': youtube_url,
      'is_paid': is_paid,
      'download_able': download_able,
      'image': image,
    };
  }

  factory VideoModel.fromMap(Map<String, dynamic> map) {
    return VideoModel(
      id: map['id'] as int,
      teacher_id: map['teacher_id'] as int,
      teacher_name: map['teacher_name'] != null ? map['teacher_name'] as String : null,
      course_id: map['course_id'] as int,
      course_name: map['course_name'] != null ? map['course_name'] as String : null,
      subject_name: map['subject_name'] as String,
      title: map['title'] as String,
      description: map['description'] as String,
      youtube_url: map['youtube_url'] as String,
      is_paid: map['is_paid'] as int,
      download_able: map['download_able'] as int,
      image: map['image'] != null ? map['image'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory VideoModel.fromJson(String source) => VideoModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'VideoModel(id: $id, teacher_id: $teacher_id, teacher_name: $teacher_name, course_id: $course_id, course_name: $course_name, subject_name: $subject_name, title: $title, description: $description, youtube_url: $youtube_url, is_paid: $is_paid, download_able: $download_able, image: $image)';
  }

  @override
  bool operator ==(covariant VideoModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id &&
      other.teacher_id == teacher_id &&
      other.teacher_name == teacher_name &&
      other.course_id == course_id &&
      other.course_name == course_name &&
      other.subject_name == subject_name &&
      other.title == title &&
      other.description == description &&
      other.youtube_url == youtube_url &&
      other.is_paid == is_paid &&
      other.download_able == download_able &&
      other.image == image;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      teacher_id.hashCode ^
      teacher_name.hashCode ^
      course_id.hashCode ^
      course_name.hashCode ^
      subject_name.hashCode ^
      title.hashCode ^
      description.hashCode ^
      youtube_url.hashCode ^
      is_paid.hashCode ^
      download_able.hashCode ^
      image.hashCode;
  }
}
