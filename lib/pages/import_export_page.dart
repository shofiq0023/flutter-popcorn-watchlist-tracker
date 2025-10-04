import 'package:flutter/material.dart';
import 'package:popcorn/providers/import_export_provider.dart';
import 'package:popcorn/utils/toast_helper.dart';
import 'package:popcorn/widgets/navigation_drawer.dart';
import 'package:provider/provider.dart';
import 'package:popcorn/utils/global_const.dart';

class ImportExportPage extends StatefulWidget {
  const ImportExportPage({super.key});

  @override
  State<ImportExportPage> createState() => _ImportExportPageState();
}

class _ImportExportPageState extends State<ImportExportPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF111129),
      appBar: AppBar(
        title: Text(
          "Backup & Restore",
          style: TextStyle(
            color: GlobalConst.whiteColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: IconThemeData(color: GlobalConst.whiteColor),
        backgroundColor: Color(0xFF1D193A),
      ),
      drawer: const MyNavigationDrawer(),
      drawerEnableOpenDragGesture: true,
      drawerEdgeDragWidth: 600,
      body: Consumer<ImportExportProvider>(
        builder: (context, provider, child) {
          return Column(
            children: [
              Visibility(
                visible: provider.isLoading,
                child: const LinearProgressIndicator(
                  backgroundColor: Color(0xFF2A2545),
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF7C3AED)),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    children: [
                      const SizedBox(height: 20),

                      // Create Backup Card
                      _buildActionCard(
                        icon: Icons.upload_file_rounded,
                        title: "Create Backup",
                        description: "Export your watchlist data to a backup file in Downloads folder",
                        buttonText: "Create Backup",
                        buttonColor: Color(0xFF7C3AED),
                        onPressed: () async {
                          if (await provider.exportTableToJson()) {
                            ToastHelper.showSuccessToast(
                              "Successfully created backup at Downloads folder",
                            );
                          } else {
                            ToastHelper.showErrorToast(
                              "Could not create backup",
                            );
                          }
                        },
                      ),

                      const SizedBox(height: 20),

                      // Restore Backup Card
                      _buildActionCard(
                        icon: Icons.restore_page_rounded,
                        title: "Restore Backup",
                        description: "Import your watchlist data from a previously created backup file",
                        buttonText: "Restore Backup",
                        buttonColor: Color(0xFF10B981),
                        onPressed: () async {
                          if (await provider.pickAndReadJsonFile()) {
                            ToastHelper.showSuccessToast(
                              "Backup restored successfully",
                            );
                          } else {
                            ToastHelper.showErrorToast(
                              "Could not restore backup",
                            );
                          }
                        },
                      ),

                      const SizedBox(height: 32),

                      // Info Section
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Color(0xFF1D193A).withOpacity(0.5),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: Color(0xFF7C3AED).withOpacity(0.2),
                            width: 1,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.info_outline_rounded,
                                  color: Color(0xFF7C3AED),
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  "Important Information",
                                  style: TextStyle(
                                    color: GlobalConst.whiteColor,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            _buildInfoItem("• Backups are stored in JSON format"),
                            _buildInfoItem("• All watchlist entries are included"),
                            _buildInfoItem("• Restore will replace existing data"),
                            _buildInfoItem("• Keep backups in a safe location"),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildActionCard({
    required IconData icon,
    required String title,
    required String description,
    required String buttonText,
    required Color buttonColor,
    required VoidCallback onPressed,
  }) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Color(0xFF1D193A),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: buttonColor.withValues(alpha: 0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: buttonColor.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: buttonColor.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: buttonColor,
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    color: GlobalConst.whiteColor,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            description,
            style: TextStyle(
              color: GlobalConst.whiteColor.withOpacity(0.7),
              fontSize: 14,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: buttonColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(icon, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    buttonText,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: TextStyle(
          color: GlobalConst.whiteColor.withOpacity(0.7),
          fontSize: 14,
          height: 1.5,
        ),
      ),
    );
  }
}