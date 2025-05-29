import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../provider/user_modulos.dart';

class ModulosGrid extends ConsumerWidget {
  const ModulosGrid({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final modulosAsync = ref.watch(modulosProvider);

    return modulosAsync.when(
      loading:
          () => Center(
            child: LoadingAnimationWidget.inkDrop(
              color: Color.fromARGB(255, 85, 57, 112),
              size: 36,
            ),
          ),
      error: (err, stack) => Center(child: Text('Erro: $err')),
      data: (modulos) {
        return SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Wrap(
                alignment: WrapAlignment.center,
                spacing: 12,
                runSpacing: 12,
                children:
                    modulos.map((modulo) {
                      final nome = modulo['nome'] ?? 'Sem nome';
                      final iconName = modulo['icon'] ?? 'help_outline';
                      final route = modulo['route'] ?? '/';

                      return SizedBox(
                        width: 150,
                        child: _HoverCard(
                          nome: nome,
                          iconName: iconName,
                          route: route,
                        ),
                      );
                    }).toList(),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _HoverCard extends StatefulWidget {
  final String nome;
  final String iconName;
  final String route;

  const _HoverCard({
    required this.nome,
    required this.iconName,
    required this.route,
  });

  @override
  State<_HoverCard> createState() => _HoverCardState();
}

class _HoverCardState extends State<_HoverCard> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      cursor: SystemMouseCursors.click,
      child: Tooltip(
        message: widget.nome,
        preferBelow: false,
        child: GestureDetector(
          onTap: () => Navigator.pushNamed(context, widget.route),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            transform:
                _hovering
                    ? Matrix4.translationValues(0, -5, 0)
                    : Matrix4.identity(),
            curve: Curves.easeOut,
            child: Card(
              elevation: _hovering ? 8 : 3,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      _getMaterialIconByName(widget.iconName),
                      size: 32,
                      color: Theme.of(context).splashColor,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.nome.toUpperCase(),
                      style: const TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 12,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  IconData _getMaterialIconByName(String iconName) {
    const iconMap = {
      'shelves': Icons.shelves,
      'factory': Icons.factory,
      'settings': Icons.settings,
      'dashboard': Icons.dashboard,
      'inventory': Icons.inventory,
      'person': Icons.person_outline,
      'help_outline': Icons.help_outline,
      'home': Icons.home,
      'logout': Icons.logout,
      'login': Icons.login,
      'user': Icons.person,
      'profile': Icons.account_circle,
      'barcode_reader': Icons.barcode_reader,
      'calculate': Icons.calculate,
      'engineering': Icons.engineering,
      'real_estate_agent': Icons.real_estate_agent,
      'manage_accounts': Icons.manage_accounts,
      'users': Icons.group,
      'notifications': Icons.notifications,
      'notification_important': Icons.notification_important,
      'email': Icons.email,
      'calendar': Icons.calendar_today,
      'event': Icons.event,
      'alarm': Icons.alarm,
      'time': Icons.access_time,
      'settings_applications': Icons.settings_applications,
      'support': Icons.support_agent,
      'chat': Icons.chat,
      'message': Icons.message,
      'document': Icons.description,
      'file': Icons.insert_drive_file,
      'files': Icons.folder,
      'upload': Icons.cloud_upload,
      'download': Icons.cloud_download,
      'print': Icons.print,
      'scanner': Icons.scanner,
      'report': Icons.assessment,
      'analytics': Icons.analytics,
      'chart': Icons.bar_chart,
      'finance': Icons.attach_money,
      'money': Icons.monetization_on,
      'payment': Icons.payment,
      'wallet': Icons.account_balance_wallet,
      'bank': Icons.account_balance,
      'list': Icons.list,
      'task': Icons.task,
      'check': Icons.check_circle,
      'close': Icons.cancel,
      'delete': Icons.delete,
      'edit': Icons.edit,
      'add': Icons.add,
      'remove': Icons.remove,
      'search': Icons.search,
      'filter': Icons.filter_list,
      'sort': Icons.sort,
      'arrow_forward': Icons.arrow_forward,
      'arrow_back': Icons.arrow_back,
      'expand_more': Icons.expand_more,
      'expand_less': Icons.expand_less,
      'qr_code': Icons.qr_code,
      'barcode': Icons.qr_code_scanner,
      'location': Icons.location_on,
      'map': Icons.map,
      'gps': Icons.gps_fixed,
      'truck': Icons.local_shipping,
      'delivery': Icons.delivery_dining,
      'store': Icons.store,
      'warehouse': Icons.warehouse,
      'production': Icons.precision_manufacturing,
      'build': Icons.build,
      'tools': Icons.handyman,
      'energy': Icons.bolt,
      'warning': Icons.warning,
      'lock': Icons.lock,
      'security': Icons.security,
      'camera': Icons.camera_alt,
      'photo': Icons.photo,
      'image': Icons.image,
      'gallery': Icons.collections,
      'upload_file': Icons.upload_file,
      'download_file': Icons.download,
      'bluetooth': Icons.bluetooth,
      'wifi': Icons.wifi,
      'signal': Icons.signal_cellular_alt,
      'cloud': Icons.cloud,
      'cloud_done': Icons.cloud_done,
      'settings_remote': Icons.settings_remote,
      'device_hub': Icons.device_hub,
      'memory': Icons.memory,
      'code': Icons.code,
      'bug_report': Icons.bug_report,
      'developer_mode': Icons.developer_mode,
      'api': Icons.api,
      'integration': Icons.extension,
      'sync': Icons.sync,
      'backup': Icons.backup,
      'history': Icons.history,
      'hourglass': Icons.hourglass_empty,
      'battery': Icons.battery_full,
      'recycling': Icons.recycling,
      'checklist': Icons.checklist,
      'category': Icons.category,
      'info': Icons.info,
      'announcement': Icons.announcement,
      'arrow_upward': Icons.arrow_upward,
      'arrow_downward': Icons.arrow_downward,
    };

    return iconMap[iconName] ?? Icons.help_outline;
  }
}
