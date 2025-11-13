import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:koperasi_rsb/widgets-global/reusable-page/timeline_widgets.dart';
import 'package:koperasi_rsb/models/project_list_model.dart';
import 'package:koperasi_rsb/models/history_project_model.dart';
import 'package:koperasi_rsb/providers/project_provider.dart';
import 'package:koperasi_rsb/widgets-global/dialog/sign_contract_dialog.dart';
import 'package:koperasi_rsb/screens/proyek/add_project.dart';
import 'dart:io';

class SubmissionStatusTab extends StatefulWidget {
  final ProjectListItem project;

  const SubmissionStatusTab({
    super.key,
    required this.project,
  });

  @override
  State<SubmissionStatusTab> createState() => _SubmissionStatusTabState();
}

class _SubmissionStatusTabState extends State<SubmissionStatusTab> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<ProjectProvider>();
      provider.loadAgreementLetter(widget.project.id);
      provider.loadProjectHistory(widget.project.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;
    final deviceHeight = MediaQuery.of(context).size.height;

    return Consumer<ProjectProvider>(
      builder: (context, provider, child) {
        final timelineSteps = provider.getTimelineSteps();

        return SingleChildScrollView(
          padding: EdgeInsets.all(deviceWidth * 0.06),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 15),
              
              Text(
                "Progres Status Pengajuan Project",
                style: GoogleFonts.roboto(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: deviceHeight * 0.02),

              if (provider.isLoadingHistory)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(32.0),
                    child: CircularProgressIndicator(),
                  ),
                )
              else if (provider.historyError != null)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: Column(
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: 48,
                          color: Colors.red.shade300,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Gagal memuat history',
                          style: GoogleFonts.roboto(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.red.shade700,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          provider.historyError!,
                          style: GoogleFonts.roboto(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton.icon(
                          onPressed: () {
                            provider.loadProjectHistory(widget.project.id);
                          },
                          icon: const Icon(Icons.refresh),
                          label: const Text('Coba Lagi'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              else
                Stack(
                  children: [
                    Positioned.fill(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 16),
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: SizedBox(
                            width: 1,
                            child: DashedLineVertical(
                              color: const Color(0xFFBBBBBB),
                              thickness: 1,
                            ),
                          ),
                        ),
                      ),
                    ),
                    
                    Column(
                      children: List.generate(
                        timelineSteps.length,
                        (index) {
                          final step = timelineSteps[index];
                          final isKontrakStep = step.stepName == "Kontrak Perjanjian";

                          final displayStatus = _getDisplayStatus(timelineSteps, index);
                          
                          // ✅ Check if should show retry button
                          final shouldShowRetry = _shouldShowRetryButton(step);

                          // ✅ NEW: Show contract button ONLY at "Kontrak Perjanjian" step
                          // AND only if it hasn't been signed yet (no SUCCESS in histories)
                          final shouldShowContractButton = isKontrakStep && 
                              step.hasHistories && 
                              !step.isSuccess;

                          return TimelineStepItem(
                            index: index,
                            isLast: index == timelineSteps.length - 1,
                            title: step.stepName,
                            overallStatus: displayStatus,
                            events: step.toTimelineEvents(),
                            showContractButton: shouldShowContractButton,
                            onSignContract: () => _handleSignContract(context, provider),
                            showRetryButton: shouldShowRetry,
                            onRetrySubmit: () => _handleRetrySubmit(context),
                          );
                        },
                      ),
                    ),
                  ],
                ),
            ],
          ),
        );
      },
    );
  }

  String _getDisplayStatus(List<TimelineStepData> steps, int index) {
    final currentStep = steps[index];
    
    if (currentStep.hasHistories) {
      final hasSuccess = currentStep.histories.any((h) => h.isSuccess);
      
      if (hasSuccess) return 'success';
      if (currentStep.isFailed) return 'failed';
      if (currentStep.isPending) return 'pending';
    }
    
    if (index == 0 && !currentStep.hasHistories) {
      return 'current';
    }
    
    if (index > 0 && steps[index - 1].isSuccess && !currentStep.hasHistories) {
      return 'current';
    }
    
    return 'upcoming';
  }

  /// ✅ Show retry button only if latest history is FAILED
  bool _shouldShowRetryButton(TimelineStepData step) {
    if (!step.hasHistories) return false;
    
    // Sort histories chronologically (oldest to newest)
    final sortedHistories = List<HistoryProject>.from(step.histories);
    sortedHistories.sort((a, b) => a.createdAt.compareTo(b.createdAt));
    
    // Get the latest (most recent) history
    final latestHistory = sortedHistories.last;
    
    // Show button ONLY if latest status is FAILED
    return latestHistory.isFailed;
  }

  void _handleDownloadContract(BuildContext context, ProjectProvider provider) {
    if (provider.agreementLetter == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Kontrak belum tersedia'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Downloading kontrak...'),
        backgroundColor: Colors.blue,
      ),
    );
  }

  /// ✅ UPDATED: Now uses SignatureInputDialog directly
  void _handleSignContract(BuildContext context, ProjectProvider provider) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) => _SignContractConfirmDialog(
        projectId: widget.project.id,
        onSuccess: () {
          provider.loadAgreementLetter(widget.project.id);
          provider.loadProjectHistory(widget.project.id);
        },
      ),
    );
  }

  void _handleRetrySubmit(BuildContext context) {
    final provider = context.read<ProjectProvider>();
    
    provider.loadProjectForEdit(widget.project.id).then((_) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => const AddProjectPage(),
        ),
      ).then((_) {
        provider.loadProjectHistory(widget.project.id);
        provider.loadUserProjects();
      });
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal memuat data: $error'),
          backgroundColor: Colors.red,
        ),
      );
    });
  }
}

