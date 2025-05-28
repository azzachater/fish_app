import 'package:fish_app/constants/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:get/get.dart';
import 'package:fish_app/controller/map_controller_X.dart';
import 'package:google_fonts/google_fonts.dart';

class MapPage extends StatelessWidget {
  final MapControllerX controller = Get.put(MapControllerX());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Carte des Spots de Pêche',
          style: GoogleFonts.poppins(
            textStyle: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.white,
              letterSpacing: 1.2,
            ),
          ),
        ),
        backgroundColor: AppTheme.primaryColor,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ), // <-- couleur de l’icône
          onPressed: () => Navigator.pop(context),
        ),
        elevation: 3,
        centerTitle: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(15)),
        ),
      ),
      body: Stack(
        children: [
          OSMFlutter(
            controller: controller.mapController,
            osmOption: OSMOption(
              userTrackingOption: UserTrackingOption(
                enableTracking: true,
                unFollowUser: false,
              ),
              zoomOption: ZoomOption(
                initZoom: 8,
                minZoomLevel: 3,
                maxZoomLevel: 19,
                stepZoom: 1.0,
              ),
              userLocationMarker: UserLocationMaker(
                personMarker: MarkerIcon(
                  icon: Icon(
                    Icons.location_history_rounded,
                    color: Colors.red,
                    size: 48,
                  ),
                ),
                directionArrowMarker: MarkerIcon(
                  icon: Icon(Icons.double_arrow, size: 48),
                ),
              ),
              roadConfiguration: RoadOption(roadColor: Colors.yellowAccent),
            ),
            onMapIsReady: (isReady) async {
              if (isReady) await controller.fetchFishingSpots();
            },
            onGeoPointClicked: (geoPoint) {
              final spotInfo = controller.fishingSpots[geoPoint];
              if (spotInfo != null) _showSpotDetails(spotInfo);
            },
          ),
          // Remplacer les Positioned existants par :
          Positioned(
            bottom: 20,
            right: 20,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                FloatingActionButton(
                  heroTag: 'filter_button',
                  onPressed: _showFilterSheet,
                  child: Icon(Icons.filter_alt, color: Colors.white),
                  backgroundColor: AppTheme.primaryColor,
                  elevation: 4,
                ),
                SizedBox(height: 15),
                FloatingActionButton(
                  heroTag: 'location_button',
                  onPressed: controller.moveToCurrentLocation,
                  child: Icon(Icons.my_location, color: Colors.white),
                  backgroundColor: AppTheme.primaryColor,
                  elevation: 4,
                ),
              ],
            ),
          ),
          Obx(
            () =>
                controller.isLoading.value
                    ? Center(child: CircularProgressIndicator())
                    : SizedBox.shrink(),
          ),
          Positioned(top: 80, right: 10, child: _buildLegend()),
        ],
      ),
    );
  }

  void _showSpotDetails(Map<String, dynamic> spotInfo) {
    final spotId = spotInfo['id'];
    if (spotId == null)
      return; // pour éviter une exception // Ajoutez cette ligne
    final userId = 1; // Remplacez par l'ID utilisateur réel
    Get.dialog(
      AlertDialog(
        title: Text(
          "Détails du Spot",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDetailRow("Nom", spotInfo['name']),
              _buildDetailRow("Description", spotInfo['description']),
              _buildDetailRow("Espèces", spotInfo['fish_species']),
              _buildDetailRow(
                "Techniques",
                spotInfo['recommendedTechniques']?.isNotEmpty == true
                    ? spotInfo['recommendedTechniques']
                    : 'Aucune technique spécifiée',
              ),
              _buildDetailRow("Profondeur", "${spotInfo['depth']}m"),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: Icon(Icons.thumb_up),
                    onPressed: () => _handleVote(spotId, userId, true),
                  ),
                  Text(
                    '${spotInfo['upvotes']?.toString() ?? '0'}',
                  ), // Affichage sécurisé
                  SizedBox(width: 20),
                  Text('${spotInfo['downvotes']?.toString() ?? '0'}'),
                  IconButton(
                    icon: Icon(Icons.thumb_down),
                    onPressed: () => _handleVote(spotId, userId, false),
                  ),
                ],
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              "Fermer",
              style: TextStyle(color: AppTheme.primaryColor),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: RichText(
        text: TextSpan(
          style: TextStyle(color: Colors.black87, fontSize: 14),
          children: [
            TextSpan(
              text: "$label: ",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            TextSpan(text: value ?? 'Non spécifié'),
          ],
        ),
      ),
    );
  }

  Widget _buildLegend() {
    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Légende", style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: 8),
          _buildLegendItem('Truite', 'assets/images/markers/trout_marker.png'),
          _buildLegendItem('Perche', 'assets/images/markers/perch_marker.png'),
          _buildLegendItem('Brochet', 'assets/images/markers/pike_marker.png'),
          _buildLegendItem(
            'Autre',
            'assets/images/markers/default_fish_marker.png',
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(String text, String iconPath) {
    // Mappez les noms de fichiers
    String actualPath;
    switch (text) {
      case 'Truite':
        actualPath = 'assets/images/markers/trout_fish.png';
        break;
      case 'Perche':
        actualPath = 'assets/images/markers/perch_fish.png';
        break;
      case 'Brochet':
        actualPath = 'assets/images/markers/pike_fish.png';
        break;
      default:
        actualPath = 'assets/images/markers/default_fish.png';
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Image.asset(
            actualPath,
            width: 24,
            height: 24,
            errorBuilder:
                (context, error, stackTrace) =>
                    Icon(Icons.location_pin, size: 24),
          ),
          SizedBox(width: 8),
          Text(text, style: TextStyle(fontSize: 12)),
        ],
      ),
    );
  }

  Future<void> _handleVote(int spotId, int userId, bool isUpvote) async {
    try {
      final success = await Get.find<MapControllerX>().voteOnSpot(
        spotId: spotId,
        isUpvote: isUpvote,
      );

      if (success) {
        Get.back(); // Ferme le dialogue
        Get.snackbar('Succès', 'Votre vote a été enregistré');
        // Rafraîchir les données
        await Get.find<MapControllerX>().fetchFishingSpots();
      } else {
        Get.snackbar('Erreur', 'Échec du vote');
      }
    } catch (e) {
      Get.snackbar('Erreur', 'Une erreur est survenue: ${e.toString()}');
    }
  }

  void _showFilterSheet() {
    Get.bottomSheet(
      Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppTheme.primaryColor.withOpacity(0.95),
          borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'FILTRER PAR ESPÈCE',
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
            ),
            SizedBox(height: 20),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: Obx(
                () => DropdownButton<String>(
                  isExpanded: true,
                  dropdownColor: Colors.white,
                  style: GoogleFonts.poppins(color: AppTheme.primaryColor),
                  icon: Icon(
                    Icons.arrow_drop_down,
                    color: AppTheme.primaryColor,
                  ),
                  value:
                      controller.selectedSpecies.value.isEmpty
                          ? null
                          : controller.selectedSpecies.value,
                  hint: Text(
                    'Sélectionnez une espèce',
                    style: GoogleFonts.poppins(color: Colors.grey),
                  ),
                  items: [
                    DropdownMenuItem(
                      value: '',
                      child: Text(
                        'Toutes les espèces',
                        style: GoogleFonts.poppins(),
                      ),
                    ),
                    ...controller.speciesList.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value, style: GoogleFonts.poppins()),
                      );
                    }).toList(),
                  ],
                  onChanged: (String? newValue) {
                    controller.selectedSpecies.value = newValue ?? '';
                    controller.applyFilters();
                    Get.back();
                  },
                ),
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }
}
