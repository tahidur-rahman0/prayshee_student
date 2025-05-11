import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:online_training_template/models/course_model.dart';
import 'package:online_training_template/models/pdfs_model.dart';
import 'package:online_training_template/models/video_model.dart';
import 'package:online_training_template/modules/home/presentation/pages/shopping_cart_page.dart';
import 'package:online_training_template/modules/home/presentation/widgets/pdf_course_list_widget.dart';
import 'package:online_training_template/modules/home/presentation/widgets/video_course_list_widget.dart';
import 'package:online_training_template/providers/current_user_notifier.dart';
import 'package:online_training_template/providers/pdf_courses_provider.dart';
import 'package:online_training_template/providers/video_courses_provider.dart';
import 'package:online_training_template/ui/color_helper.dart';
import 'package:online_training_template/ui/app_theme.dart';
import 'package:online_training_template/app/const/const.dart';

class MyCourseInfoPage extends ConsumerStatefulWidget {
  final CourseModel course;
  final int? courseId;

  const MyCourseInfoPage({super.key, required this.course, this.courseId});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CourseInfoPageState();
}

class _CourseInfoPageState extends ConsumerState<MyCourseInfoPage> {
  final double infoHeight = 364.0;
  double opacity1 = 0.0;
  double opacity2 = 0.0;
  double opacity3 = 0.0;
  final ScrollController _scrollController = ScrollController();
  int totalVideos = 0;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 200), () {
      setState(() => opacity1 = 1.0);
    });
    Future.delayed(const Duration(milliseconds: 400), () {
      setState(() => opacity2 = 1.0);
    });
    Future.delayed(const Duration(milliseconds: 600), () {
      setState(() => opacity3 = 1.0);
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = ref.watch(currentUserNotifierProvider);

    print(currentUser?.token);

    final courseDetailsAsync = widget.courseId == null
        ? ref.watch(
            pdfsListProvider(
                (token: currentUser?.token ?? '', courseId: widget.course.id)),
          )
        : ref.watch(
            pdfsListProvider(
                (token: currentUser?.token ?? '', courseId: widget.courseId!)),
          );

    final videoDetailsAsync = widget.courseId == null
        ? ref.watch(
            videosListProvider(
              (token: currentUser?.token ?? '', courseId: widget.course.id),
            ),
          )
        : ref.watch(
            videosListProvider(
              (token: currentUser?.token ?? '', courseId: widget.courseId!),
            ),
          );

    return Scaffold(
      backgroundColor: ColorHelper.bgColor,
      body: courseDetailsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (result) => result.fold(
          (failure) => Center(child: Text(failure.message)),
          (pdfs) {
            return CustomScrollView(
              controller: _scrollController,
              slivers: <Widget>[
                SliverAppBar(
                  expandedHeight: MediaQuery.of(context).size.width / 1.2,
                  stretch: true,
                  pinned: true,
                  flexibleSpace: FlexibleSpaceBar(
                    background: Image.network(
                      '${ServerConstant.baseUrl}${pdfs[0].image}',
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: Colors.grey[300],
                        child: const Icon(Icons.image_not_supported),
                      ),
                    ),
                  ),
                  leading: IconButton(
                    icon: const Icon(Icons.arrow_back_ios),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                SliverToBoxAdapter(
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
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(top: 16),
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
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '₹${widget.course.sell_price}',
                                      style: const TextStyle(
                                        fontSize: 22,
                                        color: AppTheme.primaryColor,
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        const Text(
                                          'MRP:',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.grey,
                                          ),
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          '₹${widget.course.price}',
                                          style: const TextStyle(
                                            fontSize: 14,
                                            color: Colors.black,
                                            decoration:
                                                TextDecoration.lineThrough,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                Text(
                                  'Validity: ${widget.course.validity} Months',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: ColorHelper.greyColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          AnimatedOpacity(
                            duration: const Duration(milliseconds: 500),
                            opacity: opacity2,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: <Widget>[
                                      getTimeBoxUI(
                                          '${pdfs.length.toString()} pdfs',
                                          "Courses"),
                                      getTimeBoxUI("2 hrs", "Duration"),
                                      getTimeBoxUI("Unlimited", "Access"),
                                    ],
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    widget.course.course_des,
                                    textAlign: TextAlign.justify,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: ColorHelper.grey700Color,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      if (index == 0) {
                        return Column(
                          children: [
                            const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                'Pdf Courses',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            getPdfCourseList(pdfs),
                            const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                'Video Courses',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            videoDetailsAsync.when(
                              error: (e, _) => Center(child: Text('Error: $e')),
                              loading: () => const Center(
                                  child: CircularProgressIndicator()),
                              data: (result) => result.fold(
                                  (failure) =>
                                      Center(child: Text(failure.message)),
                                  (videos) {
                                totalVideos = videos.length;

                                return getVideoCourseList(videos);
                              }),
                            )
                          ],
                        );
                      }
                    },
                    childCount: 2,
                  ),
                ),
              ],
            );
          },
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
              style: const TextStyle(
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
      buy: true,
    );
  }

  Widget getVideoCourseList(List<VideoModel> courses) {
    return VideoCourseListView(
      courses: courses,
    );
  }
}
