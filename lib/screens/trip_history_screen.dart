import 'dart:io';
import 'package:excel/excel.dart' as ex;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:share_plus/share_plus.dart';
import '../l10n/app_localizations.dart';
import '../services/booking_service.dart';

enum ReportFilter { day, week, month, year }

class TripHistoryScreen extends StatefulWidget {
  const TripHistoryScreen({super.key});

  @override
  State<TripHistoryScreen> createState() => _TripHistoryScreenState();
}

class _TripHistoryScreenState extends State<TripHistoryScreen> {
  final BookingService _bookingService = BookingService();
  final List<Map<String, dynamic>> _allBookings = [];
  List<Map<String, dynamic>> _filteredBookings = [];
  int _currentPage = 1;
  bool _loading = false;
  ReportFilter _selectedFilter = ReportFilter.month;
  static const int _pageSize = 15;

  @override
  void initState() {
    super.initState();
    _loadInitial();
  }

  Future<void> _loadInitial() async {
    setState(() {
      _loading = true;
      _allBookings.clear();
      _filteredBookings = [];
      _currentPage = 1;
    });

    try {
      final data = await _bookingService.getUserBookings();
      setState(() {
        _allBookings.addAll(data);
        _applyFilter();
      });
    } catch (_) {
      _showBlueSnack('Failed to load trip history');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _applyFilter() {
    final now = DateTime.now();
    late DateTime start;
    late DateTime end;

    switch (_selectedFilter) {
      case ReportFilter.day:
        start = DateTime(now.year, now.month, now.day);
        end = start.add(const Duration(days: 1));
        break;
      case ReportFilter.week:
        final weekday = now.weekday;
        start = DateTime(now.year, now.month, now.day)
            .subtract(Duration(days: weekday - 1));
        end = start.add(const Duration(days: 7));
        break;
      case ReportFilter.month:
        start = DateTime(now.year, now.month, 1);
        end = DateTime(now.year, now.month + 1, 1);
        break;
      case ReportFilter.year:
        start = DateTime(now.year, 1, 1);
        end = DateTime(now.year + 1, 1, 1);
        break;
    }

    _filteredBookings = _allBookings.where((item) {
      final ts = (item['travelDate'] ?? 0) as int;
      final date = DateTime.fromMillisecondsSinceEpoch(ts);
      return !date.isBefore(start) && date.isBefore(end);
    }).toList()
      ..sort((a, b) =>
          (b['travelDate'] as int).compareTo((a['travelDate'] as int)));
    _currentPage = 1;
  }

  List<Map<String, dynamic>> get _bookings {
    final end = (_currentPage * _pageSize).clamp(0, _filteredBookings.length);
    return _filteredBookings.take(end).toList();
  }

  bool get _hasMore => _bookings.length < _filteredBookings.length;

  Future<void> _exportPdf() async {
    final tr = AppLocalizations.of(context);
    if (_bookings.isEmpty) {
      _showBlueSnack(tr.t('noDataExport'));
      return;
    }
    final doc = pw.Document();
    doc.addPage(
      pw.MultiPage(
        build: (context) => [
          pw.Header(level: 0, child: pw.Text(tr.t('tripHistoryReport'))),
          pw.TableHelper.fromTextArray(
            headers: const ['Date', 'Route', 'Vehicle', 'Passengers', 'Price'],
            data: _bookings.map((b) {
              final date =
                  DateTime.fromMillisecondsSinceEpoch((b['travelDate'] ?? 0) as int);
              return [
                DateFormat('yyyy-MM-dd').format(date),
                '${b['from']} -> ${b['to']}',
                '${b['vehicleName']}',
                '${b['passengers']}',
                'AFN ${b['price']}',
              ];
            }).toList(),
          ),
        ],
      ),
    );
    final bytes = await doc.save();
    await Printing.sharePdf(bytes: bytes, filename: 'trip_history_report.pdf');
  }

  Future<void> _printPdf() async {
    final tr = AppLocalizations.of(context);
    if (_bookings.isEmpty) {
      _showBlueSnack(tr.t('noDataPrint'));
      return;
    }
    final doc = pw.Document();
    doc.addPage(
      pw.MultiPage(
        build: (context) => [
          pw.Header(level: 0, child: pw.Text(tr.t('tripHistoryReport'))),
          pw.TableHelper.fromTextArray(
            headers: const ['Date', 'Route', 'Vehicle', 'Passengers', 'Price'],
            data: _bookings.map((b) {
              final date =
                  DateTime.fromMillisecondsSinceEpoch((b['travelDate'] ?? 0) as int);
              return [
                DateFormat('yyyy-MM-dd').format(date),
                '${b['from']} -> ${b['to']}',
                '${b['vehicleName']}',
                '${b['passengers']}',
                'AFN ${b['price']}',
              ];
            }).toList(),
          ),
        ],
      ),
    );
    await Printing.layoutPdf(onLayout: (_) => doc.save());
  }

  Future<void> _exportExcel() async {
    final tr = AppLocalizations.of(context);
    if (_bookings.isEmpty) {
      _showBlueSnack(tr.t('noDataExport'));
      return;
    }
    final excel = ex.Excel.createExcel();
    final sheet = excel['Report'];
    sheet.appendRow([
      ex.TextCellValue('Date'),
      ex.TextCellValue('From'),
      ex.TextCellValue('To'),
      ex.TextCellValue('Vehicle'),
      ex.TextCellValue('Passengers'),
      ex.TextCellValue('Price'),
    ]);
    for (final booking in _bookings) {
      final date =
          DateTime.fromMillisecondsSinceEpoch((booking['travelDate'] ?? 0) as int);
      sheet.appendRow([
        ex.TextCellValue(DateFormat('yyyy-MM-dd').format(date)),
        ex.TextCellValue('${booking['from']}'),
        ex.TextCellValue('${booking['to']}'),
        ex.TextCellValue('${booking['vehicleName']}'),
        ex.IntCellValue((booking['passengers'] ?? 0) as int),
        ex.IntCellValue((booking['price'] ?? 0) as int),
      ]);
    }
    final bytes = excel.encode();
    if (bytes == null) return;
    final dir = await getTemporaryDirectory();
    final filePath = '${dir.path}/trip_history_report.xlsx';
    final file = File(filePath);
    await file.writeAsBytes(bytes, flush: true);
    await SharePlus.instance.share(
      ShareParams(
        files: [XFile(filePath)],
        text: 'Trip history report',
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tr = AppLocalizations.of(context);
    final total = _bookings.length;
    final totalRevenue = _bookings.fold<int>(
      0,
      (totalValue, item) => totalValue + ((item['price'] ?? 0) as int),
    );
    return Scaffold(
      appBar: AppBar(
        title: Text(tr.t('tripHistoryReport')),
        actions: [
          IconButton(
            onPressed: _exportExcel,
            tooltip: tr.t('exportExcel'),
            icon: const Icon(Icons.table_view_outlined),
          ),
          IconButton(
            onPressed: _exportPdf,
            tooltip: tr.t('exportPdf'),
            icon: const Icon(Icons.picture_as_pdf_outlined),
          ),
          IconButton(
            onPressed: _printPdf,
            tooltip: tr.t('print'),
            icon: const Icon(Icons.print_outlined),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _loadInitial,
        child: ListView(
          padding: const EdgeInsets.all(14),
          children: [
            Wrap(
              spacing: 8,
              children: ReportFilter.values.map((filter) {
                final selected = filter == _selectedFilter;
                return ChoiceChip(
                  label: Text(_filterLabel(filter)),
                  selected: selected,
                  onSelected: (_) {
                    setState(() {
                      _selectedFilter = filter;
                      _applyFilter();
                    });
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(child: _summaryCard(tr.t('trips'), '$total')),
                const SizedBox(width: 10),
                Expanded(child: _summaryCard(tr.t('revenue'), 'AFN $totalRevenue')),
              ],
            ),
            const SizedBox(height: 12),
            if (_loading && _bookings.isEmpty)
              const Center(child: CircularProgressIndicator()),
            if (!_loading && _bookings.isEmpty)
              Padding(
                padding: EdgeInsets.only(top: 30),
                child: Center(child: Text(tr.t('noReportsFound'))),
              ),
            ..._bookings.map(_reportCard),
            const SizedBox(height: 8),
            if (_hasMore)
              ElevatedButton(
                onPressed: _loading
                    ? null
                    : () => setState(() {
                          _currentPage++;
                        }),
                child: Text(_loading ? tr.t('loading') : tr.t('loadMore')),
              ),
          ],
        ),
      ),
    );
  }

  Widget _summaryCard(String title, String value) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(color: Colors.grey)),
          const SizedBox(height: 5),
          Text(value,
              style:
                  const TextStyle(fontWeight: FontWeight.w700, fontSize: 18)),
        ],
      ),
    );
  }

  Widget _reportCard(Map<String, dynamic> booking) {
    final travelDate =
        DateTime.fromMillisecondsSinceEpoch((booking['travelDate'] ?? 0) as int);
    final seats = ((booking['seats'] ?? []) as List).join(', ');
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${booking['from']} -> ${booking['to']}',
            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
          ),
          const SizedBox(height: 4),
          Text(
              '${DateFormat('EEE, dd MMM yyyy').format(travelDate)} | ${booking['vehicleName']}'),
          Text('Passengers: ${booking['passengers']} | Seats: $seats'),
          const SizedBox(height: 4),
          Text('AFN ${booking['price']}',
              style: const TextStyle(
                  color: Color(0xFF1D4ED8), fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }

  String _filterLabel(ReportFilter filter) {
    switch (filter) {
      case ReportFilter.day:
        return AppLocalizations.of(context).t('day');
      case ReportFilter.week:
        return AppLocalizations.of(context).t('week');
      case ReportFilter.month:
        return AppLocalizations.of(context).t('month');
      case ReportFilter.year:
        return AppLocalizations.of(context).t('year');
    }
  }

  void _showBlueSnack(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: const Color(0xFF2563EB),
        behavior: SnackBarBehavior.floating,
        content: Text(message, style: const TextStyle(color: Colors.white)),
      ),
    );
  }
}
