import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modil6_task7/all_posts.dart';
import 'package:modil6_task7/models/post_model.dart';
import 'package:modil6_task7/servis/db_service.dart';

class MyAddPost extends StatefulWidget {
  const MyAddPost({super.key});

  @override
  State<MyAddPost> createState() => _MyAddPostState();
}

class _MyAddPostState extends State<MyAddPost> {
  final _fullnameController = TextEditingController();
  final _listnameController = TextEditingController();
  final _contentnController = TextEditingController();
  final _dateController = TextEditingController();
  PostCreateState _state = PostCreateState.initial;
  String body = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade700,
      appBar: _buildAppbar(),
      body: buildBody(),
    );
  }

  _buildAppbar() {
    return AppBar(
      backgroundColor: const Color.fromARGB(255, 255, 87, 32),
      title: const Text("Add Post"),
      centerTitle: true,
    );
  }

  buildBody() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(left: 30, right: 30),
        child: Column(
          children: [
            const SizedBox(height: 16),
            _buildTextFormField(
              "FirstName",
              10,
              _fullnameController,

              // value: (value) {
              //   return value?.isNotEmpty == true ? null : "Title must be filled";
              // },
            ),
            const SizedBox(height: 10),
            _buildTextFormField("ListName", 10, _listnameController),
            const SizedBox(height: 10),
            _buildTextFormField("Content", 40, _contentnController),
            const SizedBox(height: 10),
            _buildTextFormField("Date", 10, _dateController),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () async {
                setState(() {
                  _state = PostCreateState.loading;
                });
                if (_fullnameController.text != "") {
                  final post = PostModel(
                    id: DateTime.now().microsecondsSinceEpoch.toString(),
                    fullname: _fullnameController.text,
                    listname: _listnameController.text,
                    content: _contentnController.text,
                    date: _dateController.text,
                  );
            
                  final res = await DBService.createPost(post);
                  if (res) {
                    setState(() {
                      _state = PostCreateState.loadid;
                      _clearNameContent();
                    });
                    _buildFlutterToast("Create Post", Colors.green);
                  } else {
                    _buildFlutterToast("No Create Post", Colors.red);
                  }
                } else {
                  Timer(
                    const Duration(milliseconds: 1500),
                    () {
                      setState(() {
                        _state = PostCreateState.loadid;
                        _state = PostCreateState.error;
                        body = "FirstName,ListName,Content,Date must be filled";
                        _buildFlutterToast("No Creat Post", Colors.red);
                      });
                    },
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 255, 87, 32),
                fixedSize: const Size(double.maxFinite, 46),
              ),
              child: _state == PostCreateState.loading
                  ? const CircularProgressIndicator()
                  : const Text("Add"),
            ),
            const SizedBox(height: 36),
            _state == PostCreateState.error

            
                ? Text(
                    body,
                    style: const TextStyle(
                      color: Colors.red,
                      fontSize: 20,
                    ),
                    textAlign: TextAlign.center,
                  )
                : const Text(""),
          ],
        ),
      ),
    );
  }

  _buildTextFormField(String s, int length, TextEditingController controller,
      {String? Function(String? value)? value}) {
    return Form(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: TextFormField(
        controller: controller,
        maxLength: length,
        decoration: InputDecoration(
            labelText: s,
            fillColor: Colors.grey,
            labelStyle: const TextStyle(color: Colors.white),
            filled: true,
            // hintMaxLines: 10,
            border: const OutlineInputBorder(borderSide: BorderSide.none)),
        cursorColor: Colors.red,
        style: const TextStyle(color: Colors.black),
      ),
    );
  }

  void _buildFlutterToast(String t, Color color) {
    Fluttertoast.showToast(
      msg: t,
      // msg: "post failed",
      fontSize: 20,
      backgroundColor: color,
      toastLength: Toast.LENGTH_SHORT,
      timeInSecForIosWeb: 5,
      gravity: ToastGravity.SNACKBAR,
    );
  }

  void _clearNameContent() {
    _fullnameController.text = "";
    _listnameController.text = "";
    _contentnController.text = "";
    _dateController.text = "";
  }
}

enum PostCreateState {
  initial,
  loading,
  loadid,
  error,
}
