import 'package:captainapp_crew_dashboard/controller/apps/file_manager/file_uploader_controller.dart';
import 'package:captainapp_crew_dashboard/helpers/utils/my_shadow.dart';
import 'package:captainapp_crew_dashboard/helpers/widgets/my_card.dart';
import 'package:captainapp_crew_dashboard/helpers/widgets/my_dotted_line.dart';
import 'package:captainapp_crew_dashboard/helpers/widgets/my_spacing.dart';
import 'package:captainapp_crew_dashboard/helpers/widgets/my_text.dart';
import 'package:captainapp_crew_dashboard/images.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FileUploadWidget extends StatelessWidget {
  final FileUploaderController controller = Get.find<FileUploaderController>();
  final String entityId;
  FileUploadWidget({super.key, required this.entityId});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: MySpacing.x(24), // Adjust padding as needed
      child: MyCard(
        shadow: MyShadow(elevation: 0.5),
        child: InkWell(
          onTap: () => controller.pickFile(entityId),
          child: MyDottedLine(
            strokeWidth: 0.2,
            color: Theme.of(context).colorScheme.onSurface,
            corner: const MyDottedLineCorner(
              leftBottomCorner: 2,
              leftTopCorner: 2,
              rightBottomCorner: 2,
              rightTopCorner: 2,
            ),
            child: Center(
              child: Padding(
                padding: MySpacing.all(12),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      Images.fileManager[
                          1], // Ensure this points to a valid asset
                      height: 200,
                    ),
                    const MyText.titleMedium(
                      "Drop files here or click to upload.",
                      fontWeight: 600,
                      muted: true,
                      fontSize: 18,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
