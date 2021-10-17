import 'package:customimageprovider/demo_links.dart';
import 'package:customimageprovider/image_provider/custom_image_provider.dart';
import 'package:customimageprovider/media.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:memory_info/memory_info.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  final ValueNotifier<num> memory = ValueNotifier(0);

  checkMemory() async {
    num starting = (await MemoryInfoPlugin().memoryInfo).freeMem ?? 0;
    while (true) {
      memory.value =
          starting - ((await MemoryInfoPlugin().memoryInfo).freeMem ?? 0);
      await Future.delayed(const Duration(seconds: 1));
    }
  }

  @override
  Widget build(BuildContext context) {
    checkMemory();

    return LayoutBuilder(builder: (context, constraints) {
      return OrientationBuilder(builder: (context, orientation) {
        Media().init(constraints, orientation);
        return MaterialApp(
          home: Scaffold(
            appBar: AppBar(
              title: ValueListenableBuilder(
                  valueListenable: memory,
                  builder: (context, num val, wid) {
                    return Text('${val.toStringAsFixed(2)} MB');
                  }),
            ),
            body: ListView.builder(
              itemCount: 2000,
              itemBuilder: (context, index) {
                return getPost(context, profiles[index%profiles.length], posts[index%posts.length]);
              },
            ),
          ),
        );
      });
    });
  }

  Widget getPost(BuildContext context, String profileUrl, String postUrl) {
    BoxFit boxFit = BoxFit.cover;
    bool isLiked = true;
    return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
      return Container(
          margin: EdgeInsets.symmetric(vertical: Media.height * 1.2),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(
                        right: Media.width * 5, left: Media.width * 2.7),
                    height: Media.image * 10,
                    width: Media.image * 10,
                    child: CircleAvatar(
                      backgroundImage:
                          CustomNetworkImage(profileUrl, isProfile: true),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      'username',
                      style: TextStyle(fontSize: Media.text * 2.2),
                    ),
                  ),
                  IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.more_vert_rounded,
                          color: Colors.white)),
                ],
              ),
              //croppedImage(post.picUri),
              //postImage(post, boxFit),
              //postImageNew(post, boxFit),
              SizedBox(height: Media.height * 0.5),
              Center(
                child: Container(
                  constraints: BoxConstraints(
                      maxHeight: Media.width * 85, minWidth: Media.width * 100),
                  child: GestureDetector(
                    onLongPress: () {
                      if (boxFit == BoxFit.cover) {
                        boxFit = BoxFit.contain;
                      } else {
                        boxFit = BoxFit.cover;
                      }
                      setState(() {});
                    },
                    onDoubleTap: () async {},
                    //       child: croppedImage(post.picUri, boxFit),
                    child: FadeInImage(
                      fit: boxFit,
                      image: CustomNetworkImage(
                        postUrl,
                      ),
                      placeholder: const AssetImage('images/1.gif'),
                    ),
                  ),
                ),
              ),

              // AnimatedSwitcher(
              //   duration: Duration(milliseconds: 200),
              //   child: showPopup
              //       ? Container(
              //           color: Colors.black.withOpacity(.5),
              //           width: 100.w,
              //           padding: EdgeInsets.all(3.sp),
              //           child: Text(
              //             "Double tap to ${enableImageResize ? "Resize" : "Like"} enabled",
              //             textAlign: TextAlign.center,
              //             style: TextStyle(
              //               color: whiteColor,
              //               fontSize: 6.sp,
              //             ),
              //           ))
              //       : SizedBox(),
              // ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Stack(
                        alignment: const Alignment(0, 0),
                        children: <Widget>[
                          Icon(
                            Icons.favorite_border,
                            size: Media.image * 7,
                            color: isLiked ? Colors.red : Colors.white,
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.favorite,
                              size: Media.image * 7,
                            ),
                            color: isLiked ? Colors.red : Colors.transparent,
                            onPressed: () async {
                              if (isLiked) {
                                isLiked = false;
                              } else {
                                isLiked = true;
                              }
                              setState(() {});
                            },
                          )
                        ],
                      ),
                      Stack(
                        alignment: const Alignment(0, 0),
                        children: <Widget>[
                          IconButton(
                            icon: Icon(
                              CupertinoIcons.chat_bubble,
                              size: Media.image * 7,
                            ),
                            color: Colors.white,
                            onPressed: () async {},
                          )
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ));
    });
  }
}
