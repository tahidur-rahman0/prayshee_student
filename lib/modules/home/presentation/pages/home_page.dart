import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:online_training_template/main.dart';
import 'package:online_training_template/models/course_model.dart';
import 'package:online_training_template/models/teacher_model.dart';
import 'package:online_training_template/providers/course_list_provider.dart';
import 'package:online_training_template/providers/current_user_notifier.dart';
import 'package:online_training_template/providers/teacher_details_provider.dart';
import 'package:online_training_template/ui/app_theme.dart';
import 'package:online_training_template/ui/color_helper.dart';
import 'package:online_training_template/ui/routes/app_pages.dart';
import 'package:online_training_template/ui/text_styles.dart';

import '../widgets/popular_course_list_widget.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  CategoryType categoryType = CategoryType.ui;
  String? selectedSubject;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = ref.watch(currentUserNotifierProvider);
    final teacherDetailsAsync = ref.watch(
      teacherDetailsProvider((
        token: currentUser?.token ?? '',
        teacherId: currentUser?.teacherId ?? 0
      )),
    );

    return Scaffold(
      backgroundColor: ColorHelper.bgColor,
      body: teacherDetailsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (result) => result.fold(
          (failure) => Center(child: Text(failure.message)),
          (teacher) {
            // Watch the course list when a subject is selected
            final courseListAsync = ref.watch(
              courseListProvider((
                token: currentUser?.token ?? '',
                teacherId: currentUser?.teacherId ?? 0,
                subject: selectedSubject,
              )),
            );

            return Column(
              children: <Widget>[
                SizedBox(height: MediaQuery.of(context).padding.top),
                getAppBarUI(currentUser?.name ?? ''),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        getSearchBarUI(),
                        getCategoryUI(teacher),
                        if (courseListAsync != null)
                          courseListAsync.when(
                            loading: () => const Center(
                                child: CircularProgressIndicator()),
                            error: (e, _) => Center(child: Text('Error: $e')),
                            data: (result) => result.fold(
                              (failure) => Center(child: Text(failure.message)),
                              (courses) => getCourseListUI(courses),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget getCourseListUI(List<CourseModel> courses) {
    return PopularCourseListView(
      courses: courses,
      callBack: (course) {
        Get.toNamed(
          Routes.courseInfoPage,
          arguments: course,
        );
      },
    );
  }

  Widget getCategoryUI(TeacherModel teacher) {
    final List<dynamic> subjects = teacher.course ?? [];

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Padding(
          padding: EdgeInsets.only(top: 8.0, left: 18, right: 16),
          child: Text(
            'Subjects',
            textAlign: TextAlign.left,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 22,
              letterSpacing: 0.27,
              color: AppTheme.primaryColor,
            ),
          ),
        ),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.only(left: 16),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: subjects.map((subject) {
                final isSelected = subject == selectedSubject;
                return Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: getButtonUI(subject, isSelected),
                );
              }).toList(),
            ),
          ),
        ),
        // const SizedBox(height: 16),
        // CategoryListView(
        //   callBack: () {
        //     moveTo();
        //   },
        // ),
      ],
    );
  }

  Widget getButtonUI(String subject, bool isSelected) {
    return Container(
      decoration: BoxDecoration(
        color: isSelected ? ColorHelper.primaryColor : ColorHelper.cardBgColor,
        borderRadius: BorderRadius.all(Radius.circular(24.0)),
        border: Border.all(color: ColorHelper.primaryColor),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          splashColor: Colors.white24,
          borderRadius: BorderRadius.all(Radius.circular(24.0)),
          onTap: () {
            setState(() {
              selectedSubject = subject;
            });
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 18),
            child: Text(
              subject,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 12,
                letterSpacing: 0.27,
                color:
                    isSelected ? AppTheme.nearlyWhite : AppTheme.primaryColor,
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Widget getPopularCourseUI() {
  //   return Padding(
  //     padding: const EdgeInsets.only(top: 8.0, left: 18, right: 16),
  //     child: Column(
  //       mainAxisAlignment: MainAxisAlignment.center,
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: <Widget>[
  //         Text(
  //           'Popular Course',
  //           textAlign: TextAlign.left,
  //           style: TextStyle(
  //             fontWeight: FontWeight.w600,
  //             fontSize: 22,
  //             letterSpacing: 0.27,
  //             color: ColorHelper.grey900Color,
  //           ),
  //         ),
  //         Flexible(
  //           child: PopularCourseListView(
  //             callBack: () {
  //               moveTo();
  //             },
  //           ),
  //         )
  //       ],
  //     ),
  //   );
  // }

  void moveTo() {
    Get.toNamed(Routes.courseInfoPage);
  }

  Widget getSearchBarUI() {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, left: 18),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width * 0.75,
            height: 64,
            child: Padding(
              padding: const EdgeInsets.only(top: 8, bottom: 8),
              child: Container(
                decoration: BoxDecoration(
                  color: ColorHelper.cardBgColor,
                  borderRadius: const BorderRadius.only(
                    bottomRight: Radius.circular(13.0),
                    bottomLeft: Radius.circular(13.0),
                    topLeft: Radius.circular(13.0),
                    topRight: Radius.circular(13.0),
                  ),
                ),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.only(left: 16, right: 16),
                        child: TextFormField(
                          style: const TextStyle(
                            fontFamily: 'WorkSans',
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: AppTheme.primaryColor,
                          ),
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            labelText: 'Search for course',
                            border: InputBorder.none,
                            helperStyle: AppTextStyles.body1,
                            labelStyle: AppTextStyles.body1,
                          ),
                          onEditingComplete: () {},
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 60,
                      height: 60,
                      child: Icon(Icons.search, color: HexColor('#B9BABC')),
                    )
                  ],
                ),
              ),
            ),
          ),
          const Expanded(
            child: SizedBox(),
          )
        ],
      ),
    );
  }

  Widget getAppBarUI(String name) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, left: 18, right: 18),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Prayashee',
                  textAlign: TextAlign.left,
                  style: AppTextStyles.caption,
                ),
                Text(
                  name,
                  textAlign: TextAlign.left,
                  style: AppTextStyles.title,
                ),
              ],
            ),
          ),
          Container(
            width: 60,
            height: 60,
            child: Image.asset('assets/userImage.png'),
          )
        ],
      ),
    );
  }
}

enum CategoryType {
  ui,
  coding,
  basic,
}
