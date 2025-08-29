import 'package:catalogue_3av/widgets/finance/firstEmprunt.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../controllers/finance_controller.dart';
import '../model/mode_paiement.dart';
import '../widgets/finance/globalSummary.dart';
import '../widgets/finance/loanRepayement.dart';
import '../widgets/navbar_roots.dart';

class MemberLoansScreen extends StatefulWidget {
  @override
  _MemberLoansScreenState createState() => _MemberLoansScreenState();
}

class _MemberLoansScreenState extends State<MemberLoansScreen>
    with SingleTickerProviderStateMixin {
  final FinanceController _financeController = Get.put(FinanceController());

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    // });
    _financeController.getListePret();
    _financeController.getListeRemboursement();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => NavBarRoots()),
            );
          },
        ),
        centerTitle: true,
        title: Text('Mes Finances', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.deepPurple,
        // actions: [
        //   IconButton(
        //     icon: Icon(Icons.add, color: Colors.white),
        //     onPressed: _showLoanFormModal,
        //   ),
        // ],
        bottom: TabBar(
          controller: _tabController,
          onTap: (index) {
            if (index == 0) {
              _showLoanFormModal();
            }
          },
          tabs: const [
            Tab(
              icon: Icon(Icons.list_alt, color: Colors.white),
              text: 'Demandes',
            ),
            Tab(
              icon: Icon(Icons.payment, color: Colors.white),
              text: 'Paiements',
            ),
            Tab(
              icon: Icon(Icons.analytics, color: Colors.white),
              text: 'Statistiques',
            ),
          ],
          indicatorColor: Colors.white,
          labelColor: Colors.white, // Couleur du texte sélectionné
          unselectedLabelColor:
              Colors.white70, // Couleur du texte non sélectionné
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: TabBarView(
          controller: _tabController,
          children: [_buildLoansTab(), _buildRepaymentsTab(), _buildStatsTab()],
        ),
      ),
    );
  }

  // ---------------------
  // Tabs
  // ---------------------

  Widget _buildLoansTab() {
    return Obx(() {
      if (_financeController.isLoading.value) {
        return Center(child: CircularProgressIndicator());
      }

      if (_financeController.listePret.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.money_off, size: 50, color: Colors.grey),
              SizedBox(height: 16),
              Text("Aucun prêt enregistré", style: TextStyle(fontSize: 18)),
              SizedBox(height: 8),
              Text("Cliquez sur + pour faire une demande"),
            ],
          ),
        );
      }

      return RefreshIndicator(
        onRefresh: () => _financeController.getListePret(),
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: FirstEmprunt(pretList: _financeController.listePret),
        ),
      );
    });
  }

  Widget _buildRepaymentsTab() {
    return Obx(() {
      if (_financeController.remboursements.isEmpty) {
        return const Center(
          child: Text(
            "Aucun remboursement effectué pour le moment.",
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        );
      }
      return LoanRepaymentScreen(
        remboursementList: _financeController.remboursements,
      );
    });
  }

  Widget _buildStatsTab() {
    return Obx(() {
      if (_financeController.remboursements.isEmpty) {
        return const Center(
          child: Text(
            "Aucun remboursement effectué pour le moment.",
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        );
      }
      return GlobalSummary(
        remboursementList: _financeController.remboursements,
      );
    });
  }

  // ---------------------
  // Formulaire modale
  // ---------------------

  void _showLoanFormModal() {
    final TextEditingController _montantController = TextEditingController();
    final TextEditingController _trimestreController = TextEditingController();
    final TextEditingController _modePaiementController =
        TextEditingController();
    final TextEditingController _contactController = TextEditingController();
    final TextEditingController _montantTotalController =
        TextEditingController();
    final FinanceController _financeController = Get.put(FinanceController());
    final maxLoanAmount = 500000;
    String selectedPayment = 'MTN CI';
    int calculatedInterest = 0;
    int selectedValue = 0;
    int totalAmount = 0; // Montant total (montant saisi + intérêt)
    double amountPerTerm = 0; // Montant à payer par trimestre

    bool isPhoneFieldEnabled = true;
    String getPhoneHint() {
      if (selectedPayment == 'MTN CI') return 'Ex: 05XXXXXXXX';
      if (selectedPayment == 'ORANGE CI') return 'Ex: 07XXXXXXXX';
      if (selectedPayment == 'MOOV CI') return 'Ex: 01XXXXXXXX';
      if (selectedPayment == 'WAVE') return 'Ex: XXXXXXXXXXXX';
      return '';
    }

    String? getPhonePrefix() {
      if (selectedPayment == 'MTN CI') return '05';
      if (selectedPayment == 'ORANGE CI') return '07';
      if (selectedPayment == 'MOOV CI') return '01';
      return null;
    }
  final List<int> trimestres = [1, 2]; // ou n'importe quels nombres

    @override
    void dispose() {
      _contactController.dispose();
      super.dispose();
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            top: 20,
            left: 20,
            right: 20,
          ),
          child: StatefulBuilder(
            builder: (context, setModalState) {
              return SingleChildScrollView(
                child: Column(
                  children: [
                    Text(
                      "Formulaire de demande du prêt",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      initialValue: NumberFormat('#,##0').format(maxLoanAmount),
                      enabled: false,

                      decoration: InputDecoration(
                        labelStyle: TextStyle(
                          fontSize: 18,
                          color: Colors.black54,
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.normal,
                        ),
                        labelText: 'Montant maximum (FCFA)',
                        border: OutlineInputBorder(),
                        filled: true,
                        fillColor: Colors.grey[200],
                      ),
                    ),
                    SizedBox(height: 12),
                    TextFormField(
                      controller: _montantController,
                      keyboardType: TextInputType.number,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      decoration: InputDecoration(
                        labelStyle: TextStyle(
                          fontSize: 18,
                          color: Colors.black54,
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.normal,
                        ),
                        labelText: 'Montant à emprunter',
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (value) {
                        final input =
                            int.tryParse(value.replaceAll(' ', '')) ?? 0;
                        setModalState(() {
                          calculatedInterest = (input * 0.07).round();
                          totalAmount = (input + calculatedInterest);
                          amountPerTerm = totalAmount / selectedValue;
                        });
                      },
                    ),
                    SizedBox(height: 12),
                    TextFormField(
                      enabled: false,
                      controller: TextEditingController(
                        text:
                            calculatedInterest > 0
                                ? NumberFormat(
                                  '#,##0',
                                ).format(calculatedInterest)
                                : '',
                      ),
                      decoration: InputDecoration(
                        labelStyle: TextStyle(
                          fontSize: 18,
                          color: Colors.black54,
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.normal,
                        ),
                        labelText: 'Taux d\'intérêt(7%)',
                        border: OutlineInputBorder(),
                        fillColor: Colors.grey[200],
                        filled: true,
                      ),
                    ),
                    SizedBox(height: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Nombre de trimestres :',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 6),
                        Row(
                          children:
                              trimestres.map((value) {
                                return Row(
                                  children: [
                                    Radio<int>(
                                      value: value,
                                      groupValue: selectedValue,
                                      onChanged: (val) {
                                        setModalState(() {
                                          selectedValue = val!;
                                          amountPerTerm =
                                              totalAmount / selectedValue;
                                          _trimestreController.text =
                                              value.toString();
                                        });
                                      },
                                    ),
                                    Text('$value'),
                                  ],
                                );
                              }).toList(),
                        ),
                      ],
                    ),
                    SizedBox(height: 12),
                    TextFormField(
                      enabled: false,
                      controller: TextEditingController(
                        text:
                            amountPerTerm > 0
                                ? '${NumberFormat('#,##0').format(amountPerTerm)} '
                                : '',
                      ),
                      decoration: InputDecoration(
                        labelStyle: TextStyle(
                          fontSize: 18,
                          color: Colors.black54,
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.normal,
                        ),
                        labelText: 'Remboursement par trimestre',
                        border: OutlineInputBorder(),
                        fillColor: Colors.grey[200],
                        filled: true,
                      ),
                    ),
                    SizedBox(height: 10),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Mode de paiement",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children:
                            paymentMethods.map((method) {
                              return Padding(
                                padding: const EdgeInsets.only(right: 16.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    // Bouton radio avec l'image
                                    Radio<String>(
                                      value: method.label,
                                      groupValue: selectedPayment,
                                      onChanged: (val) {
                                        setModalState(() {
                                          selectedPayment = val!;
                                          isPhoneFieldEnabled = val != 'CASH';
                                          _modePaiementController.text =
                                              val.toString();
                                          if (val == 'MTN CI') {
                                            _contactController.text = '05';
                                          } else if (val == 'ORANGE CI') {
                                            _contactController.text = '07';
                                          } else if (val == 'CASH') {
                                            _contactController.text = 'CASH';
                                          }
                                        });
                                      },
                                    ),
                                    // Image du mode de paiement
                                    Image.asset(
                                      method.image,
                                      width: 40,
                                      height: 40,
                                    ),
                                    // Label
                                    Text(method.label),
                                  ],
                                ),
                              );
                            }).toList(),
                      ),
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      controller: _contactController,
                      enabled: isPhoneFieldEnabled,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        labelText: 'Numéro de téléphone',
                        hintText: getPhoneHint(),
                        border: OutlineInputBorder(),
                        filled: !isPhoneFieldEnabled,
                        fillColor: Colors.grey[200],
                        //  prefixText: getPhonePrefix(),
                      ),
                      onChanged: (value) {
                        final prefix = getPhonePrefix() ?? '';
                        final maxDigits = 10;
                        if (value.length > 10) {
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            showDialog(
                              context: context,
                              builder:
                                  (context) => AlertDialog(
                                    title: Text(
                                      'Numéro invalide !',
                                      style: TextStyle(color: Colors.red),
                                    ),
                                    content: Text(
                                      'Le numéro ne doit pas dépasser $maxDigits chiffres',
                                      style: TextStyle(fontSize: 14),
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: Text('OK'),
                                      ),
                                    ],
                                  ),
                            );
                            _contactController.text = value.substring(0, 10);
                            _contactController
                                .selection = TextSelection.collapsed(offset: 8);
                          });
                        }
                      },
                      validator: (value) {
                        if (isPhoneFieldEnabled) {
                          if (value == null || value.isEmpty) {
                            return 'Ce champ est obligatoire';
                          }

                          final prefix = getPhonePrefix() ?? '';
                          final numberWithoutPrefix = value.replaceFirst(
                            prefix,
                            '',
                          );

                          if (numberWithoutPrefix.length >
                              (8 - prefix.length)) {
                            return 'Trop de chiffres après le préfixe (max ${8 - prefix.length})';
                          }

                          if (selectedPayment == 'MTN CI' &&
                              !value.startsWith('05')) {
                            return 'Le numéro MTN doit commencer par 05';
                          }
                          if (selectedPayment == 'ORANGE CI' &&
                              !value.startsWith('07')) {
                            return 'Le numéro ORANGE doit commencer par 07';
                          }
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () async {
                        if (_montantController.text.isEmpty ||
                            _trimestreController.text.isEmpty ||
                            _modePaiementController.text.isEmpty ||
                            _contactController.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Veuillez remplir tous les champs'),
                            ),
                          );
                          return;
                        }

                        try {
                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder:
                                (context) =>
                                    Center(child: CircularProgressIndicator()),
                          );

                          final montant =
                              double.tryParse(_montantController.text) ?? 0;
                          final trimestre =
                              int.tryParse(_trimestreController.text) ?? 1;

                          final result = await _financeController
                              .enregistrerPret(
                                montant: montant,
                                trimestre: trimestre,
                                montantTotal: totalAmount,
                                modePaiement: _modePaiementController.text,
                                contact: _contactController.text,
                              );

                          Navigator.of(context).pop();

                          if (result ?? false) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Demande de Prêt envoyé avec succès!',
                                ),
                              ),
                            );
                            _montantController.clear();
                            _trimestreController.clear();
                            _modePaiementController.clear();
                            _contactController.clear();
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Échec de l\'enregistrement'),
                              ),
                            );
                          }
                        } catch (e) {
                          Navigator.of(context).pop();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Erreur: ${e.toString()}')),
                          );
                        }
                      },
                      child: Text("Soumettre le prêt"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(
                          horizontal: 40,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 3,
                      ),
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildRadioOption(
    String label,
    String logoPath,
    String groupValue,
    ValueChanged<String?> onChanged,
  ) {
    return RadioListTile<String>(
      value: label,
      groupValue: groupValue,
      onChanged: onChanged,
      title: Row(
        children: [
          Image.asset(logoPath, width: 24, height: 24),
          SizedBox(width: 8),
          Text(label),
        ],
      ),
    );
  }
}

// ---------------------
// Modèles
// ---------------------

final List<PaymentMethod> paymentMethods = [
  // PaymentMethod(id: 1, label: 'MTN CI', image: 'images/mtn.jpg'),
  PaymentMethod(id: 2, label: 'ORANGE CI', image: 'images/orange.jpg'),
  PaymentMethod(id: 3, label: 'WAVE', image: 'images/wave.jpg'),
  PaymentMethod(id: 4, label: 'CASH', image: 'images/cash.png'),
  // PaymentMethod(id: 5, label: 'MOOV CI', image: 'images/moov.png'),
];
