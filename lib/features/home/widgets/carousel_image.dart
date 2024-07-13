import 'package:carousel_slider/carousel_slider.dart';
import 'package:cartify/constants/global_variables.dart';
import 'package:flutter/material.dart';

class CarouselImage extends StatelessWidget {
  const CarouselImage({super.key});

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      // The map function iterates over each element in the list (each image URL in this case),
      // and for each element, it executes a function that takes the current element (i) as an argument.
      items: GlobalVariables.carouselImages.map(
        (i) {
          return Builder(
            // The Builder widget is used here to create a context for the Image.network widget.
            builder: (BuildContext context) => Image.network(
              i,
              // The fit property is set to BoxFit.cover to ensure that the image covers
              // the available space without distorting the aspect ratio.
              fit: BoxFit.cover,
              height: 200,
            ),
          );
        },
        // The resulting iterable of Builder widgets is converted back into a list using .toList().
        // This is necessary because the items parameter of the CarouselSlider expects a list of widgets.
      ).toList(),
      options: CarouselOptions(
        viewportFraction: 1, // Each image will take up the full width of the carousel's viewport
        height: 200,
      ),
    );
  }
}
