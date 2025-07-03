import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:sanaa/CommonFiles/common_function.dart';
import 'package:sanaa/Navigation/navigation_service.dart';
import 'package:sanaa/Screens/FilterPage/Model/category_tree_model.dart';
import 'package:sanaa/Screens/FilterPage/cubit/filter_cubit.dart';
import 'package:sanaa/Screens/FilterPage/cubit/filter_state.dart';
import 'package:sanaa/Screens/HomePage/Model/offers_model.dart';
import 'package:sanaa/Screens/HomePage/Model/shop_model.dart';
import '../../CommonFiles/text_style.dart';
import '../../SharedPrefrence/shared_prefrence.dart';

class FilterScreen extends StatefulWidget {
  bool isFromCategory;

  FilterScreen({Key? key, required this.isFromCategory}) : super(key: key);

  @override
  State<FilterScreen> createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  String? expandedCategory;
  TreeSubcategories? selectedSubCategory;
  bool isViewingSubCategoryItems = false;

  int _selectedOption = 0;
  double _minPrice = 0;
  double _maxPrice = 99999;
  double _currentMinPrice = 0;
  double _currentMaxPrice = 99999;

  TextEditingController minPriceTextEditingController = TextEditingController();
  TextEditingController maxPriceTextEditingController = TextEditingController();

  List<ShopData> selectedVendors = [];
  OfferData? selectedOffer;
  List<ProductCategories> selectedSubCategoryItems = [];

  List<CategooryTreeData> categoriesData = [];
  late FilterCubit _cubit;

  List<String> options = [];

  List<ShopData> vendors = [];
  List<OfferData> offers = [];
  late Debouncer _debouncer;

