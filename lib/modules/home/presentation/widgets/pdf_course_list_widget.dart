import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:online_training_template/app/const/const.dart';
import 'package:online_training_template/models/pdfs_model.dart';
import 'package:online_training_template/modules/pdf_viewer/flutter_pdfview.dart';
import 'package:path_provider/path_provider.dart';

class PdfCourseListView extends StatefulWidget {
  final List<PdfsModel> courses;
  bool buy;

  PdfCourseListView({
    Key? key,
    required this.courses,
    this.buy = false,
  }) : super(key: key);

  @override
  _PdfCourseListViewState createState() => _PdfCourseListViewState();
}

class _PdfCourseListViewState extends State<PdfCourseListView>
    with TickerProviderStateMixin {
  AnimationController? animationController;

  @override
  void initState() {
    animationController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    super.initState();
  }

  Future<bool> getData() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: getData(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const SizedBox();
        return GridView.builder(
          padding: const EdgeInsets.all(8),
          physics: const BouncingScrollPhysics(),
          shrinkWrap: true,
          itemCount: widget.courses.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 32.0,
            crossAxisSpacing: 32.0,
            childAspectRatio: 0.8,
          ),
          itemBuilder: (context, index) {
            final course = widget.courses[index];
            final animation = Tween<double>(begin: 0.0, end: 1.0).animate(
              CurvedAnimation(
                parent: animationController!,
                curve: Interval((1 / widget.courses.length) * index, 1.0,
                    curve: Curves.fastOutSlowIn),
              ),
            );
            animationController?.forward();

            return CourseCard(
              course: course,
              animation: animation,
              animationController: animationController!,
              buy: widget.buy,
              callback: () {
                // if (widget.callBack != null) {
                //   widget.callBack!(course);
                // }
              },
            );
          },
        );
      },
    );
  }
}

class CourseCard extends StatelessWidget {
  final PdfsModel course;
  final AnimationController animationController;
  final Animation<double> animation;
  final VoidCallback? callback;
  final bool buy;

  const CourseCard({
    Key? key,
    required this.course,
    required this.animationController,
    required this.animation,
    required this.buy,
    this.callback,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animationController,
      builder: (context, child) {
        return FadeTransition(
          opacity: animation,
          child: Transform.translate(
            offset: Offset(0.0, 50 * (1.0 - animation.value)),
            child: InkWell(
              onTap: () {
                if (course.is_paid == 0 || buy) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => PDFViewerPage(
                              pdf: course.pdf_url,
                            )),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('You need to buy this course first'),
                    ),
                  );
                }
              },
              child: Container(
                height: 280,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    )
                  ],
                ),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    // Background Image
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.network(
                        '${ServerConstant.baseUrl}${course.image}',
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: Colors.grey[300],
                            alignment: Alignment.center,
                            child: Icon(Icons.broken_image,
                                size: 48, color: Colors.grey[600]),
                          );
                        },
                      ),
                    ),

                    // Dark overlay for readability
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: Colors.black.withOpacity(0.4),
                      ),
                    ),

                    // Text content
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            course.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            course.description,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 13,
                              color: Colors.white70,
                            ),
                          ),
                          const Spacer(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                course.is_paid == 1 ? 'Paid' : 'Free',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              // Text(
                              //   '${course.download_able} days',
                              //   style: const TextStyle(
                              //     fontSize: 13,
                              //     color: Colors.white,
                              //   ),
                              // ),
                              if (course.download_able == 1)
                                IconButton(
                                  onPressed: () async {
                                    final url =
                                        '${ServerConstant.baseUrl}/${course.pdf_url}';
                                    final fileName = url.split('/').last;

                                    // var status = await Permission.storage.request();
                                    // if (status.isGranted) {
                                    try {
                                      showDialog(
                                        context: context,
                                        barrierDismissible: false,
                                        builder: (BuildContext context) {
                                          return const AlertDialog(
                                            content: Row(
                                              children: [
                                                CircularProgressIndicator(),
                                                SizedBox(width: 16),
                                                Text("Downloading..."),
                                              ],
                                            ),
                                          );
                                        },
                                      );

                                      Directory? directory;
                                      if (Platform.isAndroid) {
                                        directory = Directory(
                                            '/storage/emulated/0/Download');
                                      } else {
                                        directory =
                                            await getApplicationDocumentsDirectory();
                                      }

                                      final filePath =
                                          '${directory.path}/$fileName';

                                      await Dio().download(url, filePath);

                                      Navigator.of(context)
                                          .pop(); // close the loading dialog

                                      Fluttertoast.showToast(
                                        msg:
                                            "Downloaded to ${directory.path}/$fileName",
                                        toastLength: Toast.LENGTH_LONG,
                                      );
                                    } catch (e) {
                                      Navigator.of(context)
                                          .pop(); // close the dialog if error
                                      Fluttertoast.showToast(
                                        msg: "Download failed: $e",
                                        toastLength: Toast.LENGTH_LONG,
                                      );
                                    }
                                    // } else {
                                    //   Fluttertoast.showToast(
                                    //     msg: "Storage permission denied",
                                    //     toastLength: Toast.LENGTH_SHORT,
                                    //   );
                                    // }
                                  },
                                  icon: const Icon(
                                    Icons.download,
                                    color: Colors.white,
                                  ),
                                )
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
