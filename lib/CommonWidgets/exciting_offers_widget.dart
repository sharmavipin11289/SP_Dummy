import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:sanaa/CommonFiles/common_variables.dart';
import 'package:sanaa/Screens/HomePage/Model/offers_model.dart';
import '../CommonFiles/text_style.dart';
import '../Navigation/navigation_service.dart';
import '../Screens/HomePage/cubit/home_cubit.dart';
import '../Screens/HomePage/cubit/home_state.dart';

class ExcitingOffersWidget extends StatefulWidget {
  const ExcitingOffersWidget({super.key});

  @override
  State<ExcitingOffersWidget> createState() => _ExcitingOffersWidgetState();
}

class _ExcitingOffersWidgetState extends State<ExcitingOffersWidget> {
  final ScrollController _scrollController = ScrollController();
  bool _isLastItemVisible = false;
  late HomeCubit _homeCubit;
  int _page = 1;
  bool _hasMore = true;
  bool _isLoading = false;
  List<OfferData> _offers = [];

  @override
  void initState() {
    super.initState();
    _homeCubit = BlocProvider.of<HomeCubit>(context);
    _scrollController.addListener(_checkLastItemVisible);
    getOffers(page: _page);
  }

  getOffers({required int page}) async {
    if (!_isLoading && _hasMore) {
      setState(() {
        _isLoading = true;
      });
      await _homeCubit.getOffers(page: page);
    }
  }

  void _checkLastItemVisible() {
    if (_scrollController.hasClients && !_isLoading && _hasMore) {
      final maxScroll = _scrollController.position.maxScrollExtent;
      final currentScroll = _scrollController.position.pixels;
      const itemWidth = 244.0; // 229 width + 15 margin
      final viewportWidth = MediaQuery.of(context).size.width;
      final totalItems = _offers.length;
      final lastItemStart = (totalItems - 1) * itemWidth;

      bool isLastVisible = currentScroll >= (lastItemStart - viewportWidth + itemWidth);

      if (isLastVisible && !_isLastItemVisible) {
        setState(() {
          _isLastItemVisible = true;
        });
        _page++;
        getOffers(page: _page);
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
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppLocalizations.of(context)?.excitingOffer ?? 'Exciting Offers',
                style: FontStyles.getStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (_offers.isNotEmpty)
                GestureDetector(
                  onTap: () {
                    final args = {'title': AppLocalizations.of(context)?.excitingOffer ?? 'Exciting Offer', 'offerId': _offers.first.id ?? '', 'view': 'exciting-offers'};
                    NavigationService.navigateTo('/excitingOffer', arguments: args);
                  },
                  child: Text(
                    AppLocalizations.of(context)?.seeAll ?? 'See All',
                    style: FontStyles.getStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF318531),
                    ),
                  ),
                ),
            ],
          ),
        ),
        SizedBox(height: 14),
        BlocConsumer<HomeCubit, HomeState>(
          listener: (context, state) {
            if (state is OffersFailed) {
              print('Failed to load offers: ${state.error}');
              setState(() {
                _isLoading = false;
              });
            } else if (state is OffersSuccess) {
              setState(() {
                _isLoading = false;
                if (_page == 1) {
                  _offers = state.offerData ?? [];
                } else {
                  _offers.addAll(state.offerData ?? []);
                }
                _hasMore = state.meta?.total != null && _offers.length < state.meta!.total!;
              });
            }
          },
          builder: (context, state) {
            if (state is OffersLoading && _page == 1) {
              return Center(child: CircularProgressIndicator());
            }
            if (_offers.isEmpty && !_isLoading) {
              return Center(
                child: Text(
                  AppLocalizations.of(context)?.dataNotAvailable ?? 'No Offers Available',
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
                    for (var offer in _offers)
                      InkWell(
                        onTap: () {
                          print(offer.id);
                          final args = {'title': AppLocalizations.of(context)?.excitingOffer ?? 'Exciting Offers', 'offerId': offer.id ?? '', 'category': null, 'vendorId': null, 'view': 'exciting-offers'};
                          NavigationService.navigateTo('/excitingOffer', arguments: args);
                        },
                        child: SizedBox(
                          width: 229,
                          height: 122,
                          child: Padding(
                            padding: EdgeInsets.only(right: 15),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.network(
                                offer.imageUrl ?? dummyImageUrl,
                                width: 229,
                                height: 122,
                                fit: BoxFit.fill,
                                errorBuilder: (context, error, stackTrace) {
                                  return Image.network(
                                    dummyImageUrl,
                                    width: 229,
                                    height: 122,
                                    fit: BoxFit.fill,
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
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


