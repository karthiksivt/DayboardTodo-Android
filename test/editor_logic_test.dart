import 'package:flutter_test/flutter_test.dart';
import 'package:dayboard_android/editor_logic.dart';

void main() {
  test('checklist Enter creates a new block and preserves checklist type', () {
    final document = EditorDocument(
        [EditorLine('buy milk', type: EditorLineType.checklist)]);
    document.enter(0, 8);
    expect(document.lines, hasLength(2));
    expect(document.lines[1].type, EditorLineType.checklist);
    expect(document.lines[1].text, isEmpty);
  });

  test('Backspace at an empty checklist start removes the whole line', () {
    final document = EditorDocument(
        [EditorLine('first'), EditorLine('', type: EditorLineType.checklist)]);
    expect(document.backspace(1, 0), isTrue);
    expect(document.lines, hasLength(1));
  });

  test('bullet Enter creates a dedicated new block', () {
    final document =
        EditorDocument([EditorLine('one', type: EditorLineType.bullet)]);
    document.enter(0, 3);
    expect(document.lines[1].type, EditorLineType.bullet);
    expect(document.lines[1].text, isEmpty);
  });
}
