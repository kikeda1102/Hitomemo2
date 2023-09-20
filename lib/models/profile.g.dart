// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetProfileCollection on Isar {
  IsarCollection<Profile> get profiles => this.collection();
}

const ProfileSchema = CollectionSchema(
  name: r'Profile',
  id: 1266279811925214857,
  properties: {
    r'created': PropertySchema(
      id: 0,
      name: r'created',
      type: IsarType.dateTime,
    ),
    r'imageBytes': PropertySchema(
      id: 1,
      name: r'imageBytes',
      type: IsarType.byteList,
    ),
    r'memo': PropertySchema(
      id: 2,
      name: r'memo',
      type: IsarType.string,
    ),
    r'name': PropertySchema(
      id: 3,
      name: r'name',
      type: IsarType.string,
    ),
    r'order': PropertySchema(
      id: 4,
      name: r'order',
      type: IsarType.long,
    ),
    r'personalTags': PropertySchema(
      id: 5,
      name: r'personalTags',
      type: IsarType.stringList,
    ),
    r'updated': PropertySchema(
      id: 6,
      name: r'updated',
      type: IsarType.dateTime,
    )
  },
  estimateSize: _profileEstimateSize,
  serialize: _profileSerialize,
  deserialize: _profileDeserialize,
  deserializeProp: _profileDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _profileGetId,
  getLinks: _profileGetLinks,
  attach: _profileAttach,
  version: '3.1.0+1',
);

int _profileEstimateSize(
  Profile object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.imageBytes;
    if (value != null) {
      bytesCount += 3 + value.length;
    }
  }
  bytesCount += 3 + object.memo.length * 3;
  bytesCount += 3 + object.name.length * 3;
  bytesCount += 3 + object.personalTags.length * 3;
  {
    for (var i = 0; i < object.personalTags.length; i++) {
      final value = object.personalTags[i];
      bytesCount += value.length * 3;
    }
  }
  return bytesCount;
}

void _profileSerialize(
  Profile object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDateTime(offsets[0], object.created);
  writer.writeByteList(offsets[1], object.imageBytes);
  writer.writeString(offsets[2], object.memo);
  writer.writeString(offsets[3], object.name);
  writer.writeLong(offsets[4], object.order);
  writer.writeStringList(offsets[5], object.personalTags);
  writer.writeDateTime(offsets[6], object.updated);
}

Profile _profileDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = Profile(
    id: id,
    imageBytes: reader.readByteList(offsets[1]),
    memo: reader.readString(offsets[2]),
    name: reader.readString(offsets[3]),
    order: reader.readLongOrNull(offsets[4]) ?? -1,
    personalTags: reader.readStringList(offsets[5]) ?? [],
    updated: reader.readDateTimeOrNull(offsets[6]),
  );
  object.created = reader.readDateTime(offsets[0]);
  return object;
}

