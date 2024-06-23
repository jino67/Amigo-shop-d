import 'dart:convert';

import 'package:e_com/models/models.dart';

class ItemListWithPageData<T> {
  const ItemListWithPageData({
    required this.listData,
    required this.pagination,
  });

  const ItemListWithPageData.empty()
      : listData = const [],
        pagination = null;

  bool get isEmpty => listData.isEmpty;
  bool get isNotEmpty => listData.isNotEmpty;
  int get length => listData.length;
  int get totalLength => pagination?.totalItem ?? 0;

  operator [](int index) => listData[index];

  final List<T> listData;
  final PaginationInfo? pagination;

  factory ItemListWithPageData.fromJson(
    String? source,
    T Function(dynamic source) fromJsonT,
  ) =>
      ItemListWithPageData.fromMap(
        source == null ? {} : json.decode(source),
        fromJsonT,
      );

  factory ItemListWithPageData.fromMap(
    Map<String, dynamic> map,
    T Function(dynamic source) fromJsonT,
  ) {
    return ItemListWithPageData(
      listData: List<T>.from(map['data']?.map((x) => fromJsonT(x)) ?? []),
      pagination: map['pagination'] == null
          ? null
          : PaginationInfo.fromMap(map['pagination']),
    );
  }

  Map<String, dynamic> toMap(Object Function(T data) toJsonT) {
    return {
      'data': List<dynamic>.from(listData.map((x) => toJsonT(x))),
      'pagination': pagination?.toMap(),
    };
  }

  String toJson(Object Function(T data) toJsonT) {
    return json.encode(toMap(toJsonT));
  }

  ItemListWithPageData<T> copyWith({
    List<T>? listData,
    PaginationInfo? pagination,
  }) {
    return ItemListWithPageData<T>(
      listData: listData ?? this.listData,
      pagination: pagination ?? this.pagination,
    );
  }
}
