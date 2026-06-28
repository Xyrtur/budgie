// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'repository.dart';

// ignore_for_file: type=lint
class $TransactionsTable extends Transactions with TableInfo<$TransactionsTable, Transaction>{
@override final GeneratedDatabase attachedDatabase;
final String? _alias;
$TransactionsTable(this.attachedDatabase, [this._alias]);
static const VerificationMeta _idMeta = const VerificationMeta('id');
@override
late final GeneratedColumn<int> id = GeneratedColumn<int>('id', aliasedName, false, hasAutoIncrement: true, type: DriftSqlType.int, requiredDuringInsert: false, defaultConstraints: GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
static const VerificationMeta _titleMeta = const VerificationMeta('title');
@override
late final GeneratedColumn<String> title = GeneratedColumn<String>('title', aliasedName, false, additionalChecks: GeneratedColumn.checkTextLength(minTextLength: 6,maxTextLength: 32), type: DriftSqlType.string, requiredDuringInsert: true);
static const VerificationMeta _valueMeta = const VerificationMeta('value');
@override
late final GeneratedColumn<double> value = GeneratedColumn<double>('value', aliasedName, false, type: DriftSqlType.double, requiredDuringInsert: true);
static const VerificationMeta _createdAtMeta = const VerificationMeta('createdAt');
@override
late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>('created_at', aliasedName, false, type: DriftSqlType.dateTime, requiredDuringInsert: true);
static const VerificationMeta _isExpenseMeta = const VerificationMeta('isExpense');
@override
late final GeneratedColumn<bool> isExpense = GeneratedColumn<bool>('is_expense', aliasedName, false, type: DriftSqlType.bool, requiredDuringInsert: true, defaultConstraints: GeneratedColumn.constraintIsAlways('CHECK ("is_expense" IN (0, 1))'));
@override
List<GeneratedColumn> get $columns => [id, title, value, createdAt, isExpense];
@override
String get aliasedName => _alias ?? actualTableName;
@override
String get actualTableName => $name;
static const String $name = 'transactions';
@override
VerificationContext validateIntegrity(Insertable<Transaction> instance, {bool isInserting = false}) {
final context = VerificationContext();
final data = instance.toColumns(true);
if (data.containsKey('id')) {
context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));}if (data.containsKey('title')) {
context.handle(_titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));} else if (isInserting) {
context.missing(_titleMeta);
}
if (data.containsKey('value')) {
context.handle(_valueMeta, value.isAcceptableOrUnknown(data['value']!, _valueMeta));} else if (isInserting) {
context.missing(_valueMeta);
}
if (data.containsKey('created_at')) {
context.handle(_createdAtMeta, createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));} else if (isInserting) {
context.missing(_createdAtMeta);
}
if (data.containsKey('is_expense')) {
context.handle(_isExpenseMeta, isExpense.isAcceptableOrUnknown(data['is_expense']!, _isExpenseMeta));} else if (isInserting) {
context.missing(_isExpenseMeta);
}
return context;
}
@override
Set<GeneratedColumn> get $primaryKey => {id};
@override Transaction map(Map<String, dynamic> data, {String? tablePrefix})  {
final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';return Transaction(id: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}id'])!, title: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}title'])!, value: attachedDatabase.typeMapping.read(DriftSqlType.double, data['${effectivePrefix}value'])!, createdAt: attachedDatabase.typeMapping.read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!, isExpense: attachedDatabase.typeMapping.read(DriftSqlType.bool, data['${effectivePrefix}is_expense'])!, );
}
@override
$TransactionsTable createAlias(String alias) {
return $TransactionsTable(attachedDatabase, alias);}
}class Transaction extends DataClass implements Insertable<Transaction> 
{
final int id;
final String title;
final double value;
final DateTime createdAt;
final bool isExpense;
const Transaction({required this.id, required this.title, required this.value, required this.createdAt, required this.isExpense});@override
Map<String, Expression> toColumns(bool nullToAbsent) {
final map = <String, Expression> {};map['id'] = Variable<int>(id);
map['title'] = Variable<String>(title);
map['value'] = Variable<double>(value);
map['created_at'] = Variable<DateTime>(createdAt);
map['is_expense'] = Variable<bool>(isExpense);
return map; 
}
TransactionsCompanion toCompanion(bool nullToAbsent) {
return TransactionsCompanion(id: Value(id),title: Value(title),value: Value(value),createdAt: Value(createdAt),isExpense: Value(isExpense),);
}
factory Transaction.fromJson(Map<String, dynamic> json, {ValueSerializer? serializer}) {
serializer ??= driftRuntimeOptions.defaultSerializer;
return Transaction(id: serializer.fromJson<int>(json['id']),title: serializer.fromJson<String>(json['title']),value: serializer.fromJson<double>(json['value']),createdAt: serializer.fromJson<DateTime>(json['createdAt']),isExpense: serializer.fromJson<bool>(json['isExpense']),);}
@override Map<String, dynamic> toJson({ValueSerializer? serializer}) {
serializer ??= driftRuntimeOptions.defaultSerializer;
return <String, dynamic>{
'id': serializer.toJson<int>(id),'title': serializer.toJson<String>(title),'value': serializer.toJson<double>(value),'createdAt': serializer.toJson<DateTime>(createdAt),'isExpense': serializer.toJson<bool>(isExpense),};}Transaction copyWith({int? id,String? title,double? value,DateTime? createdAt,bool? isExpense}) => Transaction(id: id ?? this.id,title: title ?? this.title,value: value ?? this.value,createdAt: createdAt ?? this.createdAt,isExpense: isExpense ?? this.isExpense,);Transaction copyWithCompanion(TransactionsCompanion data) {
return Transaction(
id: data.id.present ? data.id.value : this.id,title: data.title.present ? data.title.value : this.title,value: data.value.present ? data.value.value : this.value,createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,isExpense: data.isExpense.present ? data.isExpense.value : this.isExpense,);
}
@override
String toString() {return (StringBuffer('Transaction(')..write('id: $id, ')..write('title: $title, ')..write('value: $value, ')..write('createdAt: $createdAt, ')..write('isExpense: $isExpense')..write(')')).toString();}
@override
 int get hashCode => Object.hash(id, title, value, createdAt, isExpense);@override
bool operator ==(Object other) => identical(this, other) || (other is Transaction && other.id == this.id && other.title == this.title && other.value == this.value && other.createdAt == this.createdAt && other.isExpense == this.isExpense);
}class TransactionsCompanion extends UpdateCompanion<Transaction> {
final Value<int> id;
final Value<String> title;
final Value<double> value;
final Value<DateTime> createdAt;
final Value<bool> isExpense;
const TransactionsCompanion({this.id = const Value.absent(),this.title = const Value.absent(),this.value = const Value.absent(),this.createdAt = const Value.absent(),this.isExpense = const Value.absent(),});
TransactionsCompanion.insert({this.id = const Value.absent(),required String title,required double value,required DateTime createdAt,required bool isExpense,}): title = Value(title), value = Value(value), createdAt = Value(createdAt), isExpense = Value(isExpense);
static Insertable<Transaction> custom({Expression<int>? id, 
Expression<String>? title, 
Expression<double>? value, 
Expression<DateTime>? createdAt, 
Expression<bool>? isExpense, 
}) {
return RawValuesInsertable({if (id != null)'id': id,if (title != null)'title': title,if (value != null)'value': value,if (createdAt != null)'created_at': createdAt,if (isExpense != null)'is_expense': isExpense,});
}TransactionsCompanion copyWith({Value<int>? id, Value<String>? title, Value<double>? value, Value<DateTime>? createdAt, Value<bool>? isExpense}) {
return TransactionsCompanion(id: id ?? this.id,title: title ?? this.title,value: value ?? this.value,createdAt: createdAt ?? this.createdAt,isExpense: isExpense ?? this.isExpense,);
}
@override
Map<String, Expression> toColumns(bool nullToAbsent) {
final map = <String, Expression> {};if (id.present) {
map['id'] = Variable<int>(id.value);}
if (title.present) {
map['title'] = Variable<String>(title.value);}
if (value.present) {
map['value'] = Variable<double>(value.value);}
if (createdAt.present) {
map['created_at'] = Variable<DateTime>(createdAt.value);}
if (isExpense.present) {
map['is_expense'] = Variable<bool>(isExpense.value);}
return map; 
}
@override
String toString() {return (StringBuffer('TransactionsCompanion(')..write('id: $id, ')..write('title: $title, ')..write('value: $value, ')..write('createdAt: $createdAt, ')..write('isExpense: $isExpense')..write(')')).toString();}
}
abstract class _$BudgieDatabase extends GeneratedDatabase{
_$BudgieDatabase(QueryExecutor e): super(e);
$BudgieDatabaseManager get managers => $BudgieDatabaseManager(this);
late final $TransactionsTable transactions = $TransactionsTable(this);
@override
Iterable<TableInfo<Table, Object?>> get allTables => allSchemaEntities.whereType<TableInfo<Table, Object?>>();
@override
List<DatabaseSchemaEntity> get allSchemaEntities => [transactions];
}
typedef $$TransactionsTableCreateCompanionBuilder = TransactionsCompanion Function({Value<int> id,required String title,required double value,required DateTime createdAt,required bool isExpense,});
typedef $$TransactionsTableUpdateCompanionBuilder = TransactionsCompanion Function({Value<int> id,Value<String> title,Value<double> value,Value<DateTime> createdAt,Value<bool> isExpense,});
class $$TransactionsTableFilterComposer extends Composer<
        _$BudgieDatabase,
        $TransactionsTable> {
        $$TransactionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
          ColumnFilters<int> get id => $composableBuilder(
      column: $table.id,
      builder: (column) =>
      ColumnFilters(column));
      
ColumnFilters<String> get title => $composableBuilder(
      column: $table.title,
      builder: (column) =>
      ColumnFilters(column));
      
ColumnFilters<double> get value => $composableBuilder(
      column: $table.value,
      builder: (column) =>
      ColumnFilters(column));
      
ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt,
      builder: (column) =>
      ColumnFilters(column));
      
