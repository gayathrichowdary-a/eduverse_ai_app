// database_schema_screen.dart
//
// Live production database schema viewer (Supabase).
// Shows every table, its columns, primary keys and foreign keys,
// pulled directly from your Supabase project at runtime — plus an
// "Online / Offline" status alert for the connection itself.
//
// SETUP (one time):
// 1. In pubspec.yaml add:
//      supabase_flutter: ^2.5.0
// 2. Make sure Supabase.initialize(...) has already been called
//    somewhere early in your app (e.g. main.dart) with your project
//    URL + anon key.
// 3. Run supabase_schema_function.sql once in your Supabase project's
//    SQL Editor. That installs the get_schema_tables() function this
//    screen calls.
// 4. Drop this file into screens/admin/ and push to the admin
//    dashboard, e.g.:
//      Navigator.push(context,
//        MaterialPageRoute(builder: (_) => const DatabaseSchemaScreen()));

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DatabaseSchemaScreen extends StatefulWidget {
  const DatabaseSchemaScreen({super.key});

  @override
  State<DatabaseSchemaScreen> createState() => _DatabaseSchemaScreenState();
}

class _DatabaseSchemaScreenState extends State<DatabaseSchemaScreen> {
  static const Color navy = Color(0xFF1D3B64);
  static const Color yellow = Color(0xFFF7C948);
  static const Color background = Color(0xFFF8F8F8);
  static const Color green = Color(0xFF2E7D32);
  static const Color red = Color(0xFFC62828);

  final SupabaseClient _client = Supabase.instance.client;

  bool _isOnline = false;
  bool _loading = true;
  String? _error;
  List<_TableInfo> _tables = [];
  DateTime? _lastChecked;

  @override
  void initState() {
    super.initState();
    _loadSchema();
  }

  Future<void> _loadSchema() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final response = await _client.rpc('get_schema_tables');
      final List data = (response as List?) ?? [];

      final tables = data
          .map((e) => _TableInfo.fromJson(e as Map<String, dynamic>))
          .toList();

