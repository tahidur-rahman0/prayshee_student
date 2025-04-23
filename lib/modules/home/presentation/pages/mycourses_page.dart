import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:online_training_template/models/transaction_model.dart';
import 'package:online_training_template/modules/home/presentation/widgets/my_course_list_widget.dart';
import 'package:online_training_template/providers/current_user_notifier.dart';
import 'package:online_training_template/providers/my_course_list_provider.dart';

class MyCoursePage extends ConsumerStatefulWidget {
  const MyCoursePage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MyCoursePageState();
}

class _MyCoursePageState extends ConsumerState<MyCoursePage> {
  @override
  Widget build(BuildContext context) {
    final currentUser = ref.watch(currentUserNotifierProvider);
    final courseListAsync = ref.watch(
      myCourseListProvider((
        token: currentUser?.token ?? '',
        studentId: currentUser?.id ?? 0,
      )),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('My Courses'),
      ),
      body: Column(
        children: [
          courseListAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(child: Text('Error: $e')),
            data: (result) => result.fold(
              (failure) => Center(child: Text(failure.message)),
              (courses) => getCourseListUI(courses),
            ),
          ),
        ],
      ),
    );
  }

  Widget getCourseListUI(List<TransactionModel> courses) {
    return MyCourseListView(
      courses: courses,
    );
  }
}