P _profileDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDateTime(offset)) as P;
    case 1:
      return (reader.readByteList(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readString(offset)) as P;
    case 4:
      return (reader.readLongOrNull(offset) ?? -1) as P;
    case 5:
      return (reader.readStringList(offset) ?? []) as P;
    case 6:
      return (reader.readDateTimeOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _profileGetId(Profile object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _profileGetLinks(Profile object) {
  return [];
}

void _profileAttach(IsarCollection<dynamic> col, Id id, Profile object) {
  object.id = id;
}

extension ProfileQueryWhereSort on QueryBuilder<Profile, Profile, QWhere> {
  QueryBuilder<Profile, Profile, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension ProfileQueryWhere on QueryBuilder<Profile, Profile, QWhereClause> {
  QueryBuilder<Profile, Profile, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<Profile, Profile, QAfterWhereClause> idNotEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<Profile, Profile, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<Profile, Profile, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<Profile, Profile, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension ProfileQueryFilter
    on QueryBuilder<Profile, Profile, QFilterCondition> {
  QueryBuilder<Profile, Profile, QAfterFilterCondition> createdEqualTo(
      DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'created',
        value: value,
      ));
    });
  }

  QueryBuilder<Profile, Profile, QAfterFilterCondition> createdGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'created',
        value: value,
      ));
    });
  }

  QueryBuilder<Profile, Profile, QAfterFilterCondition> createdLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'created',
        value: value,
      ));
    });
  }

  QueryBuilder<Profile, Profile, QAfterFilterCondition> createdBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'created',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Profile, Profile, QAfterFilterCondition> idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Profile, Profile, QAfterFilterCondition> idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Profile, Profile, QAfterFilterCondition> idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Profile, Profile, QAfterFilterCondition> idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Profile, Profile, QAfterFilterCondition> imageBytesIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'imageBytes',
      ));
    });
  }

  QueryBuilder<Profile, Profile, QAfterFilterCondition> imageBytesIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'imageBytes',
      ));
    });
  }

  QueryBuilder<Profile, Profile, QAfterFilterCondition>
      imageBytesElementEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'imageBytes',
        value: value,
      ));
    });
  }

  QueryBuilder<Profile, Profile, QAfterFilterCondition>
      imageBytesElementGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'imageBytes',
        value: value,
      ));
    });
  }

  QueryBuilder<Profile, Profile, QAfterFilterCondition>
      imageBytesElementLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'imageBytes',
        value: value,
      ));
    });
  }

  QueryBuilder<Profile, Profile, QAfterFilterCondition>
      imageBytesElementBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'imageBytes',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Profile, Profile, QAfterFilterCondition> imageBytesLengthEqualTo(
      int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'imageBytes',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<Profile, Profile, QAfterFilterCondition> imageBytesIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'imageBytes',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<Profile, Profile, QAfterFilterCondition> imageBytesIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'imageBytes',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<Profile, Profile, QAfterFilterCondition>
      imageBytesLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'imageBytes',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<Profile, Profile, QAfterFilterCondition>
      imageBytesLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'imageBytes',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<Profile, Profile, QAfterFilterCondition> imageBytesLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'imageBytes',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<Profile, Profile, QAfterFilterCondition> memoEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'memo',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Profile, Profile, QAfterFilterCondition> memoGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'memo',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Profile, Profile, QAfterFilterCondition> memoLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'memo',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Profile, Profile, QAfterFilterCondition> memoBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'memo',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Profile, Profile, QAfterFilterCondition> memoStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'memo',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Profile, Profile, QAfterFilterCondition> memoEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'memo',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Profile, Profile, QAfterFilterCondition> memoContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'memo',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Profile, Profile, QAfterFilterCondition> memoMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'memo',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Profile, Profile, QAfterFilterCondition> memoIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'memo',
        value: '',
      ));
    });
  }

  QueryBuilder<Profile, Profile, QAfterFilterCondition> memoIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'memo',
        value: '',
      ));
    });
  }

  QueryBuilder<Profile, Profile, QAfterFilterCondition> nameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Profile, Profile, QAfterFilterCondition> nameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Profile, Profile, QAfterFilterCondition> nameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Profile, Profile, QAfterFilterCondition> nameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'name',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Profile, Profile, QAfterFilterCondition> nameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Profile, Profile, QAfterFilterCondition> nameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Profile, Profile, QAfterFilterCondition> nameContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Profile, Profile, QAfterFilterCondition> nameMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'name',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Profile, Profile, QAfterFilterCondition> nameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<Profile, Profile, QAfterFilterCondition> nameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<Profile, Profile, QAfterFilterCondition> orderEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'order',
        value: value,
      ));
    });
  }

  QueryBuilder<Profile, Profile, QAfterFilterCondition> orderGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'order',
        value: value,
      ));
    });
  }

  QueryBuilder<Profile, Profile, QAfterFilterCondition> orderLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'order',
        value: value,
      ));
    });
  }

  QueryBuilder<Profile, Profile, QAfterFilterCondition> orderBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'order',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Profile, Profile, QAfterFilterCondition>
      personalTagsElementEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'personalTags',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Profile, Profile, QAfterFilterCondition>
      personalTagsElementGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'personalTags',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Profile, Profile, QAfterFilterCondition>
      personalTagsElementLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'personalTags',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Profile, Profile, QAfterFilterCondition>
      personalTagsElementBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'personalTags',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Profile, Profile, QAfterFilterCondition>
      personalTagsElementStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'personalTags',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Profile, Profile, QAfterFilterCondition>
      personalTagsElementEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'personalTags',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Profile, Profile, QAfterFilterCondition>
      personalTagsElementContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'personalTags',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Profile, Profile, QAfterFilterCondition>
      personalTagsElementMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'personalTags',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Profile, Profile, QAfterFilterCondition>
      personalTagsElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'personalTags',
        value: '',
      ));
    });
  }

  QueryBuilder<Profile, Profile, QAfterFilterCondition>
      personalTagsElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'personalTags',
        value: '',
      ));
    });
  }

  QueryBuilder<Profile, Profile, QAfterFilterCondition>
      personalTagsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'personalTags',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<Profile, Profile, QAfterFilterCondition> personalTagsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'personalTags',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<Profile, Profile, QAfterFilterCondition>
      personalTagsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'personalTags',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<Profile, Profile, QAfterFilterCondition>
      personalTagsLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'personalTags',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<Profile, Profile, QAfterFilterCondition>
      personalTagsLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'personalTags',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<Profile, Profile, QAfterFilterCondition>
      personalTagsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'personalTags',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<Profile, Profile, QAfterFilterCondition> updatedIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'updated',
      ));
    });
  }

  QueryBuilder<Profile, Profile, QAfterFilterCondition> updatedIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'updated',
      ));
    });
  }

  QueryBuilder<Profile, Profile, QAfterFilterCondition> updatedEqualTo(
      DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'updated',
        value: value,
      ));
    });
  }

  QueryBuilder<Profile, Profile, QAfterFilterCondition> updatedGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'updated',
        value: value,
      ));
    });
  }

  QueryBuilder<Profile, Profile, QAfterFilterCondition> updatedLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'updated',
        value: value,
      ));
    });
  }

  QueryBuilder<Profile, Profile, QAfterFilterCondition> updatedBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'updated',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension ProfileQueryObject
    on QueryBuilder<Profile, Profile, QFilterCondition> {}

