import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../model/mode_paiement.dart';
import '../widgets/navbar_roots.dart';

class MemberLoansScreen extends StatefulWidget {
  @override
  _MemberLoansScreenState createState() => _MemberLoansScreenState();
}

class _MemberLoansScreenState extends State<MemberLoansScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final Map<String, List<Loan>> loansByMutual = {
    '3AV': [
      Loan(amount: 500000, date: DateTime(2025, 5, 10)),
      Loan(amount: 200000, date: DateTime(2025, 3, 15)),
    ],
  };

  final List<Repayment> repayments = [
    Repayment(mutual: '3AV', amount: 150000, date: DateTime(2025, 9, 12)),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
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
        title: Text('Mes Emprunts', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.deepPurple,
        actions: [
          IconButton(
            icon: Icon(Icons.add, color: Colors.white),
            onPressed: _showLoanFormModal,
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(icon: Icon(Icons.list_alt, color: Colors.white)),
            Tab(icon: Icon(Icons.payment, color: Colors.white)),
            Tab(icon: Icon(Icons.analytics, color: Colors.white)),
          ],
          indicatorColor: Colors.white,
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
    return ListView(
      padding: EdgeInsets.all(16),
      children:
          loansByMutual.entries.map((entry) {
            final mutual = entry.key;
            final loans = entry.value;
            final totalAmount = loans.fold(0, (sum, loan) => sum + loan.amount);

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: _getMutualColor().withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(_getMutualIcon()),
                      SizedBox(width: 10),
                      Text(
                        mutual,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: _getMutualColor(),
                        ),
                      ),
                      Spacer(),
                      Text(
                        '${NumberFormat('#,##0').format(totalAmount)} FCFA',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[800],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 8),
                ...loans.map(
                  (loan) => Padding(
                    padding: EdgeInsets.only(bottom: 8),
                    child: _buildLoanCard(loan),
                  ),
                ),
                SizedBox(height: 20),
              ],
            );
          }).toList(),
    );
  }

  Widget _buildRepaymentsTab() {
    final totalRepaid = repayments.fold(0, (sum, r) => sum + r.amount);

    return ListView(
      padding: EdgeInsets.all(16),
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: _getMutualColor().withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Icon(_getMutualIcon()),
              SizedBox(width: 10),
              Text(
                '3AV',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: _getMutualColor(),
                ),
              ),
              Spacer(),
              Text(
                '${NumberFormat('#,##0').format(totalRepaid)} FCFA',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 8),
        ...repayments.map(
          (r) => Padding(
            padding: EdgeInsets.only(bottom: 8),
            child: _buildRepaymentCard(r),
          ),
        ),
        SizedBox(height: 20),
      ],
    );
  }

  Widget _buildStatsTab() {
    final totalLoans = loansByMutual['3AV']!.fold(
      0,
      (sum, loan) => sum + loan.amount,
    );
    final totalRepaid = repayments.fold(0, (sum, r) => sum + r.amount);
    final remaining = totalLoans - totalRepaid;

    return Padding(
      padding: EdgeInsets.all(20),
      child: Column(
        children: [
          _buildStatCard(
            title: 'Synthèse Globale',
            children: [
              _buildStatItem(
                'Total emprunts',
                '${NumberFormat('#,##0').format(totalLoans)} FCFA',
                Icons.credit_card,
                Colors.deepPurple,
              ),
              _buildStatItem(
                'Total remboursés',
                '${NumberFormat('#,##0').format(totalRepaid)} FCFA',
                Icons.payment,
                Colors.green,
              ),
              _buildStatItem(
                'Reste à payer',
                '${NumberFormat('#,##0').format(remaining)} FCFA',
                Icons.timer,
                Colors.orange,
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ---------------------
  // Widgets
  // ---------------------

  Widget _buildLoanCard(Loan loan) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        leading: Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: _getMutualColor().withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          child: Icon(Icons.money, color: _getMutualColor(), size: 20),
        ),
        title: Text(
          '${NumberFormat('#,##0').format(loan.amount)} FCFA',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.grey[800],
          ),
        ),
        subtitle: Text(
          'Emprunté le ${DateFormat('dd/MM/yyyy').format(loan.date)}',
          style: TextStyle(color: Colors.grey[600]),
        ),
        trailing:
            loan.isRepaid
                ? Icon(Icons.check_circle, color: Colors.green)
                : Icon(Icons.access_time, color: Colors.orange),
      ),
    );
  }

  Widget _buildRepaymentCard(Repayment r) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        leading: Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.green.withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          child: Icon(Icons.attach_money, color: Colors.green, size: 20),
        ),
        title: Text(
          '${NumberFormat('#,##0').format(r.amount)} FCFA',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.grey[800],
          ),
        ),
        subtitle: Text(
          'Remboursé le ${DateFormat('dd/MM/yyyy').format(r.date)}',
          style: TextStyle(color: Colors.grey[600]),
        ),
        trailing: Icon(Icons.check_circle, color: Colors.green),
      ),
    );
  }

  Widget _buildStatCard({
    required String title,
    required List<Widget> children,
  }) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey[200]!, width: 1),
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
            SizedBox(height: 16),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 20, color: color),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Text(label, style: TextStyle(color: Colors.grey[600])),
          ),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
        ],
      ),
    );
  }

  Color _getMutualColor() => Colors.purple;
  IconData _getMutualIcon() => Icons.credit_card;

  // ---------------------
  // Formulaire modale
  // ---------------------

  void _showLoanFormModal() {
    final maxLoanAmount = 1000000;
    final TextEditingController amountController = TextEditingController();
    final TextEditingController phoneController = TextEditingController();
    String selectedPayment = 'MTN CI';
    int calculatedInterest = 0;
    int selectedValue = 1;
    double totalAmount = 0; // Montant total (montant saisi + intérêt)
    double amountPerTerm = 0; // Montant à payer par trimestre

    bool isPhoneFieldEnabled = true;
    String getPhoneHint() {
      if (selectedPayment == 'MTN CI') return 'Ex: 05XXXXXXXX';
      if (selectedPayment == 'ORANGE CI') return 'Ex: 07XXXXXXXX';
      if (selectedPayment == 'WAVE') return 'Ex: XXXXXXXXXXXX';
      return '';
    }

    String? getPhonePrefix() {
      if (selectedPayment == 'MTN CI') return '05';
      if (selectedPayment == 'ORANGE CI') return '07';
      return null;
    }

    @override
    void dispose() {
      phoneController.dispose();
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
                        labelText: 'Montant maximum',
                        border: OutlineInputBorder(),
                        filled: true,
                        fillColor: Colors.grey[200],
                      ),
                    ),
                    SizedBox(height: 12),
                    TextFormField(
                      controller: amountController,
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
                          totalAmount = (input + calculatedInterest).toDouble();
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
                          children: List.generate(4, (index) {
                            int value = index + 1;
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
                                    });
                                  },
                                ),
                                Text('$value'),
                              ],
                            );
                          }),
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

                                          if (val == 'MTN CI') {
                                            phoneController.text = '05';
                                          } else if (val == 'ORANGE CI') {
                                            phoneController.text = '07';
                                          } else if (val == 'CASH') {
                                            phoneController.text = '';
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
                      controller: phoneController,
                      enabled: isPhoneFieldEnabled,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        labelText: 'Numéro de téléphone',
                        hintText: getPhoneHint(),
                        border: OutlineInputBorder(),
                        filled: !isPhoneFieldEnabled,
                        fillColor: Colors.grey[200],
                        prefixText: getPhonePrefix(),
                      ),
                      onChanged: (value) {
                        final prefix = getPhonePrefix() ?? '';
                        final maxDigits = 10;
                        print(prefix + '-' + value);
                        if (value.length > 8) {
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
                            phoneController.text = value.substring(0, 10);
                            phoneController.selection = TextSelection.collapsed(
                              offset: 8,
                            );
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
                      onPressed: () {
                        // Action d'enregistrement ici
                        Navigator.pop(context);
                      },
                      child: Text("Soumettre le prêt"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(
                          horizontal: 40,
                          vertical: 12,
                        ),
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

class Loan {
  final int amount;
  final DateTime date;
  bool isRepaid;

  Loan({required this.amount, required this.date, this.isRepaid = false});
}

class Repayment {
  final String mutual;
  final int amount;
  final DateTime date;

  Repayment({required this.mutual, required this.amount, required this.date});
}

final List<PaymentMethod> paymentMethods = [
  PaymentMethod(id: 1, label: 'MTN CI', image: 'images/mtn.jpg'),
  PaymentMethod(id: 2, label: 'ORANGE CI', image: 'images/orange.jpg'),
  PaymentMethod(id: 3, label: 'WAVE', image: 'images/wave.jpg'),
  PaymentMethod(id: 4, label: 'CASH', image: 'images/cash.png'),
];
