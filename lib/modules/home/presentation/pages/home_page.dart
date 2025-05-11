import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:online_training_template/app/const/const.dart';
import 'package:online_training_template/main.dart';
import 'package:online_training_template/models/course_model.dart';
import 'package:online_training_template/models/teacher_model.dart';
import 'package:online_training_template/models/user_model.dart';
import 'package:online_training_template/modules/home/presentation/pages/my_teacher_page.dart';
import 'package:online_training_template/providers/course_list_provider.dart';
import 'package:online_training_template/providers/current_user_notifier.dart';
import 'package:online_training_template/providers/teacher_details_provider.dart';
import 'package:online_training_template/ui/app_theme.dart';
import 'package:online_training_template/ui/color_helper.dart';
import 'package:online_training_template/ui/routes/app_pages.dart';
import 'package:online_training_template/ui/text_styles.dart';

import '../widgets/popular_course_list_widget.dart';
import 'profile/profile_page.dart';

enum CategoryType {
  ui,
  coding,
  basic,
}

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  CategoryType categoryType = CategoryType.ui;
  String? selectedSubject;
  File? _localProfileImage;
  static const String _profileImageKey = 'profile_image_path';

  @override
  void initState() {
    super.initState();
    _loadProfileImage();
  }

  Future<void> _loadProfileImage() async {
    final prefs = await SharedPreferences.getInstance();
    final imagePath = prefs.getString(_profileImageKey);
    if (imagePath != null) {
      setState(() {
        _localProfileImage = File(imagePath);
      });
    }
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
                getAppBarUI(
                    currentUser?.name ?? '',
                    teacher.profile_photo,
                    teacher,
                    currentUser ??
                        UserModel(id: 0, token: '', name: '', phone: '')),
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

  Widget getAppBarUI(
      String name, String? image, TeacherModel teacher, UserModel user) {
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
                if (_localProfileImage != null)
                  InkWell(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ProfileScreen(
                                userModel: user,
                              )),
                    ),
                    child: ClipOval(
                      child: Image.file(
                        _localProfileImage!,
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                InkWell(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ProfileScreen(
                              userModel: user,
                            )),
                  ),
                  child: Text(
                    name,
                    textAlign: TextAlign.left,
                    style: AppTextStyles.title,
                  ),
                ),
              ],
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => TeacherProfileScreen(
                          teacher: teacher,
                        )),
              );
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: Image.network(
                image == null
                    ? 'https://img.freepik.com/free-vector/blue-circle-with-white-user_78370-4707.jpg?t=st=1746444895~exp=1746448495~hmac=4772f9f8087dd0456f600676caecff033f8d543ea255f16a004a2b0117b311f9&w=740'
                    : '${ServerConstant.baseUrl}/$image',
                width: 60,
                height: 60,
                fit: BoxFit.cover,
              ),
            ),
          )
        ],
      ),
    );
  }
}