ColumnFilters<bool> get isExpense => $composableBuilder(
      column: $table.isExpense,
      builder: (column) =>
      ColumnFilters(column));
      
        }
      class $$TransactionsTableOrderingComposer extends Composer<
        _$BudgieDatabase,
        $TransactionsTable> {
        $$TransactionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
          ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id,
      builder: (column) =>
      ColumnOrderings(column));
      
ColumnOrderings<String> get title => $composableBuilder(
      column: $table.title,
      builder: (column) =>
      ColumnOrderings(column));
      
ColumnOrderings<double> get value => $composableBuilder(
      column: $table.value,
      builder: (column) =>
      ColumnOrderings(column));
      
ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt,
      builder: (column) =>
      ColumnOrderings(column));
      
ColumnOrderings<bool> get isExpense => $composableBuilder(
      column: $table.isExpense,
      builder: (column) =>
      ColumnOrderings(column));
      
        }
      class $$TransactionsTableAnnotationComposer extends Composer<
        _$BudgieDatabase,
        $TransactionsTable> {
        $$TransactionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
          GeneratedColumn<int> get id => $composableBuilder(
      column: $table.id,
      builder: (column) => column);
      
GeneratedColumn<String> get title => $composableBuilder(
      column: $table.title,
      builder: (column) => column);
      
GeneratedColumn<double> get value => $composableBuilder(
      column: $table.value,
      builder: (column) => column);
      
GeneratedColumn<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt,
      builder: (column) => column);
      
