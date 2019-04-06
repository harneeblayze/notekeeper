class Note {
  String _title, _body;
  int _priority, _date;
  Note(String title, String body, int priority, int date) {
    this._title = title;
    this._body = body;
    this._priority = priority;
    this._date = date;
  }
  String get title => this._title;
  String get body => this._body;
  int get priority => this._priority;
  int get date => this._date;
  set title(String title) => this._title = title;
  set body(String body) => this._body = body;
  set priority(int right) => this._priority = right;
  set date(int date) => this._date = date;
}
