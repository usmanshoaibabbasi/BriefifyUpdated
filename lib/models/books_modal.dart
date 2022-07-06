class BooksModal {
  var id;
  var created_at;
  var updated_at;
  var book_name;
  var user_id;
  var chapters;

  BooksModal({
    required this.id,
    required this.created_at,
    required this.updated_at,
    required this.book_name,
    required this.user_id,
    required this.chapters,
  });
}
class ChapterModal {
  var id;
  var created_at;
  var updated_at;
  var chapter_name;
  var user_id;
  var book_id;
  var chapterstext;

  ChapterModal({
    required this.id,
    required this.created_at,
    required this.updated_at,
    required this.chapter_name,
    required this.user_id,
    required this.book_id,
    required this.chapterstext,
  });
}
