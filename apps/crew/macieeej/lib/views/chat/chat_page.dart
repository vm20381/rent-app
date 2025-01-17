import 'package:macieeej/controllers/chat/chat_controller.dart';
import 'package:macieeej/helpers/theme/app_style.dart';
import 'package:macieeej/helpers/theme/app_theme.dart';
import 'package:macieeej/helpers/utils/my_shadow.dart';
import 'package:macieeej/helpers/utils/ui_mixins.dart';
import 'package:macieeej/helpers/utils/utils.dart';
import 'package:macieeej/helpers/widgets/my_breadcrumb.dart';
import 'package:macieeej/helpers/widgets/my_breadcrumb_item.dart';
import 'package:macieeej/helpers/widgets/my_button.dart';
import 'package:macieeej/helpers/widgets/my_card.dart';
import 'package:macieeej/helpers/widgets/my_container.dart';
import 'package:macieeej/helpers/widgets/my_dotted_line.dart';
import 'package:macieeej/helpers/widgets/my_flex.dart';
import 'package:macieeej/helpers/widgets/my_flex_item.dart';
import 'package:macieeej/helpers/widgets/my_spacing.dart';
import 'package:macieeej/helpers/widgets/my_text.dart';
import 'package:macieeej/helpers/widgets/my_text_style.dart';
import 'package:macieeej/helpers/widgets/responsive.dart';
import 'package:macieeej/images.dart';
import 'package:macieeej/views/layouts/layout.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons/lucide_icons.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage>
    with SingleTickerProviderStateMixin, UIMixin {
  late ChatController controller;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    controller = Get.put(ChatController());
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.jumpTo(_scrollController.position.extentTotal);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Layout(
      child: Obx(() {
        return Column(
          children: [
            Padding(
              padding: MySpacing.x(flexSpacing),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  MyText.titleMedium(
                    "Chat",
                    fontSize: 18,
                    fontWeight: 600,
                  ),
                  MyBreadcrumb(
                    children: [
                      MyBreadcrumbItem(name: 'Apps'),
                      MyBreadcrumbItem(name: 'Chat', active: true),
                    ],
                  ),
                ],
              ),
            ),
            MySpacing.height(flexSpacing),
            Padding(
              padding: MySpacing.x(flexSpacing / 2),
              child: Column(
                children: [
                  MyFlex(
                    children: [
                      MyFlexItem(
                        sizes: "xxl-3 xl-3 ",
                        child: MyCard(
                          shadow: MyShadow(elevation: 0.5),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              
                              MySpacing.height(16),
                              TextField(
                                controller: controller.newContactController,
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(
                                  filled: true,
                                  prefixIcon: const Icon(
                                    LucideIcons.search,
                                    size: 20,
                                  ),
                                  hintText: "Enter username to add",
                                  border: const OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                  ),
                                  contentPadding: MySpacing.all(16),
                                ),
                                onSubmitted: (value) {
                                  controller.addNewContact();
                                },
                              ),
                              
                              MySpacing.height(20),
                              MyText.titleMedium(
                                "CONTACTS",
                                color: contentTheme.title,
                                muted: true,
                                fontWeight: 600,
                              ),
                              MySpacing.height(20),
                              SizedBox(
                                height: 510,
                                child: ListView.separated(
                                  primary: true,
                                  shrinkWrap: true,
                                  itemCount: controller.chatUsers.length,
                                  itemBuilder: (context, index) {
                                    return MyButton(
                                      onPressed: () {
                                        controller.selectedContact.value = controller.chatUsers[index].senderName;
                                      },
                                      elevation: 0,
                                      borderRadiusAll: 8,
                                      backgroundColor: theme
                                          .colorScheme.surface
                                          .withAlpha(5),
                                      splashColor: theme
                                          .colorScheme.onSurface
                                          .withAlpha(10),
                                      child: SizedBox(
                                        height: 60,
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            MyContainer.rounded(
                                              height: 40,
                                              width: 40,
                                              paddingAll: 0,
                                              child: Image.asset(
                                                Images.avatars[index %
                                                    Images.avatars.length],
                                                height: 40,
                                                width: 40,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                            MySpacing.width(12),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  MyText.labelLarge(
                                                    controller.chatUsers[index]
                                                        .senderName,
                                                  ),
                                                  SizedBox(
                                                    width: 200,
                                                    child: MyText.bodySmall(
                                                      controller.chatUsers[index]
                                                          .lastSendMessage,
                                                      muted: true,
                                                      overflow: TextOverflow
                                                          .ellipsis,
                                                      fontWeight: 400,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Row(
                                              children: [
                                                MyText.bodySmall(
                                                  '${Utils.getTimeStringFromDateTime(
                                                    controller
                                                        .chatUsers[index].lastSendAt,
                                                    showSecond: false,
                                                  )}',
                                                  muted: true,
                                                  fontWeight: 600,
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                  separatorBuilder: (context, index) {
                                    return MySpacing.height(12);
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      MyFlexItem(
                        sizes: "xxl-6 xl-6 ",
                        child: MyCard(
                          shadow: MyShadow(elevation: 0.5),
                          child: Column(
                            children: [
                              Obx(() => messages()),
                              MySpacing.height(8),
                              Align(
                                alignment: Alignment.bottomCenter,
                                child: MyContainer(
                                  color: contentTheme.primary.withAlpha(20),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: TextFormField(
                                          controller:
                                              controller.messageController,
                                          autocorrect: false,
                                          style: MyTextStyle.bodySmall(),
                                          decoration: InputDecoration(
                                            hintText: "Type message here",
                                            hintStyle: MyTextStyle.bodySmall(
                                              xMuted: true,
                                            ),
                                            border: outlineInputBorder,
                                            enabledBorder: outlineInputBorder,
                                            focusedBorder: focusedInputBorder,
                                            contentPadding:
                                                MySpacing.xy(16, 16),
                                            isCollapsed: true,
                                          ),
                                        ),
                                      ),
                                      MySpacing.width(16),
                                      InkWell(
                                        onTap: () {
                                          controller.sendMessage();
                                          _scrollToBottom();
                                        },
                                        child: const Icon(
                                          LucideIcons.send,
                                          size: 20,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      MyFlexItem(
                        sizes: "xxl-3 xl-3",
                        child: MyFlex(
                          contentPadding: false,
                          children: [
                            
                            MyFlexItem(
                              child: MyCard(
                                shadow: MyShadow(elevation: 0.5),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    MyText.titleMedium("Attached File"),
                                    MySpacing.height(12),
                                    buildAttachedFile(
                                      "image(1).png",
                                      10485760,
                                    ),
                                    MySpacing.height(12),
                                    buildAttachedFile("apk.Zip", 2306867),
                                    MySpacing.height(12),
                                    buildAttachedFile("text.ppt", 1572864),
                                    MySpacing.height(12),
                                    buildAttachedFile("Images.jpg", 1048576),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget buildAttachedFile(String fileName, dynamic mb) {
    return MyDottedLine(
      height: 50,
      dottedLength: 1,
      color: Colors.grey.shade400,
      child: Padding(
        padding: MySpacing.all(8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const MyContainer(
              paddingAll: 4,
              height: 32,
              width: 32,
              // color: contentTheme.warning,
              child: Icon(
                LucideIcons.folderArchive,
                size: 20,
              ),
            ),
            MySpacing.width(12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MyText.bodyMedium(
                    fileName,
                    fontWeight: 600,
                    muted: true,
                    overflow: TextOverflow.ellipsis,
                  ),
                  MyText.bodyMedium(
                    Utils.getStorageStringFromByte(mb),
                  ),
                ],
              ),
            ),
            IconButton(
              padding: MySpacing.zero,
              onPressed: () {},
              icon: const Icon(
                LucideIcons.download,
                size: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildProfileDetail(IconData icons, String title, String subTitle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              icons,
              size: 16,
            ),
            MySpacing.width(8),
            MyText.bodyMedium(
              title,
              fontWeight: 600,
            ),
          ],
        ),
        MyText.bodyMedium(
          subTitle,
          fontWeight: 600,
        ),
      ],
    );
  }

  Widget messages() {
    return SizedBox(
      height: 600,
      child: ListView.separated(
        controller: _scrollController,
        padding: MySpacing.x(12),
        shrinkWrap: true,
        itemCount: controller.filteredChatMessages.length,
        itemBuilder: (BuildContext context, int index) {
          // Split the firstName string and take the first part
          String firstName = controller.filteredChatMessages[index].senderName.split(' ')[0];

          if (controller.filteredChatMessages[index].fromMe == false) {
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    MyContainer.rounded(
                      height: 32,
                      width: 32,
                      paddingAll: 0,
                      child: Image.asset(
                        Images.avatars[1],
                        fit: BoxFit.cover,
                      ),
                    ),
                    MySpacing.height(4),
                    MyText.bodySmall(
                      firstName, // Display only the first name
                      muted: true,
                      fontWeight: 600,
                      fontSize: 10,
                    ),
                  ],
                ),
                MySpacing.width(12),
                Flexible( // Use Flexible here to ensure the Column doesn't take more space than available
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start, // Align to the left
                    children: [
                      MyContainer.none(
                        paddingAll: 8,
                        margin: MySpacing.only(
                          top: 10,
                          right: MediaQuery.of(context).size.width * 0.20,
                        ),
                        alignment: Alignment.bottomLeft,
                        borderRadiusAll: 4,
                        color: contentTheme.secondary.withAlpha(30),
                        child: MyText.titleMedium(
                          controller.filteredChatMessages[index].message, // Use the message property
                          fontSize: 12,
                          color: contentTheme.secondary,
                        ),
                      ),
                      MySpacing.height(4),
                      MyText.bodySmall(
                        '${Utils.getTimeStringFromDateTime(
                          controller.filteredChatMessages[index].sendAt,
                          showSecond: false,
                        )}',
                        muted: true,
                        fontWeight: 600,
                        fontSize: 8,
                      ),
                    ],
                  ),
                ),
              ],
            );
          } else {
            return Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      MyContainer(
                        paddingAll: 8,
                        margin: MySpacing.only(
                          top: 10,
                          left: MediaQuery.of(context).size.width * 0.20,
                        ),
                        color: theme.colorScheme.primary.withAlpha(30),
                        child: MyText.bodyMedium(
                          controller.filteredChatMessages[index].message, // Use the message property
                          fontSize: 12,
                          fontWeight: 600,
                          color: contentTheme.primary,
                        ),
                      ),
                      MySpacing.height(4),
                      MyText.bodySmall(
                        '${Utils.getTimeStringFromDateTime(
                          controller.filteredChatMessages[index].sendAt,
                          showSecond: false,
                        )}',
                        fontSize: 8,
                        muted: true,
                        fontWeight: 600,
                      ),
                    ],
                  ),
                ),
                MySpacing.width(12),
                Column(
                  children: [
                    MyContainer.rounded(
                      height: 32,
                      width: 32,
                      paddingAll: 0,
                      child: Image.asset(
                        Images.avatars[8],
                        fit: BoxFit.cover,
                      ),
                    ),
                    MySpacing.height(4),
                    MyText.bodySmall(
                      firstName, // Display only the first name
                      fontSize: 10,
                      muted: true,
                      fontWeight: 600,
                    ),
                  ],
                ),
              ],
            );
          }
        },
        separatorBuilder: (BuildContext context, int index) {
          return const SizedBox(
            height: 12,
          );
        },
      ),
    );
  }
}
