import 'package:flutter/material.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

void main() => runApp(EmpresaComunicacionApp());

class EmpresaComunicacionApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginScreen(),
    );
  }
}

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Bienvenido", style: TextStyle(fontSize: 24)),
            TextField(
              decoration: InputDecoration(labelText: "Correo"),
            ),
            TextField(
              decoration: InputDecoration(labelText: "Contraseña"),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HomeScreen()),
                );
              },
              child: Text("Iniciar Sesión"),
            ),
          ],
        ),
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Comunicación Interna")),
      body: ListView(
        children: [
          ListTile(
            title: Text("Chat"),
            leading: Icon(Icons.chat),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ChatScreen()),
              );
            },
          ),
          
          ListTile(
            title: Text("Monitoreo Ambiental"),
            leading: Icon(Icons.sensors),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MonitorScreen()),
              );
            },
          ),
          ListTile(
            title: Text("Correo Corporativo"),
            leading: Icon(Icons.email),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => EmailScreen()),
              );
            },
          ),
          ListTile(
            title: Text("Análisis y Mejora Continua"),
            leading: Icon(Icons.analytics),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AnalysisScreen()),
              );
            },
          ),
        ],
      ),
    );
  }
}

class ChatScreen extends StatelessWidget {
  final List<String> users = [
    "Ana García",
    "Carlos Pérez",
    "Laura Rodríguez",
    "Juan López",
    "María Martínez",
    "Pedro Sánchez",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Chat")),
      body: ListView.builder(
        itemCount: users.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(users[index]),
            leading: Icon(Icons.person),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      ConversationScreen(userName: users[index]),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class ConversationScreen extends StatefulWidget {
  final String userName;
  ConversationScreen({required this.userName});
  @override
  _ConversationScreenState createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  final TextEditingController _messageController = TextEditingController();
  final List<Map<String, String>> _messages = [];

  void _sendMessage() {
    if (_messageController.text.isNotEmpty) {
      setState(() {
        _messages.add({
          "message": _messageController.text,
          "timestamp": DateTime.now().toString(),
        });
        _messageController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Chat con ${widget.userName}")),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_messages[index]["message"]!),
                  subtitle: Text(_messages[index]["timestamp"]!),
                  leading: Icon(Icons.message),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(labelText: "Escribe un mensaje"),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class MonitorScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Monitoreo Ambiental")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Temperatura: 22°C"),
            Text("Humedad: 45%"),
            Text("Luminosidad: 300 lx"),
          ],
        ),
      ),
    );
  }
}

class EmailScreen extends StatefulWidget {
  @override
  _EmailScreenState createState() => _EmailScreenState();
}

class _EmailScreenState extends State<EmailScreen> {
  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _bodyController = TextEditingController();
  final TextEditingController _recipientController = TextEditingController();

  Future<void> sendEmail() async {
    final smtpServer = gmail('your_email@gmail.com', 'your_password');
    final message = Message()
      ..from = Address('your_email@gmail.com', 'Your Name')
      ..recipients.add(_recipientController.text)
      ..subject = _subjectController.text
      ..text = _bodyController.text;

    try {
      await send(message, smtpServer);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Correo enviado con éxito')));
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error al enviar el correo')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Correo Corporativo")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _recipientController,
              decoration: InputDecoration(labelText: "Destinatario"),
            ),
            TextField(
              controller: _subjectController,
              decoration: InputDecoration(labelText: "Asunto"),
            ),
            TextField(
              controller: _bodyController,
              decoration: InputDecoration(labelText: "Mensaje"),
              maxLines: 8,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: sendEmail,
              child: Text("Enviar"),
            ),
          ],
        ),
      ),
    );
  }
}

class AnalysisScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Análisis y Mejora Continua")),
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: [
          ListTile(
            title: Text("Áreas de Mejora en Comunicación Empresarial"),
            subtitle: Text(
                "1. Mejora en la retroalimentación entre empleados y gerencia."),
          ),
          ListTile(
            title: Text("Áreas de Mejora en Bienestar Laboral"),
            subtitle: Text(
                "2. Aumento de beneficios para la salud y el bienestar de los empleados."),
          ),
          ListTile(
            title: Text("Futuras Actualizaciones en Comunicación"),
            subtitle: Text(
                "3. Implementación de nuevas herramientas digitales para mejorar la colaboración."),
          ),
          ListTile(
            title: Text("Futuras Actualizaciones en Bienestar"),
            subtitle: Text(
                "4. Creación de programas de desarrollo personal y profesional."),
          ),
        ],
      ),
    );
  }
}
