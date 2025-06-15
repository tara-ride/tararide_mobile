import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:tararide_mobile/bloc/passenger_ride_status/passenger_ride_status_bloc.dart';

class PassengerRideLoadWeatherDataWidget extends StatefulWidget {
  final PassengerRideStatusWeatherDataLoaded weatherData;
  const PassengerRideLoadWeatherDataWidget({super.key, required this.weatherData});

  @override
  // ignore: no_logic_in_create_state
  State<StatefulWidget> createState() => _PassengerRideLoadWeatherDataWidgetState(state: weatherData);
}

class _PassengerRideLoadWeatherDataWidgetState extends State<PassengerRideLoadWeatherDataWidget> {
  final PassengerRideStatusWeatherDataLoaded state;

  _PassengerRideLoadWeatherDataWidgetState({required this.state});
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: const Color.fromARGB(255, 217, 243, 255),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 60,
                    width: double.infinity,
                    child: Lottie.asset('assets/sunny_day.json'),
                  ),
                  Text(
                    "${state.weatherDataFromAPI.temperature.degrees.toString()} °C",
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  const Text("Weather Information", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 5),
                  Text("Time: ${DateFormat('MM/dd/yyyy hh:mm a').format(DateTime.now())}"),
                  Text("Time: ${DateTime.now().timeZoneName}"),
                  // Text("Humidity: ${state.weatherDataFromAPI.relativeHumidity}%"), // Ensure this property exists
                  Text(state.weatherDataFromAPI.weatherCondition.description.text),
                  const Expanded(child: SizedBox()),
                  Padding(
                    padding: const EdgeInsets.only(left: 8, right: 8, bottom: 8),
                    child: SizedBox(
                      width: double.infinity,
                      height: 40,
                      child: ElevatedButton(
                        onPressed: () {
                          // Access the BLoC from the context of this widget
                          context.read<PassengerRideStatusBloc>().add(PassengerSelectPickupLocation());
                        },
                        child: const Text("Ride Now"),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
