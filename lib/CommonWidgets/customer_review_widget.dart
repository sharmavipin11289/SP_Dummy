import 'package:flutter/material.dart';
import 'package:flutter_rating/flutter_rating.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:sanaa/CommonFiles/common_variables.dart';
import 'package:sanaa/Screens/HomePage/Model/testimonial_model.dart';
import '../CommonFiles/text_style.dart';

class CustomerReviewWidget extends StatefulWidget {
  List<Testimonial> testimonials;
  CustomerReviewWidget({super.key, required this.testimonials});

  @override
  State<CustomerReviewWidget> createState() => _CustomerReviewWidgetState();
}

class _CustomerReviewWidgetState extends State<CustomerReviewWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            AppLocalizations.of(context)?.customerReviews ?? 'Customer Reviews',
            style: FontStyles.getStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        SizedBox(
          height: 14,
        ),
        Padding(
          padding: EdgeInsets.only(left: 20),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                for(var testimonial in widget.testimonials)
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: CustomerReviewCard(testimonial: testimonial,),
                  )
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class CustomerReviewCard extends StatelessWidget {
  Testimonial testimonial;
  CustomerReviewCard({super.key, required this.testimonial});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 17,vertical: 17),
      width: 294,
      height: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Color(0xFFC1DAC1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(width: 40,height: 40,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    testimonial.customerProfilePictureUrl ?? dummyImageUrl,
                  ),
                ),
              ),
              Spacer(),
              StarRating(
                size: 25,
                rating: testimonial.rating?.toDouble() ?? 0.0,
                allowHalfRating: true,
                onRatingChanged: (rating) {},
                color: Color(0xFFFFCE00),
                emptyIcon: Icons.star,
                halfFilledIcon: Icons.star_half_outlined,
                filledIcon: Icons.star,
              ),
            ],
          ),
          SizedBox(
            height: 14,
          ),
          Text(
            testimonial.customerName ?? '',
            style: FontStyles.getStyle(
              fontSize: 17,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 14),
          Expanded(
            child: Text(
              testimonial.review ?? '',
              overflow: TextOverflow.ellipsis,
              maxLines: 5,
              style: FontStyles.getStyle(
                fontSize: 10,
                fontWeight: FontWeight.w400,
                color: Color(0xFF202020),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
