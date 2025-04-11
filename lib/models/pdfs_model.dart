// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class PdfsModel {
  final int id;
  final int teacher_id;
  final int course_id;
  final String subject_name;
  String? teacher_name;
  String? course_name;
  final String title;
  final String description;
  final String pdf_url;
  final int is_paid;
  final int download_able;
  String? image;
  String? type;
  PdfsModel({
    required this.id,
    required this.teacher_id,
    required this.course_id,
    required this.subject_name,
    this.teacher_name,
    this.course_name,
    required this.title,
    required this.description,
    required this.pdf_url,
    required this.is_paid,
    required this.download_able,
    this.image,
    this.type,
  });

  PdfsModel copyWith({
    int? id,
    int? teacher_id,
    int? course_id,
    String? subject_name,
    String? teacher_name,
    String? course_name,
    String? title,
    String? description,
    String? pdf_url,
    int? is_paid,
    int? download_able,
    String? image,
    String? type,
  }) {
    return PdfsModel(
      id: id ?? this.id,
      teacher_id: teacher_id ?? this.teacher_id,
      course_id: course_id ?? this.course_id,
      subject_name: subject_name ?? this.subject_name,
      teacher_name: teacher_name ?? this.teacher_name,
      course_name: course_name ?? this.course_name,
      title: title ?? this.title,
      description: description ?? this.description,
      pdf_url: pdf_url ?? this.pdf_url,
      is_paid: is_paid ?? this.is_paid,
      download_able: download_able ?? this.download_able,
      image: image ?? this.image,
      type: type ?? this.type,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'teacher_id': teacher_id,
      'course_id': course_id,
      'subject_name': subject_name,
      'teacher_name': teacher_name,
      'course_name': course_name,
      'title': title,
      'description': description,
      'pdf_url': pdf_url,
      'is_paid': is_paid,
      'download_able': download_able,
      'image': image,
      'type': type,
    };
  }

  factory PdfsModel.fromMap(Map<String, dynamic> map) {
    return PdfsModel(
      id: map['id'] as int,
      teacher_id: map['teacher_id'] as int,
      course_id: map['course_id'] as int,
      subject_name: map['subject_name'] as String,
      teacher_name:
          map['teacher_name'] != null ? map['teacher_name'] as String : null,
      course_name:
          map['course_name'] != null ? map['course_name'] as String : null,
      title: map['title'] as String,
      description: map['description'] as String,
      pdf_url: map['pdf_url'] as String,
      is_paid: map['is_paid'] as int,
      download_able: map['download_able'] as int,
      image: map['image'] != null ? map['image'] as String : null,
      type: map['type'] != null ? map['type'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory PdfsModel.fromJson(String source) =>
      PdfsModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'PdfsModel(id: $id, teacher_id: $teacher_id, course_id: $course_id, subject_name: $subject_name, teacher_name: $teacher_name, course_name: $course_name, title: $title, description: $description, pdf_url: $pdf_url, is_paid: $is_paid, download_able: $download_able, image: $image, type: $type)';
  }

  @override
  bool operator ==(covariant PdfsModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.teacher_id == teacher_id &&
        other.course_id == course_id &&
        other.subject_name == subject_name &&
        other.teacher_name == teacher_name &&
        other.course_name == course_name &&
        other.title == title &&
        other.description == description &&
        other.pdf_url == pdf_url &&
        other.is_paid == is_paid &&
        other.download_able == download_able &&
        other.image == image &&
        other.type == type;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        teacher_id.hashCode ^
        course_id.hashCode ^
        subject_name.hashCode ^
        teacher_name.hashCode ^
        course_name.hashCode ^
        title.hashCode ^
        description.hashCode ^
        pdf_url.hashCode ^
        is_paid.hashCode ^
        download_able.hashCode ^
        image.hashCode ^
        type.hashCode;
  }
}
