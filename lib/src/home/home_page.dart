// import 'package:cpf_cnpj_validator/cpf_validator.dart';
import 'package:cpf_cnpj_validator/cpf_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_teresina_app/src/home/home_controller.dart';

import 'package:flutter_teresina_app/src/home/utils/cpf_input_formatter.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController _cpfController;
  TextEditingController _emailController;
  TextEditingController _nameController;

  @override
  void initState() {
    _cpfController = TextEditingController();
    _emailController = TextEditingController();
    _nameController = TextEditingController();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _homeController = Provider.of<HomeController>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Credenciamento',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          children: <Widget>[
            Form(
              key: _formKey,
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * .2,
                ),
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Nome Completo',
                      ),
                      controller: _nameController,
                      validator: (value) {
                        if (value.isEmpty || value.split(' ').length < 2) {
                          return 'Por favor, informe o seu nome';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'E-mail',
                      ),
                      keyboardType: TextInputType.emailAddress,
                      controller: _emailController,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Por favor, informe o seu e-mail.';
                        } else if (!value.contains('@')) {
                          return 'Por favor, informe e-mail válido.';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'CPF',
                      ),
                      keyboardType: TextInputType.number,
                      controller: _cpfController,
                      inputFormatters: [CPFInputFormatter()],
                      maxLength: 14,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Por favor, informe o seu CPF.';
                        } else if (!CPFValidator.isValid(value)) {
                          return 'Por favor, informe um CPF válido.';
                        }
                        return null;
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: !_homeController.isLoading
                          ? RaisedButton(
                              color: Colors.blue,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              onPressed: () async {
                                if (_formKey.currentState.validate()) {
                                  final result = await _homeController.sendForm(
                                    _nameController.text,
                                    _emailController.text,
                                    _cpfController.text,
                                  );

                                  if (result) {
                                    Alert(
                                      context: context,
                                      type: AlertType.success,
                                      title: "PARABÉNS",
                                      desc: "Registrado com sucesso!",
                                      buttons: [
                                        DialogButton(
                                          child: Text(
                                            "FECHAR",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 20,
                                            ),
                                          ),
                                          onPressed: () =>
                                              Navigator.pop(context),
                                          width: 120,
                                        )
                                      ],
                                    ).show();
                                  } else {
                                    Alert(
                                      context: context,
                                      type: AlertType.error,
                                      title: "ERROR",
                                      desc:
                                          "Não conseguimos completar a operação, tente novamente!",
                                      buttons: [
                                        DialogButton(
                                          child: Text(
                                            "FECHAR",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 20,
                                            ),
                                          ),
                                          onPressed: () =>
                                              Navigator.pop(context),
                                          width: 120,
                                        )
                                      ],
                                    ).show();
                                  }
                                }
                              },
                              child: Text(
                                'Enviar',
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            )
                          : Center(child: CircularProgressIndicator()),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _cpfController.dispose();
    _emailController.dispose();
    _nameController.dispose();

    super.dispose();
  }
}
