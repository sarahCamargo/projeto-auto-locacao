class MaintenanceManagementConstants {
  static const String maintenanceManagementTitle = "Gerenciar manutenções";
  static const String appBarTitle = 'Cadastro Manutenção';
  static const String maintenanceData = 'Dados da Manutenção';
  static const String typeLabel = 'Tipo';
  static const String otherLabel = 'Outro';
  static const String frequencyLabel = 'Frequência';
  static const String lastCheckLabel = 'Última verificação';
  static const String nextCheckLabel = 'Próxima verificação';


  static const List<String?> type = [
    'Outro',
    'Troca de óleo',
    'Fluído de freio',
    null
  ];

  static const List<String?> frequency = [
    '1x por semana',
    '2x por semana',
    '3x por semana',
    '1x por mês',
    null
  ];

}