// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'page_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PageDTO _$PageDTOFromJson(Map<String, dynamic> json) => new PageDTO(
    pageSize: json['pageSize'] as int,
    totalSize: json['totalSize'] as int,
    currentPage: json['currentPage'] as int,
    totalPage: json['totalPage'] as int);

abstract class _$PageDTOSerializerMixin {
  int get pageSize;
  int get totalSize;
  int get currentPage;
  int get totalPage;
  Map<String, dynamic> toJson() => <String, dynamic>{
        'pageSize': pageSize,
        'totalSize': totalSize,
        'currentPage': currentPage,
        'totalPage': totalPage
      };
}
