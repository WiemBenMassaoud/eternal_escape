import 'package:flutter/material.dart';
import '../utils/theme.dart';
import '../models/logement.dart';

class RoomPensionSelector extends StatefulWidget {
  final Logement logement;
  final int initialNombreChambres;
  final int initialNombreSuites;
  final String? initialPensionType;
  final Function(int chambres, int suites, String pension) onChanged;

  const RoomPensionSelector({
    Key? key,
    required this.logement,
    this.initialNombreChambres = 1,
    this.initialNombreSuites = 0,
    this.initialPensionType,
    required this.onChanged,
  }) : super(key: key);

  @override
  State<RoomPensionSelector> createState() => _RoomPensionSelectorState();
}

class _RoomPensionSelectorState extends State<RoomPensionSelector> {
  late int nombreChambres;
  late int nombreSuites;
  late String selectedPension;

  // Options de pension selon le type de logement
  List<Map<String, dynamic>> get pensionOptions {
    switch (widget.logement.type.toLowerCase()) {
      case 'hôtel':
        return [
          {
            'value': 'Sans pension',
            'label': 'Sans pension',
            'icon': Icons.close_rounded,
            'description': 'Hébergement seul',
            'priceMultiplier': 0.0,
          },
          {
            'value': 'Petit déjeuner',
            'label': 'Petit déjeuner',
            'icon': Icons.breakfast_dining_rounded,
            'description': 'Petit déjeuner inclus',
            'priceMultiplier': 0.10,
          },
          {
            'value': 'Demi-pension',
            'label': 'Demi-pension',
            'icon': Icons.restaurant_rounded,
            'description': 'Petit déjeuner + dîner',
            'priceMultiplier': 0.25,
          },
          {
            'value': 'All Inclusive',
            'label': 'All Inclusive',
            'icon': Icons.all_inclusive_rounded,
            'description': 'Tous repas + boissons',
            'priceMultiplier': 0.45,
          },
        ];
      case 'villa':
      case 'maison':
        return [
          {
            'value': 'Sans pension',
            'label': 'Sans pension',
            'icon': Icons.close_rounded,
            'description': 'Hébergement seul',
            'priceMultiplier': 0.0,
          },
          {
            'value': 'Petit déjeuner',
            'label': 'Petit déjeuner',
            'icon': Icons.breakfast_dining_rounded,
            'description': 'Petit déjeuner inclus',
            'priceMultiplier': 0.15,
          },
        ];
      default:
        return [
          {
            'value': 'Sans pension',
            'label': 'Sans pension',
            'icon': Icons.close_rounded,
            'description': 'Hébergement seul',
            'priceMultiplier': 0.0,
          },
        ];
    }
  }

  @override
  void initState() {
    super.initState();
    nombreChambres = widget.initialNombreChambres;
    nombreSuites = widget.initialNombreSuites;
    selectedPension = widget.initialPensionType ?? 
                      widget.logement.pensionType ?? 
                      pensionOptions.first['value'];
  }

  void _updateSelection() {
    widget.onChanged(nombreChambres, nombreSuites, selectedPension);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppTheme.paddingXL),
      decoration: BoxDecoration(
        color: AppTheme.backgroundLight,
        borderRadius: BorderRadius.circular(AppTheme.radiusMD),
        border: Border.all(color: AppTheme.borderLight),
        boxShadow: AppTheme.shadowLight,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // En-tête
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(AppTheme.paddingSM),
                decoration: BoxDecoration(
                  gradient: AppTheme.primaryGradient,
                  borderRadius: BorderRadius.circular(AppTheme.radiusSM),
                ),
                child: Icon(
                  Icons.hotel_rounded,
                  color: AppTheme.textLight,
                  size: 20,
                ),
              ),
              SizedBox(width: AppTheme.marginMD),
              Text(
                'Chambres & Pension',
                style: AppTheme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          SizedBox(height: AppTheme.marginXL),

          // Sélecteur de chambres
          _buildRoomSelector(),

          // Sélecteur de suites (si disponible)
          if (widget.logement.hasSuites == true) ...[
            SizedBox(height: AppTheme.marginLG),
            _buildSuiteSelector(),
          ],

          SizedBox(height: AppTheme.marginXXL),

          // Sélecteur de pension
          Text(
            'Type de pension',
            style: AppTheme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: AppTheme.marginMD),
          Text(
            'Choisissez votre formule de restauration',
            style: AppTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.textSecondary,
            ),
          ),
          SizedBox(height: AppTheme.marginLG),