/// ✅ Sign Contract Confirmation Dialog
class _SignContractConfirmDialog extends StatefulWidget {
  final String projectId;
  final VoidCallback? onSuccess;

  const _SignContractConfirmDialog({
    required this.projectId,
    this.onSuccess,
  });

  @override
  State<_SignContractConfirmDialog> createState() => _SignContractConfirmDialogState();
}

class _SignContractConfirmDialogState extends State<_SignContractConfirmDialog> {
  bool _isProcessing = false;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 500),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Icon(Icons.description, color: const Color(0xFF12B76A), size: 28),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Tanda Tangani Kontrak',
                    style: GoogleFonts.roboto(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: _isProcessing ? null : () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Info text
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFF12B76A)),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline, color: const Color(0xFF12B76A)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Dengan menandatangani kontrak ini, Anda menyetujui semua syarat dan ketentuan yang berlaku.',
                      style: GoogleFonts.roboto(
                        fontSize: 14,
                        color: const Color(0xFF0D47A1),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Action buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: _isProcessing ? null : () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.grey.shade700,
                      side: BorderSide(color: Colors.grey.shade300),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: const Text('Batal'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _isProcessing ? null : _handleSignContract,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF12B76A),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: _isProcessing
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation(Colors.white),
                            ),
                          )
                        : const Text('Tanda Tangani'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _handleSignContract() async {
    // ✅ Show signature input dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext signatureContext) => SignatureInputDialog(
        onSignatureSubmitted: (File signatureFile) {
          // Process the signature
          _submitSignature(signatureFile);
        },
      ),
    );
  }

  void _submitSignature(File signatureFile) async {
    setState(() {
      _isProcessing = true;
    });

    try {
      final provider = context.read<ProjectProvider>();
      final success = await provider.signAgreementLetter(
        widget.projectId,
        signatureFile,
      );

      if (!mounted) return;

      if (success) {
        // Close this dialog
        Navigator.pop(context);

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.check_circle, color: Colors.white),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text('Kontrak berhasil ditandatangani'),
                ),
              ],
            ),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
          ),
        );

        // Call success callback
        widget.onSuccess?.call();
      } else {
        // Show error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.error_outline, color: Colors.white),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    provider.signAgreementError ?? 'Gagal menandatangani kontrak',
                  ),
                ),
              ],
            ),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.error_outline, color: Colors.white),
              const SizedBox(width: 12),
              Expanded(child: Text('Error: ${e.toString()}')),
            ],
          ),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isProcessing = false;
        });
      }
    }
  }
}