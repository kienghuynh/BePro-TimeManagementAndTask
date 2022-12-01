import 'package:bepro/models/category_model.dart';
import 'package:bepro/models/task_model.dart';
import 'package:bepro/models/user_model.dart';
import 'package:bepro/pages/detailTask_page.dart';
import 'package:bepro/pages/task_page.dart.dart';
import 'package:bepro/services/navigation_service.dart';
import 'package:bepro/Utility/utilities.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:like_button/like_button.dart';

class EditTaskPage extends StatefulWidget {
  const EditTaskPage({super.key, required this.detailModel});
  final TaskModel detailModel;
  @override
  State<EditTaskPage> createState() => _EditTaskPageState();
}

class _EditTaskPageState extends State<EditTaskPage> {
  final User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();
  final _formKey = GlobalKey<FormState>();

  final _auth = FirebaseAuth.instance;
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  TextEditingController titleController = TextEditingController();
  TextEditingController detailController = TextEditingController();
  TextEditingController noteController = TextEditingController();
  DateTime? startDate;
  DateTime? deadline;
  bool? isImportant;
  bool? isDone;
  String? selectedValue;

  List<String> items = [];

  @override
  void initState() {
    getCategories();
    // TODO: implement initState
    titleController.text = widget.detailModel.title!;
    noteController.text = widget.detailModel.note!;
    detailController.text = widget.detailModel.detail!;
    startDate = widget.detailModel.startDate;
    deadline = widget.detailModel.deadline;
    isImportant = widget.detailModel.isImportant;
    isDone = widget.detailModel.isDone;
    selectedValue = widget.detailModel.category;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Scaffold(
      //backgroundColor: Colors.transparent,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        leading: const BackButton(
          color: Color.fromARGB(255, 99, 216, 204),
        ),
        backgroundColor: Colors.white,
        title: const Text(
          'Chi tiết',
          style: TextStyle(color: Color.fromARGB(255, 99, 216, 204)),
        ),
        actions: [
          TextButton.icon(
              onPressed: () {
                done();
                updateTaskToFireStore();
              },
              label: Text(
                'Xong',
                style: TextStyle(
                    fontSize: 20, color: Color.fromARGB(255, 99, 216, 204)),
              ),
              icon: Icon(
                Icons.done,
                color: Color.fromARGB(255, 99, 216, 204),
                size: 30,
              ))
        ],
      ),
      body: _pageWidget(),
    ));
  }

  Widget _pageWidget() {
    return SingleChildScrollView(
      child: Container(
        margin: EdgeInsets.all(25),
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
            color: Color.fromARGB(255, 255, 255, 255),
            borderRadius: BorderRadius.circular(18),
            //border: Border.all(color: Color.fromARGB(149, 194, 194, 194)),
            boxShadow: [
              BoxShadow(
                  color: Colors.grey,
                  blurRadius: 5,
                  spreadRadius: 1,
                  offset: Offset(4, 4))
            ]),
        child: Column(
          children: [
            Container(
              height: 70,
              width: 350,
              child: Utility().TextFieldEdit(
                  24,
                  FontWeight.bold,
                  titleController,
                  Icon(
                    Icons.text_fields_outlined,
                  ),
                  Color.fromARGB(255, 70, 70, 70)),
            ),
            SizedBox(
              height: 10,
            ),
            Utility().BottomLine(),
            SizedBox(
              height: 10,
            ),
            Container(
              height: 100,
              width: 350,
              child: Utility().TextFieldEdit(
                  20,
                  FontWeight.normal,
                  detailController,
                  Icon(Icons.description_outlined),
                  Color.fromARGB(255, 70, 70, 70)),
            ),
            SizedBox(
              height: 10,
            ),
            Utility().BottomLine(),
            SizedBox(
              height: 10,
            ),
            Container(
              height: 70,
              width: 350,
              child: Utility().TextFieldEdit(
                  20,
                  FontWeight.normal,
                  noteController,
                  Icon(Icons.edit_note),
                  Color.fromARGB(255, 70, 70, 70)),
            ),
            SizedBox(
              height: 10,
            ),
            Utility().BottomLine(),
            SizedBox(
              height: 10,
            ),
            Container(
              height: 70,
              width: 350,
              child: dropDownCategories(),
            ),
            SizedBox(
              height: 10,
            ),
            Utility().BottomLine(),
            SizedBox(
              height: 10,
            ),
            Container(
              height: 50,
              width: 350,
              alignment: Alignment.centerLeft,
              child: Row(children: [
                TimePickerStartDate(),
                Utility().DisplayDateTime(startDate!)
              ]),
            ),
            Container(
              height: 50,
              width: 350,
              alignment: Alignment.centerLeft,
              child: Row(children: [
                TimePickerDeadline(),
                Utility().DisplayDateTime(deadline!)
              ]),
            ),
            SizedBox(
              height: 10,
            ),
            Utility().BottomLine(),
            SizedBox(
              height: 10,
            ),
            Container(
              height: 50,
              width: 350,
              alignment: Alignment.center,
              child: Row(children: [
                Text(
                  '    Công việc quan trọng:      ',
                  style: TextStyle(
                      color: Color.fromARGB(255, 0, 0, 0), fontSize: 13),
                ),
                ImportantButton()
              ]),
            ),
            SizedBox(
              height: 10,
            ),
            Utility().BottomLine(),
            SizedBox(
              height: 10,
            ),
            Container(
              height: 50,
              width: 350,
              alignment: Alignment.center,
              child: Row(children: [
                Text(
                  '    Công việc hoàn thành:      ',
                  style: TextStyle(
                      color: Color.fromARGB(255, 0, 0, 0), fontSize: 13),
                ),
                DoneTaskButton()
              ]),
            ),
          ],
        ),
      ),
    );
  }

  Widget TimePickerStartDate() {
    return TextButton.icon(
      onPressed: () {
        setState(() {
          DatePicker.showDateTimePicker(context,
              showTitleActions: true,
              minTime: DateTime(2000, 1, 1),
              maxTime: DateTime(2099, 12, 31),
              onChanged: (date) {}, onConfirm: (date) {
            startDate = date;
            setState(() {});
          },
              currentTime: (startDate == null) ? DateTime.now() : startDate,
              locale: LocaleType.vi);
        });
      },
      label: Text(
        'Bắt đầu',
        style: TextStyle(color: Colors.blue, fontSize: 13
        ),
      ),
      icon: Icon(Icons.access_time),
    );
  }

  Widget TimePickerDeadline() {
    return TextButton.icon(
      onPressed: () {
        setState(() {
          DatePicker.showDateTimePicker(context,
              showTitleActions: true,
              minTime: startDate,
              maxTime: DateTime(2099, 12, 31),
              onChanged: (date) {}, onConfirm: (date) {
            deadline = date;
            setState(() {});
          },
              currentTime: (deadline == null) ? startDate : deadline,
              locale: LocaleType.vi);
        });
      },
      label: Text(
        'Kết thúc',
        style: TextStyle(color: Colors.blue, fontSize: 13
        ),
      ),
      icon: Icon(Icons.access_time),
    );
  }

  Widget ImportantButton() {
    return Container(
      child: LikeButton(
          size: 40,
          isLiked: isImportant,
          likeBuilder: (isLiked) {
            return Icon(
              Icons.star,
              color: (isLiked) ? Colors.amber : Colors.grey,
              size: 40,
            );
          },
          onTap: onImportantTapped),
    );
  }

  Future<bool> onImportantTapped(bool isLiked) async {
    setState(() {
      isImportant = !isLiked;
    });
    return !isLiked;
  }

  Widget DoneTaskButton() {
    return Container(
      child: LikeButton(
          size: 40,
          isLiked: isDone,
          likeBuilder: (isLiked) {
            return Icon(
              Icons.done_all,
              color:
                  (isLiked) ? Color.fromARGB(255, 95, 221, 100) : Colors.grey,
              size: 40,
            );
          },
          onTap: onDoneTapped),
    );
  }

  Future<bool> onDoneTapped(bool isLiked) async {
    setState(() {
      isDone = !isLiked;
    });
    return !isLiked;
  }

  void done() {
    print('title : ${titleController.text}');
    print('detail : ${detailController.text}');
    print('note : ${noteController.text}');
    print('start: ${startDate}}');
    print('deadline: ${deadline}}');
    print('is important: ${isImportant}');
    print('cate ${selectedValue}');
  }

  updateTaskToFireStore() async {
    TaskModel task = TaskModel();

    task.uid = widget.detailModel.uid;
    task.title = titleController.text;
    task.detail = detailController.text;
    task.colorCode = widget.detailModel.colorCode;
    task.createAt = widget.detailModel.createAt;
    task.deadline = deadline;
    (isDone!)
        ? (task.doneDate = DateTime.now())
        : task.doneDate = DateTime(0001, 01, 01, 01, 01, 01);
    task.isDone = isDone;
    task.isImportant = isImportant;
    task.note = noteController.text;
    task.startDate = startDate;
    task.category = selectedValue as String;

    if (startDate != null && deadline != null && startDate!.compareTo(deadline!) <0) {
      await firebaseFirestore
          .collection("users")
          .doc(user!.uid)
          .collection("tasks")
          .doc(task.uid)
          .set(task.toMap());
      Fluttertoast.showToast(msg: "Đã cập nhập công việc");
    } else
      (Fluttertoast.showToast(msg: 'Cần có thời gian bắt đầu trước kết thúc'));
  }

  List<DropdownMenuItem<String>> _addDividersAfterItems(List<String> items) {
    List<DropdownMenuItem<String>> _menuItems = [];
    for (var item in items) {
      _menuItems.addAll(
        [
          DropdownMenuItem<String>(
            value: item,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                item,
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
            ),
          ),
          //If it's last item, we will not add Divider after it.
          if (item != items.last)
            const DropdownMenuItem<String>(
              enabled: false,
              child: Divider(),
            ),
        ],
      );
    }
    return _menuItems;
  }

  Widget dropDownCategories() {
    return Container(
        decoration: BoxDecoration(
            border: Border.all(
                color: Colors.blueGrey, width: 1, style: BorderStyle.solid),
            borderRadius: BorderRadius.circular(5)),
        padding: EdgeInsets.all(5),
        child: DropdownButtonHideUnderline(
            child: DropdownButton(
                hint: Text(
                  'Loại công việc',
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
                items: _addDividersAfterItems(items),
                value: selectedValue,
                onChanged: (value) {
                  setState(() {
                    selectedValue = value as String;
                  });
                })));
  }

  Future<void> getCategories() async {
    var snapshotCate = await firebaseFirestore
        .collection("users")
        .doc(user!.uid)
        .collection("categories")
        .get();

    List<CategoryModel> list = snapshotCate.docs
        .map((e) => CategoryModel().fromJson(e.data()))
        .toList();

    setState(() {
      for (var item in list) {
        items.add(item.categoryName!);
      }
    });
  }
}
