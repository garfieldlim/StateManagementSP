import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
      routes: {
        '/new-contact': (context) => const NewContactView(),
      },
    );
  }
}

class Contact {
  final String id;
  final String name;
  Contact({
    required this.name,
  }) : id = const Uuid().v4();
}

class ContactBook extends ValueNotifier<List<Contact>> {
  ContactBook._sharedInstance() : super([]);
  static final ContactBook _shared = ContactBook._sharedInstance();
  factory ContactBook() => _shared;

  int get length => value.length;

  void add({required Contact contact}) {
    final contacts = value;
    contacts.add(contact);
    notifyListeners();
  }

  void remove({required Contact contact}) {
    final contacts = value;
    if (contacts.contains(contact)) {
      contacts.remove(contact);
      notifyListeners();
    }
  }

  Contact? contact({required int atIndex}) =>
      value.length > atIndex ? value[atIndex] : null;
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: const Text(
            'Home Page',
          ),
        ),
      ),
      body: ValueListenableBuilder(
        valueListenable: ContactBook(),
        builder: (contact, value, child) {
          final contacts = value;
          return ListView.builder(
            itemCount: contacts.length,
            itemBuilder: (context, index) {
              final contact = contacts[index];
              return Dismissible(
                onDismissed: (direction) {
                  ContactBook().remove(contact: contact);
                },
                key: ValueKey(contact.id),
                child: Material(
                  color: Colors.white,
                  elevation: 10.0,
                  child: ListTile(
                    title: Text(contact.name),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.pushNamed(context, '/new-contact');
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class NewContactView extends StatefulWidget {
  const NewContactView({super.key});

  @override
  State<NewContactView> createState() => _NewContactViewState();
}

class _NewContactViewState extends State<NewContactView> {
  late final TextEditingController _controller;

  @override
  void initState() {
    _controller = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add a new contact'),
      ),
      body: Column(
        children: [
          TextField(
            controller: _controller,
            decoration: const InputDecoration(
              hintText: 'Enter a new contact name here...',
            ),
          ),
          TextButton(
              onPressed: () {
                final contact = Contact(name: _controller.text);
                ContactBook().add(contact: contact);
                Navigator.of(context).pop();
              },
              child: const Text('Add Contact'))
        ],
      ),
    );
  }
}


///////////////////////////
// Importing required packages
// import 'package:flutter/material.dart';
// import 'package:uuid/uuid.dart';

// // Main entry point of the application
// void main() {
//   runApp(const MyApp());
// }

// // MyApp StatelessWidget, the root widget of the application
// class MyApp extends StatelessWidget {
//   // Constructor with optional key
//   const MyApp({super.key});
//   // Build method, responsible for building the widget tree
//   @override
//   Widget build(BuildContext context) {
//     // MaterialApp widget wraps the entire application
//     return MaterialApp(
//       title: 'Flutter Demo',
//       // Define the ThemeData for the application
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       debugShowCheckedModeBanner: false,
//       // Define the home page widget
//       home: const HomePage(),
//       // Define routes for the application
//       routes: {
//         '/new-contact': (context) => const NewContactView(),
//       },
//     );
//   }
// }


// // Contact class, representing a contact in the contact book
// class Contact {
//   final String id;
//   final String name;
//   // Constructor with required name parameter
//   Contact({
//     required this.name,
//   }) : id = const Uuid().v4(); // Generate a unique id using Uuid
// }

// // ContactBook class extends ValueNotifier for state management
// class ContactBook extends ValueNotifier<List<Contact>> {
//   // Private constructor initializing the list of contacts
//   ContactBook._sharedInstance() : super([]);
//   // Singleton instance of ContactBook
//   static final ContactBook _shared = ContactBook._sharedInstance();
//   // Factory constructor returning the singleton instance
//   factory ContactBook() => _shared;

//   // Getter for the length of the contact list
//   int get length => value.length;

//   // Add a contact to the contact list and notify listeners
//   void add({required Contact contact}) {
//     final contacts = value;
//     contacts.add(contact);
//     notifyListeners();
//   }

//   // Remove a contact from the contact list and notify listeners
//   void remove({required Contact contact}) {
//     final contacts = value;
//     if (contacts.contains(contact)) {
//       contacts.remove(contact);
//       notifyListeners();
//     }
//   }

//   // Retrieve a contact at a specific index
//   Contact? contact({required int atIndex}) =>
//       value.length > atIndex ? value[atIndex] : null;
// }

// // HomePage StatelessWidget, responsible for displaying the list of contacts
// class HomePage extends StatelessWidget {
//   // Constructor with optional key
//   const HomePage({super.key});

//   // Build method, responsible for building the widget tree
//   @override
//   Widget build(BuildContext context) {
//     // Scaffold widget provides the basic structure for the page
//     return Scaffold(
//       // AppBar at the top of the page
//       appBar: AppBar(
//         title: Center(
//           child: const Text(
//             'Home Page',
//           ),
//         ),
//       ),
//       // Display the contact list using ValueListenableBuilder
//       body: ValueListenableBuilder(
//         valueListenable: ContactBook(),
//         builder: (contact, value, child) {
//           final contacts = value;
//           // ListView.builder for efficient scrolling of contacts
//           return ListView.builder(
//             itemCount: contacts.length,
//             itemBuilder: (context, index) {
//               final contact = contacts[index];
//               // Wrap each contact with a Dismissible widget
//               return Dismissible(
//                 onDismissed: (direction) {
//                   // Remove the contact when dismissed
//                   ContactBook().remove(contact: contact);
//                 },
//                 key: ValueKey(contact.id),
//                 // ListTile wrapped in a Material widget for elevation effect
//                 child: Material(
//                   color: Colors.white,
//                   elevation: 1.0,
//                    // ListTile widget to display contact information
//                   child: ListTile(
//                     title: Text(contact.name),
//                   ),
//                 ),
//               );
//             },
//           );
//         },
//       ),
//       // FloatingActionButton to navigate to the new contact view
//       floatingActionButton: FloatingActionButton(
//         onPressed: () async {
//           await Navigator.pushNamed(context, '/new-contact');
//         },
//         child: const Icon(Icons.add),
//       ),
//     );
// }
// }

// // NewContactView StatefulWidget, responsible for adding new contacts
// class NewContactView extends StatefulWidget {
//   // Constructor with optional key
//   const NewContactView({super.key});

//   // Create the mutable state for this widget
//   @override
//   State<NewContactView> createState() => _NewContactViewState();
// }

// // State class for the NewContactView StatefulWidget
// class _NewContactViewState extends State<NewContactView> {
//   // TextEditingController for handling text input
//   late final TextEditingController _controller;

//   // Initialize the TextEditingController
//   @override
//   void initState() {
//     _controller = TextEditingController();
//     super.initState();
//   }

//   // Dispose the TextEditingController when the widget is removed
//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   // Build method, responsible for building the widget tree
//   @override
//   Widget build(BuildContext context) {
//     // Scaffold widget provides the basic structure for the page
//     return Scaffold(
//       // AppBar at the top of the page
//       appBar: AppBar(
//         title: const Text('Add a new contact'),
//       ),
//       // Column widget to arrange child widgets vertically
//       body: Column(
//         children: [
//           // TextField for user input
//           TextField(
//             controller: _controller,
//             decoration: const InputDecoration(
//               hintText: 'Enter a new contact name here...',
//             ),
//           ),
//           // TextButton for adding a new contact
//           TextButton(
//             onPressed: () {
//               // Create a new contact from user input
//               final contact = Contact(name: _controller.text);
//               // Add the new contact to the contact book
//               ContactBook().add(contact: contact);
//               // Navigate back to the home page
//               Navigator.of(context).pop();
//             },
//             child: const Text('Add Contact'))
//         ],
//       ),
//     );
//   }
// }
