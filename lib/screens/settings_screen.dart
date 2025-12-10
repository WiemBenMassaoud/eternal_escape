import 'package:flutter/material.dart';
import 'room_management_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool notificationsEnabled = true;
  
  // Configuration des chambres
  int nombreChambresNormales = 10;
  int nombreSuites = 5;
  double prixChambreNormale = 150.0;
  double prixSuite = 300.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Paramètres"),
        backgroundColor: Colors.deepPurple,
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          // Section: Configuration des Chambres
          Text(
            "Configuration des Chambres",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.deepPurple,
            ),
          ),
          SizedBox(height: 12),
          
          // Chambres Normales
          Card(
            elevation: 3,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.bed, color: Colors.blue),
                      SizedBox(width: 8),
                      Text(
                        "Chambres Normales",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  
                  // Nombre de chambres normales
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Nombre de chambres:"),
                      Row(
                        children: [
                          IconButton(
                            icon: Icon(Icons.remove_circle_outline),
                            onPressed: () {
                              if (nombreChambresNormales > 0) {
                                setState(() => nombreChambresNormales--);
                              }
                            },
                          ),
                          Text(
                            "$nombreChambresNormales",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.add_circle_outline),
                            onPressed: () {
                              setState(() => nombreChambresNormales++);
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                  
                  Divider(),
                  
                  // Prix chambre normale
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Prix par nuit:"),
                      Row(
                        children: [
                          IconButton(
                            icon: Icon(Icons.remove_circle_outline),
                            onPressed: () {
                              if (prixChambreNormale > 10) {
                                setState(() => prixChambreNormale -= 10);
                              }
                            },
                          ),
                          Text(
                            "${prixChambreNormale.toStringAsFixed(0)} DT",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.add_circle_outline),
                            onPressed: () {
                              setState(() => prixChambreNormale += 10);
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          
          SizedBox(height: 16),
          
          // Suites
          Card(
            elevation: 3,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.hotel, color: Colors.amber),
                      SizedBox(width: 8),
                      Text(
                        "Suites",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  
                  // Nombre de suites
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Nombre de suites:"),
                      Row(
                        children: [
                          IconButton(
                            icon: Icon(Icons.remove_circle_outline),
                            onPressed: () {
                              if (nombreSuites > 0) {
                                setState(() => nombreSuites--);
                              }
                            },
                          ),
                          Text(
                            "$nombreSuites",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.add_circle_outline),
                            onPressed: () {
                              setState(() => nombreSuites++);
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                  
                  Divider(),
                  
                  // Prix suite
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Prix par nuit:"),
                      Row(
                        children: [
                          IconButton(
                            icon: Icon(Icons.remove_circle_outline),
                            onPressed: () {
                              if (prixSuite > 10) {
                                setState(() => prixSuite -= 10);
                              }
                            },
                          ),
                          Text(
                            "${prixSuite.toStringAsFixed(0)} DT",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.add_circle_outline),
                            onPressed: () {
                              setState(() => prixSuite += 10);
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          
          SizedBox(height: 24),
          
          // Section: Autres Paramètres
          Text(
            "Autres Paramètres",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.deepPurple,
            ),
          ),
          SizedBox(height: 12),
          
          // Notifications
          Card(
            elevation: 3,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: SwitchListTile(
              title: Text("Notifications"),
              secondary: Icon(Icons.notifications, color: Colors.deepPurple),
              value: notificationsEnabled,
              onChanged: (val) {
                setState(() => notificationsEnabled = val);
              },
            ),
          ),
          
          // Gestion des Chambres
          Card(
            elevation: 3,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: ListTile(
              leading: Icon(Icons.hotel, color: Colors.deepPurple),
              title: Text("Gestion des Chambres"),
              subtitle: Text("Configurer les types et prix"),
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RoomManagementScreen(),
                  ),
                );
              },
            ),
          ),
          
          // Thème
          Card(
            elevation: 3,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: ListTile(
              leading: Icon(Icons.color_lens, color: Colors.deepPurple),
              title: Text("Thème"),
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: () {
                // Navigation vers page de thème
              },
            ),
          ),
          
          // Déconnexion
          Card(
            elevation: 3,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: ListTile(
              leading: Icon(Icons.logout, color: Colors.red),
              title: Text("Déconnexion"),
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: () {
                // Logique de déconnexion
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text("Déconnexion"),
                    content: Text("Voulez-vous vraiment vous déconnecter ?"),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text("Annuler"),
                      ),
                      TextButton(
                        onPressed: () {
                          // Action de déconnexion
                          Navigator.pop(context);
                        },
                        child: Text("Confirmer"),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          
          SizedBox(height: 24),
          
          // Bouton Sauvegarder
          ElevatedButton(
            onPressed: () {
              // Sauvegarder les paramètres
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("Paramètres sauvegardés avec succès!"),
                  backgroundColor: Colors.green,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepPurple,
              padding: EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              "Sauvegarder les Paramètres",
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}