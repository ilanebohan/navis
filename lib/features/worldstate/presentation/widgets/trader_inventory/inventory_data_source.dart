import 'package:flutter/material.dart';
import 'package:wfcd_client/entities.dart';

class InventoryDataSource extends DataTableSource {
  InventoryDataSource({this.inventory});

  final List<InventoryItem> inventory;

  @override
  DataRow getRow(int index) {
    assert(index >= 0);
    if (index >= inventory.length) return null;

    final product = inventory[index];

    return DataRow.byIndex(
        index: index,
        cells: <DataCell>[
          DataCell(Text(product.item), onTap: () {}),
          DataCell(Text('${product.ducats}'), onTap: () {}),
          DataCell(Text('${product.credits}cr'), onTap: () {})
        ],
        onSelectChanged: null);
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => inventory.length;

  @override
  int get selectedRowCount => 0;
}
