import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hephzibah/core/theme/text_styles.dart';
import 'package:hephzibah/features/auth/infrastructure/auth_service.dart';
import 'package:hephzibah/features/groups/domain/models/group_model.dart';
import 'package:hephzibah/features/groups/presentation/providers/group_provider.dart';

class GroupsListPage extends ConsumerStatefulWidget {
  const GroupsListPage({super.key});

  @override
  ConsumerState<GroupsListPage> createState() => _GroupsListPageState();
}

class _GroupsListPageState extends ConsumerState<GroupsListPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  bool login = false;

  @override
  void initState() {
    super.initState();
    _initializeGroupPage();
  }

  Future<void> _initializeGroupPage() async {
    print("==============Not Reaching ============");
    final loggedIn = await AuthService.isLoggedIn();
    if (loggedIn) {
      print("=============================");
      print("${login} : ${loggedIn}");
      setState(() {
        login = loggedIn;
      });
      print("=============================");
      print("${login} : ${loggedIn}");
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!login) {
      return Scaffold(
        body: Center(child: Text("You Must login to access Goups")),
      );
    }

    final groupsAsync = _searchQuery.isEmpty
        ? ref.watch(groupsProvider)
        : ref.watch(groupSearchProvider({'query': _searchQuery}));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Groups', style: AppTextStyles.headlineSmall),
        actions: [
          IconButton(
            icon: const Icon(Icons.bolt_rounded),
            onPressed: () => ref.invalidate(groupsProvider),
          ),

          IconButton(onPressed: () {}, icon: const Icon(Icons.notifications)),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search groups...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          setState(() {
                            _searchQuery = '';
                          });
                        },
                      )
                    : null,
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
          ),
          Expanded(
            child: groupsAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stackTrace) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Error: $error'),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => ref.invalidate(groupsProvider),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
              data: (groups) {
                if (groups.isEmpty) {
                  return Center(
                    child: Text(
                      _searchQuery.isEmpty
                          ? 'No groups found'
                          : 'No groups found for "$_searchQuery"',
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: () async {
                    ref.invalidate(groupsProvider);
                  },
                  child: ListView.builder(
                    itemCount: groups.length,
                    itemBuilder: (context, index) {
                      final group = groups[index];
                      return GroupListItem(
                        group: group,
                        onTap: () {
                          // Navigate to group details
                          // Navigator.push(context, MaterialPageRoute(
                          //   builder: (context) => GroupDetailsPage(groupId: group.id),
                          // ));
                        },
                        onDelete: () => _deleteGroup(context, ref, group.id),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCreateGroupDialog(context, ref),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _deleteGroup(BuildContext context, WidgetRef ref, String groupId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Group'),
        content: const Text('Are you sure you want to delete this group?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              ref.read(groupManagementProvider.notifier).deleteGroup(groupId);
              Navigator.pop(context);
              // Refresh the list
              ref.invalidate(groupsProvider);
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _showCreateGroupDialog(BuildContext context, WidgetRef ref) {
    // Implement create group dialog using groupFormProvider
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Create New Group'),
        content: const Text('Group creation form will be implemented here'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              // Handle group creation
              Navigator.pop(context);
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }
}

class GroupListItem extends StatelessWidget {
  final Group group;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const GroupListItem({
    super.key,
    required this.group,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: group.profilePicture.isNotEmpty
              ? NetworkImage(group.profilePicture)
              : null,
          child: group.profilePicture.isEmpty
              ? Text(group.name[0].toUpperCase())
              : null,
        ),
        title: Text(group.name),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              group.description,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Text(
              'Type: ${group.groupType}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            Text(
              'Created: ${_formatDate(group.createdAt)}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
        trailing: PopupMenuButton(
          itemBuilder: (context) => [
            const PopupMenuItem(value: 'edit', child: Text('Edit')),
            const PopupMenuItem(value: 'delete', child: Text('Delete')),
          ],
          onSelected: (value) {
            if (value == 'delete') {
              onDelete();
            }
          },
        ),
        onTap: onTap,
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
