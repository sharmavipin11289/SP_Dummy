import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:sanaa/Navigation/navigation_service.dart';
import 'package:sanaa/Screens/MyCartPage/Model/coupon_model.dart';
import '../../CommonFiles/text_style.dart';


class CouponPage extends StatefulWidget {
  Map<String, dynamic> args;
  CouponPage(this.args, {super.key});
  @override
  State<CouponPage> createState() => _CouponPageState();
}

class _CouponPageState extends State<CouponPage> {

  List<CouponData> coupons =  [];
  String selectedCoupon = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    coupons = widget.args['coupons'] as List<CouponData>;
    selectedCoupon = widget.args['selectedCode'];
    print(selectedCoupon);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          AppLocalizations.of(context)?.coupon ?? 'Coupons',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: coupons.length,
        itemBuilder: (context, index) {
          return CouponCard(
            title: coupons[index].name ?? '',
            offer: coupons[index].offerTill ?? '',
            code: coupons[index].code ?? '',
            selectedCoupon: selectedCoupon,
          );
        },
      ),
    );
  }
}

class CouponCard extends StatelessWidget {
  final String title;
  final String offer;
  final String code;
  final String selectedCoupon;

  const CouponCard({
    Key? key,
    required this.title,
    required this.offer,
    required this.code,
    required this.selectedCoupon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.green.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                    color: Colors.red.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(Icons.local_offer, color: Colors.red, size: 30),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: FontStyles.getStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Offer Till: $offer',
                        style: FontStyles.getStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Divider(),
            Row(children: [
              Text(
                code,
                style: FontStyles.getStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Spacer(),
              GestureDetector(
                onTap: (){
                  NavigationService.goBack(result: code);
                },
                child: Text(
                  ((code.toLowerCase() != selectedCoupon.toLowerCase()) ? AppLocalizations.of(context)?.apply : AppLocalizations.of(context)?.applied) ?? "Apply",
                  style: FontStyles.getStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Colors.green
                  ),
                ),
              )
            ],),
          ],
        ),
      ),
    );
  }
}
