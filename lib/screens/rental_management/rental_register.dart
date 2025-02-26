import 'dart:io';

import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:projeto_auto_locacao/constants/collection_names.dart';
import 'package:projeto_auto_locacao/constants/general_constants.dart';
import 'package:projeto_auto_locacao/constants/rental_constants.dart';
import 'package:projeto_auto_locacao/constants/vehicle_constants.dart';
import 'package:projeto_auto_locacao/widgets/buttons/register_save_button.dart';
import 'package:projeto_auto_locacao/widgets/text/register_text_label.dart';

import '../../constants/colors_constants.dart';
import '../../models/rental.dart';
import '../../models/vehicle.dart';
import '../../services/database/database_handler.dart';
import '../../utils/currency_input_formatter.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/text/custom_text_form_field.dart';
import '../../widgets/text/custom_text_label.dart';

class RentalRegister extends StatefulWidget {
  @override
  RentalRegisterState createState() => RentalRegisterState();

  final Rental rental;

  const RentalRegister({super.key, required this.rental});
}

class RentalRegisterState extends State<RentalRegister> {
  DatabaseHandler dbHandler = DatabaseHandler(CollectionNames.rental);
  int? _selectedVehicle;
  bool _isNaturalPerson = true;
  int? _selectedPerson;
  DateTime? _selectedDate = DateTime.now();
  String? _selectedPaymentType;

  final TextEditingController _paymentValueController = TextEditingController();

  List<Vehicle> _vehicles = [];
  List<DropdownMenuItem<int>> _naturalPerson = [];
  List<DropdownMenuItem<int>> _legalPerson = [];
  final List<String> _paymentTypes = ['Diário', 'Semanal', 'Mensal', 'Anual'];

  XFile? _image;
  String? _imageUrl;

  bool _isSaveButtonEnabled = false;

