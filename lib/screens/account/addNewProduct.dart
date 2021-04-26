import 'dart:io';
import 'package:bidding_app/utils/size_config.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:bidding_app/models/user.dart';
import 'package:bidding_app/services/productDbService.dart';
import 'package:bidding_app/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

const _ktextFieldStyle = TextStyle(fontSize: 14);

class AddNewProduct extends StatefulWidget {
  @override
  _AddNewProductState createState() => _AddNewProductState();
}

class _AddNewProductState extends State<AddNewProduct> {
  var _formKey = GlobalKey<FormState>();

  final DateFormat dateFormatter = DateFormat.yMMMMd('en_US').add_jm();
  int currentImage = 0;
  DateTime? biddingTime;
  String? category;
  String? subcategory;
  String condition = "New";
  List<File> images = [];
  bool isUpForBidding = true;
  TextEditingController titleTextController = TextEditingController();
  TextEditingController descriptionTextController = TextEditingController();
  TextEditingController quickSellController = TextEditingController();
  TextEditingController minimumBidController = TextEditingController();

  List<String> conditionList = ["New", "Like New", "Good", "Fair", "Poor"];

  Map<String, List<String>> categoryList = {
    'Fashion': ["Shirts"],
    'Electronics': ["Mobiles"],
    'Collectibles': ["Stamps"],
    'Handbags': ["asd"],
    'Watches': ["asdasd"],
    'Others': []
  };

  @override
  void initState() {
    super.initState();
  }

