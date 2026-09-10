import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sae_mobile/Views/viewRestaurant.dart';

import '../Model/Restaurant/Restaurant.dart';
import '../ViewModels/restaurantViewModel.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("IUTable"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Recommander",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.left,
            ),

            Expanded(
              child: ViewRestaurant(
                axis: Axis.horizontal,
                restaurants: context
                    .watch<RestaurantViewModel>()
                    .getRestaurants(),
              ),
            ),

            const SizedBox(height: 35),

            const Text(
              "Récemment consulté",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.left,
            ),

            FutureBuilder<List<Restaurant>>(
              future: context
                  .watch<RestaurantViewModel>()
                  .getViewedRestaurants(),
              builder: (context, snapshot) {
                if (snapshot.data?.isEmpty ?? true) {
                  return const Expanded(
                    child: Center(
                      child: Text('Aucun restaurant consulté'),
                    ),
                  );
                }

                return Expanded(
                  child: ViewRestaurant(
                    axis: Axis.horizontal,
                    restaurants: snapshot.data!,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
