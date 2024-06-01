import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Main entry point
void main() {
  runApp(MyApp());
}

// Main application widget
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => PetProvider(),
      child: MaterialApp(
        title: 'Happy Tails',
        theme: ThemeData(
          primarySwatch: Colors.pink,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: HomePage(),
      ),
    );
  }
}

// Pet model class
class Pet {
  final String id;
  final String name;
  final String breed;
  final String description;
  final String imageUrl;
  final IconData icon;

  Pet({
    required this.id,
    required this.name,
    required this.breed,
    required this.description,
    required this.imageUrl,
    required this.icon,
  });
}

// Home page
class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink[100],
      appBar: AppBar(
        backgroundColor: Colors.pink[100],
        title: Text('Happy Tails'),
        actions: [
          IconButton(
            icon: Icon(Icons.pets),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PetCarePage()),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.report),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ReportPetPage()),
              );
            },
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'Profile') {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProfilePage()),
                );
              } else if (value == 'Adoption') {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AdoptionPage()),
                );
              } else if (value == 'Donation') {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DonationPage()),
                );
              } else if (value == 'Favorites') {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => FavoritesPage()),
                );
              }
            },
            itemBuilder: (BuildContext context) {
              return {'Profile', 'Adoption', 'Donation', 'Favorites'}.map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            },
          ),
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(100.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: PetSearchBar(),
              ),
              CategoriesBar(),
            ],
          ),
        ),
      ),
      body: Consumer<PetProvider>(
        builder: (context, petProvider, child) {
          if (petProvider.isLoading) {
            return Center(child: CircularProgressIndicator());
          }

          return ListView.builder(
            itemCount: petProvider.pets.length,
            itemBuilder: (context, index) {
              final pet = petProvider.pets[index];
              return Card(
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundImage: AssetImage(pet.imageUrl),
                  ),
                  title: Text(pet.name),
                  subtitle: Text(pet.breed),
                  trailing: Icon(Icons.arrow_forward),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PetDetailPage(pet: pet),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ReportPetPage()),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

// Pet search bar widget
class PetSearchBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: TextField(
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.search),
          hintText: 'Search pets...',
          border: InputBorder.none,
          contentPadding: EdgeInsets.all(16.0),
        ),
      ),
    );
  }
}

// Categories bar widget
class CategoriesBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final petProvider = Provider.of<PetProvider>(context, listen: false);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        CategoryButton(
          label: 'Dogs',
          onPressed: () => petProvider.filterPetsByCategory('dog'),
        ),
        CategoryButton(
          label: 'Cats',
          onPressed: () => petProvider.filterPetsByCategory('cat'),
        ),
        CategoryButton(
          label: 'Birds',
          onPressed: () => petProvider.filterPetsByCategory('bird'),
        ),
      ],
    );
  }
}
// Category button widget
// Category button widget
class CategoryButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  CategoryButton({required this.label, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Text(
        label,
        style: TextStyle(color: Colors.black), // Set text color
      ),
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(Colors.pink[100]!), // Set background color
      ),
    );
  }
}






// Pet detail page
class PetDetailPage extends StatelessWidget {
  final Pet pet;

