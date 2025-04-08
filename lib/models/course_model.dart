// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class CourseModel {
  final int id;
  final String course_name;
  final String course_des;
  final String image_name;
  final String price;
  final String sell_price;
  final int validity;
  CourseModel({
    required this.id,
    required this.course_name,
    required this.course_des,
    required this.image_name,
    required this.price,
    required this.sell_price,
    required this.validity,
  });

  CourseModel copyWith({
    int? id,
    String? course_name,
    String? course_des,
    String? image_name,
    String? price,
    String? sell_price,
    int? validity,
  }) {
    return CourseModel(
      id: id ?? this.id,
      course_name: course_name ?? this.course_name,
      course_des: course_des ?? this.course_des,
      image_name: image_name ?? this.image_name,
      price: price ?? this.price,
      sell_price: sell_price ?? this.sell_price,
      validity: validity ?? this.validity,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'course_name': course_name,
      'course_des': course_des,
      'image_name': image_name,
      'price': price,
      'sell_price': sell_price,
      'validity': validity,
    };
  }

  factory CourseModel.fromMap(Map<String, dynamic> map) {
    return CourseModel(
      id: map['id'] as int,
      course_name: map['course_name'] as String,
      course_des: map['course_des'] as String,
      image_name: map['image_name'] as String,
      price: map['price'] as String,
      sell_price: map['sell_price'] as String,
      validity: map['validity'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory CourseModel.fromJson(String source) =>
      CourseModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'CourseModel(id: $id, course_name: $course_name, course_des: $course_des, image_name: $image_name, price: $price, sell_price: $sell_price, validity: $validity)';
  }

  @override
  bool operator ==(covariant CourseModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.course_name == course_name &&
        other.course_des == course_des &&
        other.image_name == image_name &&
        other.price == price &&
        other.sell_price == sell_price &&
        other.validity == validity;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        course_name.hashCode ^
        course_des.hashCode ^
        image_name.hashCode ^
        price.hashCode ^
        sell_price.hashCode ^
        validity.hashCode;
  }
}
