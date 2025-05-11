import 'package:flutter/material.dart';
import 'package:online_training_template/app/const/const.dart';
import 'package:online_training_template/models/video_model.dart';
import 'package:online_training_template/modules/video_payer/video_payer.dart';

class VideoCourseListView extends StatefulWidget {
  final List<VideoModel> courses;
  bool buy;

  VideoCourseListView({
    Key? key,
    required this.courses,
    this.buy = false,
  }) : super(key: key);

  @override
  _VideoCourseListViewState createState() => _VideoCourseListViewState();
}

class _VideoCourseListViewState extends State<VideoCourseListView>
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
  final VideoModel course;
  final AnimationController animationController;
  final Animation<double> animation;
  final VoidCallback? callback;
  final bool buy;

  const CourseCard({
    Key? key,
    required this.course,
    required this.animationController,
    required this.animation,
    this.callback,
    required this.buy,
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
                      builder: (context) => VideoPlayerSection(
                        video: course,
                      ),
                    ),
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
