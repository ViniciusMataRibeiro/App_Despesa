import 'package:flutter/material.dart';

import '../controller/despesa_dao.dart';
import '../model/despesaModel.dart';
import 'list_despesas.dart';

class RegDespesa extends StatefulWidget {
  const RegDespesa({super.key});

  @override
  State<RegDespesa> createState() => _RegDespesa();
}

class _RegDespesa extends State<RegDespesa> {
  List<Despesa> despesa = [];

  final DespesaDao dao = DespesaDao();

  TextEditingController nomeDespesa = TextEditingController();
  TextEditingController tipoDespesa = TextEditingController();
  TextEditingController valorDespesa = TextEditingController();
  // ignore: unused_field
  double _valorDespesaDouble = 0;

  _RegDespesa() {
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
        valorDespesa.text = "";
      });
    });
  }

  @override
  void dispose() {
    valorDespesa.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: Colors.grey[200],
        elevation: 0,
        leading: Container(),
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: const Text('Registrar Despesas',
            style: TextStyle(
                fontSize: 30,
                color: Colors.black,
                fontWeight: FontWeight.bold)),
      ),
      body: Container(
        padding: const EdgeInsets.all(30),
        child: Form(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Qual o nome da despesa?',
                ),
                controller: nomeDespesa,
                validator: (value) {
                  if (value.toString().isEmpty) {
                    return 'Insira uma despesa';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Tipo da despesa',
                ),
                controller: tipoDespesa,
                validator: (value) {
                  if (value.toString().isEmpty) {
                    return 'Insira o tipo da despesa';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Valor da despesa',
                ),
                controller: valorDespesa,
                validator: (value) {
                  if (value.toString().isEmpty) {
                    return 'Insira o valor da despesa';
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
                        if (nomeDespesa.text.trim() != '') {
                          var dep = Despesa(
                            nomeDespesa: nomeDespesa.text,
                            tipoDespesa: tipoDespesa.text,
                            valorDespesa: _valorDespesaDouble =
                                double.parse(valorDespesa.text),
                          );
                          dao.insert(dep).then(
                            (value) {
                              load();
                            },
                          );
                        }
                      },
                      child: const Text('     Enviar     '),
                    ),
                  ),
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
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: ((context) => const ListaDespesa())));
                      },
                      child: const Text('Consultar Despesas'),
                    ),
                  ),
                ],
              ),
              listView(),
              Center(
                child: Text(
                  'Total: RS ${soma()}',
                  style: const TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                ),
              ),
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

  double soma() {
    double total = 0;
    for (var valor in despesa) {
      total += valor.valorDespesa;
    }

    return total;
  }
}
