import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';

import '../rest_demo_screen.dart';
import 'ui/custom_text_form_field.dart';

class AddPostDialog extends StatefulWidget {
  static show(BuildContext context, {required PostController controller}) =>
      showDialog(
          context: context, builder: (dContext) => AddPostDialog(controller));
  const AddPostDialog(this.controller, {super.key});

  final PostController controller;

  @override
  State<AddPostDialog> createState() => _AddPostDialogState();
}

class _AddPostDialogState extends State<AddPostDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController bodyC, titleC;
  late FocusNode titleFn, bodyFn;

  @override
  void initState() {
    super.initState();
    bodyC = TextEditingController();
    titleC = TextEditingController();
    titleFn = FocusNode();
    bodyFn = FocusNode();
  }

  @override
  void dispose() {
    super.dispose();
    bodyC.dispose();
    titleC.dispose();
    titleFn.dispose();
    bodyFn.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return AlertDialog(
      title: const Text("Add new post"),
      actions: [
        ElevatedButton(
          onPressed: () async {
            if (_formKey.currentState!.validate()) {
              widget.controller.makePost(
                  title: titleC.text.trim(),
                  body: bodyC.text.trim(),
                  userId: 1);
              Navigator.of(context).pop(true);
            }
          },
          child: const Text("Add"),
        )
      ],
      content: SizedBox(
        width: width,
        height: height * 0.2,
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flexible(
                child: CustomTextFormField(
                  controller: titleC,
                  labelText: "Title",
                  focusNode: titleFn,
                  obscureText: false,
                  keyboardType: TextInputType.text,
                  errorMaxLines: 3,
                  onEditingComplete: () {
                    bodyFn.requestFocus();
                  },
                  validator: MultiValidator([
                    RequiredValidator(errorText: "Title is required"),
                    MinLengthValidator(2,
                        errorText: "Title must be at least 2 characters long"),
                    PatternValidator(r'^[a-zA-Z0-9 ]+$',
                        errorText:
                            "Title cannot contain any special characters"),
                  ]).call,
                ),
              ),
              Flexible(
                child: CustomTextFormField(
                  controller: bodyC,
                  labelText: "Content",
                  focusNode: bodyFn,
                  obscureText: false,
                  keyboardType: TextInputType.text,
                  errorMaxLines: 3,
                  onEditingComplete: () {
                    bodyFn.unfocus();
                  },
                  validator: MultiValidator([
                    RequiredValidator(errorText: "Content is required"),
                    MinLengthValidator(10,
                        errorText:
                            "Content must be at least 10 characters long"),
                  ]).call,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
