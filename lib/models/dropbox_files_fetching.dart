// To parse this JSON data, do
//
//     final dropboxFilesFetching = dropboxFilesFetchingFromJson(jsonString);

import 'dart:convert';

DropboxFilesFetching dropboxFilesFetchingFromJson(String str) =>
    DropboxFilesFetching.fromJson(json.decode(str));

String dropboxFilesFetchingToJson(DropboxFilesFetching data) =>
    json.encode(data.toJson());

class DropboxFilesFetching {
  List<FilesFetchingEntry> entries;
  String cursor;
  bool hasMore;

  DropboxFilesFetching({
    required this.entries,
    required this.cursor,
    required this.hasMore,
  });

  DropboxFilesFetching copyWith({
    List<FilesFetchingEntry>? entries,
    String? cursor,
    bool? hasMore,
  }) =>
      DropboxFilesFetching(
        entries: entries ?? this.entries,
        cursor: cursor ?? this.cursor,
        hasMore: hasMore ?? this.hasMore,
      );

  factory DropboxFilesFetching.fromJson(Map<String, dynamic> json) =>
      DropboxFilesFetching(
        entries: List<FilesFetchingEntry>.from(
            json["entries"].map((x) => FilesFetchingEntry.fromJson(x))),
        cursor: json["cursor"],
        hasMore: json["has_more"],
      );

  Map<String, dynamic> toJson() => {
        "entries": List<dynamic>.from(entries.map((x) => x.toJson())),
        "cursor": cursor,
        "has_more": hasMore,
      };
}

class FilesFetchingEntry {
  Tag tag;
  String name;
  String pathLower;
  String pathDisplay;
  String id;
  String? sharedFolderId;
  SharingInfo? sharingInfo;
  DateTime? clientModified;
  DateTime? serverModified;
  String? rev;
  int? size;
  bool? isDownloadable;
  String? contentHash;

  FilesFetchingEntry({
    required this.tag,
    required this.name,
    required this.pathLower,
    required this.pathDisplay,
    required this.id,
    this.sharedFolderId,
    this.sharingInfo,
    this.clientModified,
    this.serverModified,
    this.rev,
    this.size,
    this.isDownloadable,
    this.contentHash,
  });

  FilesFetchingEntry copyWith({
    Tag? tag,
    String? name,
    String? pathLower,
    String? pathDisplay,
    String? id,
    String? sharedFolderId,
    SharingInfo? sharingInfo,
    DateTime? clientModified,
    DateTime? serverModified,
    String? rev,
    int? size,
    bool? isDownloadable,
    String? contentHash,
  }) =>
      FilesFetchingEntry(
        tag: tag ?? this.tag,
        name: name ?? this.name,
        pathLower: pathLower ?? this.pathLower,
        pathDisplay: pathDisplay ?? this.pathDisplay,
        id: id ?? this.id,
        sharedFolderId: sharedFolderId ?? this.sharedFolderId,
        sharingInfo: sharingInfo ?? this.sharingInfo,
        clientModified: clientModified ?? this.clientModified,
        serverModified: serverModified ?? this.serverModified,
        rev: rev ?? this.rev,
        size: size ?? this.size,
        isDownloadable: isDownloadable ?? this.isDownloadable,
        contentHash: contentHash ?? this.contentHash,
      );

  factory FilesFetchingEntry.fromJson(Map<String, dynamic> json) =>
      FilesFetchingEntry(
        tag: tagValues.map[json[".tag"]]!,
        name: json["name"],
        pathLower: json["path_lower"],
        pathDisplay: json["path_display"],
        id: json["id"],
        sharedFolderId: json["shared_folder_id"],
        sharingInfo: json["sharing_info"] == null
            ? null
            : SharingInfo.fromJson(json["sharing_info"]),
        clientModified: json["client_modified"] == null
            ? null
            : DateTime.parse(json["client_modified"]),
        serverModified: json["server_modified"] == null
            ? null
            : DateTime.parse(json["server_modified"]),
        rev: json["rev"],
        size: json["size"],
        isDownloadable: json["is_downloadable"],
        contentHash: json["content_hash"],
      );

  Map<String, dynamic> toJson() => {
        ".tag": tagValues.reverse[tag],
        "name": name,
        "path_lower": pathLower,
        "path_display": pathDisplay,
        "id": id,
        "shared_folder_id": sharedFolderId,
        "sharing_info": sharingInfo?.toJson(),
        "client_modified": clientModified?.toIso8601String(),
        "server_modified": serverModified?.toIso8601String(),
        "rev": rev,
        "size": size,
        "is_downloadable": isDownloadable,
        "content_hash": contentHash,
      };
}

class SharingInfo {
  bool readOnly;
  String sharedFolderId;
  bool traverseOnly;
  bool noAccess;

  SharingInfo({
    required this.readOnly,
    required this.sharedFolderId,
    required this.traverseOnly,
    required this.noAccess,
  });

  SharingInfo copyWith({
    bool? readOnly,
    String? sharedFolderId,
    bool? traverseOnly,
    bool? noAccess,
  }) =>
      SharingInfo(
        readOnly: readOnly ?? this.readOnly,
        sharedFolderId: sharedFolderId ?? this.sharedFolderId,
        traverseOnly: traverseOnly ?? this.traverseOnly,
        noAccess: noAccess ?? this.noAccess,
      );

  factory SharingInfo.fromJson(Map<String, dynamic> json) => SharingInfo(
        readOnly: json["read_only"],
        sharedFolderId: json["shared_folder_id"],
        traverseOnly: json["traverse_only"],
        noAccess: json["no_access"],
      );

  Map<String, dynamic> toJson() => {
        "read_only": readOnly,
        "shared_folder_id": sharedFolderId,
        "traverse_only": traverseOnly,
        "no_access": noAccess,
      };
}

enum Tag { file, folder }

final tagValues = EnumValues({"file": Tag.file, "folder": Tag.folder});

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