GeneratedColumn<bool> get isExpense => $composableBuilder(
      column: $table.isExpense,
      builder: (column) => column);
      
        }
      class $$TransactionsTableTableManager extends RootTableManager    <_$BudgieDatabase,
    $TransactionsTable,
    Transaction,
    $$TransactionsTableFilterComposer,
    $$TransactionsTableOrderingComposer,
    $$TransactionsTableAnnotationComposer,
    $$TransactionsTableCreateCompanionBuilder,
    $$TransactionsTableUpdateCompanionBuilder,
    (Transaction,BaseReferences<_$BudgieDatabase,$TransactionsTable,Transaction>),
    Transaction,
    PrefetchHooks Function()
    > {
    $$TransactionsTableTableManager(_$BudgieDatabase db, $TransactionsTable table) : super(
      TableManagerState(
        db: db,
        table: table,
        createFilteringComposer: () => $$TransactionsTableFilterComposer($db: db,$table:table),
        createOrderingComposer: () => $$TransactionsTableOrderingComposer($db: db,$table:table),
        createComputedFieldComposer: () => $$TransactionsTableAnnotationComposer($db: db,$table:table),
        updateCompanionCallback: ({Value<int> id = const Value.absent(),Value<String> title = const Value.absent(),Value<double> value = const Value.absent(),Value<DateTime> createdAt = const Value.absent(),Value<bool> isExpense = const Value.absent(),})=> TransactionsCompanion(id: id,title: title,value: value,createdAt: createdAt,isExpense: isExpense,),
        createCompanionCallback: ({Value<int> id = const Value.absent(),required String title,required double value,required DateTime createdAt,required bool isExpense,})=> TransactionsCompanion.insert(id: id,title: title,value: value,createdAt: createdAt,isExpense: isExpense,),
        withReferenceMapper: (p0) => p0
              .map(
                  (e) =>
                     (e.readTable(table), BaseReferences(db, table, e))
                  )
              .toList(),
        prefetchHooksCallback: null,
        ));
        }
    typedef $$TransactionsTableProcessedTableManager = ProcessedTableManager    <_$BudgieDatabase,
    $TransactionsTable,
    Transaction,
    $$TransactionsTableFilterComposer,
    $$TransactionsTableOrderingComposer,
    $$TransactionsTableAnnotationComposer,
    $$TransactionsTableCreateCompanionBuilder,
    $$TransactionsTableUpdateCompanionBuilder,
    (Transaction,BaseReferences<_$BudgieDatabase,$TransactionsTable,Transaction>),
    Transaction,
    PrefetchHooks Function()
    >;class $BudgieDatabaseManager {
final _$BudgieDatabase _db;
$BudgieDatabaseManager(this._db);
$$TransactionsTableTableManager get transactions => $$TransactionsTableTableManager(_db, _db.transactions);
}
