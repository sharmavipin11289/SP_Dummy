import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sanaa/CommonFiles/common_variables.dart';
import 'package:sanaa/CommonFiles/text_style.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:sanaa/Screens/HomePage/Model/main_category_model.dart';
import '../Navigation/navigation_service.dart';
import '../Screens/HomePage/cubit/home_cubit.dart';
import '../Screens/HomePage/cubit/home_state.dart';


class CategoryWidget extends StatefulWidget {
  List<MainCategoryData>? categories;
  CategoryWidget({super.key, this.categories});

  @override
  State<CategoryWidget> createState() => _CategoryWidgetState();
}

class _CategoryWidgetState extends State<CategoryWidget> {
  final ScrollController _scrollController = ScrollController();
  bool _isLastItemVisible = false;
  late HomeCubit _homeCubit;
  int _page = 1;
  bool _hasMore = true;
  bool _isLoading = false;
  List<MainCategoryData> _categoryData = [];

  @override
  void initState() {
    super.initState();
    _homeCubit = BlocProvider.of<HomeCubit>(context);
    _scrollController.addListener(_checkLastItemVisible);
    if (widget.categories == null) {
      getCategories(page: _page);
    }else{
      _categoryData = widget.categories ?? [];
    }
  }

  getCategories({required int page}) async {
    if (!_isLoading && _hasMore) {
      setState(() {
        _isLoading = true;
      });
      await _homeCubit.getMainCategories(page: page);
    }
  }

  void _checkLastItemVisible() {
    if (_scrollController.hasClients && !_isLoading && _hasMore && widget.categories == null) {
      final maxScroll = _scrollController.position.maxScrollExtent;
      final currentScroll = _scrollController.position.pixels;
      const itemWidth = 78.0; // Each category item is 66 width + 12 margin
      final viewportWidth = MediaQuery.of(context).size.width;
      final totalItems = _categoryData.length;
      final lastItemStart = (totalItems - 1) * itemWidth;

      bool isLastVisible = currentScroll >= (lastItemStart - viewportWidth + itemWidth);

      if (isLastVisible && !_isLastItemVisible) {
        setState(() {
          _isLastItemVisible = true;
        });
        _page++;
        getCategories(page: _page);
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
    return SizedBox(
      height: 130,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              AppLocalizations.of(context)?.categories ?? 'Categories',
              style: FontStyles.getStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          SizedBox(height: 14),
          Expanded(
            child: BlocConsumer<HomeCubit, HomeState>(
              listener: (context, state) {
                if (state is MainCategoryFailed) {
                  print('Failed to load categories: ${state.error}');
                  setState(() {
                    _isLoading = false;
                  });
                } else if (state is MainCategorySuccess) {
                  setState(() {
                    _isLoading = false;
                    if (_page == 1) {
                      _categoryData = state.categoryData ?? [];
                    } else {
                      _categoryData.addAll(state.categoryData ?? []);
                    }
                    _hasMore = state.meta?.total != null &&
                        _categoryData.length < state.meta!.total!;
                  });
                }
              },
              builder: (context, state) {
                if (state is MainCategoryLoading && _page == 1) {
                  return Center(child: CircularProgressIndicator());
                }
                if (_categoryData.isEmpty && !_isLoading) {
                  return Center(
                    child: Text(
                      AppLocalizations.of(context)?.dataNotAvailable ?? 'No Categories Available',
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
                        for (var category in _categoryData)
                          InkWell(
                            onTap: () {
                              final args = {
                                'title': category.name,
                                'offerId': null,
                                'category': category.slug,
                                'vendorId': null,
                              };
                              NavigationService.navigateTo('/excitingOffer', arguments: args);
                            },
                            child: CategoryContainer(category: category),
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
          ),

        ],
      ),
    );
  }
}

class CategoryContainer extends StatelessWidget {
  final MainCategoryData category;

  const CategoryContainer({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: 12),
      color: Colors.transparent,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(33),
              child: SizedBox(
                width: 66,
                height: 66,
                child: Image.network(
                  category.imageUrl ?? dummyImageUrl,
                  width: 66,
                  height: 66,
                  fit: BoxFit.fill,
                  errorBuilder: (context, error, stackTrace) {
                    return Image.network(
                      dummyImageUrl,
                      width: 66,
                      height: 66,
                      fit: BoxFit.fill,
                    );
                  },
                ),
              ),
            ),
            SizedBox(height: 10),
            Text(
              category.name ?? '',
              style: FontStyles.getStyle(fontSize: 10, fontWeight: FontWeight.w700),
            ),
          ],
        ),
      ),
    );
  }
}