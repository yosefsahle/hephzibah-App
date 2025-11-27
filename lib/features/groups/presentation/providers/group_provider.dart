import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hephzibah/features/groups/data/services/group_services.dart';
import 'package:hephzibah/features/groups/domain/models/group_model.dart';

/// Provider to fetch all groups
final groupsProvider = FutureProvider.autoDispose<List<Group>>((ref) {
  return GroupService.getGroups();
});

/// Provider to fetch a single group by ID
final groupProvider = FutureProvider.autoDispose.family<Group, String>((
  ref,
  groupId,
) {
  return GroupService.getGroup(groupId);
});

/// Provider for search functionality
final groupSearchProvider = FutureProvider.autoDispose
    .family<List<Group>, Map<String, dynamic>>((ref, params) {
      final query = params['query'] as String;
      final page = params['page'] as int? ?? 1;
      final limit = params['limit'] as int? ?? 20;

      return GroupService.searchGroups(query: query, page: page, limit: limit);
    });

/// State for group creation/editing form
class GroupFormState {
  final bool isLoading;
  final String? error;
  final Group? group;

  GroupFormState({this.isLoading = false, this.error, this.group});

  GroupFormState copyWith({bool? isLoading, String? error, Group? group}) {
    return GroupFormState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      group: group ?? this.group,
    );
  }
}

class GroupFormNotifier extends StateNotifier<GroupFormState> {
  GroupFormNotifier() : super(GroupFormState());

  Future<void> createGroup(Group group) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final createdGroup = await GroupService.createGroup(group);
      state = state.copyWith(isLoading: false, group: createdGroup);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> updateGroup(Group group) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final updatedGroup = await GroupService.updateGroup(group);
      state = state.copyWith(isLoading: false, group: updatedGroup);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  void clearState() {
    state = GroupFormState();
  }
}

final groupFormProvider =
    StateNotifierProvider.autoDispose<GroupFormNotifier, GroupFormState>((ref) {
      return GroupFormNotifier();
    });

/// State for group management (delete, etc.)
class GroupManagementState {
  final bool isDeleting;
  final String? error;

  GroupManagementState({this.isDeleting = false, this.error});

  GroupManagementState copyWith({bool? isDeleting, String? error}) {
    return GroupManagementState(
      isDeleting: isDeleting ?? this.isDeleting,
      error: error ?? this.error,
    );
  }
}

class GroupManagementNotifier extends StateNotifier<GroupManagementState> {
  GroupManagementNotifier() : super(GroupManagementState());

  Future<void> deleteGroup(String groupId) async {
    state = state.copyWith(isDeleting: true, error: null);
    try {
      await GroupService.deleteGroup(groupId);
      state = state.copyWith(isDeleting: false);
    } catch (e) {
      state = state.copyWith(isDeleting: false, error: e.toString());
    }
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}

final groupManagementProvider =
    StateNotifierProvider.autoDispose<
      GroupManagementNotifier,
      GroupManagementState
    >((ref) {
      return GroupManagementNotifier();
    });