      setState(() {
        _tables = tables;
        _isOnline = true;
        _loading = false;
        _lastChecked = DateTime.now();
      });
    } catch (e) {
      setState(() {
        _isOnline = false;
        _loading = false;
        _error = e.toString();
        _lastChecked = DateTime.now();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        backgroundColor: navy,
        foregroundColor: Colors.white,
        title: const Text(
          'Database Schema',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loading ? null : _loadSchema,
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _loadSchema,
        child: ListView(
          padding: const EdgeInsets.all(18),
          children: [
            _StatusBanner(
              isOnline: _isOnline,
              loading: _loading,
              lastChecked: _lastChecked,
              error: _error,
              green: green,
              red: red,
              navy: navy,
            ),
            const SizedBox(height: 20),
            const Text(
              'Production Tables',
              style: TextStyle(
                color: navy,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              _loading
                  ? 'Loading schema from Supabase…'
                  : '${_tables.length} table${_tables.length == 1 ? '' : 's'} found in the public schema.',
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 20),

            if (_loading)
              const Padding(
                padding: EdgeInsets.only(top: 40),
                child: Center(child: CircularProgressIndicator(color: navy)),
              )
            else if (_tables.isEmpty && _error == null)
              const Padding(
                padding: EdgeInsets.only(top: 40),
                child: Center(
                  child: Text(
                    'No tables found in the public schema.',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              )
            else
              ..._tables.map((t) => _TableCard(
                    table: t,
                    navy: navy,
                    yellow: yellow,
                  )),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------
// Status banner: shows whether the live Supabase connection is up
// ---------------------------------------------------------------------
class _StatusBanner extends StatelessWidget {
  final bool isOnline;
  final bool loading;
  final DateTime? lastChecked;
  final String? error;
  final Color green;
  final Color red;
  final Color navy;

  const _StatusBanner({
    required this.isOnline,
    required this.loading,
    required this.lastChecked,
    required this.error,
    required this.green,
    required this.red,
    required this.navy,
  });

  @override
  Widget build(BuildContext context) {
    final Color statusColor = loading ? navy : (isOnline ? green : red);
    final String statusText = loading
        ? 'Checking connection…'
        : (isOnline ? 'Online — connected to Supabase' : 'Offline — connection failed');

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: statusColor.withOpacity(0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: statusColor, width: 1.2),
      ),
      child: Row(
        children: [
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              color: statusColor,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  statusText,
                  style: TextStyle(
                    color: statusColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (lastChecked != null)
                  Text(
                    'Last checked: ${lastChecked!.hour.toString().padLeft(2, '0')}:${lastChecked!.minute.toString().padLeft(2, '0')}:${lastChecked!.second.toString().padLeft(2, '0')}',
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                if (!loading && !isOnline && error != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      error!,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------
// One expandable card per table
// ---------------------------------------------------------------------
class _TableCard extends StatelessWidget {
  final _TableInfo table;
  final Color navy;
  final Color yellow;

  const _TableCard({
    required this.table,
    required this.navy,
    required this.yellow,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: navy, width: 1.2),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          leading: Icon(Icons.table_chart, color: yellow, size: 26),
          title: Text(
            table.name,
            style: TextStyle(
              color: navy,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          subtitle: Text(
            '${table.columns.length} columns'
            '${table.foreignKeys.isNotEmpty ? ' • ${table.foreignKeys.length} foreign key${table.foreignKeys.length == 1 ? '' : 's'}' : ''}',
            style: const TextStyle(color: Colors.grey, fontSize: 12),
          ),
          childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          children: [
            ...table.columns.map((c) => _ColumnRow(column: c, navy: navy)),
            if (table.foreignKeys.isNotEmpty) ...[
              const SizedBox(height: 10),
              Text(
                'Foreign Keys',
                style: TextStyle(
                  color: navy,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 6),
              ...table.foreignKeys.map((fk) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 3),
                    child: Row(
                      children: [
                        const Icon(Icons.link, size: 16, color: Colors.grey),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            '${fk.columnName} → ${fk.referencesTable}.${fk.referencesColumn}',
                            style: const TextStyle(fontSize: 13),
                          ),
                        ),
                      ],
                    ),
                  )),
            ],
          ],
        ),
      ),
    );
  }
}

class _ColumnRow extends StatelessWidget {
  final _ColumnInfo column;
  final Color navy;

  const _ColumnRow({required this.column, required this.navy});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          if (column.isPrimaryKey)
            const Icon(Icons.key, size: 15, color: Color(0xFFF7C948))
          else
            const SizedBox(width: 15),
          const SizedBox(width: 6),
          Expanded(
            flex: 3,
            child: Text(
              column.name,
              style: TextStyle(
                fontWeight: column.isPrimaryKey ? FontWeight.bold : FontWeight.normal,
                color: navy,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              column.dataType,
              style: const TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ),
          if (!column.isNullable)
            const Padding(
              padding: EdgeInsets.only(left: 4),
              child: Text(
                'NOT NULL',
                style: TextStyle(fontSize: 10, color: Colors.redAccent),
              ),
            ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------
// Data models
// ---------------------------------------------------------------------
class _TableInfo {
  final String name;
  final List<_ColumnInfo> columns;
  final List<_ForeignKeyInfo> foreignKeys;

  _TableInfo({
    required this.name,
    required this.columns,
    required this.foreignKeys,
  });

  factory _TableInfo.fromJson(Map<String, dynamic> json) {
    return _TableInfo(
      name: json['table_name'] as String? ?? 'unknown',
      columns: ((json['columns'] as List?) ?? [])
          .map((c) => _ColumnInfo.fromJson(c as Map<String, dynamic>))
          .toList(),
      foreignKeys: ((json['foreign_keys'] as List?) ?? [])
          .map((f) => _ForeignKeyInfo.fromJson(f as Map<String, dynamic>))
          .toList(),
    );
  }
}

class _ColumnInfo {
  final String name;
  final String dataType;
  final bool isNullable;
  final bool isPrimaryKey;

  _ColumnInfo({
    required this.name,
    required this.dataType,
    required this.isNullable,
    required this.isPrimaryKey,
  });

  factory _ColumnInfo.fromJson(Map<String, dynamic> json) {
    return _ColumnInfo(
      name: json['column_name'] as String? ?? '',
      dataType: json['data_type'] as String? ?? '',
      isNullable: (json['is_nullable'] as String? ?? 'YES') == 'YES',
      isPrimaryKey: json['is_primary_key'] as bool? ?? false,
    );
  }
}

class _ForeignKeyInfo {
  final String columnName;
  final String referencesTable;
  final String referencesColumn;

  _ForeignKeyInfo({
    required this.columnName,
    required this.referencesTable,
    required this.referencesColumn,
  });

  factory _ForeignKeyInfo.fromJson(Map<String, dynamic> json) {
    return _ForeignKeyInfo(
      columnName: json['column_name'] as String? ?? '',
      referencesTable: json['references_table'] as String? ?? '',
      referencesColumn: json['references_column'] as String? ?? '',
    );
  }
}