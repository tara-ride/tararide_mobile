import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tararide_mobile/bloc/driver_ride_status/driver_ride_status_bloc.dart';

class DriverPostRideFormDisplayedWidget extends StatefulWidget {
  final ValueChanged<Map<String, String>> onCarpoolDetailsCollected;

  const DriverPostRideFormDisplayedWidget({super.key, required this.onCarpoolDetailsCollected});

  @override
  State<DriverPostRideFormDisplayedWidget> createState() => _DriverPostRideFormDisplayedWidgetState();
}

class _DriverPostRideFormDisplayedWidgetState extends State<DriverPostRideFormDisplayedWidget> {
  final TextEditingController _carpoolDescriptionController = TextEditingController();
  final TextEditingController _carpoolTitleController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Row(
          children: [
            Expanded(
              child: SizedBox(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 8),
                  child: Text(
                    "Carpool Details",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ],
        ),

        // Add your form fields here

        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextFormField(
            controller: _carpoolTitleController,
            decoration: const InputDecoration(
              labelText: 'Carpool Title',
              border: OutlineInputBorder(),
              hintText: 'e.g. SM Southmall to Festival Mall Alabang',
            ),
            onChanged: (value) {},
          ),
        ),

        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: _carpoolDescriptionController,
              maxLines: 6,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'e.g. along Zapote - Alabang Road (Nearby malls, ATC, Molito Lifestyle Center, South Station)',
              ),
              onChanged: (value) {},
            ),
          ),
        ),

        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
                child: Padding(
              padding: const EdgeInsets.only(left: 8, right: 4),
              child: SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () {
                    context.read<DriverRideStatusBloc>().add(const DriverRideInitialize());
                  },
                  child: const Text('Cancel'),
                ),
              ),
            )),
            Expanded(
                child: Padding(
              padding: const EdgeInsets.only(left: 8, right: 4),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (_carpoolTitleController.text.isEmpty && _carpoolDescriptionController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Please fill up the title and description."),
                        ),
                      );
                    } else {
                      widget.onCarpoolDetailsCollected({
                        "ride_title": _carpoolTitleController.text,
                        "ride_description": _carpoolDescriptionController.text,
                      });
                      context.read<DriverRideStatusBloc>().add(const DriverSelectStartLocation());
                    }
                  },
                  child: const Text('Next'),
                ),
              ),
            )),
          ],
        ),
      ],
    );
  }
}
