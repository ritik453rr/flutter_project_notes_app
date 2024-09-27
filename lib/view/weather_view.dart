import 'package:flutter/material.dart';
import 'package:notes_app/view_model/weather_view_model.dart';
import 'package:provider/provider.dart';

class WeatheView extends StatefulWidget {
  const WeatheView({super.key});

  @override
  State<WeatheView> createState() => _WeatheViewState();
}

class _WeatheViewState extends State<WeatheView> {
  final TextEditingController locationController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Location Field
            TextField(
              controller: locationController,
              decoration: const InputDecoration(hintText: "Enter Location"),
            ),
            const SizedBox(height: 15),

            // Search Button
            Consumer<WeatherViewModel>(
              builder: (context, weatherProvider, child) => OutlinedButton(
                onPressed: () async {
                  await weatherProvider.loadWeather(
                      location: locationController.text);
                },
                child: const Text("Search"),
              ),
            ),
            const SizedBox(height: 10),

            // Error message display
            Consumer<WeatherViewModel>(
              builder: (context, weatherProvider, child) {
                if (weatherProvider.isLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (weatherProvider.errorMessage != null) {
                  return Text(
                    weatherProvider.errorMessage!,
                    style: const TextStyle(color: Colors.red, fontSize: 16),
                  );
                }
                final weather = weatherProvider.weather.main;
                if (locationController.text.isNotEmpty &&
                    weatherProvider.errorMessage == null) {
                  return Column(
                    children: [
                      Text("City: ${locationController.text}"),
                      if (weather?.temp != null)
                        Text("Temp: ${weather?.temp}°f"),
                      if (weather?.tempMax != null)
                        Text("Max Temp: ${weather?.tempMax}°f"),
                      if (weather?.tempMin != null)
                        Text("Min Temp: ${weather?.tempMin}°f"),
                    ],
                  );
                }
                return const SizedBox();
              },
            ),
          ],
        ),
      ),
    );
  }
}
