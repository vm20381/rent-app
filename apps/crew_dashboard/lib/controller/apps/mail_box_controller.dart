import 'package:captainapp_crew_dashboard/controller/my_controller.dart';
import 'package:captainapp_crew_dashboard/helpers/theme/admin_theme.dart';
import 'package:captainapp_crew_dashboard/helpers/widgets/my_button.dart';
import 'package:captainapp_crew_dashboard/helpers/widgets/my_spacing.dart';
import 'package:captainapp_crew_dashboard/helpers/widgets/my_text.dart';
import 'package:captainapp_crew_dashboard/helpers/widgets/my_text_style.dart';
import 'package:captainapp_crew_dashboard/models/mail_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MailBoxController extends MyController {
  List<MailModel> mail = [];
  List<MailModel> search = [];

  bool isChecked = false;

  late TextEditingController toTE, subjectTE, extraTextAreaTE;
  TextEditingController searchController = TextEditingController();

  void searchMail(String query) {
    search = mail.where((mail) {
      final from = mail.title.toLowerCase();
      final input = query.toLowerCase();
      return from.contains(input);
    }).toList();
    update();
  }

  void allSelectToggle() {
    isChecked = !isChecked;
    for (int i = 0; i < search.length; i++) {
      search[i].isToggle = isChecked;
      update();
    }
    update();
  }

  void singleSelectToggle() {
    for (int j = 0; j < search.length; j++) {
      if (search[j].isToggle == false) {
        isChecked = false;
      }
    }
    update();
  }

  void removeData() {
    for (var i = 0; i < search.length; i++) {
      if (!search[i].isToggle == !isChecked) {
        search.removeAt(i);
      }
      update();
    }
    update();
  }

  void addData() {
    mail.add(
      MailModel(
        (-1) as String,
        toTE.text,
        subjectTE.text,
        DateTime.now(),
        false,
      ),
    );
    toTE.clear();
    subjectTE.clear();
    update();
  }

  @override
  void onInit() {
    toTE = TextEditingController(text: 'demo@gmail.com');
    subjectTE = TextEditingController(text: 'Dummy Text');
    extraTextAreaTE = TextEditingController();

    MailModel.dummyList.then((value) {
      mail = value;
      search = value;
      update();
    });
    super.onInit();
  }

  void isAlertBox() {
    ContentTheme contentTheme = AdminTheme.theme.contentTheme;
    Get.dialog(
      AlertDialog(
        title: const MyText.titleMedium("New Message", fontWeight: 600),
        content: SizedBox(
          width: 300,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: toTE,
                decoration: InputDecoration(
                  hintStyle: MyTextStyle.bodyMedium(fontWeight: 600),
                  hintText: "TO",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              MySpacing.height(12),
              TextFormField(
                controller: subjectTE,
                decoration: InputDecoration(
                  hintStyle: MyTextStyle.bodyMedium(fontWeight: 600),
                  hintText: "Subject",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              MySpacing.height(12),
              TextFormField(
                maxLines: 3,
                minLines: 3,
                controller: extraTextAreaTE,
                decoration: InputDecoration(
                  hintStyle: MyTextStyle.bodyMedium(fontWeight: 600),
                  hintText: "Extra TextArea",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: [
          Row(
            children: [
              Expanded(
                child: MyButton.text(
                  onPressed: () => Get.back(),
                  child: const MyText.bodyMedium("Cancel", fontWeight: 600),
                ),
              ),
              Expanded(
                child: MyButton.block(
                  elevation: 0,
                  onPressed: () {
                    addData();
                    Get.back();
                  },
                  backgroundColor: contentTheme.primary,
                  borderRadiusAll: 12,
                  child: MyText.bodyMedium(
                    "Send",
                    color: contentTheme.onPrimary,
                    fontWeight: 600,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
