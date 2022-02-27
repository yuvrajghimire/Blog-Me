import 'dart:typed_data';

import 'package:blog_me/models/user.dart';
import 'package:blog_me/providers/user_provider.dart';
import 'package:blog_me/resources/firestore_methods.dart';
import 'package:blog_me/utils/colors.dart';
import 'package:blog_me/utils/utils.dart';
import 'package:blog_me/utils/variables_constants.dart';
import 'package:blog_me/widgets/text_field_input.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class CreatePost extends StatefulWidget {
  const CreatePost({Key? key}) : super(key: key);

  @override
  State<CreatePost> createState() => _CreatePostState();
}

class _CreatePostState extends State<CreatePost> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _tagsController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  int _page = 0;
  Uint8List? _file;
  String selectedCategory = 'Any';
  List<String> tags = [];

  _selectImage(BuildContext parentContext) async {
    return showDialog(
      context: parentContext,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: const Text('Create a Post'),
          children: <Widget>[
            SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text('Take a photo'),
                onPressed: () async {
                  Navigator.pop(context);
                  Uint8List file = await pickImage(ImageSource.camera);
                  setState(() {
                    _file = file;
                  });
                }),
            SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text('Choose from Gallery'),
                onPressed: () async {
                  Navigator.of(context).pop();
                  Uint8List file = await pickImage(ImageSource.gallery);
                  setState(() {
                    _file = file;
                  });
                }),
            SimpleDialogOption(
              padding: const EdgeInsets.all(20),
              child: const Text("Cancel"),
              onPressed: () {
                Navigator.pop(context);
              },
            )
          ],
        );
      },
    );
  }

  void clearImage() {
    setState(() {
      _file = null;
    });
  }

  void postImage(
    List<String> tags,
    String uid,
    String username,
    String fullname,
    String profileImage,
  ) async {
    try {
      String res = await FirestoreMethods().uploadPost(
          uid,
          _titleController.text,
          _descriptionController.text,
          selectedCategory,
          tags,
          _file!,
          username,
          fullname,
          profileImage);
      if (res == "success") {
        showSnackBar(context, 'Posted successfully!');
      } else {
        showSnackBar(context, res);
      }
    } catch (err) {
      showSnackBar(context, 'Some error occured!');
    }
  }

  @override
  void dispose() {
    super.dispose();
    _titleController.dispose();
    _tagsController.dispose();
    _descriptionController.dispose();
  }

  checkTags(str) {
    setState(() {
      tags = str.split(' ');
      tags.removeWhere((element) => element == '');
    });
  }

  @override
  Widget build(BuildContext context) {
    final inputBorder = OutlineInputBorder(
      borderSide: Divider.createBorderSide(context),
    );
    final User user = Provider.of<UserProvider>(context).getUser;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Create Article',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    )),
                _page == 0
                    ? IconButton(
                        onPressed: () {}, icon: const Icon(Icons.close))
                    : TextButton(
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(primaryColor)),
                        onPressed: () => postImage(tags, user.uid,
                            user.userName, user.fullName, user.photoUrl),
                        child: const Text('POST',
                            style: TextStyle(
                                color: secondaryColor,
                                fontWeight: FontWeight.bold)))
              ],
            ),
            _page == 0
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 15),
                      label(
                          "Let's think of something great for your article name"),
                      const SizedBox(height: 15),
                      TextFieldInput(
                        textEditingController: _titleController,
                        hintText: 'Enter article name',
                        icon:
                            const Icon(Icons.description, color: primaryColor),
                        isPass: false,
                        textInputType: TextInputType.text,
                      ),
                      const SizedBox(height: 30),
                      label("Wisely choose the main image for your article"),
                      const SizedBox(height: 15),
                      Row(
                        children: [
                          _file != null
                              ? Container(
                                  width: 100,
                                  height: 100,
                                  decoration: BoxDecoration(
                                      image: DecorationImage(
                                          image: MemoryImage(_file!))))
                              : Container(
                                  width: 100,
                                  height: 100,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: const Color.fromARGB(
                                        255, 216, 212, 212),
                                  ),
                                  child: const Center(child: Icon(Icons.add))),
                          IconButton(
                            icon: const Icon(
                              Icons.upload,
                            ),
                            onPressed: () => _selectImage(context),
                          ),
                        ],
                      ),
                      const SizedBox(height: 30),
                      label("What is the category for your story?"),
                      const SizedBox(height: 15),
                      DropdownButtonHideUnderline(
                        child: ButtonTheme(
                          alignedDropdown: true,
                          child: DropdownButton(
                            menuMaxHeight: 400,
                            iconEnabledColor: Colors.white,
                            dropdownColor:
                                Theme.of(context).scaffoldBackgroundColor,
                            borderRadius: BorderRadius.circular(20),
                            isDense: true,
                            icon: const SizedBox(),
                            hint: Row(
                              children: [
                                const Icon(
                                  Icons.arrow_drop_down_circle_outlined,
                                  color: primaryColor,
                                ),
                                const SizedBox(width: 20),
                                Text(selectedCategory,
                                    style: const TextStyle(
                                        fontFamily: 'Nunito',
                                        color: primaryColor))
                              ],
                            ),
                            style: TextStyle(
                                fontFamily: 'Nunito',
                                color: Theme.of(context).primaryColor),
                            items: categories.map((dynamic items) {
                              return DropdownMenuItem(
                                value: items,
                                child: SizedBox(
                                  width: 130,
                                  child: Text(items,
                                      style: const TextStyle(
                                          color: primaryColor, fontSize: 16)),
                                ),
                              );
                            }).toList(),
                            onChanged: (dynamic value) {
                              setState(() {
                                selectedCategory = value.toString();
                              });
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      label("Let's give your article some tags"),
                      const SizedBox(height: 15),
                      TextField(
                        onChanged: (str) {
                          checkTags(str);
                        },
                        controller: _tagsController,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.tag_outlined,
                              color: primaryColor),
                          hintText: 'Enter tags separated by space',
                          hintStyle: const TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Colors.black38,
                              fontSize: 14),
                          border: inputBorder,
                          focusedBorder: inputBorder,
                          enabledBorder: inputBorder,
                          filled: true,
                          contentPadding:
                              const EdgeInsets.fromLTRB(15, 5, 15, 5),
                        ),
                        keyboardType: TextInputType.text,
                        obscureText: false,
                      ),
                      const SizedBox(height: 10),
                      tags.isEmpty
                          ? const SizedBox()
                          : SingleChildScrollView(
                              physics: const BouncingScrollPhysics(),
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: tags
                                    .map(
                                      (data) => Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 6),
                                        margin:
                                            const EdgeInsets.only(right: 10),
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: Colors.grey,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(15),
                                        ),
                                        child: Text(
                                          '#${data.toLowerCase()}',
                                          style: const TextStyle(
                                            color: primaryColor,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    )
                                    .toList(),
                              ),
                            ),
                    ],
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 15),
                      label("Write the content for your blog"),
                      const SizedBox(height: 15),
                      TextFormField(
                        cursorColor: Theme.of(context).primaryColor,
                        minLines: 25,
                        maxLines: 100,
                        style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            color: primaryColor,
                            fontSize: 14),
                        controller: _descriptionController,
                        decoration: InputDecoration(
                          hintStyle: const TextStyle(fontSize: 16),
                          hintText: 'Description',
                          border: inputBorder,
                          focusedBorder: inputBorder,
                          enabledBorder: inputBorder,
                          filled: true,
                        ),
                      ),
                    ],
                  ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Text('${_page + 1}',
                            style:
                                const TextStyle(fontWeight: FontWeight.w900)),
                        Text(' OF 2',
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Colors.grey.shade600)),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: InkWell(
                      focusColor: Colors.transparent,
                      onTap: () {
                        // print(_page);
                        if (_page == 0) {
                          setState(() {
                            _page = 1;
                          });
                        } else {
                          setState(() {
                            _page = 0;
                          });
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 50, vertical: 15),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: primaryColor),
                        child: Center(
                            child: Text(_page == 0 ? "Next Step" : "Go Back",
                                style: const TextStyle(color: secondaryColor))),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Text label(label) => Text(label,
      style:
          TextStyle(color: Colors.grey.shade500, fontWeight: FontWeight.w700));
}
