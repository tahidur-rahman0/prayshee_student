// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class TransactionModel {
  final int id;
  final int teacher_id;
  final int student_id;
  final String student_name;
  final int course_id;
  final String course_name;
  final int price;
  final String payment_id;
  final String payment_mode;
  final int platform_fee;
  final int status;
  TransactionModel({
    required this.id,
    required this.teacher_id,
    required this.student_id,
    required this.student_name,
    required this.course_id,
    required this.course_name,
    required this.price,
    required this.payment_id,
    required this.payment_mode,
    required this.platform_fee,
    required this.status,
  });

  TransactionModel copyWith({
    int? id,
    int? teacher_id,
    int? student_id,
    String? student_name,
    int? course_id,
    String? course_name,
    int? price,
    String? payment_id,
    String? payment_mode,
    int? platform_fee,
    int? status,
  }) {
    return TransactionModel(
      id: id ?? this.id,
      teacher_id: teacher_id ?? this.teacher_id,
      student_id: student_id ?? this.student_id,
      student_name: student_name ?? this.student_name,
      course_id: course_id ?? this.course_id,
      course_name: course_name ?? this.course_name,
      price: price ?? this.price,
      payment_id: payment_id ?? this.payment_id,
      payment_mode: payment_mode ?? this.payment_mode,
      platform_fee: platform_fee ?? this.platform_fee,
      status: status ?? this.status,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'teacher_id': teacher_id,
      'student_id': student_id,
      'student_name': student_name,
      'course_id': course_id,
      'course_name': course_name,
      'price': price,
      'payment_id': payment_id,
      'payment_mode': payment_mode,
      'platform_fee': platform_fee,
      'status': status,
    };
  }

  factory TransactionModel.fromMap(Map<String, dynamic> map) {
    return TransactionModel(
      id: map['id'] as int,
      teacher_id: map['teacher_id'] as int,
      student_id: map['student_id'] as int,
      student_name: map['student_name'] as String,
      course_id: map['course_id'] as int,
      course_name: map['course_name'] as String,
      price: map['price'] as int,
      payment_id: map['payment_id'] as String,
      payment_mode: map['payment_mode'] as String,
      platform_fee: map['platform_fee'] as int,
      status: map['status'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory TransactionModel.fromJson(String source) =>
      TransactionModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'TransactionModel(id: $id, teacher_id: $teacher_id, student_id: $student_id, student_name: $student_name, course_id: $course_id, course_name: $course_name, price: $price, payment_id: $payment_id, payment_mode: $payment_mode, platform_fee: $platform_fee, status: $status)';
  }

  @override
  bool operator ==(covariant TransactionModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.teacher_id == teacher_id &&
        other.student_id == student_id &&
        other.student_name == student_name &&
        other.course_id == course_id &&
        other.course_name == course_name &&
        other.price == price &&
        other.payment_id == payment_id &&
        other.payment_mode == payment_mode &&
        other.platform_fee == platform_fee &&
        other.status == status;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        teacher_id.hashCode ^
        student_id.hashCode ^
        student_name.hashCode ^
        course_id.hashCode ^
        course_name.hashCode ^
        price.hashCode ^
        payment_id.hashCode ^
        payment_mode.hashCode ^
        platform_fee.hashCode ^
        status.hashCode;
  }
}