  PetDetailPage({required this.pet});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue[50],
      appBar: AppBar(
        title: Text(pet.name),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Image.asset(pet.imageUrl, height: 250),
            ),
            SizedBox(height: 16.0),
            Text(
              pet.name,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            Text(
              pet.breed,
              style: TextStyle(fontSize: 20, color: Colors.grey),
            ),
            SizedBox(height: 16.0),
            Text(pet.description),
            Spacer(),
            ElevatedButton.icon(
              icon: Icon(Icons.medical_services),
              label: Text('Hand Over to Blue Cross'),
              onPressed: () {
                // Navigate to HandOverPage
              },
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50),
              ),
            ),
            ElevatedButton.icon(
              icon: Icon(Icons.pets),
              label: Text('Adopt'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AdoptPetPage(pet: pet)),
                );
              },
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Report pet page
class ReportPetPage extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  String _description = '';

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      // Handle form submission
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue[50],
      appBar: AppBar(
        title: Text('Report a Pet'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Report a Pet',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16.0),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
                onSaved: (value) {
                  _description = value!;
                },
              ),
              SizedBox(height: 20.0),
              Center(
                child: ElevatedButton(
                  onPressed: _submitForm,
                  child: Text('Submit'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Adopt pet page
class AdoptPetPage extends StatelessWidget {
  final Pet pet;
  final _formKey = GlobalKey<FormState>();
  String _ownerName = '';
  String  _contactNumber = '';
  AdoptPetPage({required this.pet});

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      // Handle form submission
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue[50],
      appBar: AppBar(
        title: Text('Adopt ${pet.name}'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Adopt ${pet.name}',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16.0),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Owner Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
                onSaved: (value) {
                  _ownerName = value!;
                },
              ),
              SizedBox(height: 16.0),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Contact Number',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your contact number';
                  }
                  return null;
                },
                onSaved: (value) {
                  _contactNumber = value!;
                },
              ),
              SizedBox(height: 20.0),
              Center(
                child: ElevatedButton(
                  onPressed: _submitForm,
                  child: Text('Submit'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Pet care page
class PetCarePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue[50],
      appBar: AppBar(
        title: Text('Pet Care'),
        actions: [
          IconButton(
            icon: Icon(Icons.favorite),
            onPressed: () {
              // Navigate to FavoritesPage
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => FavoritesPage()),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Text(
              'Pet Care Tips',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16.0),
            Text(
              'Food:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text(
              'Ensure your pet has a balanced diet with the right nutrients. Consult your vet for specific dietary requirements based on your pet\'s age, breed, and health condition.',
            ),
            SizedBox(height: 16.0),
            Text(
              'Common Diseases:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text(
              'Keep an eye out for common diseases such as fleas, ticks, and infections. Regular vet check-ups and vaccinations can help prevent these issues.',
            ),
            SizedBox(height: 16.0),
            Text(
              'Veterinary Doctor:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text(
              'Dr. John Doe\nPhone: 123-456-7890\nClinic: Pet Health Clinic\nAddress: 1234 Pet St, Pet City',
            ),
          ],
        ),
      ),
    );
  }
}

// Donation page
class DonationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue[50],
      appBar: AppBar(
        title: Text('Donation'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Donation',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16.0),
            Text(
              'Your support helps us provide care and shelter for animals in need. Every donation makes a difference in the lives of homeless pets.',
            ),
            SizedBox(height: 16.0),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Implement donation logic
                },
                child: Text('Donate Now'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Adoption page
class AdoptionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue[50],
      appBar: AppBar(
        title: Text('Adoption'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Adoption',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16.0),
            Text(
              'Adopting a pet can bring joy and companionship to your life while giving a loving home to a pet in need. Visit our shelter to meet our adorable animals available for adoption.',
            ),
            SizedBox(height: 16.0),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Implement adoption logic
                },
                child: Text('View Pets for Adoption'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Favorites page
class FavoritesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue[50],
      appBar: AppBar(
        title: Text('Favorites'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Favorites',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16.0),
            Text(
                'Your favorite pets are saved here. Keep track of your preferred animals for adoption and easily find them when youre ready to bring a new furry friend home.',
            ),
            // Add favorite pets list here
          ],
        ),
      ),
    );
  }
}

// Profile page
class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue[50],
      appBar: AppBar(
        title: Text('My Profile'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'My Profile',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16.0),
            // Add owner details here
            Text('Name: John Doe'),
            Text('Email: john@example.com'),
            Text('Phone: 123-456-7890'),
            Text('Address: 1234 Street, City, Country'),
          ],
        ),
      ),
    );
  }
}

// Pet provider for managing state
class PetProvider with ChangeNotifier {
  List<Pet> _pets = [];
  bool _isLoading = false;

  List<Pet> get pets => _pets;
  bool get isLoading => _isLoading;

  PetProvider() {
    fetchPets();
  }