  @override
  void initState() {
    super.initState();
    _selectedVehicle = widget.rental.vehicleId;
    _loadData();
    if (widget.rental.naturalPersonId != null) {
      _selectedPerson = widget.rental.naturalPersonId;
    }
    if (widget.rental.legalPersonId != null) {
      _selectedPerson = widget.rental.legalPersonId;
      _isNaturalPerson = false;
    }

    if (widget.rental.startDate != null) {
      _selectedDate = DateFormat('dd/MM/yyyy').parse(widget.rental.startDate!);
    }
    _selectedPaymentType = widget.rental.paymentType;
    _paymentValueController.text = widget.rental.paymentValue ?? '';
    if (widget.rental.vehicle?.imageUrl != null) {
      _imageUrl = widget.rental.vehicle?.imageUrl;
    }
    _paymentValueController.addListener(_checkButtonStatus);
    _checkButtonStatus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: RentalConstants.rentalPrimaryTab),
      body: _buildForm(),
    );
  }

  @override
  void dispose() {
    _paymentValueController.removeListener(_checkButtonStatus);
    super.dispose();
  }

  Future<void> _loadData() async {
    var vehicles;
    if (_selectedVehicle != null) {
      vehicles = await dbHandler.fetchVehiclesToRent(_selectedVehicle);
    } else {
      vehicles = await dbHandler.fetchVehiclesToRent(null);
    }
    setState(() {
      _vehicles = vehicles;
    });

    final naturalPersons = await dbHandler.getData('natural_person');
    setState(() {
      _naturalPerson = naturalPersons.map((person) {
        return DropdownMenuItem<int>(
          value: person['id'],
          child: Text('${person['name']} - ${person['cpf']}'),
        );
      }).toList();
    });

    final legalPersons = await dbHandler.getData('legal_person');
    setState(() {
      _legalPerson = legalPersons.map((person) {
        return DropdownMenuItem<int>(
          value: person['id'],
          child: Text(
              '${person['tradingName']}/${person['companyName']} ${person['cnpj']}'),
        );
      }).toList();
    });
  }

  Future<void> _selectDate() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  Widget _buildForm() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10.0),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const SizedBox(height: 16.0),
              const RegisterTextLabel(
                  label: VehicleConstants.vehicleData,
                  fontWeight: FontWeight.bold),
              const SizedBox(height: 16.0),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  GestureDetector(child: _buildImageAndButton()),
                  const SizedBox(height: 20),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: Row(
                  children: [
                    Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const RegisterTextLabel(
                              label: 'Veículo',
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.grey.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(10.0),
                                border: Border.all(
                                  color: _selectedVehicle == null
                                      ? Colors.red
                                      : Colors.transparent,
                                ),
                              ),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10.0),
                              child: DropdownButtonFormField<int>(
                                isExpanded: true,
                                value: _selectedVehicle,
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                ),
                                items: _vehicles
                                    .map<DropdownMenuItem<int>>((
                                    Vehicle vehicle) {
                                  return DropdownMenuItem<int>(
                                    value: vehicle.id,
                                    child: Text(
                                        '${vehicle.model} / ${vehicle
                                            .brand} - ${vehicle.licensePlate}'),
                                  );
                                }).toList(),
                                onChanged: (int? value) {
                                  setState(() {
                                    _selectedVehicle = value;
                                    _imageUrl = _vehicles
                                        .firstWhere(
                                          (vehicle) => vehicle.id == value,
                                      orElse: () =>
                                          Vehicle(
                                            id: null,
                                            model: '',
                                            brand: '',
                                            licensePlate: '',
                                            imageUrl: '',
                                          ),
                                    )
                                        .imageUrl;
                                    _checkButtonStatus();
                                  });
                                },
                              ),
                            ),
                          ],
                        ))
                  ],
                ),
              ),
              const RegisterTextLabel(
                label: 'Tipo de Pessoa:',
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Wrap(
                  spacing: 20.0,
                  runSpacing: 10.0,
                  children: <Widget>[
                    _buildRadioButtonRow(
                      value: true,
                      groupValue: _isNaturalPerson,
                      label: 'Pessoa Física',
                      onChanged: (bool? value) {
                        setState(() {
                          _isNaturalPerson = value ?? true;
                          _selectedPerson = null;
                        });
                      },
                    ),
                    _buildRadioButtonRow(
                      value: false,
                      groupValue: _isNaturalPerson,
                      label: 'Pessoa Jurídica',
                      onChanged: (bool? value) {
                        setState(() {
                          _isNaturalPerson = value ?? false;
                          _selectedPerson = null;
                        });
                      },
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const RegisterTextLabel(
                            label: 'Locador',
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.grey.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(10.0),
                              border: Border.all(
                                color: _selectedPerson == null
                                    ? Colors.red
                                    : Colors.transparent,
                              ),
                            ),
                            padding:
                            const EdgeInsets.symmetric(horizontal: 10.0),
                            child: DropdownButtonFormField<int>(
                              isExpanded: true,
                              value: _selectedPerson,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                              ),
                              items: (_isNaturalPerson
                                  ? _naturalPerson
                                  : _legalPerson),
                              onChanged: (int? value) {
                                setState(() {
                                  _selectedPerson = value;
                                  _checkButtonStatus();
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const RegisterTextLabel(
                            label: 'Tipo de Pagamento',
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.grey.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(10.0),
                              border: Border.all(
                                color: _selectedPaymentType == null
                                    ? Colors.red
                                    : Colors.transparent,
                              ),
                            ),
                            padding:
                            const EdgeInsets.symmetric(horizontal: 10.0),
                            child: DropdownButtonFormField<String>(
                              isExpanded: true,
                              value: _selectedPaymentType,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                              ),
                              items: _paymentTypes
                                  .map<DropdownMenuItem<String>>(
                                      (String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  _selectedPaymentType = value;
                                  _checkButtonStatus();
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const RegisterTextLabel(
                label: 'Valor do Pagamento',
              ),
              CustomTextField(
                controller: _paymentValueController,
                keyboardType:
                const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  CurrencyInputFormatter(),
                ],
                hintText: 'R\$ XX,XX',
                isRequired: true,
              ),
              const SizedBox(height: 16.0),
              const RegisterTextLabel(
                label: 'Data de Início',
              ),
              CustomTextField(
                controller: TextEditingController(
                    text: _selectedDate != null
                        ? DateFormat('dd/MM/yyyy').format(_selectedDate!)
                        : ''),
                readOnly: true,
                onTap: _selectDate,
                hintText: 'dd/mm/aaaa',
              ),
              const SizedBox(height: 16.0),
              RegisterSaveButton(onPressed: pressSave()),
            ],
          ),
        ),
      ),
    );
  }

  pressSave() {
    if (_isSaveButtonEnabled) {
      return () {
        save();
      };
    }
    return () => {};
  }

  void save() {
    saveData().then((rental) {
      dbHandler.save(context, widget.rental.id, rental);
    });
  }

  Future<Rental> saveData() async {
    Rental rental = Rental();
    rental.vehicleId = _selectedVehicle;
    rental.startDate = DateFormat('dd/MM/yyyy').format(_selectedDate!);
    if (_isNaturalPerson) {
      rental.naturalPersonId = _selectedPerson;
    } else {
      rental.legalPersonId = _selectedPerson;
    }
    rental.paymentType = _selectedPaymentType;
    rental.paymentValue = _paymentValueController.text;
    return rental;
  }

  Widget _buildImageContainer() {
    String? newImage = _image == null ? _imageUrl : _image!.path;
    return Container(
      width: double.infinity,
      height: 150,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(10),
      ),
      child: newImage == null
          ? Center(
        child: Icon(
          FontAwesomeIcons.image,
          size: 50,
          color: Colors.grey[400],
        ),
      )
          : ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Image.file(
          File(newImage),
          fit: BoxFit.contain,
        ),
      ),
    );
  }

  Widget _buildImageAndButton() {
    return Stack(
      children: [_buildImageContainer()],
    );
  }

  Widget _buildRadioButtonRow({
    required bool value,
    required bool groupValue,
    required String label,
    required ValueChanged<bool?> onChanged,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Radio<bool>(
          value: value,
          groupValue: groupValue,
          onChanged: (bool? newValue) {
            onChanged(newValue);
          },
        ),
        Flexible(
          child: Text(
            label,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  void _checkButtonStatus() {
    setState(() {
      _isSaveButtonEnabled = _selectedVehicle != null &&
          _selectedPerson != null &&
          _selectedPaymentType != null &&
          _paymentValueController.text.isNotEmpty;
    });
  }
}
