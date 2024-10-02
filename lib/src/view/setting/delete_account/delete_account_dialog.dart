import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../component/error_dialog.dart';
import '../../../model/custom_error.dart';
import 'delete_account_provider.dart';

class DeleteAccountDialog extends ConsumerStatefulWidget {
  const DeleteAccountDialog({super.key});

  @override
  _DeleteAccountDialogState createState() => _DeleteAccountDialogState();
}

class _DeleteAccountDialogState extends ConsumerState<DeleteAccountDialog> {
  bool submitting = false;

  Future<void> _deleteAccount() async {
    await ref.read(deleteAccountProvider.notifier).deleteAccount();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue<void>>(
      deleteAccountProvider,
      (previous, next) {
        next.whenOrNull(
          error: (e, st) {
            errorDialog(context, e as CustomError);
          },
          data: (_) {
            GoRouter.of(context).pop();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Account deleted successfully'),
              ),
            );
          },
        );
      },
    );

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: AlertDialog(
        title: const Text('Delete Account'),
        content: const Text(
            'Are you sure you want to delete your account? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () {
              GoRouter.of(context).pop();
            },
            child: const Text('Cancle'),
          ),
          TextButton(
            onPressed: () => _deleteAccount(),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
