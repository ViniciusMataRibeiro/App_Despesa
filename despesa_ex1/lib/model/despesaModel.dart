// ignore_for_file: file_names

class Despesa {
  static const String tableName = 'despesaDB';
  static const String columnDespesa = 'nomeDespesa';
  static const String columnTipo = 'tipoDespesa';
  static const String columnValor = 'valorDespesa';

  final String nomeDespesa;
  final String tipoDespesa;
  final double valorDespesa;

  Despesa({required this.nomeDespesa, required this.tipoDespesa, required this.valorDespesa});

  Map<String, dynamic> toMap() {
    return {'nomeDespesa': nomeDespesa, 'tipoDespesa': tipoDespesa, 'valorDespesa': valorDespesa};
  }
}
