import "package:json_annotation/json_annotation.dart";

part 'page_dto.g.dart';

@JsonSerializable()
class PageDTO extends Object with _$PageDTOSerializerMixin {
  int pageSize;
  int totalSize;
  int currentPage;
  int totalPage;

  PageDTO(
      {this.pageSize = 10,
      this.totalSize,
      this.currentPage = 1,
      this.totalPage = 1});

  factory PageDTO.fromJson(Map<String, dynamic> json) =>
      _$PageDTOFromJson(json);
}
