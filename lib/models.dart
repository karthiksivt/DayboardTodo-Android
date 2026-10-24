import 'dart:convert';

enum DayTheme { cream, pink, yellow, lilac, mint, blue, orange, green }

extension DayThemeValue on DayTheme {
  String get value => name;
  static DayTheme fromValue(String? value) => DayTheme.values.firstWhere((theme) => theme.name == value, orElse: () => DayTheme.cream);
}

class PlannerItem {
  PlannerItem({required this.id, required this.title, required this.start, required this.end, required this.color, required this.reminder, this.done = false, this.isBlock = false});
  final String id;
  String title;
  String start;
  String end;
  String color;
  String reminder;
  bool done;
  bool isBlock;
  Map<String, dynamic> toJson() => {'id': id, 'title': title, 'start': start, 'end': end, 'color': color, 'reminder': reminder, 'done': done, 'isBlock': isBlock};
  factory PlannerItem.fromJson(Map<String, dynamic> json) => PlannerItem(id: json['id'] as String? ?? DateTime.now().microsecondsSinceEpoch.toString(), title: json['title'] as String? ?? '', start: json['start'] as String? ?? '', end: json['end'] as String? ?? '', color: json['color'] as String? ?? 'pink', reminder: json['reminder'] as String? ?? 'none', done: json['done'] as bool? ?? false, isBlock: json['isBlock'] as bool? ?? false);
}

class NoteAttachment {
  NoteAttachment({required this.id, required this.name, required this.path, required this.kind, required this.size});
  final String id;
  final String name;
  final String path;
  final String kind;
  final int size;
  Map<String, dynamic> toJson() => {'id': id, 'name': name, 'path': path, 'kind': kind, 'size': size};
  factory NoteAttachment.fromJson(Map<String, dynamic> json) => NoteAttachment(id: json['id'] as String? ?? '', name: json['name'] as String? ?? 'file', path: json['path'] as String? ?? '', kind: json['kind'] as String? ?? 'file', size: json['size'] as int? ?? 0);
}

class NoteData {
  NoteData({this.title = 'A note worth keeping', this.html = '', this.plainText = '', this.theme = DayTheme.cream, List<NoteAttachment>? attachments, List<String>? links}) : attachments = attachments ?? [], links = links ?? [];
  String title;
  String html;
  String plainText;
  DayTheme theme;
  final List<NoteAttachment> attachments;
  final List<String> links;
  Map<String, dynamic> toJson() => {'title': title, 'html': html, 'plainText': plainText, 'theme': theme.value, 'attachments': attachments.map((item) => item.toJson()).toList(), 'links': links};
  factory NoteData.fromJson(Map<String, dynamic> json) => NoteData(title: json['title'] as String? ?? 'A note worth keeping', html: json['html'] as String? ?? '', plainText: json['plainText'] as String? ?? '', theme: DayThemeValue.fromValue(json['theme'] as String?), attachments: ((json['attachments'] as List?) ?? []).whereType<Map>().map((item) => NoteAttachment.fromJson(Map<String, dynamic>.from(item))).toList(), links: ((json['links'] as List?) ?? []).whereType<String>().toList());
}

class DayData {
  DayData({List<PlannerItem>? tasks, List<PlannerItem>? blocks, NoteData? note}) : tasks = tasks ?? [], blocks = blocks ?? [], note = note ?? NoteData();
  final List<PlannerItem> tasks;
  final List<PlannerItem> blocks;
  final NoteData note;
  Map<String, dynamic> toJson() => {'tasks': tasks.map((item) => item.toJson()).toList(), 'blocks': blocks.map((item) => item.toJson()).toList(), 'note': note.toJson()};
  factory DayData.fromJson(Map<String, dynamic> json) => DayData(tasks: ((json['tasks'] as List?) ?? []).whereType<Map>().map((item) => PlannerItem.fromJson(Map<String, dynamic>.from(item))).toList(), blocks: ((json['blocks'] as List?) ?? []).whereType<Map>().map((item) => PlannerItem.fromJson(Map<String, dynamic>.from(item))).toList(), note: NoteData.fromJson(Map<String, dynamic>.from((json['note'] as Map?) ?? {})));
}

class PlannerState {
  PlannerState({Map<String, DayData>? days, this.version = 1}) : days = days ?? {};
  int version;
  final Map<String, DayData> days;
  DayData day(DateTime date) => days.putIfAbsent(dateKey(date), DayData.new);
  Map<String, dynamic> toJson() => {'version': version, 'days': days.map((key, value) => MapEntry(key, value.toJson()))};
  String encode() => jsonEncode(toJson());
  factory PlannerState.decode(String raw) {
    final json = Map<String, dynamic>.from(jsonDecode(raw) as Map);
    final days = <String, DayData>{};
    for (final entry in (json['days'] as Map? ?? {}).entries) { days[entry.key.toString()] = DayData.fromJson(Map<String, dynamic>.from(entry.value as Map)); }
    return PlannerState(days: days, version: json['version'] as int? ?? 1);
  }
}

String dateKey(DateTime date) => '${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