  @override
  void initState() {
    super.initState();
    _debouncer = Debouncer(duration: Duration(seconds: 2));
    _cubit = BlocProvider.of<FilterCubit>(context);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final locale = AppLocalizations.of(context);
      setState(() {
        options = [
          locale?.categories ?? 'Categories',
          locale?.priceRange ?? 'Price Range',
          locale?.ourVendor ?? 'Our Vendors',
          locale?.excitingOffer ?? 'Exciting Offer',
        ];
        if (widget.isFromCategory) {
          _selectedOption = 1;
          expandedCategory = locale?.priceRange ?? 'Price Range';
        }
      });
      _getCategoories();
      _getVendors();
      _getExcitingOffer();
    });
  }

  _getCategoories() async {
    await _cubit.getCategoryTree();
  }

  _getVendors() async {
    await _cubit.getVendors();
  }

  _getExcitingOffer() async {
    await _cubit.getOffers();
  }

  Map<String, dynamic> _convertFilterToParam() {
    Map<String, dynamic> param = {};
    for (int i = 0; i < selectedSubCategoryItems.length; i++) {
      param['category_ids[$i]'] = selectedSubCategoryItems[i].id ?? '';
    }
    for (int i = 0; i < selectedVendors.length; i++) {
      param['vendor_ids[$i]'] = selectedVendors[i].id ?? '';
    }
    if (minPriceTextEditingController.text.isNotEmpty) {
      param['min_price'] = minPriceTextEditingController.text;
    }
    if (maxPriceTextEditingController.text.isNotEmpty) {
      param['max_price'] = maxPriceTextEditingController.text;
    }

    if (selectedOffer != null) {
      param['exciting_offer_id'] = selectedOffer?.id ?? '';
      param['view'] = 'exciting-offers';
    }
    print(param);
    return param;
  }

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          locale?.filterBy ?? 'Filter by',
          style: FontStyles.getStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                expandedCategory = null;
                selectedSubCategory = null;
                selectedSubCategoryItems.clear();
                isViewingSubCategoryItems = false;
                _minPrice = 0;
                _maxPrice = 99999;
                _currentMinPrice = 0;
                _currentMaxPrice = 99999;
                selectedOffer = null;
                selectedVendors.clear();
                minPriceTextEditingController.text = '';
                maxPriceTextEditingController.text = '';
                _selectedOption = 0;
                if (widget.isFromCategory) {
                  _selectedOption = 1;
                  expandedCategory = locale?.priceRange ?? 'Price Range';
                }
              });
            },
            child: Text(
              locale?.reset ?? 'Reset',
              style: FontStyles.getStyle(fontSize: 14, fontWeight: FontWeight.w400, color: Colors.red),
            ),
          ),
        ],
      ),
      body: BlocConsumer<FilterCubit, FilterState>(builder: (context, state) {
        return Row(
          children: [
            Expanded(
              flex: 1,
              child: Container(
                color: Colors.grey.shade100,
                child: ListView(
                  children: [
                    for (var i = (widget.isFromCategory) ? 1 : 0; i < options.length; i++)
                      Container(
                        color: (_selectedOption == i ? Colors.white : Colors.transparent),
                        child: _buildFilterOption(options[i], i),
                      ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: _buildRightPanel(locale),
            ),
          ],
        );
      }, listener: (context, state) {
        if (state is CategoryTreeLoading) {
        } else if (state is CategoryTreeFailed) {
        } else if (state is CategoryTreeSuccess) {
          categoriesData = state.categoryData;
        } else if (state is ShopsSuccess) {
          vendors = state.shopsData;
        } else if (state is OffersSuccess) {
          offers = state.offerData;
        }
      }),
      bottomNavigationBar: BottomAppBar(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
          child: Row(
            children: [
              Expanded(
                child: TextButton(
                  onPressed: () => Navigator.pop(context),
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.white,
                  ),
                  child: Text(
                    locale?.close ?? 'Close',
                    style: FontStyles.getStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    final param = _convertFilterToParam();
                    print(param);
                    NavigationService.goBack(result: param);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                  ),
                  child: Text(
                    '${locale?.apply ?? 'Apply'} (${_getSelectionCount()})',
                    style: FontStyles.getStyle(fontSize: 16, fontWeight: FontWeight.w400, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilterOption(String label, int i) {
    final locale = AppLocalizations.of(context);
    return ListTile(
      title: Text(label),
      onTap: () {
        _selectedOption = i;
        setState(() {
          if (label == (locale?.categories ?? 'Categories')) {
            expandedCategory = null;
            selectedSubCategory = null;
            isViewingSubCategoryItems = false;
          } else if (label == (locale?.priceRange ?? 'Price Range')) {
            expandedCategory = locale?.priceRange ?? 'Price Range';
          } else if (label == (locale?.ourVendor ?? 'Our Vendors')) {
            expandedCategory = locale?.ourVendor ?? 'Our Vendors';
          } else if (label == (locale?.excitingOffer ?? 'Exciting Offer')) {
            expandedCategory = locale?.excitingOffer ?? 'Exciting Offer';
          }
        });
      },
    );
  }

  Widget _buildRightPanel(AppLocalizations? locale) {
    if (expandedCategory == (locale?.priceRange ?? 'Price Range')) {
      return _buildPriceRangePanel(locale);
    } else if (expandedCategory == (locale?.ourVendor ?? 'Our Vendors')) {
      return _buildVendorsPanel(locale);
    } else if (expandedCategory == (locale?.excitingOffer ?? 'Exciting Offer')) {
      return _buildOfferPanel(locale);
    }

    if (isViewingSubCategoryItems && selectedSubCategory != null) {
      return Column(
        children: [
          _buildHeader(
            title: selectedSubCategory?.name ?? '',
            onBackPressed: () {
              setState(() {
                isViewingSubCategoryItems = false;
                selectedSubCategory = null;
              });
            },
          ),
          Expanded(
            child: ListView(
              children: (selectedSubCategory?.productCategories ?? [])
                  .map((item) => CheckboxListTile(
                activeColor: Colors.green,
                title: Text(item.name ?? ''),
                value: selectedSubCategoryItems.contains(item),
                onChanged: (bool? selected) {
                  setState(() {
                    if (selected == true) {
                      selectedSubCategoryItems.add(item);
                    } else {
                      selectedSubCategoryItems.remove(item);
                    }
                  });
                },
              ))
                  .toList(),
            ),
          ),
        ],
      );
    }

    return ListView(
      children: categoriesData.map((category) {
        final bool isExpanded = expandedCategory == category.name;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              title: Text(category.name!),
              trailing: category.subcategories != null
                  ? Icon(
                isExpanded ? Icons.expand_less : Icons.expand_more,
                size: 20,
              )
                  : null,
              onTap: () {
                setState(() {
                  expandedCategory = isExpanded ? null : category.name;
                });
              },
            ),
            if (isExpanded && category.subcategories != null)
              Padding(
                padding: const EdgeInsets.only(left: 16),
                child: Column(
                  children: category.subcategories!
                      .map(
                        (subCategory) => RadioListTile<TreeSubcategories>(
                      activeColor: Colors.green,
                      title: Text(subCategory.name!),
                      value: subCategory,
                      groupValue: selectedSubCategory,
                      onChanged: (value) {
                        setState(() {
                          selectedSubCategory = value;
                          isViewingSubCategoryItems = true;
                        });
                      },
                    ),
                  )
                      .toList(),
                ),
              ),
          ],
        );
      }).toList() ??
          [],
    );
  }

  Widget _buildPriceRangePanel(AppLocalizations? locale) {
    return Column(
      children: [
        _buildHeader(
          title: locale?.priceRange ?? 'Price Range',
          onBackPressed: () {
            setState(() {
              expandedCategory = null;
            });
          },
        ),
        SizedBox(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              SizedBox(
                width: 120,
                child: buildTextField(locale?.minPrice ?? 'Min Price', minPriceTextEditingController, onChange: (value) {
                  if (value.isNotEmpty) {
                    final minValue = double.tryParse(value) ?? 0.0;
                    if (minValue > 99999) {
                      setState(() {
                        minPriceTextEditingController.text = '$_currentMinPrice';
                      });
                    } else {
                      _currentMinPrice = minValue;
                    }
                  }
                }),
              ),
              SizedBox(
                width: 120,
                child: buildTextField(
                  locale?.maxPrice ?? 'Max Price',
                  maxPriceTextEditingController,
                  onChange: (value) {
                    if (value.isNotEmpty) {
                      _debouncer.run(() {
                        final maxValue = double.tryParse(value) ?? 0.0;
                        setState(() {
                          if (maxValue > 99999) {
                            maxPriceTextEditingController.text = '$_currentMaxPrice';
                            maxPriceTextEditingController.selection = TextSelection.fromPosition(
                              TextPosition(offset: maxPriceTextEditingController.text.length),
                            );
                          } else if (maxValue < _currentMinPrice) {
                            setState(() {
                              _currentMaxPrice = _currentMinPrice;
                              maxPriceTextEditingController.text = '$_currentMinPrice';
                              maxPriceTextEditingController.selection = TextSelection.fromPosition(
                                TextPosition(offset: maxPriceTextEditingController.text.length),
                              );
                            });
                          } else {
                            _currentMaxPrice = maxValue;
                          }
                        });
                      });
                    }
                  },
                ),
              ),
            ],
          ),
        ),
        RangeSlider(
          activeColor: Colors.green,
          values: RangeValues(_currentMinPrice, _currentMaxPrice),
          min: _minPrice,
          max: _maxPrice,
          divisions: 20,
          labels: RangeLabels(
            '${SharedPreferencesHelper.getString('savedCurrency') ?? 'KES'} ${_currentMinPrice.toStringAsFixed(0)}',
            '${SharedPreferencesHelper.getString('savedCurrency') ?? 'KES'} ${_currentMaxPrice.toStringAsFixed(0)}',
          ),
          onChanged: (RangeValues values) {
            setState(() {
              _currentMinPrice = values.start;
              _currentMaxPrice = values.end;
              minPriceTextEditingController.text = _currentMinPrice.toString();
              maxPriceTextEditingController.text = _currentMaxPrice.toString();
            });
          },
        ),
        Text(
          '${locale?.price ?? 'Price'} ${SharedPreferencesHelper.getString('savedCurrency') ?? 'KES'} ${_currentMinPrice.toStringAsFixed(0)} - ${SharedPreferencesHelper.getString('savedCurrency') ?? 'KES'} ${_currentMaxPrice.toStringAsFixed(0)}',
        ),
      ],
    );
  }

  Widget _buildVendorsPanel(AppLocalizations? locale) {
    return Column(
      children: [
        _buildHeader(
          title: locale?.ourVendor ?? 'Our Vendors',
          onBackPressed: () {
            setState(() {
              expandedCategory = null;
            });
          },
        ),
        Column(
          children: vendors
              .map((vendor) => CheckboxListTile(
            activeColor: Colors.green,
            value: selectedVendors.contains(vendor),
            title: Text(
              vendor.businessName ?? '',
              overflow: TextOverflow.ellipsis,
            ),
            onChanged: (value) {
              setState(() {
                print(vendor.id);
                print(vendor.name);
                if (value == true) {
                  selectedVendors.add(vendor);
                } else {
                  selectedVendors.remove(vendor);
                }
              });
            },
          ))
              .toList(),
        ),
      ],
    );
  }

  Widget _buildOfferPanel(AppLocalizations? locale) {
    return Column(
      children: [
        _buildHeader(
          title: locale?.excitingOffer ?? 'Exciting Offer',
          onBackPressed: () {
            setState(() {
              expandedCategory = null;
            });
          },
        ),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: offers
                  .map(
                    (offer) => RadioListTile<OfferData>(
                  activeColor: Colors.green,
                  title: Text(offer.title ?? ''),
                  value: offer,
                  groupValue: selectedOffer,
                  onChanged: (value) {
                    setState(() {
                      selectedOffer = value;
                    });
                  },
                ),
              )
                  .toList(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeader({required String title, VoidCallback? onBackPressed}) {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.grey[200],
      child: Row(
        children: [
          if (onBackPressed != null)
            IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: onBackPressed,
            ),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  int _getSelectionCount() {
    int total = 0;
    if (maxPriceTextEditingController.text.isNotEmpty || minPriceTextEditingController.text.isNotEmpty) {
      total += 1;
    }
    if (selectedOffer != null) {
      total += 1;
    }
    total += selectedSubCategoryItems.length + selectedVendors.length;
    return total;
  }
}

class Debouncer {
  final Duration duration;
  Timer? _timer;

  Debouncer({required this.duration});

  void run(void Function() action) {
    _timer?.cancel();
    _timer = Timer(duration, action);
  }

  void cancel() {
    _timer?.cancel();
  }
}