          ...pensionOptions.map((option) => _buildPensionOption(option)),
        ],
      ),
    );
  }

  Widget _buildRoomSelector() {
    return Container(
      padding: EdgeInsets.all(AppTheme.paddingLG),
      decoration: BoxDecoration(
        color: AppTheme.backgroundAlt,
        borderRadius: BorderRadius.circular(AppTheme.radiusSM),
        border: Border.all(color: AppTheme.borderLight),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(AppTheme.paddingSM),
            decoration: BoxDecoration(
              color: AppTheme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(AppTheme.radiusSM),
            ),
            child: Icon(Icons.bed_rounded, color: AppTheme.primary, size: 24),
          ),
          SizedBox(width: AppTheme.marginMD),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Chambres standard',
                  style: AppTheme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'Max ${widget.logement.nombreChambresDisponibles ?? widget.logement.nombreChambres} disponibles',
                  style: AppTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: [
              _buildCounterButton(
                icon: Icons.remove_rounded,
                onPressed: () {
                  if (nombreChambres > 1) {
                    setState(() => nombreChambres--);
                    _updateSelection();
                  }
                },
                enabled: nombreChambres > 1,
              ),
              Container(
                width: 50,
                alignment: Alignment.center,
                child: Text(
                  '$nombreChambres',
                  style: AppTheme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: AppTheme.primary,
                  ),
                ),
              ),
              _buildCounterButton(
                icon: Icons.add_rounded,
                onPressed: () {
                  int maxChambres = widget.logement.nombreChambresDisponibles ?? 
                                   widget.logement.nombreChambres;
                  if (nombreChambres < maxChambres) {
                    setState(() => nombreChambres++);
                    _updateSelection();
                  }
                },
                enabled: nombreChambres < (widget.logement.nombreChambresDisponibles ?? 
                                           widget.logement.nombreChambres),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSuiteSelector() {
    return Container(
      padding: EdgeInsets.all(AppTheme.paddingLG),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.accentLight.withOpacity(0.1),
            AppTheme.accentDark.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(AppTheme.radiusSM),
        border: Border.all(color: AppTheme.accentDark.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(AppTheme.paddingSM),
            decoration: BoxDecoration(
              color: AppTheme.accentDark.withOpacity(0.15),
              borderRadius: BorderRadius.circular(AppTheme.radiusSM),
            ),
            child: Icon(Icons.king_bed_rounded, color: AppTheme.accentDark, size: 24),
          ),
          SizedBox(width: AppTheme.marginMD),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'Suites Premium',
                      style: AppTheme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(width: AppTheme.marginSM),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: AppTheme.paddingSM,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        gradient: AppTheme.promoGradient,
                        borderRadius: BorderRadius.circular(AppTheme.radiusCircle),
                      ),
                      child: Text(
                        '+${widget.logement.prixSuite?.toStringAsFixed(0) ?? '50'} DT',
                        style: AppTheme.textTheme.labelSmall?.copyWith(
                          color: AppTheme.textLight,
                          fontWeight: FontWeight.w700,
                          fontSize: 10,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 2),
                Text(
                  'Plus d\'espace et confort',
                  style: AppTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: [
              _buildCounterButton(
                icon: Icons.remove_rounded,
                onPressed: () {
                  if (nombreSuites > 0) {
                    setState(() => nombreSuites--);
                    _updateSelection();
                  }
                },
                enabled: nombreSuites > 0,
              ),
              Container(
                width: 50,
                alignment: Alignment.center,
                child: Text(
                  '$nombreSuites',
                  style: AppTheme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: AppTheme.accentDark,
                  ),
                ),
              ),
              _buildCounterButton(
                icon: Icons.add_rounded,
                onPressed: () {
                  if (nombreSuites < 5) {
                    setState(() => nombreSuites++);
                    _updateSelection();
                  }
                },
                enabled: nombreSuites < 5,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPensionOption(Map<String, dynamic> option) {
    final isSelected = selectedPension == option['value'];
    
    return Container(
      margin: EdgeInsets.only(bottom: AppTheme.marginMD),
      decoration: BoxDecoration(
        color: AppTheme.backgroundAlt,
        borderRadius: BorderRadius.circular(AppTheme.radiusSM),
        border: Border.all(
          color: isSelected ? AppTheme.primary : AppTheme.borderLight,
          width: isSelected ? 2 : 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            setState(() => selectedPension = option['value']);
            _updateSelection();
          },
          borderRadius: BorderRadius.circular(AppTheme.radiusSM),
          child: Padding(
            padding: EdgeInsets.all(AppTheme.paddingLG),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(AppTheme.paddingSM),
                  decoration: BoxDecoration(
                    gradient: isSelected ? AppTheme.primaryGradient : null,
                    color: isSelected ? null : AppTheme.backgroundLight,
                    borderRadius: BorderRadius.circular(AppTheme.radiusSM),
                  ),
                  child: Icon(
                    option['icon'],
                    color: isSelected ? AppTheme.textLight : AppTheme.textSecondary,
                    size: 20,
                  ),
                ),
                SizedBox(width: AppTheme.marginMD),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        option['label'],
                        style: AppTheme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: isSelected ? AppTheme.primary : AppTheme.textPrimary,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        option['description'],
                        style: AppTheme.textTheme.bodySmall?.copyWith(
                          color: AppTheme.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                if (option['priceMultiplier'] > 0) ...[
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppTheme.paddingMD,
                      vertical: AppTheme.paddingXS,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.success.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(AppTheme.radiusCircle),
                      border: Border.all(color: AppTheme.success),
                    ),
                    child: Text(
                      '+${(option['priceMultiplier'] * 100).toStringAsFixed(0)}%',
                      style: AppTheme.textTheme.labelSmall?.copyWith(
                        color: AppTheme.success,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  SizedBox(width: AppTheme.marginMD),
                ],
                Radio<String>(
                  value: option['value'],
                  groupValue: selectedPension,
                  onChanged: (value) {
                    setState(() => selectedPension = value!);
                    _updateSelection();
                  },
                  activeColor: AppTheme.primary,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCounterButton({
    required IconData icon,
    required VoidCallback onPressed,
    required bool enabled,
  }) {
    return Container(
      decoration: BoxDecoration(
        gradient: enabled ? AppTheme.primaryGradient : null,
        color: enabled ? null : AppTheme.backgroundAlt,
        borderRadius: BorderRadius.circular(AppTheme.radiusSM),
        border: Border.all(
          color: enabled ? Colors.transparent : AppTheme.borderLight,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: enabled ? onPressed : null,
          borderRadius: BorderRadius.circular(AppTheme.radiusSM),
          child: Padding(
            padding: EdgeInsets.all(AppTheme.paddingSM),
            child: Icon(
              icon,
              size: 20,
              color: enabled ? AppTheme.textLight : AppTheme.textTertiary,
            ),
          ),
        ),
      ),
    );
  }
}