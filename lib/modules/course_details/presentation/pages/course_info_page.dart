import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:online_training_template/models/course_model.dart';
import 'package:online_training_template/models/pdfs_model.dart';
import 'package:online_training_template/modules/home/presentation/widgets/pdf_course_list_widget.dart';
import 'package:online_training_template/providers/current_user_notifier.dart';
import 'package:online_training_template/providers/pdf_courses_provider.dart';
import 'package:online_training_template/ui/color_helper.dart';
import 'package:online_training_template/ui/app_theme.dart';
import 'package:online_training_template/app/const/const.dart';
import 'package:online_training_template/ui/routes/app_pages.dart';

class CourseInfoPage extends ConsumerStatefulWidget {
  final CourseModel course;

  const CourseInfoPage({super.key, required this.course});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CourseInfoPageState();
}

class _CourseInfoPageState extends ConsumerState<CourseInfoPage>
    with TickerProviderStateMixin {
  final double infoHeight = 364.0;
  AnimationController? animationController;
  Animation<double>? animation;
  double opacity1 = 0.0;
  double opacity2 = 0.0;
  double opacity3 = 0.0;

  @override
  void initState() {
    animationController = AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this);
    animation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
      parent: animationController!,
      curve: const Interval(0, 1.0, curve: Curves.fastOutSlowIn),
    ));
    setData();
    super.initState();
  }

  Future<void> setData() async {
    animationController?.forward();
    await Future<dynamic>.delayed(const Duration(milliseconds: 200));
    setState(() => opacity1 = 1.0);
    await Future<dynamic>.delayed(const Duration(milliseconds: 200));
    setState(() => opacity2 = 1.0);
    await Future<dynamic>.delayed(const Duration(milliseconds: 200));
    setState(() => opacity3 = 1.0);
  }

  @override
  Widget build(BuildContext context) {
    final double tempHeight = MediaQuery.of(context).size.height -
        (MediaQuery.of(context).size.width / 1.2) +
        24.0;
    final currentUser = ref.watch(currentUserNotifierProvider);

    final courseDetailsAsync = ref.watch(
      pdfsListProvider(
          (token: currentUser?.token ?? '', courseId: widget.course.id)),
    );

    return Container(
      color: ColorHelper.bgColor,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: courseDetailsAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text('Error: $e')),
          data: (result) => result.fold(
            (failure) => Center(child: Text(failure.message)),
            (pdfs) {
              return Stack(
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      AspectRatio(
                        aspectRatio: 1.2,
                        child: Image.network(
                          '${ServerConstant.baseUrl}${widget.course.image_name}',
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              Container(
                            color: Colors.grey[300],
                            child: const Icon(Icons.image_not_supported),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Positioned(
                    top: (MediaQuery.of(context).size.width / 1.2) - 24.0,
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      decoration: BoxDecoration(
                        color: ColorHelper.bgColor,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(32.0),
                          topRight: Radius.circular(32.0),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: ColorHelper.greyColor.withOpacity(0.2),
                            offset: const Offset(1.1, 1.1),
                            blurRadius: 10.0,
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: SingleChildScrollView(
                          child: Container(
                            constraints: BoxConstraints(
                              minHeight: infoHeight,
                              maxHeight: tempHeight > infoHeight
                                  ? tempHeight
                                  : infoHeight,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 32, left: 18, right: 16),
                                  child: Text(
                                    widget.course.course_name,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 22,
                                      letterSpacing: 0.27,
                                      color: ColorHelper.grey900Color,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 16, right: 16, bottom: 8, top: 16),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            '₹${widget.course.sell_price ?? widget.course.price}',
                                            style: TextStyle(
                                              fontSize: 22,
                                              color: AppTheme.primaryColor,
                                            ),
                                          ),
                                          Text(
                                            '₹${widget.course.price}',
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Text(
                                        'Validity: ${widget.course.validity} days',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: ColorHelper.greyColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: AnimatedOpacity(
                                    duration: const Duration(milliseconds: 500),
                                    opacity: opacity2,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16, vertical: 8),
                                      child: SingleChildScrollView(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Row(
                                                children: <Widget>[
                                                  getTimeBoxUI("24", "Classes"),
                                                  getTimeBoxUI(
                                                      "2 hrs", "Duration"),
                                                  getTimeBoxUI(
                                                      "Unlimited", "Access"),
                                                ],
                                              ),
                                            ),
                                            Text(
                                              widget.course.course_des,
                                              textAlign: TextAlign.justify,
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: ColorHelper.grey700Color,
                                              ),
                                            ),
                                            const SizedBox(height: 16),
                                            getPdfCourseList(pdfs),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                AnimatedOpacity(
                                  duration: const Duration(milliseconds: 500),
                                  opacity: opacity3,
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 16, right: 16, bottom: 16),
                                    child: Row(
                                      children: <Widget>[
                                        Container(
                                          width: 48,
                                          height: 48,
                                          decoration: BoxDecoration(
                                            color: ColorHelper.cardBgColor,
                                            borderRadius:
                                                BorderRadius.circular(16.0),
                                            border: Border.all(
                                              color: ColorHelper.greyColor
                                                  .withOpacity(0.2),
                                            ),
                                          ),
                                          child:
                                              const Icon(Icons.favorite_border),
                                        ),
                                        const SizedBox(width: 16),
                                        Expanded(
                                          child: SizedBox(
                                            height: 48,
                                            child: ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    AppTheme.primaryColor,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(16),
                                                ),
                                              ),
                                              onPressed: () {
                                                // Handle course enrollment
                                              },
                                              child: const Text(
                                                'Join Course',
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    color: Colors.white),
                                              ),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(
                                    height:
                                        MediaQuery.of(context).padding.bottom),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: (MediaQuery.of(context).size.width / 1.2) - 59,
                    right: 35,
                    child: ScaleTransition(
                      scale: CurvedAnimation(
                        parent: animationController!,
                        curve: Curves.fastOutSlowIn,
                      ),
                      child: Card(
                        color: ColorHelper.primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50.0),
                        ),
                        elevation: 10.0,
                        child: const SizedBox(
                          width: 60,
                          height: 60,
                          child: Icon(
                            Icons.favorite,
                            color: Colors.white,
                            size: 30,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        top: MediaQuery.of(context).padding.top),
                    child: SizedBox(
                      width: AppBar().preferredSize.height,
                      height: AppBar().preferredSize.height,
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(
                              AppBar().preferredSize.height),
                          onTap: () => Navigator.pop(context),
                          child: const Icon(Icons.arrow_back_ios),
                        ),
                      ),
                    ),
                  )
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget getTimeBoxUI(String text1, String txt2) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          color: ColorHelper.cardBgColor,
          borderRadius: BorderRadius.circular(16.0),
          boxShadow: [
            BoxShadow(
              color: AppTheme.grey.withOpacity(0.2),
              offset: const Offset(1.1, 1.1),
              blurRadius: 8.0,
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 18),
        child: Column(
          children: <Widget>[
            Text(
              text1,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppTheme.primaryColor,
              ),
            ),
            Text(
              txt2,
              style: TextStyle(
                fontSize: 14,
                color: ColorHelper.greyColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget getPdfCourseList(List<PdfsModel> courses) {
    return PdfCourseListView(
      courses: courses,
    );
  }
}
