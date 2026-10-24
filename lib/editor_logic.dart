enum EditorLineType { paragraph, heading, subheading, bullet, checklist }

class EditorLine {
  EditorLine(this.text, {this.type = EditorLineType.paragraph, this.checked = false});
  String text;
  EditorLineType type;
  bool checked;
}

class EditorDocument {
  EditorDocument([List<EditorLine>? initial]) : lines = initial ?? [EditorLine('')];
  final List<EditorLine> lines;
  void enter(int index, int cursor) { final line = lines[index]; final position = cursor.clamp(0, line.text.length); final next = EditorLine(line.text.substring(position), type: line.type); line.text = line.text.substring(0, position); if (line.type == EditorLineType.checklist || line.type == EditorLineType.bullet) next.checked = false; lines.insert(index + 1, next); }
  bool backspace(int index, int cursor) { if (index < 0 || index >= lines.length || cursor != 0) return false; final line = lines[index]; if ((line.type == EditorLineType.checklist || line.type == EditorLineType.bullet) && line.text.isEmpty) { lines.removeAt(index); if (lines.isEmpty) lines.add(EditorLine('')); return true; } return false; }
  void toggleChecklist(int index) { final line = lines[index]; line.type = line.type == EditorLineType.checklist ? EditorLineType.paragraph : EditorLineType.checklist; }
}
