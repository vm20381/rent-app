import 'package:chris_c3a/controllers/fitness/fitness_controller.dart';
import 'package:chris_c3a/helpers/theme/app_theme.dart';
import 'package:chris_c3a/helpers/utils/ui_mixins.dart';
import 'package:chris_c3a/helpers/widgets/my_breadcrumb.dart';
import 'package:chris_c3a/helpers/widgets/my_breadcrumb_item.dart';
import 'package:chris_c3a/helpers/widgets/my_container.dart';
import 'package:chris_c3a/helpers/widgets/my_flex.dart';
import 'package:chris_c3a/helpers/widgets/my_flex_item.dart';
import 'package:chris_c3a/helpers/widgets/my_spacing.dart';
import 'package:chris_c3a/helpers/widgets/my_text.dart';
import 'package:chris_c3a/helpers/widgets/my_text_style.dart';
import 'package:chris_c3a/helpers/widgets/responsive.dart';
import 'package:chris_c3a/images.dart';
import 'package:chris_c3a/views/layouts/layout.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class FitnessPage extends StatefulWidget {
  const FitnessPage({super.key});

  @override
  State<FitnessPage> createState() => _FitnessPageState();
}

class _FitnessPageState extends State<FitnessPage>
    with SingleTickerProviderStateMixin, UIMixin {
  late FitnessController controller;

  @override
  void initState() {
    controller = Get.put(FitnessController());
    super.initState();
  }

  @override
  void didChangeDependencies() {
    controller.isWeb = MediaQuery.of(context).size.width > 767;

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    // Retrieve the controller
    final FitnessController controller = Get.find<FitnessController>();

    return Layout(
      child: GetBuilder(
        init: controller,
        builder: (controller) {
          final bool enableMultiView = controller.isClosed &&
              (controller.selectionMode == DateRangePickerSelectionMode.range ||
                  controller.selectionMode ==
                      DateRangePickerSelectionMode.multiRange ||
                  controller.selectionMode ==
                      DateRangePickerSelectionMode.extendableRange);

          return Column(
            children: [
              Padding(
                padding: MySpacing.x(flexSpacing),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    MyText.titleMedium(
                      "Fitness",
                      fontSize: 18,
                      fontWeight: 600,
                    ),
                    MyBreadcrumb(
                      children: [
                        MyBreadcrumbItem(name: "Apps"),
                        MyBreadcrumbItem(name: "Fitness", active: true),
                      ],
                    ),
                  ],
                ),
              ),
              MySpacing.height(flexSpacing),
              Padding(
                padding: MySpacing.x(flexSpacing),
                child: MyFlex(
                  contentPadding: false,
                  children: [
                    MyFlexItem(
                      sizes: 'lg-9',
                      child: MyFlex(
                        contentPadding: false,
                        children: [
                          MyFlexItem(
                            child: SizedBox(
                              height: 120,
                              child: ListView(
                                scrollDirection: Axis.horizontal,
                                shrinkWrap: true,
                                children: [
                                  buildWorkoutCategory(
                                    contentTheme.danger,
                                    Icons.favorite,
                                    '100',
                                    'Heart Rate',
                                  ),
                                  MySpacing.width(20),
                                  buildWorkoutCategory(
                                    contentTheme.info,
                                    Icons.local_fire_department_rounded,
                                    '60',
                                    'Calories Burn',
                                  ),
                                  MySpacing.width(20),
                                  buildWorkoutCategory(
                                    contentTheme.success,
                                    Icons.directions_run_rounded,
                                    '3.5 KM',
                                    'Running',
                                  ),
                                  MySpacing.width(20),
                                  buildWorkoutCategory(
                                    contentTheme.primary,
                                    Icons.timelapse_rounded,
                                    '8 Hours',
                                    'Sleeping',
                                  ),
                                ],
                              ),
                            ),
                          ),
                          MyFlexItem(
                            sizes: 'lg-8',
                            child: MyContainer(
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      MyText.bodyMedium(
                                        "Activity",
                                        fontWeight: 600,
                                      ),
                                      PopupMenuButton(
                                        onSelected:
                                            controller.onSelectedActivity,
                                        itemBuilder: (BuildContext context) {
                                          return [
                                            "Year",
                                            "Month",
                                            "Week",
                                            "Day",
                                            "Hours",
                                          ].map((behavior) {
                                            return PopupMenuItem(
                                              value: behavior,
                                              height: 32,
                                              child: MyText.bodySmall(
                                                behavior.toString(),
                                                color:
                                                    theme.colorScheme.onSurface,
                                                fontWeight: 600,
                                              ),
                                            );
                                          }).toList();
                                        },
                                        color: theme.cardTheme.color,
                                        child: MyContainer(
                                          padding: MySpacing.xy(12, 8),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              MyText.labelMedium(
                                                controller.selectedActivity
                                                    .toString(),
                                                color:
                                                    theme.colorScheme.onSurface,
                                              ),
                                              Icon(
                                                LucideIcons.chevronDown,
                                                size: 22,
                                                color:
                                                    theme.colorScheme.onSurface,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SfCartesianChart(
                                    plotAreaBorderWidth: 0,
                                    primaryXAxis: const CategoryAxis(
                                      majorGridLines: MajorGridLines(width: 0),
                                    ),
                                    primaryYAxis: const NumericAxis(
                                        // majorGridLines:
                                        // const MajorGridLines(width: 0),
                                        ),
                                    series: <CartesianSeries>[
                                      SplineSeries<ChartSampleData, String>(
                                        color: const Color(0xff727cf5),
                                        dataLabelSettings:
                                            const DataLabelSettings(
                                          borderWidth: 100,
                                          showZeroValue: true,
                                        ),
                                        dataSource: controller.activityChart,
                                        xValueMapper:
                                            (ChartSampleData data, _) => data.x,
                                        yValueMapper:
                                            (ChartSampleData data, _) => data.y,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          MyFlexItem(
                            sizes: 'lg-4',
                            child: MyContainer(
                              child: SizedBox(
                                height: 338,
                                child: _buildAngleRadialBarChart(),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    MyFlexItem(
                      sizes: 'lg-3 ',
                      child: MyContainer(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            buildProfileDetail(),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget buildOutPut(
    Color color,
    IconData icon,
    String title,
    String weight,
    String emoji,
  ) {
    return MyContainer(
      color: color.withAlpha(40),
      child: Row(
        children: [
          MyContainer(
            paddingAll: 0,
            height: 50,
            width: 50,
            color: color,
            child: Center(
              child: Icon(
                icon,
                color: contentTheme.onPrimary,
              ),
            ),
          ),
          MySpacing.width(12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MyText.bodyMedium(
                  title,
                  fontWeight: 600,
                ),
                MyText.bodyMedium(
                  weight,
                  fontWeight: 600,
                  color: color,
                ),
              ],
            ),
          ),
          MyText.bodyMedium(emoji),
        ],
      ),
    );
  }

  Widget buildScheduled(String name, String title, String time) {
    return MyContainer.bordered(
      borderRadiusAll: 12,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MyText.bodyMedium(name, fontWeight: 600, muted: true),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              MyText.bodyMedium(
                title,
                fontWeight: 600,
              ),
              MyText.bodyMedium(time, fontWeight: 600, muted: true),
            ],
          ),
        ],
      ),
    );
  }

  SfDateRangePicker getGettingStartedDatePicker(
    DateRangePickerController controller,
    DateRangePickerSelectionMode mode,
    bool showLeading,
    bool enablePastDates,
    bool enableSwipingSelection,
    bool enableViewNavigation,
    bool showActionButtons,
    DateTime minDate,
    DateTime maxDate,
    bool enableMultiView,
    bool showWeekNumber,
    BuildContext context,
  ) {
    return SfDateRangePicker(
      enablePastDates: enablePastDates,
      minDate: minDate,
      maxDate: maxDate,
      enableMultiView: enableMultiView,
      allowViewNavigation: enableViewNavigation,
      selectionMode: mode,
      controller: controller,
      monthViewSettings: DateRangePickerMonthViewSettings(
        enableSwipeSelection: enableSwipingSelection,
        showTrailingAndLeadingDates: showLeading,
        weekNumberStyle: DateRangePickerWeekNumberStyle(
          textStyle: MyTextStyle.bodyMedium(),
        ),
        showWeekNumber: showWeekNumber,
      ),
    );
  }

  Widget buildProfileDetail() {
    // Retrieve the controller
    final FitnessController controller = Get.find<FitnessController>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MyText.bodyMedium(
          'User Body Measurements',
          fontWeight: 600,
        ),
        MySpacing.height(12),
        Center(
          child: MyContainer.roundBordered(
            paddingAll: 2,
            child: MyContainer.rounded(
              paddingAll: 0,
              height: 100,
              child: Image.asset(Images.avatars[2]),
            ),
          ),
        ),
        Center(
          child: MyText.bodyMedium(
            'Chris',
            fontWeight: 600,
          ),
        ),
        MySpacing.height(12),
        MyContainer.bordered(
          borderRadiusAll: 12,
          child: Obx(() {
            final measurement = controller.bodyMeasurement.value;
            if (measurement != null) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  buildProfileOverView(
                    '${measurement.weightKilogram.toStringAsFixed(2)} kg',
                    'Weight',
                  ),
                  buildProfileOverView(
                    '${measurement.heightMeter.toStringAsFixed(2)} m',
                    'Height',
                  ),
                  buildProfileOverView(
                    '${measurement.maxHeartRate} bpm',
                    'Max Heart Rate',
                  ),
                ],
              );
            } else {
              return const SizedBox.shrink();
            }
          }),
        ),
      ],
    );
  }

  Widget buildProfileOverView(String title, String subTitle) {
    return Column(
      children: [
        MyText.bodyMedium(title, fontWeight: 600),
        MyText.bodyMedium(subTitle, fontWeight: 600, muted: true),
      ],
    );
  }

  SfCircularChart _buildAngleRadialBarChart() {
    return SfCircularChart(
      title: ChartTitle(
        text: 'Today Activity',
        textStyle: MyTextStyle.bodySmall(fontWeight: 600),
      ),
      legend: const Legend(
        isVisible: true,
        iconHeight: 20,
        iconWidth: 20,
        position: LegendPosition.right,
        overflowMode: LegendItemOverflowMode.none,
      ),
      series: controller.getRadialBarSeries(),
    );
  }

  Widget buildWorkoutCategory(
    Color color,
    IconData icon,
    String title,
    String subTitle,
  ) {
    return SizedBox(
      height: 120,
      width: 250,
      child: Stack(
        children: [
          Align(
            alignment: Alignment.bottomCenter,
            child: MyContainer(
              height: 100,
              paddingAll: 0,
              borderRadiusAll: 8,
              clipBehavior: Clip.antiAliasWithSaveLayer,
              width: 300,
              child: Stack(
                children: [
                  Positioned(
                    top: 26,
                    width: 425,
                    child: Icon(
                      icon,
                      size: 120,
                      color: Colors.grey.withAlpha(40),
                    ),
                  ),
                  Padding(
                    padding: MySpacing.only(left: 12, bottom: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        MyText.bodyLarge(
                          title,
                          fontWeight: 600,
                        ),
                        MyText.bodyMedium(
                          subTitle,
                          fontWeight: 600,
                          muted: true,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: MySpacing.x(16),
            child: MyContainer(
              paddingAll: 0,
              height: 50,
              width: 50,
              color: color,
              child: Icon(
                icon,
                color: contentTheme.onDark,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
