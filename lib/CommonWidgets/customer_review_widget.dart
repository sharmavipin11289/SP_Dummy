import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating/flutter_rating.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:sanaa/CommonFiles/common_variables.dart';
import 'package:sanaa/Screens/HomePage/Model/testimonial_model.dart';
import '../CommonFiles/text_style.dart';
import '../Screens/HomePage/cubit/home_cubit.dart';
import '../Screens/HomePage/cubit/home_state.dart';


class CustomerReviewWidget extends StatefulWidget {
  const CustomerReviewWidget({super.key});

  @override
  State<CustomerReviewWidget> createState() => _CustomerReviewWidgetState();
}

class _CustomerReviewWidgetState extends State<CustomerReviewWidget> {
  final ScrollController _scrollController = ScrollController();
  bool _isLastItemVisible = false;
  late HomeCubit _homeCubit;
  int _page = 1;
  bool _hasMore = true;
  bool _isLoading = false;
  List<Testimonial> _testimonials = [];

  @override
  void initState() {
    super.initState();
    _homeCubit = BlocProvider.of<HomeCubit>(context);
    _scrollController.addListener(_checkLastItemVisible);
    getTestimonials(page: _page);
  }

  getTestimonials({required int page}) async {
    if (!_isLoading && _hasMore) {
      setState(() {
        _isLoading = true;
      });
      await _homeCubit.getTestimonials(page: page);
    }
  }

  void _checkLastItemVisible() {
    if (_scrollController.hasClients && !_isLoading && _hasMore) {
      final maxScroll = _scrollController.position.maxScrollExtent;
      final currentScroll = _scrollController.position.pixels;
      const itemWidth = 302.0; // 294 width + 8 margin
      final viewportWidth = MediaQuery.of(context).size.width;
      final totalItems = _testimonials.length;
      final lastItemStart = (totalItems - 1) * itemWidth;

      bool isLastVisible = currentScroll >= (lastItemStart - viewportWidth + itemWidth);

      if (isLastVisible && !_isLastItemVisible) {
        setState(() {
          _isLastItemVisible = true;
        });
        _page++;
        getTestimonials(page: _page);
      } else if (!isLastVisible && _isLastItemVisible) {
        setState(() {
          _isLastItemVisible = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_checkLastItemVisible);
    _scrollController.dispose();
    super.dispose();
  }

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
        SizedBox(height: 14),
        BlocConsumer<HomeCubit, HomeState>(
          listener: (context, state) {
            if (state is TestimonialsFailed) {
              print('Failed to load testimonials: ${state.error}');
              setState(() {
                _isLoading = false;
              });
            } else if (state is TestimonialsSuccess) {
              setState(() {
                _isLoading = false;
                if (_page == 1) {
                  _testimonials = state.testimonials ?? [];
                } else {
                  _testimonials.addAll(state.testimonials ?? []);
                }
                _hasMore = state.meta?.total != null &&
                    _testimonials.length < state.meta!.total!;
              });
            }
          },
          builder: (context, state) {
            if (state is TestimonialsLoading && _page == 1) {
              return Center(child: CircularProgressIndicator());
            }
            if (_testimonials.isEmpty && !_isLoading) {
              return Center(
                child: Text(
                  AppLocalizations.of(context)?.dataNotAvailable ?? 'No Reviews Available',
                ),
              );
            }
            return SingleChildScrollView(
              controller: _scrollController,
              scrollDirection: Axis.horizontal,
              child: Padding(
                padding: EdgeInsets.only(left: 20),
                child: Row(
                  children: [
                    for (var testimonial in _testimonials)
                      Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: CustomerReviewCard(testimonial: testimonial),
                      ),
                    if (_isLoading && _page > 1)
                     const Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(child: CircularProgressIndicator()),
                      ),
                  ],
                ),
              ),
            );
          },
        ),

      ],
    );
  }
}

class CustomerReviewCard extends StatelessWidget {
  final Testimonial testimonial;

  const CustomerReviewCard({super.key, required this.testimonial});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 17, vertical: 17),
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
              SizedBox(
                width: 40,
                height: 40,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    testimonial.customerProfilePictureUrl ?? dummyImageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Image.network(
                        dummyImageUrl,
                        fit: BoxFit.cover,
                      );
                    },
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
          SizedBox(height: 14),
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






/*
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
*/