  Future<void> fetchPets() async {
    _isLoading = true;
    notifyListeners();

    // Simulate network request
    await Future.delayed(Duration(seconds: 2));

    _pets = [
    Pet(
    id: '1',
    name: 'Buddy',
    breed: 'Golden Retriever',
    description:
    'Buddy is a friendly and energetic Golden Retriever. He loves playing fetch and going for long walks. He is great with kids and other pets. He enjoys swimming and being outdoors. Buddy needs a loving home where he can get plenty of exercise and attention.',
    imageUrl: 'assets/images/dog1.jpg',
    icon: Icons.pets,
    ),
    Pet(
    id: '2',
    name: 'Whiskers',
    breed: 'Siamese Cat',
    description:
    'Whiskers is a curious and playful Siamese cat. He enjoys exploring new places and cuddling with his human companions. Whiskers is an indoor cat who loves to lounge by the window and watch the world go by. He is litter box trained and enjoys interactive play with toys.',
    imageUrl: 'assets/images/cat1.jpg',
    icon: Icons.pets,
    ),
    Pet(
    id: '3',
    name: 'Max',
    breed: 'Golden Retriever',
    description:
    'Max is a loyal and intelligent Golden Retriever. He is always eager to learn new tricks and accompany his family on adventures. Max loves outdoor activities such as hiking and camping. He is gentle with children and makes a great family pet.',
    imageUrl: 'assets/images/dog2.jpg',
    icon: Icons.pets,
    ),
    Pet(
    id: '4',
    name: 'Snowball',
    breed: 'Shih Tzu',
    description:
    'Snowball is a cute and cuddly Shih Tzu puppy. She loves snuggling on the couch and getting belly rubs. Snowball enjoys short walks in the park and playing with her favorite toys. She is hypoallergenic and suitable for families with allergies.',
    imageUrl: 'assets/images/dog3.jpg',
    icon: Icons.pets,
    ),
    Pet(
    id: '5',
    name: 'Fluffy',
    breed: 'Persian Cat',
    description:
    'Fluffy is a gentle and affectionate Persian cat. She enjoys lounging in sunbeams and receiving gentle pets from her human companions. Fluffy prefers a calm and quiet environment where she can relax and unwind.',
    imageUrl: 'assets/images/cat2.jpg',
    icon: Icons.pets,
    ),
    Pet(
    id: '6',
    name: 'Rocky',
    breed: 'Boxer',
    description:
    'Rocky is an energetic and playful Boxer. He loves running around in the backyard and playing fetch with his favorite ball. Rocky is great with kids and enjoys being part of an active family. He is looking for a loving home with plenty of space to play.',
    imageUrl: 'assets/images/dog4.jpg',
    icon: Icons.pets,
    ),
    // Add more pets here
    Pet(
    id: '7',
    name: 'Bella',
    breed: 'Labrador Retriever',
    description:
    'Bella is a sweet and gentle Labrador Retriever. She loves being around people and is very friendly with other pets. Bella enjoys playing in the yard and loves water activities. She is well-trained and obedient, making her a great family pet.',
    imageUrl: 'assets/images/dog5.jpg',
    icon: Icons.pets,
    ),
    Pet(
    id: '8',
    name: 'Charlie',
    breed: 'Beagle',
    description:
    'Charlie is a curious and playful Beagle. He loves sniffing around and discovering new things. Charlie is very friendly and gets along well with kids and other pets. He enjoys outdoor activities and needs a loving home with plenty of space to explore.',
    imageUrl: 'assets/images/dog6.jpg',
    icon: Icons.pets,
    ),
    Pet(
    id: '9',
    name: 'Lucy',
    breed: 'Bulldog',
    description:
    'Lucy is a calm and loving Bulldog. She enjoys lounging around the house and getting belly rubs. Lucy is very gentle and good with children. She prefers a quiet environment and is looking for a loving home where she can relax and be pampered.',
    imageUrl: 'assets/images/dog7.jpg',
    icon: Icons.pets,
    ),
    Pet(
    id: '10',
    name: 'Milo',
    breed: 'Maine Coon',
    description:
    'Milo is a majestic Maine Coon cat with a playful and affectionate personality. He enjoys spending time with his human companions and is very sociable. Milo loves interactive play and is always up for a game of chase or fetch. He is looking for a loving home where he can be the center of attention.',
      imageUrl: 'assets/images/cat3.jpg',
      icon: Icons.pets,
    ),
    ];

    _isLoading = false;
    notifyListeners();
  }

  void filterPetsByCategory(String category) {
    // Implement filtering logic based on category
  }
}

// Profile model class
class Profile {
  final String name;
  final String email;
  final String phone;
  final String address;

  Profile({
    required this.name,
    required this.email,
    required this.phone,
    required this.address,
  });
}
