import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';

class SwipePage extends StatefulWidget {
  const SwipePage({
    super.key,
  });

  @override
  State<SwipePage> createState() => _ExamplePageState();
}

class _ExamplePageState extends State<SwipePage> {
  final CardSwiperController controller = CardSwiperController();

  final cards = candidates.map(ExampleCard.new).toList();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Swipe!'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Flexible(
              child: CardSwiper(
                controller: controller,
                cardsCount: cards.length,
                onSwipe: _onSwipe,
                onUndo: _onUndo,
                numberOfCardsDisplayed: 3,
                backCardOffset: const Offset(40, 40),
                padding: const EdgeInsets.all(24.0),
                cardBuilder: (
                  context,
                  index,
                  horizontalThresholdPercentage,
                  verticalThresholdPercentage,
                ) =>
                    cards[index],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  FloatingActionButton(
                    onPressed: controller.undo,
                    child: const Icon(Icons.rotate_left),
                  ),
                  FloatingActionButton(
                    onPressed: () => controller.swipe(CardSwiperDirection.left),
                    child: const Icon(Icons.keyboard_arrow_left),
                  ),
                  FloatingActionButton(
                    onPressed: () =>
                        controller.swipe(CardSwiperDirection.right),
                    child: const Icon(Icons.keyboard_arrow_right),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

bool _onSwipe(
    int previousIndex,
    int? currentIndex,
    CardSwiperDirection direction,
  ) {
    debugPrint(
      'The card $previousIndex was swiped to the ${direction.name}. Now the card $currentIndex is on top',
    );

    if (currentIndex != null) {
      final databaseReference = FirebaseDatabase(
        databaseURL:
            'https://appjam-1-default-rtdb.europe-west1.firebasedatabase.app',
      ).reference().child('swipedRight');

      // Use the name of the place as a unique identifier
      String placeName = cards[currentIndex].candidate.name;

      if (direction == CardSwiperDirection.right) {
        databaseReference.child(placeName).update({
          'name': cards[currentIndex].candidate.name,
          'job': cards[currentIndex].candidate.job,
          'city': cards[currentIndex].candidate.city,
          'color': cards[currentIndex]
              .candidate
              .color
              .map((color) => color.value)
              .toList(),
          'imageUrl': cards[currentIndex].candidate.imageUrl,
          'rating': cards[currentIndex].candidate.rating,
          'address': cards[currentIndex].candidate.address,
          'swipedRight': true,
          'user': FirebaseAuth.instance.currentUser?.uid, // Add this line
        });
      } else if (direction == CardSwiperDirection.left) {
        // Remove the place from the database when swiped left
        databaseReference.child(placeName).remove();
      }
    }

    return true;
  }

  bool _onUndo(
    int? previousIndex,
    int currentIndex,
    CardSwiperDirection direction,
  ) {
    debugPrint(
      'The card $currentIndex was undod from the ${direction.name}',
    );
    return true;
  }
}

class ExampleCard extends StatelessWidget {
  final ExampleCandidateModel candidate;

  const ExampleCard(
    this.candidate, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 3,
            blurRadius: 7,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      alignment: Alignment.center,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(
            child: Image.network(candidate.imageUrl, fit: BoxFit.cover),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  candidate.name,
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  candidate.job,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  candidate.city,
                  style: const TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 5),
                Text(
                  candidate.address,
                  style: const TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 5),
                Text(
                  'Rating: ${candidate.rating}',
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ExampleCandidateModel {
  final String name;
  final String job;
  final String city;
  final List<Color> color;
  final String imageUrl;
  final double rating;
  final String address;

  ExampleCandidateModel({
    required this.name,
    required this.job,
    required this.city,
    required this.color,
    required this.imageUrl,
    required this.rating,
    required this.address,
  });
}

final List<ExampleCandidateModel> candidates = [
  ExampleCandidateModel(
    name: 'Absinthe Brasserie & Bar',
    job: 'Restaurant',
    city: 'San Francisco',
    color: const [Color(0xFFFF3868), Color(0xFFFFB49A)],
    imageUrl:
        'https://images.squarespace-cdn.com/content/v1/624f382421799e11a4bac2d8/82893d80-a81b-41a6-bace-de5c8e4f23f2/11314043035_ab87655a26_k.jpg',
    rating: 4.5,
    address: '398 Hayes St, San Francisco, CA 94102',
  ),
  ExampleCandidateModel(
    name: 'Blue Bottle Coffee',
    job: 'Cafe',
    city: 'Oakland',
    color: const [Color(0xFF736EFE), Color(0xFF62E4EC)],
    imageUrl:
        'https://res.cloudinary.com/hbhhv9rz9/image/upload/v1687376961/cafes/Gramercy%20Park/Cafe-Gramercy-Hero.jpg',
    rating: 4.7,
    address: '300 Webster St, Oakland, CA 94607',
  ),
  ExampleCandidateModel(
    name: 'Smuggler\'s Cove',
    job: 'Bar',
    city: 'San Francisco',
    color: const [Color(0xFF2F80ED), Color(0xFF56CCF2)],
    imageUrl:
        'https://images.squarespace-cdn.com/content/v1/56e84c3cb654f9ada96c30ed/1462472252358-FXBGVQB8ACCYSYQYX2JB/bar.jpg',
    rating: 4.8,
    address: '650 Gough St, San Francisco, CA 94102',
  ),
  ExampleCandidateModel(
    name: 'Memorial Court',
    job: 'Park',
    city: 'Stanford',
    color: const [Color(0xFF0BA4E0), Color(0xFFA9E4BD)],
    imageUrl:
        'https://s3-us-west-2.amazonaws.com/stanford-125/wp-content/uploads/2015/12/Memorial_Court-cropped-2048x1231.jpg',
    rating: 4.6,
    address: '450 Serra Mall, Stanford, CA 94305',
  ),
];