extension ProfileQueryLinks
    on QueryBuilder<Profile, Profile, QFilterCondition> {}

extension ProfileQuerySortBy on QueryBuilder<Profile, Profile, QSortBy> {
  QueryBuilder<Profile, Profile, QAfterSortBy> sortByCreated() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'created', Sort.asc);
    });
  }

  QueryBuilder<Profile, Profile, QAfterSortBy> sortByCreatedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'created', Sort.desc);
    });
  }

  QueryBuilder<Profile, Profile, QAfterSortBy> sortByMemo() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'memo', Sort.asc);
    });
  }

  QueryBuilder<Profile, Profile, QAfterSortBy> sortByMemoDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'memo', Sort.desc);
    });
  }

  QueryBuilder<Profile, Profile, QAfterSortBy> sortByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<Profile, Profile, QAfterSortBy> sortByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<Profile, Profile, QAfterSortBy> sortByOrder() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'order', Sort.asc);
    });
  }

  QueryBuilder<Profile, Profile, QAfterSortBy> sortByOrderDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'order', Sort.desc);
    });
  }

  QueryBuilder<Profile, Profile, QAfterSortBy> sortByUpdated() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updated', Sort.asc);
    });
  }

  QueryBuilder<Profile, Profile, QAfterSortBy> sortByUpdatedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updated', Sort.desc);
    });
  }
}

extension ProfileQuerySortThenBy
    on QueryBuilder<Profile, Profile, QSortThenBy> {
  QueryBuilder<Profile, Profile, QAfterSortBy> thenByCreated() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'created', Sort.asc);
    });
  }

  QueryBuilder<Profile, Profile, QAfterSortBy> thenByCreatedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'created', Sort.desc);
    });
  }

  QueryBuilder<Profile, Profile, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<Profile, Profile, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<Profile, Profile, QAfterSortBy> thenByMemo() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'memo', Sort.asc);
    });
  }

  QueryBuilder<Profile, Profile, QAfterSortBy> thenByMemoDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'memo', Sort.desc);
    });
  }

  QueryBuilder<Profile, Profile, QAfterSortBy> thenByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<Profile, Profile, QAfterSortBy> thenByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<Profile, Profile, QAfterSortBy> thenByOrder() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'order', Sort.asc);
    });
  }

  QueryBuilder<Profile, Profile, QAfterSortBy> thenByOrderDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'order', Sort.desc);
    });
  }

  QueryBuilder<Profile, Profile, QAfterSortBy> thenByUpdated() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updated', Sort.asc);
    });
  }

  QueryBuilder<Profile, Profile, QAfterSortBy> thenByUpdatedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updated', Sort.desc);
    });
  }
}

extension ProfileQueryWhereDistinct
    on QueryBuilder<Profile, Profile, QDistinct> {
  QueryBuilder<Profile, Profile, QDistinct> distinctByCreated() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'created');
    });
  }

  QueryBuilder<Profile, Profile, QDistinct> distinctByImageBytes() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'imageBytes');
    });
  }

  QueryBuilder<Profile, Profile, QDistinct> distinctByMemo(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'memo', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Profile, Profile, QDistinct> distinctByName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'name', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Profile, Profile, QDistinct> distinctByOrder() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'order');
    });
  }

  QueryBuilder<Profile, Profile, QDistinct> distinctByPersonalTags() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'personalTags');
    });
  }

  QueryBuilder<Profile, Profile, QDistinct> distinctByUpdated() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'updated');
    });
  }
}

extension ProfileQueryProperty
    on QueryBuilder<Profile, Profile, QQueryProperty> {
  QueryBuilder<Profile, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<Profile, DateTime, QQueryOperations> createdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'created');
    });
  }

  QueryBuilder<Profile, List<int>?, QQueryOperations> imageBytesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'imageBytes');
    });
  }

  QueryBuilder<Profile, String, QQueryOperations> memoProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'memo');
    });
  }

  QueryBuilder<Profile, String, QQueryOperations> nameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'name');
    });
  }

  QueryBuilder<Profile, int, QQueryOperations> orderProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'order');
    });
  }

  QueryBuilder<Profile, List<String>, QQueryOperations> personalTagsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'personalTags');
    });
  }

  QueryBuilder<Profile, DateTime?, QQueryOperations> updatedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'updated');
    });
  }
}
