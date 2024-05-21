import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../common/widgets/custom_button.dart';
import '../../../constants/color_constant.dart';
import '../../../constants/dimension_constant.dart';
import '../../application/kitchen_provider.dart';
import '../../application/kitchen_state.dart';

class KitchenReprint extends ConsumerStatefulWidget {
  const KitchenReprint(
      {required this.salesNo,
      required this.splitNo,
      required this.tableNo,
      Key? key})
      : super(key: key);

  final int salesNo;
  final int splitNo;
  final String tableNo;

  @override
  _KitchenReprintState createState() => _KitchenReprintState();
}

class _KitchenReprintState extends ConsumerState<KitchenReprint> {
  @override
  void initState() {
    super.initState();
    // fetch reprint items
    ref
        .read(kitchenProvider.notifier)
        .fetchReprintData(widget.salesNo, widget.splitNo, widget.tableNo);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(Spacing.screenHPadding),
      width: 500.w,
      height: 250.h,
      child: Column(
        children: [
          Expanded(child: reprintItemList()),
          btnGroup(),
        ],
      ),
    );
  }

  List<bool> reprintCheck = <bool>[];
  Widget reprintItemList() {
    KitchenState state = ref.watch(kitchenProvider);
    List<DataRow> dataRows = <DataRow>[];
    if (state.workable == Workable.loading) {
    } else if (state.workable == Workable.ready) {
      List<List<String>> reprintArray = state.kitchenData?.reprintArray ?? [];
      dataRows = List.generate(reprintArray.length, (index) {
        return DataRow(cells: <DataCell>[
          DataCell(Checkbox(
            onChanged: (bool? value) {
              setState(() {
                reprintCheck[index] = value!;
              });
            },
            value: reprintCheck[index],
          )),
          DataCell(Text(reprintArray[index][2])),
          DataCell(Text(reprintArray[index][3])),
          DataCell(Text(reprintArray[index][4])),
        ]);
      });
    } else if (state.workable == Workable.failure) {
    } else {}

    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columns: const <DataColumn>[
            DataColumn(label: Text('Reprint')),
            DataColumn(label: Text('Item Name')),
            DataColumn(label: Text('Qty')),
            DataColumn(label: Text('Count')),
          ],
          rows: dataRows,
        ),
      ),
    );
  }

  Widget btnGroup() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: [
        CustomButton(
            width: 120.w,
            height: 30.h,
            callback: () {},
            text: 'FIRE',
            borderColor: primaryDarkColor,
            fillColor: primaryDarkColor),
        horizontalSpaceLarge,
        CustomButton(
            width: 120.w,
            height: 30.h,
            callback: () {},
            text: 'CLOSE',
            borderColor: primaryDarkColor,
            fillColor: primaryDarkColor),
      ],
    );
  }
}
