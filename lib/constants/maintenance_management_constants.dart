class MaintenanceConstants {
  static const String maintenanceManagementTitle = "Gerenciar manutenções";
  static const String appBarTitle = 'Cadastro Manutenção';
  static const String maintenanceData = 'Dados da Manutenção';
  static const String typeLabel = 'Tipo';
  static const String otherLabel = 'Outro';
  static const String frequencyLabel = 'Frequência';
  static const String lastCheckLabel = 'Última verificação';
  static const String nextCheckLabel = 'Próxima verificação';


  static const List<String?> type = [
    'Troca de óleo',
    'Fluído de freio',
    'Verificação dos pneus',
    'Outro',
    null
  ];

  static const Map<int, String> frequency = {
    1: '1x por semana',
    2: '1x a cada 15 dias',
    3: '1x por mês',
    4: '1x a cada 3 meses',
    5: '1x a cada 6 meses',
    6: '1x por ano',
  };

  static const Map<int, Duration> frequencyDurations = {
    1: Duration(days: 7),
    2: Duration(days: 15),
    3: Duration(days: 30),
    4: Duration(days: 90),
    5: Duration(days: 180),
    6: Duration(days: 365),
  };

}