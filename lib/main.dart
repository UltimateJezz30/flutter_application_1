import 'package:flutter/material.dart';

void main() {
  runApp(const CurrencyConverterApp());
}

class CurrencyConverterApp extends StatelessWidget {
  const CurrencyConverterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Convertidor de Divisas',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const PantallaConvertidor(),
    );
  }
}

class PantallaConvertidor extends StatefulWidget {
  const PantallaConvertidor({super.key});

  @override
  State<PantallaConvertidor> createState() => _PantallaConvertidorState();
}

class _PantallaConvertidorState extends State<PantallaConvertidor> {
  int _indiceActual = 0;
  double tasaCambio = 50.0;
  final List<String> historial = [];

  final List<Widget> _pantallas = [];

  @override
  void initState() {
    super.initState();
    _pantallas.addAll([
      Principal(
        tasaCambio: tasaCambio,
        onConvert: (dolares, bolivares) {
          setState(() {
            historial.add('$dolares USD = $bolivares VES');
          });
        },
      ),
      Historial(historial: historial),
      AjusteTasa(onTasaCambiada: (nuevaTasa) {
        setState(() {
          tasaCambio = nuevaTasa;
        });
      }),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Imagen de fondo
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/fondo-convertidor.png'),
                fit: BoxFit.cover, 
              ),
            ),
          ),
          Column(
            children: [
              AppBar(
                title: const Text("Convertidor de Divisas"),
                backgroundColor: const Color.fromRGBO(0, 255, 234, 1),
              ),
              Expanded(child: _pantallas[_indiceActual]),
              BottomNavigationBar(
                currentIndex: _indiceActual,
                onTap: (index) {
                  setState(() {
                    _indiceActual = index;
                  });
                },
                items: const [
                  BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Convertir'),
                  BottomNavigationBarItem(icon: Icon(Icons.history), label: 'Historial'),
                  BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Tasa'),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class Principal extends StatelessWidget {
  final double tasaCambio;
  final Function(double, double) onConvert;

  const Principal({required this.tasaCambio, required this.onConvert, super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController controladorDolares = TextEditingController();
    final TextEditingController controladorBolivares = TextEditingController();

    void convertir() {
      final double dolares = double.tryParse(controladorDolares.text) ?? 0;
      final double bolivares = dolares * tasaCambio;
      controladorBolivares.text = bolivares.toStringAsFixed(2);
      onConvert(dolares, bolivares);
    }

    void reset() {
      controladorDolares.clear();
      controladorBolivares.clear();
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextField(
            controller: controladorDolares,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(labelText: 'Dólares (USD)'),
          ),
          const SizedBox(height: 10),
          IconButton(
            onPressed: convertir,
            icon: const Icon(Icons.swap_horiz, size: 30),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: controladorBolivares,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(labelText: 'Bolívares (VES)'),
            readOnly: true,
          ),
          const SizedBox(height: 20),
          ElevatedButton(onPressed: reset, child: const Text('Reiniciar')),
          const SizedBox(height: 20),
          ElevatedButton(onPressed: convertir, child: const Text('Convertir')),
        ],
      ),
    );
  }
}

class Historial extends StatelessWidget {
  final List<String> historial;

  const Historial({required this.historial, super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: historial.length,
      itemBuilder: (context, index) {
        return ListTile(
          leading: const Icon(Icons.monetization_on),
          title: Text(historial[index]),
        );
      },
    );
  }
}

class AjusteTasa extends StatefulWidget {
  final Function(double) onTasaCambiada;

  const AjusteTasa({required this.onTasaCambiada, super.key});

  @override
  State<AjusteTasa> createState() => _AjusteTasaState();
}

class _AjusteTasaState extends State<AjusteTasa> {
  final TextEditingController controladorTasa = TextEditingController();

  void actualizarTasa() {
    final double nuevaTasa = double.tryParse(controladorTasa.text) ?? 1.0;
    widget.onTasaCambiada(nuevaTasa);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Tasa actualizada a $nuevaTasa VES/USD')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextField(
            controller: controladorTasa,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(labelText: 'Nueva Tasa (VES/USD)'),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: actualizarTasa,
            child: const Text('Actualizar Tasa'),
          ),
        ],
      ),
    );
  }
}