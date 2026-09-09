// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $RoutineItemsTable extends RoutineItems
    with TableInfo<$RoutineItemsTable, RoutineItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RoutineItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sphereMeta = const VerificationMeta('sphere');
  @override
  late final GeneratedColumn<String> sphere = GeneratedColumn<String>(
    'sphere',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _weekdaysMeta = const VerificationMeta(
    'weekdays',
  );
  @override
  late final GeneratedColumn<int> weekdays = GeneratedColumn<int>(
    'weekdays',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _scheduledMinuteOfDayMeta =
      const VerificationMeta('scheduledMinuteOfDay');
  @override
  late final GeneratedColumn<int> scheduledMinuteOfDay = GeneratedColumn<int>(
    'scheduled_minute_of_day',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _effortMeta = const VerificationMeta('effort');
  @override
  late final GeneratedColumn<int> effort = GeneratedColumn<int>(
    'effort',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _isOptionalMeta = const VerificationMeta(
    'isOptional',
  );
  @override
  late final GeneratedColumn<bool> isOptional = GeneratedColumn<bool>(
    'is_optional',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_optional" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    title,
    sphere,
    weekdays,
    sortOrder,
    scheduledMinuteOfDay,
    effort,
    isOptional,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'routine_items';
  @override
  VerificationContext validateIntegrity(
    Insertable<RoutineItem> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('sphere')) {
      context.handle(
        _sphereMeta,
        sphere.isAcceptableOrUnknown(data['sphere']!, _sphereMeta),
      );
    } else if (isInserting) {
      context.missing(_sphereMeta);
    }
    if (data.containsKey('weekdays')) {
      context.handle(
        _weekdaysMeta,
        weekdays.isAcceptableOrUnknown(data['weekdays']!, _weekdaysMeta),
      );
    } else if (isInserting) {
      context.missing(_weekdaysMeta);
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    }
    if (data.containsKey('scheduled_minute_of_day')) {
      context.handle(
        _scheduledMinuteOfDayMeta,
        scheduledMinuteOfDay.isAcceptableOrUnknown(
          data['scheduled_minute_of_day']!,
          _scheduledMinuteOfDayMeta,
        ),
      );
    }
    if (data.containsKey('effort')) {
      context.handle(
        _effortMeta,
        effort.isAcceptableOrUnknown(data['effort']!, _effortMeta),
      );
    }
    if (data.containsKey('is_optional')) {
      context.handle(
        _isOptionalMeta,
        isOptional.isAcceptableOrUnknown(data['is_optional']!, _isOptionalMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  RoutineItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RoutineItem(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      sphere: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sphere'],
      )!,
      weekdays: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}weekdays'],
      )!,
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
      scheduledMinuteOfDay: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}scheduled_minute_of_day'],
      ),
      effort: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}effort'],
      )!,
      isOptional: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_optional'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $RoutineItemsTable createAlias(String alias) {
    return $RoutineItemsTable(attachedDatabase, alias);
  }
}

class RoutineItem extends DataClass implements Insertable<RoutineItem> {
  final int id;
  final String title;
  final String sphere;
  final int weekdays;
  final int sortOrder;

