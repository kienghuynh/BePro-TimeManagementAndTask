import 'package:bepro/models/task_model.dart';
import 'package:bepro/models/user_model.dart';
import 'package:bepro/pages/editTask_page.dart';
import 'package:bepro/pages/task_page.dart.dart';
import 'package:bepro/services/navigation_service.dart';
import 'package:bepro/Utility/utilities.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class DetailTaskPage extends StatefulWidget {
  final TaskModel detailModel;
  const DetailTaskPage({super.key, required this.detailModel});

  @override
  State<DetailTaskPage> createState() => _DetailTaskPageState();
}

class _DetailTaskPageState extends State<DetailTaskPage> {
  final User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();
  final _formKey = GlobalKey<FormState>();

  final _auth = FirebaseAuth.instance;
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

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
          IconButton(
              onPressed: () {
                NavigationService().replaceScreen(
                    EditTaskPage(detailModel: widget.detailModel));
              },
              tooltip: 'Chỉnh sữa công việc',
              icon: Icon(
                Icons.edit,
                color: Color.fromARGB(255, 99, 216, 204),
                size: 30,
              ))
        ],
      ),
      body: _pageWidget(),
    ));
  }

  Widget _pageWidget() {
    return Container(
      child: SingleChildScrollView(
        child: Center(
            child: Container(
          width: double.maxFinite,
          margin: EdgeInsets.all(25),
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
              color: Color.fromARGB(255, 255, 255, 255),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: Color.fromARGB(149, 194, 194, 194)),
              boxShadow: [
                BoxShadow(
                    color: Colors.grey,
                    blurRadius: 5,
                    spreadRadius: 1,
                    offset: Offset(4, 4))
              ]),
          child: Column(
            children: [
              SizedBox(
                height: 25,
              ),

              // Hiển thị tiêu đề
              (widget.detailModel.title == "" ||
                      widget.detailModel.title!.replaceAll(' ', '') == '')
                  ? Utility().DisplayNotiNull(
                      Icons.text_fields_outlined,
                      '(Không có Tiêu đề !)',
                      24,
                      FontWeight.w500,
                      Color.fromARGB(255, 149, 149, 149))
                  : Utility().DisplayTextDetail(
                      Icons.text_fields_outlined,
                      widget.detailModel.title!,
                      24,
                      FontWeight.w500,
                      Color.fromARGB(255, 70, 70, 70)),
              SizedBox(
                height: 20,
              ),
              Utility().BottomLine(),
              SizedBox(
                height: 20,
              ),

              // hiển thị nội dung
              (widget.detailModel.detail == "" ||
                      widget.detailModel.detail!.replaceAll(' ', '') == '')
                  ? Utility().DisplayNotiNull(
                      Icons.description_outlined,
                      '(Không có nội dung !)',
                      20,
                      FontWeight.normal,
                      Color.fromARGB(255, 149, 149, 149))
                  : Utility().DisplayTextDetail(
                      Icons.description_outlined,
                      widget.detailModel.detail!,
                      20,
                      FontWeight.normal,
                      Color.fromARGB(255, 37, 37, 37)),
              SizedBox(
                height: 20,
              ),
              Utility().BottomLine(),
              SizedBox(
                height: 20,
              ),

              // hiển thị ghi chú
              (widget.detailModel.note == "" ||
                      widget.detailModel.note!.replaceAll(' ', '') == '')
                  ? Utility().DisplayNotiNull(
                      Icons.edit_note,
                      '(Không có ghi chú !)',
                      18,
                      FontWeight.normal,
                      Color.fromARGB(255, 150, 150, 150))
                  : Utility().DisplayTextDetail(
                      Icons.edit_note,
                      widget.detailModel.note!,
                      18,
                      FontWeight.normal,
                      Color.fromARGB(255, 37, 37, 37)),
              SizedBox(
                height: 20,
              ),

              
              
              Utility().BottomLine(),
              SizedBox(
                height: 20,
              ),
              Utility().DisplayTextDetail(
                      Icons.note_alt,
                      widget.detailModel.category!,
                      18,
                      FontWeight.normal,
                      Color.fromARGB(255, 37, 37, 37)),
              SizedBox(
                height: 20,
              ),


              Utility().BottomLine(),
              SizedBox(
                height: 20,
              ),

              // ngày bắt đầu
              Utility().DisplayTextDetail(
                  Icons.access_time,
                  ('Bắt đầu: ${Utility().formatDateDisplay(widget.detailModel.startDate)}'),
                  16,
                  FontWeight.normal,
                  Color.fromARGB(255, 182, 24, 24)),
              SizedBox(
                height: 15,
              ),

              // ngày kết thúc
              Utility().DisplayTextDetail(
                  Icons.access_time,
                  ('Kết thúc: ${Utility().formatDateDisplay(widget.detailModel.deadline)}'),
                  16,
                  FontWeight.normal,
                  Color.fromARGB(255, 182, 24, 24)),
              SizedBox(
                height: 20,
              ),
              Utility().BottomLine(),
              SizedBox(
                height: 20,
              ),

              // ngày hoàn thành
              Utility().DisplayTextDetail(
                  (widget.detailModel.isDone!)
                      ? Icons.done_all
                      : Icons.clear_outlined,
                  (widget.detailModel.isDone!)
                      ? ('Đã hoành thành lúc ${Utility().formatDateDisplay(widget.detailModel.doneDate)}')
                      : ('Chưa hoàn thành'),
                  13,
                  FontWeight.normal,
                  (widget.detailModel.isDone!)
                      ? Color.fromARGB(255, 32, 176, 56)
                      : Color.fromARGB(255, 42, 42, 42)),

              SizedBox(
                height: 20,
              ),
              Utility().BottomLine(),
              SizedBox(
                height: 20,
              ),

              // hiển thị sao quang trọng
              Utility().DisplayImportant(
                  Icons.star,
                  (widget.detailModel.isImportant!)
                      ? ('Quan trọng ')
                      : ('Không quan trọng'),
                  16,
                  FontWeight.normal,
                  (widget.detailModel.isImportant!)
                      ? Colors.amber
                      : Color.fromARGB(255, 70, 70, 70)),

              SizedBox(
                height: 20,
              ),
            ],
          ),
        )),
      ),
    );
  }
}
