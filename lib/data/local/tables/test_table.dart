part of '../api_db.dart';

// Название сгенерированного класса данных.
@DataClassName('TestDto')
// Индекс для столбцов в таблице упрощает идентификацию строк.
// Используется для ускорения поиска и сортировки данных.
@TableIndex(name: 'val_1', columns: {#val1, #val2})
@TableIndex(name: 'val_4', columns: {#val4}, unique: true)
class TestTable extends Table {
  @override
  String get tableName => 'test'; // название таблицы в БД

  // Int
  IntColumn get id => integer().autoIncrement()();
  IntColumn get val1 => integer().nullable().references(TestTodoCategoryTable, #id)();
  Int64Column get val2 => int64().unique()(); // if value > 2^52
  @JsonKey('val_3')
  RealColumn get val3 => real().clientDefault(() => Random().nextDouble())(); // double
  // Bool
  BoolColumn get val4 => boolean().withDefault(const Constant(false))(); // 0,1
  // String
  TextColumn get val5 => text()();
  TextColumn get val6 => text().nullable().named('body').withLength(min: 6, max: 32)();
  // DateTime. Drift возвращает значение, отличное от UTC даже если сохраняются даты и время UTC.
  // Если значение строка ISO 8601, необходимо в конце наличия `z` для считывания как UTC.
  DateTimeColumn get val7 => dateTime().nullable()(); //
  // Enum. New values must be added to the end of the enum class.
  // IntColumn get val8 => intEnum()(); // enum's index.
  // TextColumn get val9 => textEnum()(); // enum's value.
  // Converters to native types.
  // TextColumn get preferences => text().map(const PreferenceConverter()).nullable()();

  // Переопределение первичного ключа
  // @override
  // Set<Column> get primaryKey => {val1, val2}; // только если не используется autoIncrement

  // Когда объединенное значение нескольких столбцов должно быть уникальным
  @override
  List<Set<Column>> get uniqueKeys => [
        {val3, val5},
        {val6, val7}
      ];
}

class TestTodoCategoryTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get description => text()();
}
