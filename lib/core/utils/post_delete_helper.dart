import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../theme/app_colors.dart';
import '../models/post_model.dart';
import '../providers/providers.dart';
import '../services/firestore_service.dart';

/// Centralized, secure helper for executing post deletions across the application.
///
/// Enforces:
/// 1. Current user authentication check
/// 2. Post ownership / Admin authorization verification
/// 3. Claim / Recovery safety lock check
/// 4. User confirmation dialog
/// 5. Double-tap prevention via non-dismissible loading indicator
/// 6. Firestore deletion with proper error handling
/// 7. Riverpod state invalidation and immediate UI refresh
class PostDeleteHelper {
  /// Prompts confirmation and permanently deletes the specified post.
  /// Returns `true` if post was successfully deleted, `false` otherwise.
  static Future<bool> confirmAndDeletePost({
    required BuildContext context,
    required WidgetRef ref,
    required PostModel post,
    VoidCallback? onSuccess,
  }) async {
    final FirestoreService firestoreService = ref.read(
      firestoreServiceProvider,
    );
    final authUser = FirebaseAuth.instance.currentUser;

    // 1. Authenticated User Check
    if (authUser == null || authUser.uid.isEmpty) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please log in to delete your post.'),
            backgroundColor: AppColors.error,
          ),
        );
      }
      return false;
    }

    final currentUid = authUser.uid;
    final currentUserModel = ref.read(currentUserProvider).value;
    final isAdmin = currentUserModel?.role == 'admin';

    debugPrint("DELETE POST START");
    debugPrint("postId: ${post.id}");
    debugPrint("currentUserUid: $currentUid");

    // 2. Ownership / Admin Authorization Check
    if (post.userId != currentUid && post.userId.isNotEmpty && !isAdmin) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('You can only delete your own post.'),
            backgroundColor: AppColors.error,
          ),
        );
      }
      return false;
    }

    // 3. Claim / Recovery Safety Guard Check
    try {
      final claims = await firestoreService.getClaimsForPost(post.id);
      final hasApprovedClaim = claims.any(
        (c) => c.status == 'approved' || c.status == 'completed',
      );
      if (hasApprovedClaim) {
        if (context.mounted) {
          await showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
              title: const Text('Cannot Delete Post'),
              content: const Text(
                'This post has an active approved claim or recovery in progress. Please complete or resolve the recovery process first.',
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text('OK'),
                ),
              ],
            ),
          );
        }
        return false;
      }
    } catch (e) {
      debugPrint("Check claims notice: $e");
    }

    // 4. Confirmation Dialog
    if (!context.mounted) return false;
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Post?'),
        content: Text(
          'Are you sure you want to permanently delete "${post.title}"? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: Colors.white,
            ),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed != true) return false;
    if (!context.mounted) return false;

    // 5. Show Non-Dismissible Loading Dialog to Prevent Double Tap & Multiple Delete Calls
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => const Center(
        child: Card(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text(
                  'Deleting post...',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    try {
      // 6. Execute Firestore Delete (Awaited)
      await firestoreService.deletePost(postId: post.id, userId: currentUid);

      // Dismiss Loading Dialog safely
      if (context.mounted) {
        Navigator.of(context, rootNavigator: true).pop();
      }

      // 7. Refresh Riverpod State Providers
      ref.invalidate(postsStreamProvider);
      ref.invalidate(rawAllPostsStreamProvider);
      ref.invalidate(allHistoryStreamProvider);
      ref.invalidate(userPostsStreamProvider(currentUid));
      if (post.campusId.isNotEmpty) {
        ref.invalidate(campusPostsStreamProvider(post.campusId));
      }

      // 8. Show Success Message & Trigger Success Callback
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Post deleted successfully.'),
            backgroundColor: Colors.green,
          ),
        );
        onSuccess?.call();
      }
      return true;
    } catch (e) {
      debugPrint("Delete error: $e");
      if (e is FirebaseException) {
        debugPrint("Firebase error: ${e.code} ${e.message}");
      }

      // Dismiss Loading Dialog safely on error
      if (context.mounted) {
        Navigator.of(context, rootNavigator: true).pop();
      }

      final errorMsg = e.toString().replaceAll(RegExp(r'\[.*?\]'), '').trim();

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Failed to delete post: ${errorMsg.isEmpty ? "Network error or permission denied." : errorMsg}',
            ),
            backgroundColor: AppColors.error,
          ),
        );
      }
      return false;
    }
  }
}