  Future getimage() async {
    try {
      var img = await ImagePicker().getImage(source: ImageSource.gallery);
      File? image = await ImageCropper.cropImage(
        sourcePath: img!.path,
        aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
        compressQuality: 80,
        androidUiSettings: AndroidUiSettings(
          hideBottomControls: true,
          toolbarColor: Color(0xFFFFA53E),
          cropGridColor: Color(0xFFFFA53E),
          cropFrameColor: Color(0xFFFFA53E),
          toolbarWidgetColor: Colors.white,
          dimmedLayerColor: Colors.white,
        ),
      );
      if (image != null) {
        setState(() {
          images.add(File(image.path));
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("This image can not be used")));
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Something went wrong")));
    }
  }

  updateInfo() async {
    String uid = context.read<AppUser>().id!;
    try {
      await ProductDBServices(uid: uid).addNewProduct(
        title: titleTextController.text,
        description: descriptionTextController.text,
        category: category,
        subcategory: subcategory,
        condition: condition,
        quickSellPrice: double.parse(quickSellController.text),
        isUpForBidding: isUpForBidding,
        minimumBid: double.parse(minimumBidController.text),
        biddingTime: biddingTime,
        images: images,
        isActive: true,
      );
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("$e")));
    }
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add New Product"),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          child: ListView(
            children: <Widget>[
              images != []
                  ? Column(
                      children: [
                        CarouselSlider(
                          options: CarouselOptions(
                            height: MediaQuery.of(context).size.width,
                            onPageChanged: (index, reason) {
                              setState(() {
                                currentImage = index;
                              });
                            },
                            viewportFraction: 1,
                          ),
                          items: images.map((i) {
                            return Container(
                                child: Image.file(
                              i,
                              fit: BoxFit.cover,
                              width: MediaQuery.of(context).size.width,
                            ));
                          }).toList(),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                            images.length,
                            (index) => buildDot(index: index),
                          ),
                        ),
                      ],
                    )
                  : Container(
                      height: getProportionateScreenHeight(100),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.grey,
                      ),
                    ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text("Add Image"),
                  IconButton(
                    icon: Icon(Icons.add_a_photo_rounded),
                    onPressed: getimage,
                  ),
                ],
              ),
              EditDetail(
                child: TextFormField(
                  style: _ktextFieldStyle,
                  keyboardType: TextInputType.text,
                  controller: titleTextController,
                  validator: (String? value) {
                    if (value!.isEmpty) {
                      return 'Product Name cannot be empty';
                    }
                  },
                  decoration: _myInputDecoration(
                      hintText: 'Enter Product name', labelText: "Product (*)"),
                ),
              ),
              EditDetail(
                child: TextFormField(
                  style: _ktextFieldStyle,
                  keyboardType: TextInputType.text,
                  controller: descriptionTextController,
                  minLines: 2,
                  maxLines: 5,
                  validator: (String? value) {
                    if (value!.isEmpty) {
                      return 'Product Description cannot be empty';
                    }
                  },
                  decoration: _myInputDecoration(
                    hintText: 'Enter Product Description',
                    labelText: "Description (*)",
                  ),
                ),
              ),
              EditDetail(
                child: DropdownButton<String>(
                  hint: Text(
                    'Choose condition of Product (*)',
                    style: _ktextFieldStyle,
                  ),
                  isDense: false,
                  items: conditionList
                      .map((e) => DropdownMenuItem<String>(
                            child: Text(
                              '$e',
                              textScaleFactor: 0.9,
                            ),
                            value: '$e',
                          ))
                      .toList(),
                  value: condition,
                  onChanged: (v) {
                    setState(() {
                      condition = v!;
                    });
                  },
                ),
              ),
              EditDetail(
                child: DropdownButton<String>(
                  hint: Text(
                    'Choose a category (*)',
                    style: _ktextFieldStyle,
                  ),
                  isDense: false,
                  items: categoryList.keys
                      .map((e) => DropdownMenuItem<String>(
                            child: Text(
                              '$e',
                              textScaleFactor: 0.9,
                            ),
                            value: '$e',
                          ))
                      .toList(),
                  value: category,
                  onChanged: (v) {
                    setState(() {
                      category = v;
                    });
                  },
                ),
              ),
              category != null && category != "Others"
                  ? EditDetail(
                      child: DropdownButton<String>(
                        hint: Text(
                          'Choose a subcategory',
                          style: _ktextFieldStyle,
                        ),
                        isDense: false,
                        items: categoryList[category]!
                            .map((e) => DropdownMenuItem<String>(
                                  child: Text(
                                    '$e',
                                    textScaleFactor: 0.9,
                                  ),
                                  value: '$e',
                                ))
                            .toList(),
                        value: subcategory,
                        onChanged: (v) {
                          setState(() {
                            subcategory = v;
                          });
                        },
                      ),
                    )
                  : Container(),
              EditDetail(
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  controller: quickSellController,
                  validator: (String? value) {
                    if (value!.isEmpty) {
                      return 'Please enter a Quick Sell Price';
                    }
                  },
                  style: _ktextFieldStyle,
                  decoration: _myInputDecoration(
                    hintText: 'Enter Quicksell Price',
                    labelText: "Quick Sell Price (*)",
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Checkbox(
                      value: isUpForBidding,
                      onChanged: (value) {
                        setState(() {
                          isUpForBidding = value!;
                        });
                      }),
                  Text("Put this product up for bidding"),
                ],
              ),
              Visibility(
                visible: isUpForBidding,
                child: EditDetail(
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    controller: minimumBidController,
                    validator: (String? value) {
                      if (value!.isEmpty && isUpForBidding) {
                        return 'Minimum Bid cannot be empty';
                      }
                    },
                    style: _ktextFieldStyle,
                    decoration: _myInputDecoration(
                      hintText: 'Enter Minimum Bid',
                      labelText: "Minimum Bid",
                    ),
                  ),
                ),
              ),
              Visibility(
                visible: isUpForBidding,
                child: EditDetail(
                  child: GestureDetector(
                    onTap: () async {
                      DateTime temp = (await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime.now(),
                            lastDate: DateTime.now().add(Duration(days: 30)),
                          )) ??
                          DateTime.now();
                      TimeOfDay tempTime = (await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.now(),
                          )) ??
                          TimeOfDay.now();
                      temp = DateTime(temp.year, temp.month, temp.day,
                          tempTime.hour, tempTime.minute);
                      setState(() {
                        biddingTime = temp;
                      });
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${biddingTime != null ? dateFormatter.format(biddingTime!) : 'Enter Bidding Date!'}',
                          style: _ktextFieldStyle,
                        ),
                        Icon(Icons.arrow_drop_down),
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.all(20),
                child: TextButton(
                  style: ButtonStyle(
                    minimumSize: MaterialStateProperty.resolveWith(
                        (states) => Size.fromHeight(40)),
                    backgroundColor: MaterialStateColor.resolveWith(
                        (states) => kPrimaryColor),
                  ),
                  child: Text('Upload Product',
                      style: TextStyle(color: Colors.white)),
                  onPressed: () {
                    if (_formKey.currentState!.validate() &&
                        (isUpForBidding ? biddingTime != null : true) &&
                        category != null &&
                        condition != null) {
                      updateInfo();
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  AnimatedContainer buildDot({int? index}) {
    return AnimatedContainer(
      duration: kAnimationDuration,
      margin: EdgeInsets.only(right: 5),
      height: 6,
      width: currentImage == index ? 20 : 6,
      decoration: BoxDecoration(
        color: currentImage == index ? kPrimaryColor : Color(0xFFD8D8D8),
        borderRadius: BorderRadius.circular(3),
      ),
    );
  }
}

class EditDetail extends StatelessWidget {
  final Widget? child;
  EditDetail({this.child});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: ListTile(
        shape: RoundedRectangleBorder(),
        tileColor: Color(0xFFF2F7FB),
        contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Expanded(
              child: child!,
            ),
          ],
        ),
      ),
    );
  }
}

InputDecoration _myInputDecoration(
    {required String? hintText, required String? labelText}) {
  return InputDecoration(
    labelText: labelText,
    errorBorder: UnderlineInputBorder(),
    focusedErrorBorder: UnderlineInputBorder(),
    hintText: hintText,
    border: InputBorder.none,
  );
}
