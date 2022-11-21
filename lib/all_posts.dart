import 'dart:async';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modil6_task7/add_post.dart';
import 'package:modil6_task7/models/post_model.dart';
import 'package:modil6_task7/servis/db_service.dart';

class MyAllPost extends StatefulWidget {
  const MyAllPost({super.key});

  @override
  State<MyAllPost> createState() => _MyAllPostState();
}

class _MyAllPostState extends State<MyAllPost> {
  List<PostModel> posts = [];

  @override
  void initState() {
    DBService.getPosts().then((value) {
      setState(() {
        posts = value;
      });
    });
    super.initState();
  }

  Future refresh() async {
    // await Future.delayed(
    //   const Duration(milliseconds: 3000),
    // );
    final result = await DBService.getPosts();
    if (result.isNotEmpty == true) {
      DBService.getPosts().then((value) {
        setState(() {
          posts = value;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    setState(() {});
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: buildAppbar(),
      body: buildBody(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const MyAddPost(),
            ),
          );
        },
        backgroundColor: const Color.fromARGB(255, 255, 87, 32),
        elevation: 16,
        splashColor: Colors.black,
        child: const Icon(Icons.add),
      ),
    );
  }

  buildAppbar() {
    return AppBar(
      backgroundColor: const Color.fromARGB(255, 255, 87, 32),
      title: const Text("All Posts"),
      centerTitle: true,
      actions: const [
        Padding(
          padding: EdgeInsets.all(8.0),
          child: Icon(Icons.exit_to_app),
        ),
      ],
    );
  }

  buildBody() {
    return posts.isNotEmpty == true
        ? RefreshIndicator(
            onRefresh: refresh,
            color: Colors.black,
            child: ListView.separated(
              itemBuilder: (context, index) => Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                color: Colors.grey,
                elevation: 10,
                shadowColor: Colors.grey,
                margin: const EdgeInsets.all(10),
                child: ListTile(
                  minVerticalPadding: 20,
                  leading: GestureDetector(
                    onTap: () {
                      _buildShowDialog(
                          "assets/images/photo${index >= 12 ? 0 : index}.jpg");
                    },
                    child: CircleAvatar(
                      backgroundColor: Colors.red,
                      radius: 33,
                      child: CircleAvatar(
                        backgroundColor: Colors.black,
                        radius: 26,
                        backgroundImage: AssetImage(
                            "assets/images/photo${index >= 12 ? 0 : index}.jpg"),
                      ),
                    ),
                  ),
                  title: Row(
                    children: [
                      Text(posts[index].fullname ?? "not name"),
                      const SizedBox(width: 10),
                      Text(posts[index].listname ?? "not name"),
                    ],
                  ),
                  horizontalTitleGap: 10,
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 10),
                      Text(posts[index].date ?? "not data"),
                      const SizedBox(height: 10),
                      Text(posts[index].content ?? "mot body"),
                    ],
                  ),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "post:${index + 1}",
                        style: const TextStyle(color: CupertinoColors.white),
                      ),
                      // SizedBox(height: 16),
                      GestureDetector(
                        onTap: () {
                          _buildAwesimoDialog(index);
                        },
                        child: const Icon(
                          Icons.delete_forever,
                          size: 30,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              separatorBuilder: (context, index) => const SizedBox(),
              itemCount: posts.length,
            ),
          )
        : const Center(
            child: CircularProgressIndicator(
            color: Colors.red,
          ));
  }

  _buildShowDialog(String s) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: SizedBox(
          height: 350,
          width: 350,
          child: Image(
            image: AssetImage(s),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  void _buildAwesimoDialog(int index) {
    AwesomeDialog(
      context: context,
      btnCancelOnPress: () {},
      btnOkOnPress: () {
        setState(() {
          posts.removeAt(index);
          // DBService.deletPost(index);
        });
      },
      alignment: Alignment.center,
      animType: AnimType.leftSlide,
      dialogType: DialogType.question,
      headerAnimationLoop: false,
      showCloseIcon: true,
      title: "Delete: post${index + 1}",
      titleTextStyle: const TextStyle(
        color: Colors.red,
        fontSize: 20,
      ),
      desc: "Name:  ${posts[index].fullname} ${posts[index].listname} ",
      descTextStyle: const TextStyle(
        fontSize: 16,
      ),
    ).show();
  }
}
