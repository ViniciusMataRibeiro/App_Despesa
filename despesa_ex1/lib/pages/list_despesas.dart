import 'package:flutter/material.dart';

import '../controller/despesa_dao.dart';
import '../model/despesaModel.dart';

class ListaDespesa extends StatefulWidget {
  const ListaDespesa({super.key});

  @override
  State<ListaDespesa> createState() => _ListaDespesa();
}

class _ListaDespesa extends State<ListaDespesa> {
  final DespesaDao dao = DespesaDao();

  List<Despesa> despesa = [];

  bool _isValor = false;

  double total = 0;

  TextEditingController nomeDespesa = TextEditingController();
  TextEditingController tipoDespesa = TextEditingController();
  TextEditingController valorDespesa = TextEditingController();

  _ListaDespesa() {
    dao.connect().then((value) {
      load();
    });
  }

  load() {
    dao.getList().then((value) {
      setState(() {
        despesa = value;
        nomeDespesa.text = "";
        tipoDespesa.text = "";
        valorDespesa.text = "0";
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: Colors.grey[200],
        centerTitle: true,
        title: const Text('Consultar Despesa'),
      ),
      body: Container(
        margin: const EdgeInsets.only(top: 5, right: 10, left: 10),
        padding: const EdgeInsets.all(30),
        child: Form(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Pesquisar por Despesa',
                  hintText: 'Ex:. Limpeza',
                ),
                controller: tipoDespesa,
                validator: (value) {
                  if (value.toString().isEmpty) {
                    return 'Insira uma despesa';
                  }
                  return null;
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[200],
                        foregroundColor: Colors.black,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(100),
                          ),
                          side: BorderSide(width: 2, color: Colors.black),
                        ),
                      ),
                      onPressed: () {
                        setState(
                          () {
                            dao.getByTipo(tipoDespesa.text).then((value) {
                              setState(() {
                                despesa = value;
                                total = totalDespesa();
                              });
                            });
                          },
                        );
                      },
                      child: const Text(
                          '                    Pesquisar Despesa                   '),
                    ),
                  ),
                ],
              ),
              Center(
                child: Text(
                  'Total: RS$total',
                  style: const TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                ),
              ),
              _isValor ? listView() : Container(),
            ],
          ),
        ),
      ),
    );
  }

  listView() {
    return Expanded(
      child: ListView.builder(
        itemCount: despesa.length,
        padding: const EdgeInsets.only(bottom: 10, top: 10),
        itemBuilder: (context, index) {
          Map item = despesa[index].toMap();
          return GestureDetector(
            onTap: () {},
            child: Container(
              margin: const EdgeInsets.all(1),
              child: Card(
                  elevation: 5,
                  child: Column(
                    children: [
                      ListTile(
                        title: Text(
                          item['nomeDespesa'],
                          style: const TextStyle(
                              fontSize: 20,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          item['tipoDespesa'],
                          style: const TextStyle(
                              fontSize: 15,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                        ),
                        trailing: Text(
                          'RS ${item['valorDespesa']}',
                          style: const TextStyle(
                              fontSize: 20,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  )),
            ),
          );
        },
      ),
    );
  }

  double totalDespesa() {
    _isValor = true;
    double total = 0;
    for (var valor in despesa) {
      total += valor.valorDespesa;
    }
    return total;
  }
}
