import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:koperasi_rsb/widgets-global/reusable-page/timeline_widgets.dart';
import 'package:koperasi_rsb/models/project_list_model.dart';
import 'package:koperasi_rsb/models/history_project_model.dart';
import 'package:koperasi_rsb/providers/project_provider.dart';
import 'package:koperasi_rsb/widgets-global/dialog/sign_contract_dialog.dart';


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
    // Load both agreement and history when tab opens
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
        // Get timeline steps with real data
        final timelineSteps = provider.getTimelineSteps();

        return SingleChildScrollView(
          padding: EdgeInsets.all(deviceWidth * 0.06),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 15),
              
              // Title
              Text(
                "Progres Status Pengajuan Project",
                style: GoogleFonts.roboto(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: deviceHeight * 0.02),

              // Loading state
              if (provider.isLoadingHistory)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(32.0),
                    child: CircularProgressIndicator(),
                  ),
                )
              // Error state
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
              // Timeline with real data
              else
                Stack(
                  children: [
                    // Background dashed vertical line
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
                    
                    // Timeline steps
                    Column(
                      children: List.generate(
                        timelineSteps.length,
                        (index) {
                          final step = timelineSteps[index];
                          final isKontrakStep = step.stepName == "Kontrak Perjanjian";
                          final isAfterKontrak = index > timelineSteps.indexWhere(
                            (s) => s.stepName == "Kontrak Perjanjian"
                          );

                          // Determine current step
                          final isCurrent = _isCurrentStep(timelineSteps, index);

                          return TimelineStepItem(
                            index: index,
                            isLast: index == timelineSteps.length - 1,
                            title: step.stepName,
                            overallStatus: isCurrent ? 'current' : step.overallStatus.toLowerCase(),
                            events: step.toTimelineEvents(),
                            showContractButton: isKontrakStep || isAfterKontrak,
                            hasAgreement: provider.hasAgreementLetter(),
                            isLoadingAgreement: provider.isLoadingAgreement,
                            onDownloadContract: () => _handleDownloadContract(context, provider),
                            onSignContract: () => _handleSignContract(context, provider),
                            // Show "Ajukan Ulang" button if step failed
                            showRetryButton: step.isFailed,
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

  /// Determine if step is current (active)
  bool _isCurrentStep(List<TimelineStepData> steps, int index) {
    // If this step has pending status, it's current
    if (steps[index].isPending) return true;

    // If previous step is success and current has no history, it's current
    if (index > 0 && steps[index - 1].isSuccess && !steps[index].hasHistories) {
      return true;
    }

    // If it's first step and has no history, it's current
    if (index == 0 && !steps[index].hasHistories) {
      return true;
    }

    return false;
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
  }

  void _handleSignContract(BuildContext context, ProjectProvider provider) {
    showSignContractDialog(
      context,
      projectId: widget.project.id,
      onSuccess: () {
        // Reload agreement and history after signing
        provider.loadAgreementLetter(widget.project.id);
        provider.loadProjectHistory(widget.project.id);
      },
    );
  }

  void _handleRetrySubmit(BuildContext context) {
    // TODO: Navigate to edit project page
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Silakan perbaiki dokumen dan ajukan ulang'),
        backgroundColor: Colors.orange,
      ),
    );
    
  }
}