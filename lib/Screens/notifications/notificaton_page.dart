import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../CommonFiles/text_style.dart';
import 'cubit/notification_cubit.dart';
import 'cubit/notification_state.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  final ScrollController _scrollController = ScrollController();
  List<dynamic> _notifications = [];
  int _page = 1;
  bool _showLoader = false;
  bool _hasMore = true;
  final String _limit = "10";

  @override
  void initState() {
    super.initState();
    _showLoader = true;
    _getNotifications();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200 &&
        !_showLoader &&
        _hasMore) {
      _page++;
      _getNotifications();
    }
  }

  Future<void> _getNotifications() async {
    await context.read<NotificationCubit>().getNotifications(page: _page);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        surfaceTintColor: Colors.white,
        backgroundColor: Colors.white,
        title: Text(
          AppLocalizations.of(context)?.notification ??  'Notifications',
          style: FontStyles.getStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: BlocConsumer<NotificationCubit, NotificationState>(
            listener: (context, state) {
              _showLoader = false;
              if (state is NotificationLoading) {
                _showLoader = true;
              } else if (state is NotificationFailed) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.error)),
                );
              } else if (state is NotificationSuccess) {
                setState(() {
                  if (_page == 1) {
                    _notifications = state.notifications ?? [];
                  } else {
                    _notifications.addAll(state.notifications ?? []);
                  }
                  _hasMore = state.meta?.total != null &&
                      _notifications.length < state.meta!.total!;
                });
              }
            },
            builder: (context, state) {
              if (_notifications.isEmpty && !_showLoader) {
                return const Center(child: Text('No notifications available'));
              }
              return Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      controller: _scrollController,
                      itemCount: _notifications.length,
                      itemBuilder: (context, index) {
                        final notification = _notifications[index];
                        return Card(
                          margin: const EdgeInsets.only(bottom: 8),
                          child: ListTile(
                            leading: const Icon(Icons.notifications),
                            title: Text(
                              notification.title ?? 'No Title',
                              style: FontStyles.getStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            subtitle: Text(
                              notification.message ?? 'No Message',
                              style: FontStyles.getStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            /*trailing: Text(
                              notification.readAt?.toString() ?? 'Unread',
                              style: const TextStyle(fontSize: 12, color: Colors.grey),
                            ),*/
                          ),
                        );
                      },
                    ),
                  ),
                  if (_showLoader)
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Center(child: CircularProgressIndicator()),
                    ),
                ],
              );
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _page = 1;
            _notifications.clear();
            _hasMore = true;
          });
          _getNotifications();
        },
        child: const Icon(Icons.refresh),
      ),
    );
  }
}