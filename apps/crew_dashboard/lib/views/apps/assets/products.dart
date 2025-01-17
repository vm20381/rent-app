import 'package:captainapp_crew_dashboard/controller/apps/assets/product_controller.dart';
import 'package:captainapp_crew_dashboard/helpers/extensions/string.dart';
import 'package:captainapp_crew_dashboard/helpers/theme/app_style.dart';
import 'package:captainapp_crew_dashboard/helpers/utils/ui_mixins.dart';
import 'package:captainapp_crew_dashboard/helpers/utils/utils.dart';
import 'package:captainapp_crew_dashboard/helpers/widgets/my_breadcrumb.dart';
import 'package:captainapp_crew_dashboard/helpers/widgets/my_breadcrumb_item.dart';
import 'package:captainapp_crew_dashboard/helpers/widgets/my_button.dart';
import 'package:captainapp_crew_dashboard/helpers/widgets/my_container.dart';
import 'package:captainapp_crew_dashboard/helpers/widgets/my_spacing.dart';
import 'package:captainapp_crew_dashboard/helpers/widgets/my_text.dart';
import 'package:captainapp_crew_dashboard/helpers/widgets/responsive.dart';
import 'package:captainapp_crew_dashboard/models/product.dart';
import 'package:captainapp_crew_dashboard/views/layouts/layout.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/instance_manager.dart';
import 'package:lucide_icons/lucide_icons.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({super.key});

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage>
    with SingleTickerProviderStateMixin, UIMixin {
  late ProductController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put(ProductController());
  }

  @override
  Widget build(BuildContext context) {
    return Layout(
      child: GetBuilder(
        init: controller,
        builder: (controller) {
          return Column(
            children: [
              Padding(
                padding: MySpacing.x(flexSpacing),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    MyText.titleMedium(
                      "products".tr(),
                      fontSize: 18,
                      fontWeight: 600,
                    ),
                    MyBreadcrumb(
                      children: [
                        MyBreadcrumbItem(name: 'assets'.tr()),
                        MyBreadcrumbItem(name: 'products'.tr(), active: true),
                      ],
                    ),
                  ],
                ),
              ),
              MySpacing.height(flexSpacing),
              if (controller.data != null)
                Padding(
                  padding: MySpacing.x(flexSpacing),
                  child: PaginatedDataTable(
                    source: controller.data!,
                    header: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const MyText.titleMedium(
                          "Product List",
                          fontWeight: 600,
                          fontSize: 20,
                        ),
                        MyButton(
                          onPressed: controller.goToCreateProduct,
                          elevation: 0,
                          padding: MySpacing.xy(20, 16),
                          backgroundColor: contentTheme.primary,
                          borderRadiusAll: AppStyle.buttonRadius.medium,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                LucideIcons.plus,
                                color: Color(0xffffffff),
                              ),
                              MySpacing.width(8),
                              MyText.labelMedium(
                                'create_product'.tr().capitalizeWords,
                                color: contentTheme.onPrimary,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    columns: const [
                      DataColumn(
                        label: MyText.titleMedium(
                          'Id',
                          fontWeight: 600,
                        ),
                      ),
                      DataColumn(
                        label: MyText.titleMedium('Name', fontWeight: 600),
                      ),
                      DataColumn(
                        label: MyText.titleMedium('Price', fontWeight: 600),
                      ),
                      DataColumn(
                        label: MyText.titleMedium('Rating', fontWeight: 600),
                      ),
                      DataColumn(
                        label: MyText.titleMedium('SKU', fontWeight: 600),
                      ),
                      DataColumn(
                        label: MyText.titleMedium('Stock', fontWeight: 600),
                      ),
                      DataColumn(
                        label: MyText.titleMedium('Orders', fontWeight: 600),
                      ),
                      DataColumn(
                        label: MyText.titleMedium(
                          'Created At',
                          fontWeight: 600,
                        ),
                      ),
                      DataColumn(
                        label: MyText.titleMedium('Action', fontWeight: 600),
                      ),
                      // DataColumn(label: Text('Delete')),
                    ],
                    columnSpacing: 110,
                    horizontalMargin: 28,
                    rowsPerPage: 10,
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}

class MyData extends DataTableSource with UIMixin {
  List<Product> data = [];

  MyData(this.data);

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => data.length;

  @override
  int get selectedRowCount => 0;

  @override
  DataRow getRow(int index) {
    return DataRow(
      cells: [
        DataCell(
          MyText.titleMedium(
            data[index].id.toString(),
            fontWeight: 600,
          ),
        ),
        DataCell(
          MyText.titleMedium(
            data[index].name,
            fontWeight: 600,
          ),
        ),
        DataCell(MyText.titleMedium(data[index].price.toString())),
        DataCell(MyText.titleMedium(data[index].rating.toString())),
        DataCell(MyText.titleMedium(data[index].sku)),
        DataCell(MyText.titleMedium(data[index].stock.toString())),
        DataCell(MyText.titleMedium(data[index].ordersCount.toString())),
        DataCell(
          MyText.bodyMedium(
            '${Utils.getDateStringFromDateTime(
              data[index].createdAt,
              showMonthShort: true,
            )}',
          ),
        ),
        DataCell(
          Align(
            alignment: Alignment.center,
            child: Row(
              children: [
                MyContainer.bordered(
                  onTap: () => {},
                  padding: MySpacing.xy(6, 6),
                  borderColor: contentTheme.primary.withAlpha(40),
                  child: Icon(
                    LucideIcons.edit2,
                    size: 12,
                    color: contentTheme.primary,
                  ),
                ),
                MySpacing.width(12),
                MyContainer.bordered(
                  onTap: () => {},
                  padding: MySpacing.xy(6, 6),
                  borderColor: contentTheme.primary.withAlpha(40),
                  child: Icon(
                    LucideIcons.trash2,
                    size: 12,
                    color: contentTheme.primary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