  /// Minutes from midnight (0–1439). Null = no fixed time on the timeline.
  final int? scheduledMinuteOfDay;
  final int effort;
  final bool isOptional;
  final DateTime createdAt;
  const RoutineItem({
    required this.id,
    required this.title,
    required this.sphere,
    required this.weekdays,
    required this.sortOrder,
    this.scheduledMinuteOfDay,
    required this.effort,
    required this.isOptional,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['title'] = Variable<String>(title);
    map['sphere'] = Variable<String>(sphere);
    map['weekdays'] = Variable<int>(weekdays);
    map['sort_order'] = Variable<int>(sortOrder);
    if (!nullToAbsent || scheduledMinuteOfDay != null) {
      map['scheduled_minute_of_day'] = Variable<int>(scheduledMinuteOfDay);
    }
    map['effort'] = Variable<int>(effort);
    map['is_optional'] = Variable<bool>(isOptional);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  RoutineItemsCompanion toCompanion(bool nullToAbsent) {
    return RoutineItemsCompanion(
      id: Value(id),
      title: Value(title),
      sphere: Value(sphere),
      weekdays: Value(weekdays),
      sortOrder: Value(sortOrder),
      scheduledMinuteOfDay: scheduledMinuteOfDay == null && nullToAbsent
          ? const Value.absent()
          : Value(scheduledMinuteOfDay),
      effort: Value(effort),
      isOptional: Value(isOptional),
      createdAt: Value(createdAt),
    );
  }

  factory RoutineItem.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RoutineItem(
      id: serializer.fromJson<int>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      sphere: serializer.fromJson<String>(json['sphere']),
      weekdays: serializer.fromJson<int>(json['weekdays']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
      scheduledMinuteOfDay: serializer.fromJson<int?>(
        json['scheduledMinuteOfDay'],
      ),
      effort: serializer.fromJson<int>(json['effort']),
      isOptional: serializer.fromJson<bool>(json['isOptional']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'title': serializer.toJson<String>(title),
      'sphere': serializer.toJson<String>(sphere),
      'weekdays': serializer.toJson<int>(weekdays),
      'sortOrder': serializer.toJson<int>(sortOrder),
      'scheduledMinuteOfDay': serializer.toJson<int?>(scheduledMinuteOfDay),
      'effort': serializer.toJson<int>(effort),
      'isOptional': serializer.toJson<bool>(isOptional),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  RoutineItem copyWith({
    int? id,
    String? title,
    String? sphere,
    int? weekdays,
    int? sortOrder,
    Value<int?> scheduledMinuteOfDay = const Value.absent(),
    int? effort,
    bool? isOptional,
    DateTime? createdAt,
  }) => RoutineItem(
    id: id ?? this.id,
    title: title ?? this.title,
    sphere: sphere ?? this.sphere,
    weekdays: weekdays ?? this.weekdays,
    sortOrder: sortOrder ?? this.sortOrder,
    scheduledMinuteOfDay: scheduledMinuteOfDay.present
        ? scheduledMinuteOfDay.value
        : this.scheduledMinuteOfDay,
    effort: effort ?? this.effort,
    isOptional: isOptional ?? this.isOptional,
    createdAt: createdAt ?? this.createdAt,
  );
  RoutineItem copyWithCompanion(RoutineItemsCompanion data) {
    return RoutineItem(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      sphere: data.sphere.present ? data.sphere.value : this.sphere,
      weekdays: data.weekdays.present ? data.weekdays.value : this.weekdays,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
      scheduledMinuteOfDay: data.scheduledMinuteOfDay.present
          ? data.scheduledMinuteOfDay.value
          : this.scheduledMinuteOfDay,
      effort: data.effort.present ? data.effort.value : this.effort,
      isOptional: data.isOptional.present
          ? data.isOptional.value
          : this.isOptional,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RoutineItem(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('sphere: $sphere, ')
          ..write('weekdays: $weekdays, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('scheduledMinuteOfDay: $scheduledMinuteOfDay, ')
          ..write('effort: $effort, ')
          ..write('isOptional: $isOptional, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    title,
    sphere,
    weekdays,
    sortOrder,
    scheduledMinuteOfDay,
    effort,
    isOptional,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RoutineItem &&
          other.id == this.id &&
          other.title == this.title &&
          other.sphere == this.sphere &&
          other.weekdays == this.weekdays &&
          other.sortOrder == this.sortOrder &&
          other.scheduledMinuteOfDay == this.scheduledMinuteOfDay &&
          other.effort == this.effort &&
          other.isOptional == this.isOptional &&
          other.createdAt == this.createdAt);
}

class RoutineItemsCompanion extends UpdateCompanion<RoutineItem> {
  final Value<int> id;
  final Value<String> title;
  final Value<String> sphere;
  final Value<int> weekdays;
  final Value<int> sortOrder;
  final Value<int?> scheduledMinuteOfDay;
  final Value<int> effort;
  final Value<bool> isOptional;
  final Value<DateTime> createdAt;
  const RoutineItemsCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.sphere = const Value.absent(),
    this.weekdays = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.scheduledMinuteOfDay = const Value.absent(),
    this.effort = const Value.absent(),
    this.isOptional = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  RoutineItemsCompanion.insert({
    this.id = const Value.absent(),
    required String title,
    required String sphere,
    required int weekdays,
    this.sortOrder = const Value.absent(),
    this.scheduledMinuteOfDay = const Value.absent(),
    this.effort = const Value.absent(),
    this.isOptional = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : title = Value(title),
       sphere = Value(sphere),
       weekdays = Value(weekdays);
  static Insertable<RoutineItem> custom({
    Expression<int>? id,
    Expression<String>? title,
    Expression<String>? sphere,
    Expression<int>? weekdays,
    Expression<int>? sortOrder,
    Expression<int>? scheduledMinuteOfDay,
    Expression<int>? effort,
    Expression<bool>? isOptional,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (sphere != null) 'sphere': sphere,
      if (weekdays != null) 'weekdays': weekdays,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (scheduledMinuteOfDay != null)
        'scheduled_minute_of_day': scheduledMinuteOfDay,
      if (effort != null) 'effort': effort,
      if (isOptional != null) 'is_optional': isOptional,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  RoutineItemsCompanion copyWith({
    Value<int>? id,
    Value<String>? title,
    Value<String>? sphere,
    Value<int>? weekdays,
    Value<int>? sortOrder,
    Value<int?>? scheduledMinuteOfDay,
    Value<int>? effort,
    Value<bool>? isOptional,
    Value<DateTime>? createdAt,
  }) {
    return RoutineItemsCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      sphere: sphere ?? this.sphere,
      weekdays: weekdays ?? this.weekdays,
      sortOrder: sortOrder ?? this.sortOrder,
      scheduledMinuteOfDay: scheduledMinuteOfDay ?? this.scheduledMinuteOfDay,
      effort: effort ?? this.effort,
      isOptional: isOptional ?? this.isOptional,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (sphere.present) {
      map['sphere'] = Variable<String>(sphere.value);
    }
    if (weekdays.present) {
      map['weekdays'] = Variable<int>(weekdays.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (scheduledMinuteOfDay.present) {
      map['scheduled_minute_of_day'] = Variable<int>(
        scheduledMinuteOfDay.value,
      );
    }
    if (effort.present) {
      map['effort'] = Variable<int>(effort.value);
    }
    if (isOptional.present) {
      map['is_optional'] = Variable<bool>(isOptional.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RoutineItemsCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('sphere: $sphere, ')
          ..write('weekdays: $weekdays, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('scheduledMinuteOfDay: $scheduledMinuteOfDay, ')
          ..write('effort: $effort, ')
          ..write('isOptional: $isOptional, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $RoutineDayStatesTable extends RoutineDayStates
    with TableInfo<$RoutineDayStatesTable, RoutineDayState> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RoutineDayStatesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _routineItemIdMeta = const VerificationMeta(
    'routineItemId',
  );
  @override
  late final GeneratedColumn<int> routineItemId = GeneratedColumn<int>(
    'routine_item_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES routine_items (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _dateKeyMeta = const VerificationMeta(
    'dateKey',
  );
  @override
  late final GeneratedColumn<String> dateKey = GeneratedColumn<String>(
    'date_key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<int> status = GeneratedColumn<int>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [id, routineItemId, dateKey, status];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'routine_day_states';
  @override
  VerificationContext validateIntegrity(
    Insertable<RoutineDayState> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('routine_item_id')) {
      context.handle(
        _routineItemIdMeta,
        routineItemId.isAcceptableOrUnknown(
          data['routine_item_id']!,
          _routineItemIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_routineItemIdMeta);
    }
    if (data.containsKey('date_key')) {
      context.handle(
        _dateKeyMeta,
        dateKey.isAcceptableOrUnknown(data['date_key']!, _dateKeyMeta),
      );
    } else if (isInserting) {
      context.missing(_dateKeyMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {routineItemId, dateKey},
  ];
  @override
  RoutineDayState map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RoutineDayState(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      routineItemId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}routine_item_id'],
      )!,
      dateKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}date_key'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}status'],
      )!,
    );
  }

  @override
  $RoutineDayStatesTable createAlias(String alias) {
    return $RoutineDayStatesTable(attachedDatabase, alias);
  }
}

class RoutineDayState extends DataClass implements Insertable<RoutineDayState> {
  final int id;
  final int routineItemId;
  final String dateKey;

  /// 0 = pending, 1 = done, 2 = skipped
  final int status;
  const RoutineDayState({
    required this.id,
    required this.routineItemId,
    required this.dateKey,
    required this.status,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['routine_item_id'] = Variable<int>(routineItemId);
    map['date_key'] = Variable<String>(dateKey);
    map['status'] = Variable<int>(status);
    return map;
  }

  RoutineDayStatesCompanion toCompanion(bool nullToAbsent) {
    return RoutineDayStatesCompanion(
      id: Value(id),
      routineItemId: Value(routineItemId),
      dateKey: Value(dateKey),
      status: Value(status),
    );
  }

  factory RoutineDayState.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RoutineDayState(
      id: serializer.fromJson<int>(json['id']),
      routineItemId: serializer.fromJson<int>(json['routineItemId']),
      dateKey: serializer.fromJson<String>(json['dateKey']),
      status: serializer.fromJson<int>(json['status']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'routineItemId': serializer.toJson<int>(routineItemId),
      'dateKey': serializer.toJson<String>(dateKey),
      'status': serializer.toJson<int>(status),
    };
  }

  RoutineDayState copyWith({
    int? id,
    int? routineItemId,
    String? dateKey,
    int? status,
  }) => RoutineDayState(
    id: id ?? this.id,
    routineItemId: routineItemId ?? this.routineItemId,
    dateKey: dateKey ?? this.dateKey,
    status: status ?? this.status,
  );
  RoutineDayState copyWithCompanion(RoutineDayStatesCompanion data) {
    return RoutineDayState(
      id: data.id.present ? data.id.value : this.id,
      routineItemId: data.routineItemId.present
          ? data.routineItemId.value
          : this.routineItemId,
      dateKey: data.dateKey.present ? data.dateKey.value : this.dateKey,
      status: data.status.present ? data.status.value : this.status,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RoutineDayState(')
          ..write('id: $id, ')
          ..write('routineItemId: $routineItemId, ')
          ..write('dateKey: $dateKey, ')
          ..write('status: $status')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, routineItemId, dateKey, status);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RoutineDayState &&
          other.id == this.id &&
          other.routineItemId == this.routineItemId &&
          other.dateKey == this.dateKey &&
          other.status == this.status);
}

class RoutineDayStatesCompanion extends UpdateCompanion<RoutineDayState> {
  final Value<int> id;
  final Value<int> routineItemId;
  final Value<String> dateKey;
  final Value<int> status;
  const RoutineDayStatesCompanion({
    this.id = const Value.absent(),
    this.routineItemId = const Value.absent(),
    this.dateKey = const Value.absent(),
    this.status = const Value.absent(),
  });
  RoutineDayStatesCompanion.insert({
    this.id = const Value.absent(),
    required int routineItemId,
    required String dateKey,
    this.status = const Value.absent(),
  }) : routineItemId = Value(routineItemId),
       dateKey = Value(dateKey);
  static Insertable<RoutineDayState> custom({
    Expression<int>? id,
    Expression<int>? routineItemId,
    Expression<String>? dateKey,
    Expression<int>? status,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (routineItemId != null) 'routine_item_id': routineItemId,
      if (dateKey != null) 'date_key': dateKey,
      if (status != null) 'status': status,
    });
  }

  RoutineDayStatesCompanion copyWith({
    Value<int>? id,
    Value<int>? routineItemId,
    Value<String>? dateKey,
    Value<int>? status,
  }) {
    return RoutineDayStatesCompanion(
      id: id ?? this.id,
      routineItemId: routineItemId ?? this.routineItemId,
      dateKey: dateKey ?? this.dateKey,
      status: status ?? this.status,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (routineItemId.present) {
      map['routine_item_id'] = Variable<int>(routineItemId.value);
    }
    if (dateKey.present) {
      map['date_key'] = Variable<String>(dateKey.value);
    }
    if (status.present) {
      map['status'] = Variable<int>(status.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RoutineDayStatesCompanion(')
          ..write('id: $id, ')
          ..write('routineItemId: $routineItemId, ')
          ..write('dateKey: $dateKey, ')
          ..write('status: $status')
          ..write(')'))
        .toString();
  }
}

class $WeeklyGoalsTable extends WeeklyGoals
    with TableInfo<$WeeklyGoalsTable, WeeklyGoal> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WeeklyGoalsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _weekKeyMeta = const VerificationMeta(
    'weekKey',
  );
  @override
  late final GeneratedColumn<String> weekKey = GeneratedColumn<String>(
    'week_key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sphereMeta = const VerificationMeta('sphere');
  @override
  late final GeneratedColumn<String> sphere = GeneratedColumn<String>(
    'sphere',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _targetCountMeta = const VerificationMeta(
    'targetCount',
  );
  @override
  late final GeneratedColumn<int> targetCount = GeneratedColumn<int>(
    'target_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _progressCountMeta = const VerificationMeta(
    'progressCount',
  );
  @override
  late final GeneratedColumn<int> progressCount = GeneratedColumn<int>(
    'progress_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<int> status = GeneratedColumn<int>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    weekKey,
    sphere,
    title,
    targetCount,
    progressCount,
    status,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'weekly_goals';
  @override
  VerificationContext validateIntegrity(
    Insertable<WeeklyGoal> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('week_key')) {
      context.handle(
        _weekKeyMeta,
        weekKey.isAcceptableOrUnknown(data['week_key']!, _weekKeyMeta),
      );
    } else if (isInserting) {
      context.missing(_weekKeyMeta);
    }
    if (data.containsKey('sphere')) {
      context.handle(
        _sphereMeta,
        sphere.isAcceptableOrUnknown(data['sphere']!, _sphereMeta),
      );
    } else if (isInserting) {
      context.missing(_sphereMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('target_count')) {
      context.handle(
        _targetCountMeta,
        targetCount.isAcceptableOrUnknown(
          data['target_count']!,
          _targetCountMeta,
        ),
      );
    }
    if (data.containsKey('progress_count')) {
      context.handle(
        _progressCountMeta,
        progressCount.isAcceptableOrUnknown(
          data['progress_count']!,
          _progressCountMeta,
        ),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  WeeklyGoal map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WeeklyGoal(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      weekKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}week_key'],
      )!,
      sphere: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sphere'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      targetCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}target_count'],
      )!,
      progressCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}progress_count'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}status'],
      )!,
    );
  }

  @override
  $WeeklyGoalsTable createAlias(String alias) {
    return $WeeklyGoalsTable(attachedDatabase, alias);
  }
}

class WeeklyGoal extends DataClass implements Insertable<WeeklyGoal> {
  final int id;
  final String weekKey;
  final String sphere;
  final String title;
  final int targetCount;
  final int progressCount;
  final int status;
  const WeeklyGoal({
    required this.id,
    required this.weekKey,
    required this.sphere,
    required this.title,
    required this.targetCount,
    required this.progressCount,
    required this.status,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['week_key'] = Variable<String>(weekKey);
    map['sphere'] = Variable<String>(sphere);
    map['title'] = Variable<String>(title);
    map['target_count'] = Variable<int>(targetCount);
    map['progress_count'] = Variable<int>(progressCount);
    map['status'] = Variable<int>(status);
    return map;
  }

  WeeklyGoalsCompanion toCompanion(bool nullToAbsent) {
    return WeeklyGoalsCompanion(
      id: Value(id),
      weekKey: Value(weekKey),
      sphere: Value(sphere),
      title: Value(title),
      targetCount: Value(targetCount),
      progressCount: Value(progressCount),
      status: Value(status),
    );
  }

  factory WeeklyGoal.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WeeklyGoal(
      id: serializer.fromJson<int>(json['id']),
      weekKey: serializer.fromJson<String>(json['weekKey']),
      sphere: serializer.fromJson<String>(json['sphere']),
      title: serializer.fromJson<String>(json['title']),
      targetCount: serializer.fromJson<int>(json['targetCount']),
      progressCount: serializer.fromJson<int>(json['progressCount']),
      status: serializer.fromJson<int>(json['status']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'weekKey': serializer.toJson<String>(weekKey),
      'sphere': serializer.toJson<String>(sphere),
      'title': serializer.toJson<String>(title),
      'targetCount': serializer.toJson<int>(targetCount),
      'progressCount': serializer.toJson<int>(progressCount),
      'status': serializer.toJson<int>(status),
    };
  }

  WeeklyGoal copyWith({
    int? id,
    String? weekKey,
    String? sphere,
    String? title,
    int? targetCount,
    int? progressCount,
    int? status,
  }) => WeeklyGoal(
    id: id ?? this.id,
    weekKey: weekKey ?? this.weekKey,
    sphere: sphere ?? this.sphere,
    title: title ?? this.title,
    targetCount: targetCount ?? this.targetCount,
    progressCount: progressCount ?? this.progressCount,
    status: status ?? this.status,
  );
  WeeklyGoal copyWithCompanion(WeeklyGoalsCompanion data) {
    return WeeklyGoal(
      id: data.id.present ? data.id.value : this.id,
      weekKey: data.weekKey.present ? data.weekKey.value : this.weekKey,
      sphere: data.sphere.present ? data.sphere.value : this.sphere,
      title: data.title.present ? data.title.value : this.title,
      targetCount: data.targetCount.present
          ? data.targetCount.value
          : this.targetCount,
      progressCount: data.progressCount.present
          ? data.progressCount.value
          : this.progressCount,
      status: data.status.present ? data.status.value : this.status,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WeeklyGoal(')
          ..write('id: $id, ')
          ..write('weekKey: $weekKey, ')
          ..write('sphere: $sphere, ')
          ..write('title: $title, ')
          ..write('targetCount: $targetCount, ')
          ..write('progressCount: $progressCount, ')
          ..write('status: $status')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    weekKey,
    sphere,
    title,
    targetCount,
    progressCount,
    status,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WeeklyGoal &&
          other.id == this.id &&
          other.weekKey == this.weekKey &&
          other.sphere == this.sphere &&
          other.title == this.title &&
          other.targetCount == this.targetCount &&
          other.progressCount == this.progressCount &&
          other.status == this.status);
}

class WeeklyGoalsCompanion extends UpdateCompanion<WeeklyGoal> {
  final Value<int> id;
  final Value<String> weekKey;
  final Value<String> sphere;
  final Value<String> title;
  final Value<int> targetCount;
  final Value<int> progressCount;
  final Value<int> status;
  const WeeklyGoalsCompanion({
    this.id = const Value.absent(),
    this.weekKey = const Value.absent(),
    this.sphere = const Value.absent(),
    this.title = const Value.absent(),
    this.targetCount = const Value.absent(),
    this.progressCount = const Value.absent(),
    this.status = const Value.absent(),
  });
  WeeklyGoalsCompanion.insert({
    this.id = const Value.absent(),
    required String weekKey,
    required String sphere,
    required String title,
    this.targetCount = const Value.absent(),
    this.progressCount = const Value.absent(),
    this.status = const Value.absent(),
  }) : weekKey = Value(weekKey),
       sphere = Value(sphere),
       title = Value(title);
  static Insertable<WeeklyGoal> custom({
    Expression<int>? id,
    Expression<String>? weekKey,
    Expression<String>? sphere,
    Expression<String>? title,
    Expression<int>? targetCount,
    Expression<int>? progressCount,
    Expression<int>? status,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (weekKey != null) 'week_key': weekKey,
      if (sphere != null) 'sphere': sphere,
      if (title != null) 'title': title,
      if (targetCount != null) 'target_count': targetCount,
      if (progressCount != null) 'progress_count': progressCount,
      if (status != null) 'status': status,
    });
  }

  WeeklyGoalsCompanion copyWith({
    Value<int>? id,
    Value<String>? weekKey,
    Value<String>? sphere,
    Value<String>? title,
    Value<int>? targetCount,
    Value<int>? progressCount,
    Value<int>? status,
  }) {
    return WeeklyGoalsCompanion(
      id: id ?? this.id,
      weekKey: weekKey ?? this.weekKey,
      sphere: sphere ?? this.sphere,
      title: title ?? this.title,
      targetCount: targetCount ?? this.targetCount,
      progressCount: progressCount ?? this.progressCount,
      status: status ?? this.status,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (weekKey.present) {
      map['week_key'] = Variable<String>(weekKey.value);
    }
    if (sphere.present) {
      map['sphere'] = Variable<String>(sphere.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (targetCount.present) {
      map['target_count'] = Variable<int>(targetCount.value);
    }
    if (progressCount.present) {
      map['progress_count'] = Variable<int>(progressCount.value);
    }
    if (status.present) {
      map['status'] = Variable<int>(status.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WeeklyGoalsCompanion(')
          ..write('id: $id, ')
          ..write('weekKey: $weekKey, ')
          ..write('sphere: $sphere, ')
          ..write('title: $title, ')
          ..write('targetCount: $targetCount, ')
          ..write('progressCount: $progressCount, ')
          ..write('status: $status')
          ..write(')'))
        .toString();
  }
}

class $DailyReportsTable extends DailyReports
    with TableInfo<$DailyReportsTable, DailyReport> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DailyReportsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _dayKeyMeta = const VerificationMeta('dayKey');
  @override
  late final GeneratedColumn<String> dayKey = GeneratedColumn<String>(
    'day_key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _moodMeta = const VerificationMeta('mood');
  @override
  late final GeneratedColumn<int> mood = GeneratedColumn<int>(
    'mood',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _noteHighlightMeta = const VerificationMeta(
    'noteHighlight',
  );
  @override
  late final GeneratedColumn<String> noteHighlight = GeneratedColumn<String>(
    'note_highlight',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _noteReflectionMeta = const VerificationMeta(
    'noteReflection',
  );
  @override
  late final GeneratedColumn<String> noteReflection = GeneratedColumn<String>(
    'note_reflection',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dayTierMeta = const VerificationMeta(
    'dayTier',
  );
  @override
  late final GeneratedColumn<int> dayTier = GeneratedColumn<int>(
    'day_tier',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _xpAwardedMeta = const VerificationMeta(
    'xpAwarded',
  );
  @override
  late final GeneratedColumn<int> xpAwarded = GeneratedColumn<int>(
    'xp_awarded',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _closedAtMeta = const VerificationMeta(
    'closedAt',
  );
  @override
  late final GeneratedColumn<DateTime> closedAt = GeneratedColumn<DateTime>(
    'closed_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    dayKey,
    mood,
    noteHighlight,
    noteReflection,
    dayTier,
    xpAwarded,
    closedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'daily_reports';
  @override
  VerificationContext validateIntegrity(
    Insertable<DailyReport> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('day_key')) {
      context.handle(
        _dayKeyMeta,
        dayKey.isAcceptableOrUnknown(data['day_key']!, _dayKeyMeta),
      );
    } else if (isInserting) {
      context.missing(_dayKeyMeta);
    }
    if (data.containsKey('mood')) {
      context.handle(
        _moodMeta,
        mood.isAcceptableOrUnknown(data['mood']!, _moodMeta),
      );
    }
    if (data.containsKey('note_highlight')) {
      context.handle(
        _noteHighlightMeta,
        noteHighlight.isAcceptableOrUnknown(
          data['note_highlight']!,
          _noteHighlightMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_noteHighlightMeta);
    }
    if (data.containsKey('note_reflection')) {
      context.handle(
        _noteReflectionMeta,
        noteReflection.isAcceptableOrUnknown(
          data['note_reflection']!,
          _noteReflectionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_noteReflectionMeta);
    }
    if (data.containsKey('day_tier')) {
      context.handle(
        _dayTierMeta,
        dayTier.isAcceptableOrUnknown(data['day_tier']!, _dayTierMeta),
      );
    } else if (isInserting) {
      context.missing(_dayTierMeta);
    }
    if (data.containsKey('xp_awarded')) {
      context.handle(
        _xpAwardedMeta,
        xpAwarded.isAcceptableOrUnknown(data['xp_awarded']!, _xpAwardedMeta),
      );
    } else if (isInserting) {
      context.missing(_xpAwardedMeta);
    }
    if (data.containsKey('closed_at')) {
      context.handle(
        _closedAtMeta,
        closedAt.isAcceptableOrUnknown(data['closed_at']!, _closedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DailyReport map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DailyReport(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      dayKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}day_key'],
      )!,
      mood: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}mood'],
      ),
      noteHighlight: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note_highlight'],
      )!,
      noteReflection: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note_reflection'],
      )!,
      dayTier: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}day_tier'],
      )!,
      xpAwarded: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}xp_awarded'],
      )!,
      closedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}closed_at'],
      )!,
    );
  }

  @override
  $DailyReportsTable createAlias(String alias) {
    return $DailyReportsTable(attachedDatabase, alias);
  }
}

class DailyReport extends DataClass implements Insertable<DailyReport> {
  final int id;
  final String dayKey;
  final int? mood;
  final String noteHighlight;
  final String noteReflection;
  final int dayTier;
  final int xpAwarded;
  final DateTime closedAt;
  const DailyReport({
    required this.id,
    required this.dayKey,
    this.mood,
    required this.noteHighlight,
    required this.noteReflection,
    required this.dayTier,
    required this.xpAwarded,
    required this.closedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['day_key'] = Variable<String>(dayKey);
    if (!nullToAbsent || mood != null) {
      map['mood'] = Variable<int>(mood);
    }
    map['note_highlight'] = Variable<String>(noteHighlight);
    map['note_reflection'] = Variable<String>(noteReflection);
    map['day_tier'] = Variable<int>(dayTier);
    map['xp_awarded'] = Variable<int>(xpAwarded);
    map['closed_at'] = Variable<DateTime>(closedAt);
    return map;
  }

  DailyReportsCompanion toCompanion(bool nullToAbsent) {
    return DailyReportsCompanion(
      id: Value(id),
      dayKey: Value(dayKey),
      mood: mood == null && nullToAbsent ? const Value.absent() : Value(mood),
      noteHighlight: Value(noteHighlight),
      noteReflection: Value(noteReflection),
      dayTier: Value(dayTier),
      xpAwarded: Value(xpAwarded),
      closedAt: Value(closedAt),
    );
  }

  factory DailyReport.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DailyReport(
      id: serializer.fromJson<int>(json['id']),
      dayKey: serializer.fromJson<String>(json['dayKey']),
      mood: serializer.fromJson<int?>(json['mood']),
      noteHighlight: serializer.fromJson<String>(json['noteHighlight']),
      noteReflection: serializer.fromJson<String>(json['noteReflection']),
      dayTier: serializer.fromJson<int>(json['dayTier']),
      xpAwarded: serializer.fromJson<int>(json['xpAwarded']),
      closedAt: serializer.fromJson<DateTime>(json['closedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'dayKey': serializer.toJson<String>(dayKey),
      'mood': serializer.toJson<int?>(mood),
      'noteHighlight': serializer.toJson<String>(noteHighlight),
      'noteReflection': serializer.toJson<String>(noteReflection),
      'dayTier': serializer.toJson<int>(dayTier),
      'xpAwarded': serializer.toJson<int>(xpAwarded),
      'closedAt': serializer.toJson<DateTime>(closedAt),
    };
  }

  DailyReport copyWith({
    int? id,
    String? dayKey,
    Value<int?> mood = const Value.absent(),
    String? noteHighlight,
    String? noteReflection,
    int? dayTier,
    int? xpAwarded,
    DateTime? closedAt,
  }) => DailyReport(
    id: id ?? this.id,
    dayKey: dayKey ?? this.dayKey,
    mood: mood.present ? mood.value : this.mood,
    noteHighlight: noteHighlight ?? this.noteHighlight,
    noteReflection: noteReflection ?? this.noteReflection,
    dayTier: dayTier ?? this.dayTier,
    xpAwarded: xpAwarded ?? this.xpAwarded,
    closedAt: closedAt ?? this.closedAt,
  );
  DailyReport copyWithCompanion(DailyReportsCompanion data) {
    return DailyReport(
      id: data.id.present ? data.id.value : this.id,
      dayKey: data.dayKey.present ? data.dayKey.value : this.dayKey,
      mood: data.mood.present ? data.mood.value : this.mood,
      noteHighlight: data.noteHighlight.present
          ? data.noteHighlight.value
          : this.noteHighlight,
      noteReflection: data.noteReflection.present
          ? data.noteReflection.value
          : this.noteReflection,
      dayTier: data.dayTier.present ? data.dayTier.value : this.dayTier,
      xpAwarded: data.xpAwarded.present ? data.xpAwarded.value : this.xpAwarded,
      closedAt: data.closedAt.present ? data.closedAt.value : this.closedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DailyReport(')
          ..write('id: $id, ')
          ..write('dayKey: $dayKey, ')
          ..write('mood: $mood, ')
          ..write('noteHighlight: $noteHighlight, ')
          ..write('noteReflection: $noteReflection, ')
          ..write('dayTier: $dayTier, ')
          ..write('xpAwarded: $xpAwarded, ')
          ..write('closedAt: $closedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    dayKey,
    mood,
    noteHighlight,
    noteReflection,
    dayTier,
    xpAwarded,
    closedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DailyReport &&
          other.id == this.id &&
          other.dayKey == this.dayKey &&
          other.mood == this.mood &&
          other.noteHighlight == this.noteHighlight &&
          other.noteReflection == this.noteReflection &&
          other.dayTier == this.dayTier &&
          other.xpAwarded == this.xpAwarded &&
          other.closedAt == this.closedAt);
}

class DailyReportsCompanion extends UpdateCompanion<DailyReport> {
  final Value<int> id;
  final Value<String> dayKey;
  final Value<int?> mood;
  final Value<String> noteHighlight;
  final Value<String> noteReflection;
  final Value<int> dayTier;
  final Value<int> xpAwarded;
  final Value<DateTime> closedAt;
  const DailyReportsCompanion({
    this.id = const Value.absent(),
    this.dayKey = const Value.absent(),
    this.mood = const Value.absent(),
    this.noteHighlight = const Value.absent(),
    this.noteReflection = const Value.absent(),
    this.dayTier = const Value.absent(),
    this.xpAwarded = const Value.absent(),
    this.closedAt = const Value.absent(),
  });
  DailyReportsCompanion.insert({
    this.id = const Value.absent(),
    required String dayKey,
    this.mood = const Value.absent(),
    required String noteHighlight,
    required String noteReflection,
    required int dayTier,
    required int xpAwarded,
    this.closedAt = const Value.absent(),
  }) : dayKey = Value(dayKey),
       noteHighlight = Value(noteHighlight),
       noteReflection = Value(noteReflection),
       dayTier = Value(dayTier),
       xpAwarded = Value(xpAwarded);
  static Insertable<DailyReport> custom({
    Expression<int>? id,
    Expression<String>? dayKey,
    Expression<int>? mood,
    Expression<String>? noteHighlight,
    Expression<String>? noteReflection,
    Expression<int>? dayTier,
    Expression<int>? xpAwarded,
    Expression<DateTime>? closedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (dayKey != null) 'day_key': dayKey,
      if (mood != null) 'mood': mood,
      if (noteHighlight != null) 'note_highlight': noteHighlight,
      if (noteReflection != null) 'note_reflection': noteReflection,
      if (dayTier != null) 'day_tier': dayTier,
      if (xpAwarded != null) 'xp_awarded': xpAwarded,
      if (closedAt != null) 'closed_at': closedAt,
    });
  }

  DailyReportsCompanion copyWith({
    Value<int>? id,
    Value<String>? dayKey,
    Value<int?>? mood,
    Value<String>? noteHighlight,
    Value<String>? noteReflection,
    Value<int>? dayTier,
    Value<int>? xpAwarded,
    Value<DateTime>? closedAt,
  }) {
    return DailyReportsCompanion(
      id: id ?? this.id,
      dayKey: dayKey ?? this.dayKey,
      mood: mood ?? this.mood,
      noteHighlight: noteHighlight ?? this.noteHighlight,
      noteReflection: noteReflection ?? this.noteReflection,
      dayTier: dayTier ?? this.dayTier,
      xpAwarded: xpAwarded ?? this.xpAwarded,
      closedAt: closedAt ?? this.closedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (dayKey.present) {
      map['day_key'] = Variable<String>(dayKey.value);
    }
    if (mood.present) {
      map['mood'] = Variable<int>(mood.value);
    }
    if (noteHighlight.present) {
      map['note_highlight'] = Variable<String>(noteHighlight.value);
    }
    if (noteReflection.present) {
      map['note_reflection'] = Variable<String>(noteReflection.value);
    }
    if (dayTier.present) {
      map['day_tier'] = Variable<int>(dayTier.value);
    }
    if (xpAwarded.present) {
      map['xp_awarded'] = Variable<int>(xpAwarded.value);
    }
    if (closedAt.present) {
      map['closed_at'] = Variable<DateTime>(closedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DailyReportsCompanion(')
          ..write('id: $id, ')
          ..write('dayKey: $dayKey, ')
          ..write('mood: $mood, ')
          ..write('noteHighlight: $noteHighlight, ')
          ..write('noteReflection: $noteReflection, ')
          ..write('dayTier: $dayTier, ')
          ..write('xpAwarded: $xpAwarded, ')
          ..write('closedAt: $closedAt')
          ..write(')'))
        .toString();
  }
}

class $WeeklyReportsTable extends WeeklyReports
    with TableInfo<$WeeklyReportsTable, WeeklyReport> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WeeklyReportsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _weekKeyMeta = const VerificationMeta(
    'weekKey',
  );
  @override
  late final GeneratedColumn<String> weekKey = GeneratedColumn<String>(
    'week_key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _noteWinMeta = const VerificationMeta(
    'noteWin',
  );
  @override
  late final GeneratedColumn<String> noteWin = GeneratedColumn<String>(
    'note_win',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _noteFocusMeta = const VerificationMeta(
    'noteFocus',
  );
  @override
  late final GeneratedColumn<String> noteFocus = GeneratedColumn<String>(
    'note_focus',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    weekKey,
    noteWin,
    noteFocus,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'weekly_reports';
  @override
  VerificationContext validateIntegrity(
    Insertable<WeeklyReport> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('week_key')) {
      context.handle(
        _weekKeyMeta,
        weekKey.isAcceptableOrUnknown(data['week_key']!, _weekKeyMeta),
      );
    } else if (isInserting) {
      context.missing(_weekKeyMeta);
    }
    if (data.containsKey('note_win')) {
      context.handle(
        _noteWinMeta,
        noteWin.isAcceptableOrUnknown(data['note_win']!, _noteWinMeta),
      );
    }
    if (data.containsKey('note_focus')) {
      context.handle(
        _noteFocusMeta,
        noteFocus.isAcceptableOrUnknown(data['note_focus']!, _noteFocusMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {weekKey};
  @override
  WeeklyReport map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WeeklyReport(
      weekKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}week_key'],
      )!,
      noteWin: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note_win'],
      )!,
      noteFocus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note_focus'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $WeeklyReportsTable createAlias(String alias) {
    return $WeeklyReportsTable(attachedDatabase, alias);
  }
}

class WeeklyReport extends DataClass implements Insertable<WeeklyReport> {
  final String weekKey;
  final String noteWin;
  final String noteFocus;
  final DateTime updatedAt;
  const WeeklyReport({
    required this.weekKey,
    required this.noteWin,
    required this.noteFocus,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['week_key'] = Variable<String>(weekKey);
    map['note_win'] = Variable<String>(noteWin);
    map['note_focus'] = Variable<String>(noteFocus);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  WeeklyReportsCompanion toCompanion(bool nullToAbsent) {
    return WeeklyReportsCompanion(
      weekKey: Value(weekKey),
      noteWin: Value(noteWin),
      noteFocus: Value(noteFocus),
      updatedAt: Value(updatedAt),
    );
  }

  factory WeeklyReport.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WeeklyReport(
      weekKey: serializer.fromJson<String>(json['weekKey']),
      noteWin: serializer.fromJson<String>(json['noteWin']),
      noteFocus: serializer.fromJson<String>(json['noteFocus']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'weekKey': serializer.toJson<String>(weekKey),
      'noteWin': serializer.toJson<String>(noteWin),
      'noteFocus': serializer.toJson<String>(noteFocus),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  WeeklyReport copyWith({
    String? weekKey,
    String? noteWin,
    String? noteFocus,
    DateTime? updatedAt,
  }) => WeeklyReport(
    weekKey: weekKey ?? this.weekKey,
    noteWin: noteWin ?? this.noteWin,
    noteFocus: noteFocus ?? this.noteFocus,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  WeeklyReport copyWithCompanion(WeeklyReportsCompanion data) {
    return WeeklyReport(
      weekKey: data.weekKey.present ? data.weekKey.value : this.weekKey,
      noteWin: data.noteWin.present ? data.noteWin.value : this.noteWin,
      noteFocus: data.noteFocus.present ? data.noteFocus.value : this.noteFocus,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WeeklyReport(')
          ..write('weekKey: $weekKey, ')
          ..write('noteWin: $noteWin, ')
          ..write('noteFocus: $noteFocus, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(weekKey, noteWin, noteFocus, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WeeklyReport &&
          other.weekKey == this.weekKey &&
          other.noteWin == this.noteWin &&
          other.noteFocus == this.noteFocus &&
          other.updatedAt == this.updatedAt);
}

class WeeklyReportsCompanion extends UpdateCompanion<WeeklyReport> {
  final Value<String> weekKey;
  final Value<String> noteWin;
  final Value<String> noteFocus;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const WeeklyReportsCompanion({
    this.weekKey = const Value.absent(),
    this.noteWin = const Value.absent(),
    this.noteFocus = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  WeeklyReportsCompanion.insert({
    required String weekKey,
    this.noteWin = const Value.absent(),
    this.noteFocus = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : weekKey = Value(weekKey);
  static Insertable<WeeklyReport> custom({
    Expression<String>? weekKey,
    Expression<String>? noteWin,
    Expression<String>? noteFocus,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (weekKey != null) 'week_key': weekKey,
      if (noteWin != null) 'note_win': noteWin,
      if (noteFocus != null) 'note_focus': noteFocus,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  WeeklyReportsCompanion copyWith({
    Value<String>? weekKey,
    Value<String>? noteWin,
    Value<String>? noteFocus,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return WeeklyReportsCompanion(
      weekKey: weekKey ?? this.weekKey,
      noteWin: noteWin ?? this.noteWin,
      noteFocus: noteFocus ?? this.noteFocus,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (weekKey.present) {
      map['week_key'] = Variable<String>(weekKey.value);
    }
    if (noteWin.present) {
      map['note_win'] = Variable<String>(noteWin.value);
    }
    if (noteFocus.present) {
      map['note_focus'] = Variable<String>(noteFocus.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WeeklyReportsCompanion(')
          ..write('weekKey: $weekKey, ')
          ..write('noteWin: $noteWin, ')
          ..write('noteFocus: $noteFocus, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $OwnedShopItemsTable extends OwnedShopItems
    with TableInfo<$OwnedShopItemsTable, OwnedShopItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $OwnedShopItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _itemIdMeta = const VerificationMeta('itemId');
  @override
  late final GeneratedColumn<String> itemId = GeneratedColumn<String>(
    'item_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _purchasedAtMeta = const VerificationMeta(
    'purchasedAt',
  );
  @override
  late final GeneratedColumn<DateTime> purchasedAt = GeneratedColumn<DateTime>(
    'purchased_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [itemId, purchasedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'owned_shop_items';
  @override
  VerificationContext validateIntegrity(
    Insertable<OwnedShopItem> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('item_id')) {
      context.handle(
        _itemIdMeta,
        itemId.isAcceptableOrUnknown(data['item_id']!, _itemIdMeta),
      );
    } else if (isInserting) {
      context.missing(_itemIdMeta);
    }
    if (data.containsKey('purchased_at')) {
      context.handle(
        _purchasedAtMeta,
        purchasedAt.isAcceptableOrUnknown(
          data['purchased_at']!,
          _purchasedAtMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {itemId};
  @override
  OwnedShopItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return OwnedShopItem(
      itemId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}item_id'],
      )!,
      purchasedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}purchased_at'],
      )!,
    );
  }

  @override
  $OwnedShopItemsTable createAlias(String alias) {
    return $OwnedShopItemsTable(attachedDatabase, alias);
  }
}

class OwnedShopItem extends DataClass implements Insertable<OwnedShopItem> {
  final String itemId;
  final DateTime purchasedAt;
  const OwnedShopItem({required this.itemId, required this.purchasedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['item_id'] = Variable<String>(itemId);
    map['purchased_at'] = Variable<DateTime>(purchasedAt);
    return map;
  }

  OwnedShopItemsCompanion toCompanion(bool nullToAbsent) {
    return OwnedShopItemsCompanion(
      itemId: Value(itemId),
      purchasedAt: Value(purchasedAt),
    );
  }

  factory OwnedShopItem.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return OwnedShopItem(
      itemId: serializer.fromJson<String>(json['itemId']),
      purchasedAt: serializer.fromJson<DateTime>(json['purchasedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'itemId': serializer.toJson<String>(itemId),
      'purchasedAt': serializer.toJson<DateTime>(purchasedAt),
    };
  }

  OwnedShopItem copyWith({String? itemId, DateTime? purchasedAt}) =>
      OwnedShopItem(
        itemId: itemId ?? this.itemId,
        purchasedAt: purchasedAt ?? this.purchasedAt,
      );
  OwnedShopItem copyWithCompanion(OwnedShopItemsCompanion data) {
    return OwnedShopItem(
      itemId: data.itemId.present ? data.itemId.value : this.itemId,
      purchasedAt: data.purchasedAt.present
          ? data.purchasedAt.value
          : this.purchasedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('OwnedShopItem(')
          ..write('itemId: $itemId, ')
          ..write('purchasedAt: $purchasedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(itemId, purchasedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is OwnedShopItem &&
          other.itemId == this.itemId &&
          other.purchasedAt == this.purchasedAt);
}

class OwnedShopItemsCompanion extends UpdateCompanion<OwnedShopItem> {
  final Value<String> itemId;
  final Value<DateTime> purchasedAt;
  final Value<int> rowid;
  const OwnedShopItemsCompanion({
    this.itemId = const Value.absent(),
    this.purchasedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  OwnedShopItemsCompanion.insert({
    required String itemId,
    this.purchasedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : itemId = Value(itemId);
  static Insertable<OwnedShopItem> custom({
    Expression<String>? itemId,
    Expression<DateTime>? purchasedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (itemId != null) 'item_id': itemId,
      if (purchasedAt != null) 'purchased_at': purchasedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  OwnedShopItemsCompanion copyWith({
    Value<String>? itemId,
    Value<DateTime>? purchasedAt,
    Value<int>? rowid,
  }) {
    return OwnedShopItemsCompanion(
      itemId: itemId ?? this.itemId,
      purchasedAt: purchasedAt ?? this.purchasedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (itemId.present) {
      map['item_id'] = Variable<String>(itemId.value);
    }
    if (purchasedAt.present) {
      map['purchased_at'] = Variable<DateTime>(purchasedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('OwnedShopItemsCompanion(')
          ..write('itemId: $itemId, ')
          ..write('purchasedAt: $purchasedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $UserStatsTable extends UserStats
    with TableInfo<$UserStatsTable, UserStat> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UserStatsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _totalXpMeta = const VerificationMeta(
    'totalXp',
  );
  @override
  late final GeneratedColumn<int> totalXp = GeneratedColumn<int>(
    'total_xp',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _currentStreakMeta = const VerificationMeta(
    'currentStreak',
  );
  @override
  late final GeneratedColumn<int> currentStreak = GeneratedColumn<int>(
    'current_streak',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _bestStreakMeta = const VerificationMeta(
    'bestStreak',
  );
  @override
  late final GeneratedColumn<int> bestStreak = GeneratedColumn<int>(
    'best_streak',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _lastGreenDayKeyMeta = const VerificationMeta(
    'lastGreenDayKey',
  );
  @override
  late final GeneratedColumn<String> lastGreenDayKey = GeneratedColumn<String>(
    'last_green_day_key',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    totalXp,
    currentStreak,
    bestStreak,
    lastGreenDayKey,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'user_stats';
  @override
  VerificationContext validateIntegrity(
    Insertable<UserStat> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('total_xp')) {
      context.handle(
        _totalXpMeta,
        totalXp.isAcceptableOrUnknown(data['total_xp']!, _totalXpMeta),
      );
    }
    if (data.containsKey('current_streak')) {
      context.handle(
        _currentStreakMeta,
        currentStreak.isAcceptableOrUnknown(
          data['current_streak']!,
          _currentStreakMeta,
        ),
      );
    }
    if (data.containsKey('best_streak')) {
      context.handle(
        _bestStreakMeta,
        bestStreak.isAcceptableOrUnknown(data['best_streak']!, _bestStreakMeta),
      );
    }
    if (data.containsKey('last_green_day_key')) {
      context.handle(
        _lastGreenDayKeyMeta,
        lastGreenDayKey.isAcceptableOrUnknown(
          data['last_green_day_key']!,
          _lastGreenDayKeyMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  UserStat map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UserStat(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      totalXp: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}total_xp'],
      )!,
      currentStreak: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}current_streak'],
      )!,
      bestStreak: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}best_streak'],
      )!,
      lastGreenDayKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}last_green_day_key'],
      ),
    );
  }

  @override
  $UserStatsTable createAlias(String alias) {
    return $UserStatsTable(attachedDatabase, alias);
  }
}

class UserStat extends DataClass implements Insertable<UserStat> {
  final int id;
  final int totalXp;
  final int currentStreak;
  final int bestStreak;
  final String? lastGreenDayKey;
  const UserStat({
    required this.id,
    required this.totalXp,
    required this.currentStreak,
    required this.bestStreak,
    this.lastGreenDayKey,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['total_xp'] = Variable<int>(totalXp);
    map['current_streak'] = Variable<int>(currentStreak);
    map['best_streak'] = Variable<int>(bestStreak);
    if (!nullToAbsent || lastGreenDayKey != null) {
      map['last_green_day_key'] = Variable<String>(lastGreenDayKey);
    }
    return map;
  }

  UserStatsCompanion toCompanion(bool nullToAbsent) {
    return UserStatsCompanion(
      id: Value(id),
      totalXp: Value(totalXp),
      currentStreak: Value(currentStreak),
      bestStreak: Value(bestStreak),
      lastGreenDayKey: lastGreenDayKey == null && nullToAbsent
          ? const Value.absent()
          : Value(lastGreenDayKey),
    );
  }

  factory UserStat.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UserStat(
      id: serializer.fromJson<int>(json['id']),
      totalXp: serializer.fromJson<int>(json['totalXp']),
      currentStreak: serializer.fromJson<int>(json['currentStreak']),
      bestStreak: serializer.fromJson<int>(json['bestStreak']),
      lastGreenDayKey: serializer.fromJson<String?>(json['lastGreenDayKey']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'totalXp': serializer.toJson<int>(totalXp),
      'currentStreak': serializer.toJson<int>(currentStreak),
      'bestStreak': serializer.toJson<int>(bestStreak),
      'lastGreenDayKey': serializer.toJson<String?>(lastGreenDayKey),
    };
  }

  UserStat copyWith({
    int? id,
    int? totalXp,
    int? currentStreak,
    int? bestStreak,
    Value<String?> lastGreenDayKey = const Value.absent(),
  }) => UserStat(
    id: id ?? this.id,
    totalXp: totalXp ?? this.totalXp,
    currentStreak: currentStreak ?? this.currentStreak,
    bestStreak: bestStreak ?? this.bestStreak,
    lastGreenDayKey: lastGreenDayKey.present
        ? lastGreenDayKey.value
        : this.lastGreenDayKey,
  );
  UserStat copyWithCompanion(UserStatsCompanion data) {
    return UserStat(
      id: data.id.present ? data.id.value : this.id,
      totalXp: data.totalXp.present ? data.totalXp.value : this.totalXp,
      currentStreak: data.currentStreak.present
          ? data.currentStreak.value
          : this.currentStreak,
      bestStreak: data.bestStreak.present
          ? data.bestStreak.value
          : this.bestStreak,
      lastGreenDayKey: data.lastGreenDayKey.present
          ? data.lastGreenDayKey.value
          : this.lastGreenDayKey,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UserStat(')
          ..write('id: $id, ')
          ..write('totalXp: $totalXp, ')
          ..write('currentStreak: $currentStreak, ')
          ..write('bestStreak: $bestStreak, ')
          ..write('lastGreenDayKey: $lastGreenDayKey')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, totalXp, currentStreak, bestStreak, lastGreenDayKey);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UserStat &&
          other.id == this.id &&
          other.totalXp == this.totalXp &&
          other.currentStreak == this.currentStreak &&
          other.bestStreak == this.bestStreak &&
          other.lastGreenDayKey == this.lastGreenDayKey);
}

class UserStatsCompanion extends UpdateCompanion<UserStat> {
  final Value<int> id;
  final Value<int> totalXp;
  final Value<int> currentStreak;
  final Value<int> bestStreak;
  final Value<String?> lastGreenDayKey;
  const UserStatsCompanion({
    this.id = const Value.absent(),
    this.totalXp = const Value.absent(),
    this.currentStreak = const Value.absent(),
    this.bestStreak = const Value.absent(),
    this.lastGreenDayKey = const Value.absent(),
  });
  UserStatsCompanion.insert({
    this.id = const Value.absent(),
    this.totalXp = const Value.absent(),
    this.currentStreak = const Value.absent(),
    this.bestStreak = const Value.absent(),
    this.lastGreenDayKey = const Value.absent(),
  });
  static Insertable<UserStat> custom({
    Expression<int>? id,
    Expression<int>? totalXp,
    Expression<int>? currentStreak,
    Expression<int>? bestStreak,
    Expression<String>? lastGreenDayKey,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (totalXp != null) 'total_xp': totalXp,
      if (currentStreak != null) 'current_streak': currentStreak,
      if (bestStreak != null) 'best_streak': bestStreak,
      if (lastGreenDayKey != null) 'last_green_day_key': lastGreenDayKey,
    });
  }

  UserStatsCompanion copyWith({
    Value<int>? id,
    Value<int>? totalXp,
    Value<int>? currentStreak,
    Value<int>? bestStreak,
    Value<String?>? lastGreenDayKey,
  }) {
    return UserStatsCompanion(
      id: id ?? this.id,
      totalXp: totalXp ?? this.totalXp,
      currentStreak: currentStreak ?? this.currentStreak,
      bestStreak: bestStreak ?? this.bestStreak,
      lastGreenDayKey: lastGreenDayKey ?? this.lastGreenDayKey,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (totalXp.present) {
      map['total_xp'] = Variable<int>(totalXp.value);
    }
    if (currentStreak.present) {
      map['current_streak'] = Variable<int>(currentStreak.value);
    }
    if (bestStreak.present) {
      map['best_streak'] = Variable<int>(bestStreak.value);
    }
    if (lastGreenDayKey.present) {
      map['last_green_day_key'] = Variable<String>(lastGreenDayKey.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UserStatsCompanion(')
          ..write('id: $id, ')
          ..write('totalXp: $totalXp, ')
          ..write('currentStreak: $currentStreak, ')
          ..write('bestStreak: $bestStreak, ')
          ..write('lastGreenDayKey: $lastGreenDayKey')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $RoutineItemsTable routineItems = $RoutineItemsTable(this);
  late final $RoutineDayStatesTable routineDayStates = $RoutineDayStatesTable(
    this,
  );
  late final $WeeklyGoalsTable weeklyGoals = $WeeklyGoalsTable(this);
  late final $DailyReportsTable dailyReports = $DailyReportsTable(this);
  late final $WeeklyReportsTable weeklyReports = $WeeklyReportsTable(this);
  late final $OwnedShopItemsTable ownedShopItems = $OwnedShopItemsTable(this);
  late final $UserStatsTable userStats = $UserStatsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    routineItems,
    routineDayStates,
    weeklyGoals,
    dailyReports,
    weeklyReports,
    ownedShopItems,
    userStats,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'routine_items',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('routine_day_states', kind: UpdateKind.delete)],
    ),
  ]);
}

typedef $$RoutineItemsTableCreateCompanionBuilder =
    RoutineItemsCompanion Function({
      Value<int> id,
      required String title,
      required String sphere,
      required int weekdays,
      Value<int> sortOrder,
      Value<int?> scheduledMinuteOfDay,
      Value<int> effort,
      Value<bool> isOptional,
      Value<DateTime> createdAt,
    });
typedef $$RoutineItemsTableUpdateCompanionBuilder =
    RoutineItemsCompanion Function({
      Value<int> id,
      Value<String> title,
      Value<String> sphere,
      Value<int> weekdays,
      Value<int> sortOrder,
      Value<int?> scheduledMinuteOfDay,
      Value<int> effort,
      Value<bool> isOptional,
      Value<DateTime> createdAt,
    });

final class $$RoutineItemsTableReferences
    extends BaseReferences<_$AppDatabase, $RoutineItemsTable, RoutineItem> {
  $$RoutineItemsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$RoutineDayStatesTable, List<RoutineDayState>>
  _routineDayStatesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.routineDayStates,
    aliasName: $_aliasNameGenerator(
      db.routineItems.id,
      db.routineDayStates.routineItemId,
    ),
  );

  $$RoutineDayStatesTableProcessedTableManager get routineDayStatesRefs {
    final manager = $$RoutineDayStatesTableTableManager(
      $_db,
      $_db.routineDayStates,
    ).filter((f) => f.routineItemId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _routineDayStatesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$RoutineItemsTableFilterComposer
    extends Composer<_$AppDatabase, $RoutineItemsTable> {
  $$RoutineItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sphere => $composableBuilder(
    column: $table.sphere,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get weekdays => $composableBuilder(
    column: $table.weekdays,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get scheduledMinuteOfDay => $composableBuilder(
    column: $table.scheduledMinuteOfDay,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get effort => $composableBuilder(
    column: $table.effort,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isOptional => $composableBuilder(
    column: $table.isOptional,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> routineDayStatesRefs(
    Expression<bool> Function($$RoutineDayStatesTableFilterComposer f) f,
  ) {
    final $$RoutineDayStatesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.routineDayStates,
      getReferencedColumn: (t) => t.routineItemId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RoutineDayStatesTableFilterComposer(
            $db: $db,
            $table: $db.routineDayStates,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$RoutineItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $RoutineItemsTable> {
  $$RoutineItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sphere => $composableBuilder(
    column: $table.sphere,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get weekdays => $composableBuilder(
    column: $table.weekdays,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get scheduledMinuteOfDay => $composableBuilder(
    column: $table.scheduledMinuteOfDay,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get effort => $composableBuilder(
    column: $table.effort,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isOptional => $composableBuilder(
    column: $table.isOptional,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$RoutineItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $RoutineItemsTable> {
  $$RoutineItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get sphere =>
      $composableBuilder(column: $table.sphere, builder: (column) => column);

  GeneratedColumn<int> get weekdays =>
      $composableBuilder(column: $table.weekdays, builder: (column) => column);

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  GeneratedColumn<int> get scheduledMinuteOfDay => $composableBuilder(
    column: $table.scheduledMinuteOfDay,
    builder: (column) => column,
  );

  GeneratedColumn<int> get effort =>
      $composableBuilder(column: $table.effort, builder: (column) => column);

  GeneratedColumn<bool> get isOptional => $composableBuilder(
    column: $table.isOptional,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  Expression<T> routineDayStatesRefs<T extends Object>(
    Expression<T> Function($$RoutineDayStatesTableAnnotationComposer a) f,
  ) {
    final $$RoutineDayStatesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.routineDayStates,
      getReferencedColumn: (t) => t.routineItemId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RoutineDayStatesTableAnnotationComposer(
            $db: $db,
            $table: $db.routineDayStates,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$RoutineItemsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RoutineItemsTable,
          RoutineItem,
          $$RoutineItemsTableFilterComposer,
          $$RoutineItemsTableOrderingComposer,
          $$RoutineItemsTableAnnotationComposer,
          $$RoutineItemsTableCreateCompanionBuilder,
          $$RoutineItemsTableUpdateCompanionBuilder,
          (RoutineItem, $$RoutineItemsTableReferences),
          RoutineItem,
          PrefetchHooks Function({bool routineDayStatesRefs})
        > {
  $$RoutineItemsTableTableManager(_$AppDatabase db, $RoutineItemsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RoutineItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RoutineItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RoutineItemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> sphere = const Value.absent(),
                Value<int> weekdays = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<int?> scheduledMinuteOfDay = const Value.absent(),
                Value<int> effort = const Value.absent(),
                Value<bool> isOptional = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => RoutineItemsCompanion(
                id: id,
                title: title,
                sphere: sphere,
                weekdays: weekdays,
                sortOrder: sortOrder,
                scheduledMinuteOfDay: scheduledMinuteOfDay,
                effort: effort,
                isOptional: isOptional,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String title,
                required String sphere,
                required int weekdays,
                Value<int> sortOrder = const Value.absent(),
                Value<int?> scheduledMinuteOfDay = const Value.absent(),
                Value<int> effort = const Value.absent(),
                Value<bool> isOptional = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => RoutineItemsCompanion.insert(
                id: id,
                title: title,
                sphere: sphere,
                weekdays: weekdays,
                sortOrder: sortOrder,
                scheduledMinuteOfDay: scheduledMinuteOfDay,
                effort: effort,
                isOptional: isOptional,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$RoutineItemsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({routineDayStatesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (routineDayStatesRefs) db.routineDayStates,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (routineDayStatesRefs)
                    await $_getPrefetchedData<
                      RoutineItem,
                      $RoutineItemsTable,
                      RoutineDayState
                    >(
                      currentTable: table,
                      referencedTable: $$RoutineItemsTableReferences
                          ._routineDayStatesRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$RoutineItemsTableReferences(
                            db,
                            table,
                            p0,
                          ).routineDayStatesRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where(
                            (e) => e.routineItemId == item.id,
                          ),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$RoutineItemsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RoutineItemsTable,
      RoutineItem,
      $$RoutineItemsTableFilterComposer,
      $$RoutineItemsTableOrderingComposer,
      $$RoutineItemsTableAnnotationComposer,
      $$RoutineItemsTableCreateCompanionBuilder,
      $$RoutineItemsTableUpdateCompanionBuilder,
      (RoutineItem, $$RoutineItemsTableReferences),
      RoutineItem,
      PrefetchHooks Function({bool routineDayStatesRefs})
    >;
typedef $$RoutineDayStatesTableCreateCompanionBuilder =
    RoutineDayStatesCompanion Function({
      Value<int> id,
      required int routineItemId,
      required String dateKey,
      Value<int> status,
    });
typedef $$RoutineDayStatesTableUpdateCompanionBuilder =
    RoutineDayStatesCompanion Function({
      Value<int> id,
      Value<int> routineItemId,
      Value<String> dateKey,
      Value<int> status,
    });

final class $$RoutineDayStatesTableReferences
    extends
        BaseReferences<_$AppDatabase, $RoutineDayStatesTable, RoutineDayState> {
  $$RoutineDayStatesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $RoutineItemsTable _routineItemIdTable(_$AppDatabase db) =>
      db.routineItems.createAlias(
        $_aliasNameGenerator(
          db.routineDayStates.routineItemId,
          db.routineItems.id,
        ),
      );

  $$RoutineItemsTableProcessedTableManager get routineItemId {
    final $_column = $_itemColumn<int>('routine_item_id')!;

    final manager = $$RoutineItemsTableTableManager(
      $_db,
      $_db.routineItems,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_routineItemIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$RoutineDayStatesTableFilterComposer
    extends Composer<_$AppDatabase, $RoutineDayStatesTable> {
  $$RoutineDayStatesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get dateKey => $composableBuilder(
    column: $table.dateKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  $$RoutineItemsTableFilterComposer get routineItemId {
    final $$RoutineItemsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.routineItemId,
      referencedTable: $db.routineItems,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RoutineItemsTableFilterComposer(
            $db: $db,
            $table: $db.routineItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RoutineDayStatesTableOrderingComposer
    extends Composer<_$AppDatabase, $RoutineDayStatesTable> {
  $$RoutineDayStatesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get dateKey => $composableBuilder(
    column: $table.dateKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  $$RoutineItemsTableOrderingComposer get routineItemId {
    final $$RoutineItemsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.routineItemId,
      referencedTable: $db.routineItems,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RoutineItemsTableOrderingComposer(
            $db: $db,
            $table: $db.routineItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RoutineDayStatesTableAnnotationComposer
    extends Composer<_$AppDatabase, $RoutineDayStatesTable> {
  $$RoutineDayStatesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get dateKey =>
      $composableBuilder(column: $table.dateKey, builder: (column) => column);

  GeneratedColumn<int> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  $$RoutineItemsTableAnnotationComposer get routineItemId {
    final $$RoutineItemsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.routineItemId,
      referencedTable: $db.routineItems,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RoutineItemsTableAnnotationComposer(
            $db: $db,
            $table: $db.routineItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RoutineDayStatesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RoutineDayStatesTable,
          RoutineDayState,
          $$RoutineDayStatesTableFilterComposer,
          $$RoutineDayStatesTableOrderingComposer,
          $$RoutineDayStatesTableAnnotationComposer,
          $$RoutineDayStatesTableCreateCompanionBuilder,
          $$RoutineDayStatesTableUpdateCompanionBuilder,
          (RoutineDayState, $$RoutineDayStatesTableReferences),
          RoutineDayState,
          PrefetchHooks Function({bool routineItemId})
        > {
  $$RoutineDayStatesTableTableManager(
    _$AppDatabase db,
    $RoutineDayStatesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RoutineDayStatesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RoutineDayStatesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RoutineDayStatesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> routineItemId = const Value.absent(),
                Value<String> dateKey = const Value.absent(),
                Value<int> status = const Value.absent(),
              }) => RoutineDayStatesCompanion(
                id: id,
                routineItemId: routineItemId,
                dateKey: dateKey,
                status: status,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int routineItemId,
                required String dateKey,
                Value<int> status = const Value.absent(),
              }) => RoutineDayStatesCompanion.insert(
                id: id,
                routineItemId: routineItemId,
                dateKey: dateKey,
                status: status,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$RoutineDayStatesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({routineItemId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (routineItemId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.routineItemId,
                                referencedTable:
                                    $$RoutineDayStatesTableReferences
                                        ._routineItemIdTable(db),
                                referencedColumn:
                                    $$RoutineDayStatesTableReferences
                                        ._routineItemIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$RoutineDayStatesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RoutineDayStatesTable,
      RoutineDayState,
      $$RoutineDayStatesTableFilterComposer,
      $$RoutineDayStatesTableOrderingComposer,
      $$RoutineDayStatesTableAnnotationComposer,
      $$RoutineDayStatesTableCreateCompanionBuilder,
      $$RoutineDayStatesTableUpdateCompanionBuilder,
      (RoutineDayState, $$RoutineDayStatesTableReferences),
      RoutineDayState,
      PrefetchHooks Function({bool routineItemId})
    >;
typedef $$WeeklyGoalsTableCreateCompanionBuilder =
    WeeklyGoalsCompanion Function({
      Value<int> id,
      required String weekKey,
      required String sphere,
      required String title,
      Value<int> targetCount,
      Value<int> progressCount,
      Value<int> status,
    });
typedef $$WeeklyGoalsTableUpdateCompanionBuilder =
    WeeklyGoalsCompanion Function({
      Value<int> id,
      Value<String> weekKey,
      Value<String> sphere,
      Value<String> title,
      Value<int> targetCount,
      Value<int> progressCount,
      Value<int> status,
    });

class $$WeeklyGoalsTableFilterComposer
    extends Composer<_$AppDatabase, $WeeklyGoalsTable> {
  $$WeeklyGoalsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get weekKey => $composableBuilder(
    column: $table.weekKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sphere => $composableBuilder(
    column: $table.sphere,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get targetCount => $composableBuilder(
    column: $table.targetCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get progressCount => $composableBuilder(
    column: $table.progressCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );
}

class $$WeeklyGoalsTableOrderingComposer
    extends Composer<_$AppDatabase, $WeeklyGoalsTable> {
  $$WeeklyGoalsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get weekKey => $composableBuilder(
    column: $table.weekKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sphere => $composableBuilder(
    column: $table.sphere,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get targetCount => $composableBuilder(
    column: $table.targetCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get progressCount => $composableBuilder(
    column: $table.progressCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$WeeklyGoalsTableAnnotationComposer
    extends Composer<_$AppDatabase, $WeeklyGoalsTable> {
  $$WeeklyGoalsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get weekKey =>
      $composableBuilder(column: $table.weekKey, builder: (column) => column);

  GeneratedColumn<String> get sphere =>
      $composableBuilder(column: $table.sphere, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<int> get targetCount => $composableBuilder(
    column: $table.targetCount,
    builder: (column) => column,
  );

  GeneratedColumn<int> get progressCount => $composableBuilder(
    column: $table.progressCount,
    builder: (column) => column,
  );

  GeneratedColumn<int> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);
}

class $$WeeklyGoalsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $WeeklyGoalsTable,
          WeeklyGoal,
          $$WeeklyGoalsTableFilterComposer,
          $$WeeklyGoalsTableOrderingComposer,
          $$WeeklyGoalsTableAnnotationComposer,
          $$WeeklyGoalsTableCreateCompanionBuilder,
          $$WeeklyGoalsTableUpdateCompanionBuilder,
          (
            WeeklyGoal,
            BaseReferences<_$AppDatabase, $WeeklyGoalsTable, WeeklyGoal>,
          ),
          WeeklyGoal,
          PrefetchHooks Function()
        > {
  $$WeeklyGoalsTableTableManager(_$AppDatabase db, $WeeklyGoalsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WeeklyGoalsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WeeklyGoalsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WeeklyGoalsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> weekKey = const Value.absent(),
                Value<String> sphere = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<int> targetCount = const Value.absent(),
                Value<int> progressCount = const Value.absent(),
                Value<int> status = const Value.absent(),
              }) => WeeklyGoalsCompanion(
                id: id,
                weekKey: weekKey,
                sphere: sphere,
                title: title,
                targetCount: targetCount,
                progressCount: progressCount,
                status: status,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String weekKey,
                required String sphere,
                required String title,
                Value<int> targetCount = const Value.absent(),
                Value<int> progressCount = const Value.absent(),
                Value<int> status = const Value.absent(),
              }) => WeeklyGoalsCompanion.insert(
                id: id,
                weekKey: weekKey,
                sphere: sphere,
                title: title,
                targetCount: targetCount,
                progressCount: progressCount,
                status: status,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$WeeklyGoalsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $WeeklyGoalsTable,
      WeeklyGoal,
      $$WeeklyGoalsTableFilterComposer,
      $$WeeklyGoalsTableOrderingComposer,
      $$WeeklyGoalsTableAnnotationComposer,
      $$WeeklyGoalsTableCreateCompanionBuilder,
      $$WeeklyGoalsTableUpdateCompanionBuilder,
      (
        WeeklyGoal,
        BaseReferences<_$AppDatabase, $WeeklyGoalsTable, WeeklyGoal>,
      ),
      WeeklyGoal,
      PrefetchHooks Function()
    >;
typedef $$DailyReportsTableCreateCompanionBuilder =
    DailyReportsCompanion Function({
      Value<int> id,
      required String dayKey,
      Value<int?> mood,
      required String noteHighlight,
      required String noteReflection,
      required int dayTier,
      required int xpAwarded,
      Value<DateTime> closedAt,
    });
typedef $$DailyReportsTableUpdateCompanionBuilder =
    DailyReportsCompanion Function({
      Value<int> id,
      Value<String> dayKey,
      Value<int?> mood,
      Value<String> noteHighlight,
      Value<String> noteReflection,
      Value<int> dayTier,
      Value<int> xpAwarded,
      Value<DateTime> closedAt,
    });

class $$DailyReportsTableFilterComposer
    extends Composer<_$AppDatabase, $DailyReportsTable> {
  $$DailyReportsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get dayKey => $composableBuilder(
    column: $table.dayKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get mood => $composableBuilder(
    column: $table.mood,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get noteHighlight => $composableBuilder(
    column: $table.noteHighlight,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get noteReflection => $composableBuilder(
    column: $table.noteReflection,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get dayTier => $composableBuilder(
    column: $table.dayTier,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get xpAwarded => $composableBuilder(
    column: $table.xpAwarded,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get closedAt => $composableBuilder(
    column: $table.closedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$DailyReportsTableOrderingComposer
    extends Composer<_$AppDatabase, $DailyReportsTable> {
  $$DailyReportsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get dayKey => $composableBuilder(
    column: $table.dayKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get mood => $composableBuilder(
    column: $table.mood,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get noteHighlight => $composableBuilder(
    column: $table.noteHighlight,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get noteReflection => $composableBuilder(
    column: $table.noteReflection,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get dayTier => $composableBuilder(
    column: $table.dayTier,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get xpAwarded => $composableBuilder(
    column: $table.xpAwarded,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get closedAt => $composableBuilder(
    column: $table.closedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$DailyReportsTableAnnotationComposer
    extends Composer<_$AppDatabase, $DailyReportsTable> {
  $$DailyReportsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get dayKey =>
      $composableBuilder(column: $table.dayKey, builder: (column) => column);

  GeneratedColumn<int> get mood =>
      $composableBuilder(column: $table.mood, builder: (column) => column);

  GeneratedColumn<String> get noteHighlight => $composableBuilder(
    column: $table.noteHighlight,
    builder: (column) => column,
  );

  GeneratedColumn<String> get noteReflection => $composableBuilder(
    column: $table.noteReflection,
    builder: (column) => column,
  );

  GeneratedColumn<int> get dayTier =>
      $composableBuilder(column: $table.dayTier, builder: (column) => column);

  GeneratedColumn<int> get xpAwarded =>
      $composableBuilder(column: $table.xpAwarded, builder: (column) => column);

  GeneratedColumn<DateTime> get closedAt =>
      $composableBuilder(column: $table.closedAt, builder: (column) => column);
}

class $$DailyReportsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DailyReportsTable,
          DailyReport,
          $$DailyReportsTableFilterComposer,
          $$DailyReportsTableOrderingComposer,
          $$DailyReportsTableAnnotationComposer,
          $$DailyReportsTableCreateCompanionBuilder,
          $$DailyReportsTableUpdateCompanionBuilder,
          (
            DailyReport,
            BaseReferences<_$AppDatabase, $DailyReportsTable, DailyReport>,
          ),
          DailyReport,
          PrefetchHooks Function()
        > {
  $$DailyReportsTableTableManager(_$AppDatabase db, $DailyReportsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DailyReportsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DailyReportsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DailyReportsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> dayKey = const Value.absent(),
                Value<int?> mood = const Value.absent(),
                Value<String> noteHighlight = const Value.absent(),
                Value<String> noteReflection = const Value.absent(),
                Value<int> dayTier = const Value.absent(),
                Value<int> xpAwarded = const Value.absent(),
                Value<DateTime> closedAt = const Value.absent(),
              }) => DailyReportsCompanion(
                id: id,
                dayKey: dayKey,
                mood: mood,
                noteHighlight: noteHighlight,
                noteReflection: noteReflection,
                dayTier: dayTier,
                xpAwarded: xpAwarded,
                closedAt: closedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String dayKey,
                Value<int?> mood = const Value.absent(),
                required String noteHighlight,
                required String noteReflection,
                required int dayTier,
                required int xpAwarded,
                Value<DateTime> closedAt = const Value.absent(),
              }) => DailyReportsCompanion.insert(
                id: id,
                dayKey: dayKey,
                mood: mood,
                noteHighlight: noteHighlight,
                noteReflection: noteReflection,
                dayTier: dayTier,
                xpAwarded: xpAwarded,
                closedAt: closedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$DailyReportsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DailyReportsTable,
      DailyReport,
      $$DailyReportsTableFilterComposer,
      $$DailyReportsTableOrderingComposer,
      $$DailyReportsTableAnnotationComposer,
      $$DailyReportsTableCreateCompanionBuilder,
      $$DailyReportsTableUpdateCompanionBuilder,
      (
        DailyReport,
        BaseReferences<_$AppDatabase, $DailyReportsTable, DailyReport>,
      ),
      DailyReport,
      PrefetchHooks Function()
    >;
typedef $$WeeklyReportsTableCreateCompanionBuilder =
    WeeklyReportsCompanion Function({
      required String weekKey,
      Value<String> noteWin,
      Value<String> noteFocus,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });
typedef $$WeeklyReportsTableUpdateCompanionBuilder =
    WeeklyReportsCompanion Function({
      Value<String> weekKey,
      Value<String> noteWin,
      Value<String> noteFocus,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$WeeklyReportsTableFilterComposer
    extends Composer<_$AppDatabase, $WeeklyReportsTable> {
  $$WeeklyReportsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get weekKey => $composableBuilder(
    column: $table.weekKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get noteWin => $composableBuilder(
    column: $table.noteWin,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get noteFocus => $composableBuilder(
    column: $table.noteFocus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$WeeklyReportsTableOrderingComposer
    extends Composer<_$AppDatabase, $WeeklyReportsTable> {
  $$WeeklyReportsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get weekKey => $composableBuilder(
    column: $table.weekKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get noteWin => $composableBuilder(
    column: $table.noteWin,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get noteFocus => $composableBuilder(
    column: $table.noteFocus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$WeeklyReportsTableAnnotationComposer
    extends Composer<_$AppDatabase, $WeeklyReportsTable> {
  $$WeeklyReportsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get weekKey =>
      $composableBuilder(column: $table.weekKey, builder: (column) => column);

  GeneratedColumn<String> get noteWin =>
      $composableBuilder(column: $table.noteWin, builder: (column) => column);

  GeneratedColumn<String> get noteFocus =>
      $composableBuilder(column: $table.noteFocus, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$WeeklyReportsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $WeeklyReportsTable,
          WeeklyReport,
          $$WeeklyReportsTableFilterComposer,
          $$WeeklyReportsTableOrderingComposer,
          $$WeeklyReportsTableAnnotationComposer,
          $$WeeklyReportsTableCreateCompanionBuilder,
          $$WeeklyReportsTableUpdateCompanionBuilder,
          (
            WeeklyReport,
            BaseReferences<_$AppDatabase, $WeeklyReportsTable, WeeklyReport>,
          ),
          WeeklyReport,
          PrefetchHooks Function()
        > {
  $$WeeklyReportsTableTableManager(_$AppDatabase db, $WeeklyReportsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WeeklyReportsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WeeklyReportsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WeeklyReportsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> weekKey = const Value.absent(),
                Value<String> noteWin = const Value.absent(),
                Value<String> noteFocus = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => WeeklyReportsCompanion(
                weekKey: weekKey,
                noteWin: noteWin,
                noteFocus: noteFocus,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String weekKey,
                Value<String> noteWin = const Value.absent(),
                Value<String> noteFocus = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => WeeklyReportsCompanion.insert(
                weekKey: weekKey,
                noteWin: noteWin,
                noteFocus: noteFocus,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$WeeklyReportsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $WeeklyReportsTable,
      WeeklyReport,
      $$WeeklyReportsTableFilterComposer,
      $$WeeklyReportsTableOrderingComposer,
      $$WeeklyReportsTableAnnotationComposer,
      $$WeeklyReportsTableCreateCompanionBuilder,
      $$WeeklyReportsTableUpdateCompanionBuilder,
      (
        WeeklyReport,
        BaseReferences<_$AppDatabase, $WeeklyReportsTable, WeeklyReport>,
      ),
      WeeklyReport,
      PrefetchHooks Function()
    >;
typedef $$OwnedShopItemsTableCreateCompanionBuilder =
    OwnedShopItemsCompanion Function({
      required String itemId,
      Value<DateTime> purchasedAt,
      Value<int> rowid,
    });
typedef $$OwnedShopItemsTableUpdateCompanionBuilder =
    OwnedShopItemsCompanion Function({
      Value<String> itemId,
      Value<DateTime> purchasedAt,
      Value<int> rowid,
    });

class $$OwnedShopItemsTableFilterComposer
    extends Composer<_$AppDatabase, $OwnedShopItemsTable> {
  $$OwnedShopItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get itemId => $composableBuilder(
    column: $table.itemId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get purchasedAt => $composableBuilder(
    column: $table.purchasedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$OwnedShopItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $OwnedShopItemsTable> {
  $$OwnedShopItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get itemId => $composableBuilder(
    column: $table.itemId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get purchasedAt => $composableBuilder(
    column: $table.purchasedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$OwnedShopItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $OwnedShopItemsTable> {
  $$OwnedShopItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get itemId =>
      $composableBuilder(column: $table.itemId, builder: (column) => column);

  GeneratedColumn<DateTime> get purchasedAt => $composableBuilder(
    column: $table.purchasedAt,
    builder: (column) => column,
  );
}

class $$OwnedShopItemsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $OwnedShopItemsTable,
          OwnedShopItem,
          $$OwnedShopItemsTableFilterComposer,
          $$OwnedShopItemsTableOrderingComposer,
          $$OwnedShopItemsTableAnnotationComposer,
          $$OwnedShopItemsTableCreateCompanionBuilder,
          $$OwnedShopItemsTableUpdateCompanionBuilder,
          (
            OwnedShopItem,
            BaseReferences<_$AppDatabase, $OwnedShopItemsTable, OwnedShopItem>,
          ),
          OwnedShopItem,
          PrefetchHooks Function()
        > {
  $$OwnedShopItemsTableTableManager(
    _$AppDatabase db,
    $OwnedShopItemsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$OwnedShopItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$OwnedShopItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$OwnedShopItemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> itemId = const Value.absent(),
                Value<DateTime> purchasedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => OwnedShopItemsCompanion(
                itemId: itemId,
                purchasedAt: purchasedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String itemId,
                Value<DateTime> purchasedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => OwnedShopItemsCompanion.insert(
                itemId: itemId,
                purchasedAt: purchasedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$OwnedShopItemsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $OwnedShopItemsTable,
      OwnedShopItem,
      $$OwnedShopItemsTableFilterComposer,
      $$OwnedShopItemsTableOrderingComposer,
      $$OwnedShopItemsTableAnnotationComposer,
      $$OwnedShopItemsTableCreateCompanionBuilder,
      $$OwnedShopItemsTableUpdateCompanionBuilder,
      (
        OwnedShopItem,
        BaseReferences<_$AppDatabase, $OwnedShopItemsTable, OwnedShopItem>,
      ),
      OwnedShopItem,
      PrefetchHooks Function()
    >;
typedef $$UserStatsTableCreateCompanionBuilder =
    UserStatsCompanion Function({
      Value<int> id,
      Value<int> totalXp,
      Value<int> currentStreak,
      Value<int> bestStreak,
      Value<String?> lastGreenDayKey,
    });
typedef $$UserStatsTableUpdateCompanionBuilder =
    UserStatsCompanion Function({
      Value<int> id,
      Value<int> totalXp,
      Value<int> currentStreak,
      Value<int> bestStreak,
      Value<String?> lastGreenDayKey,
    });

class $$UserStatsTableFilterComposer
    extends Composer<_$AppDatabase, $UserStatsTable> {
  $$UserStatsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get totalXp => $composableBuilder(
    column: $table.totalXp,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get currentStreak => $composableBuilder(
    column: $table.currentStreak,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get bestStreak => $composableBuilder(
    column: $table.bestStreak,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lastGreenDayKey => $composableBuilder(
    column: $table.lastGreenDayKey,
    builder: (column) => ColumnFilters(column),
  );
}

class $$UserStatsTableOrderingComposer
    extends Composer<_$AppDatabase, $UserStatsTable> {
  $$UserStatsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get totalXp => $composableBuilder(
    column: $table.totalXp,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get currentStreak => $composableBuilder(
    column: $table.currentStreak,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get bestStreak => $composableBuilder(
    column: $table.bestStreak,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lastGreenDayKey => $composableBuilder(
    column: $table.lastGreenDayKey,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$UserStatsTableAnnotationComposer
    extends Composer<_$AppDatabase, $UserStatsTable> {
  $$UserStatsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get totalXp =>
      $composableBuilder(column: $table.totalXp, builder: (column) => column);

  GeneratedColumn<int> get currentStreak => $composableBuilder(
    column: $table.currentStreak,
    builder: (column) => column,
  );

  GeneratedColumn<int> get bestStreak => $composableBuilder(
    column: $table.bestStreak,
    builder: (column) => column,
  );

  GeneratedColumn<String> get lastGreenDayKey => $composableBuilder(
    column: $table.lastGreenDayKey,
    builder: (column) => column,
  );
}

class $$UserStatsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $UserStatsTable,
          UserStat,
          $$UserStatsTableFilterComposer,
          $$UserStatsTableOrderingComposer,
          $$UserStatsTableAnnotationComposer,
          $$UserStatsTableCreateCompanionBuilder,
          $$UserStatsTableUpdateCompanionBuilder,
          (UserStat, BaseReferences<_$AppDatabase, $UserStatsTable, UserStat>),
          UserStat,
          PrefetchHooks Function()
        > {
  $$UserStatsTableTableManager(_$AppDatabase db, $UserStatsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UserStatsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UserStatsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UserStatsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> totalXp = const Value.absent(),
                Value<int> currentStreak = const Value.absent(),
                Value<int> bestStreak = const Value.absent(),
                Value<String?> lastGreenDayKey = const Value.absent(),
              }) => UserStatsCompanion(
                id: id,
                totalXp: totalXp,
                currentStreak: currentStreak,
                bestStreak: bestStreak,
                lastGreenDayKey: lastGreenDayKey,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> totalXp = const Value.absent(),
                Value<int> currentStreak = const Value.absent(),
                Value<int> bestStreak = const Value.absent(),
                Value<String?> lastGreenDayKey = const Value.absent(),
              }) => UserStatsCompanion.insert(
                id: id,
                totalXp: totalXp,
                currentStreak: currentStreak,
                bestStreak: bestStreak,
                lastGreenDayKey: lastGreenDayKey,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$UserStatsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $UserStatsTable,
      UserStat,
      $$UserStatsTableFilterComposer,
      $$UserStatsTableOrderingComposer,
      $$UserStatsTableAnnotationComposer,
      $$UserStatsTableCreateCompanionBuilder,
      $$UserStatsTableUpdateCompanionBuilder,
      (UserStat, BaseReferences<_$AppDatabase, $UserStatsTable, UserStat>),
      UserStat,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$RoutineItemsTableTableManager get routineItems =>
      $$RoutineItemsTableTableManager(_db, _db.routineItems);
  $$RoutineDayStatesTableTableManager get routineDayStates =>
      $$RoutineDayStatesTableTableManager(_db, _db.routineDayStates);
  $$WeeklyGoalsTableTableManager get weeklyGoals =>
      $$WeeklyGoalsTableTableManager(_db, _db.weeklyGoals);
  $$DailyReportsTableTableManager get dailyReports =>
      $$DailyReportsTableTableManager(_db, _db.dailyReports);
  $$WeeklyReportsTableTableManager get weeklyReports =>
      $$WeeklyReportsTableTableManager(_db, _db.weeklyReports);
  $$OwnedShopItemsTableTableManager get ownedShopItems =>
      $$OwnedShopItemsTableTableManager(_db, _db.ownedShopItems);
  $$UserStatsTableTableManager get userStats =>
      $$UserStatsTableTableManager(_db, _db.userStats);
}
