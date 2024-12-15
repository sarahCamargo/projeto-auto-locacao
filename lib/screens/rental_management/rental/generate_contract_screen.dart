import 'package:flutter/material.dart';
import 'package:projeto_auto_locacao/models/rental.dart';

import '../../../services/prefs_service.dart';
import '../../../utils/contract_file_manipulation.dart';
import '../../../utils/show_snackbar.dart';
import 'file_selection_dialog.dart';

class GenerateContractScreen {
  final PrefsService prefsService = PrefsService();
  final Rental rental;

  GenerateContractScreen(this.rental);

  Future<void> showFileSelectionDialog(BuildContext context) async {
    final files = await prefsService.getFiles();

    if (files.isEmpty) {
      showCustomSnackBar(context, 'Nenhum arquivo disponível para seleção.');
      return;
    }

    FileSelectionDialog.show(context, files, (selectedFile) {
      ContractFileManipulation().contractFileManipulation(rental, selectedFile);
    });
  }
}
