
import 'package:common/network/exception/ApiException.dart';
import 'package:common/network/model/QuestionarieCategory.dart';
import 'package:common/network/model/QuestionarieResponse.dart';
import 'package:common/network/model/SubCategories.dart';
import 'package:common/network/model/error_response.dart';
import 'package:common/network/repository/HomeRepository.dart';
import 'package:common/network/request/Data.dart';
import 'package:common/network/request/Postquestionarieapi.dart';
import 'package:common/network/response/SuccessResponse.dart';
import 'package:common/utils/CPSessionManager.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:socialcarpooling/font&margin/font_size.dart';
import 'package:socialcarpooling/util/TextStylesUtil.dart';
import 'package:socialcarpooling/font&margin/margin_confiq.dart';
import 'package:socialcarpooling/view/home/home_page.dart';
import 'package:socialcarpooling/widgets/aleart_widgets.dart';
import 'package:socialcarpooling/widgets/circular_progress_loader.dart';

import '../../util/CPString.dart';
import '../../util/color.dart';


class QuestionariePage extends StatefulWidget {
  const QuestionariePage({Key? key}) : super(key: key);

  @override
  State<QuestionariePage> createState() => _QuestionarieState();
}

class _QuestionarieState extends State<QuestionariePage>
    with TickerProviderStateMixin {
  late TabController tabController;
  TextStyle tabStyle = TextStyleUtils.primaryTextBold.copyWith(fontSize: textsize16sp);
  List<Questionarie> categories = [];
  bool isDataLoading = true;

  @override
  void initState() {
    super.initState();
    tabController =
        TabController(length: categories.length, initialIndex: 0, vsync: this);
    fetchCategories();
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  void fetchCategories() async {
    HomeRepository()
        .getQuestionarieData()
        .then((value) => handleQuestionResponseData(value))
        .catchError((onError) {
      handleErrorResponseData(onError);
    });
  }

  void _onCategoriesUpdated(dynamic val) {
    setState(() {
      categories = val;
      for (var element in categories) {
        element.subcategory?.forEach((subCategory) {
          CPSessionManager().saveSelectedCategoryIds(subCategory.questionnarieId!, subCategory.id!, subCategory.enabled??false);
        });
      }
      tabController.dispose();
      tabController = TabController(
          length: categories.length, initialIndex: 0, vsync: this);
    });
  }

  tabCreate() => CustomScrollView(
        slivers: <Widget>[
          SliverFillRemaining(
            child: Column(children: [
              Expanded(
                child: Scaffold(
                  backgroundColor: Colors.white,
                  appBar: AppBar(
                    backgroundColor: lightGreyColor,
                    elevation: 0,
                    toolbarHeight: 0,
                    bottom: TabBar(
                    unselectedLabelColor: tabUnSelectedTextColor,
                    labelColor: tabSelectedTextColor,
                    indicatorColor: primaryColor,
                    indicatorSize: TabBarIndicatorSize.tab,
                    indicator: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: primaryColor),
                    labelStyle:
                        TextStyleUtils.primaryTextBold.copyWith(fontSize: textsize12sp),
                    unselectedLabelStyle: TextStyleUtils.primaryTextRegular
                        .copyWith(fontSize: textsize12sp),
                    controller: tabController,
                    isScrollable: true,
                    tabs: List<Widget>.generate(categories.length, (int index) {
                      return Tab(child: Text(categories[index].category!));
                    }),
                  ),
                  ),
                  body: TabBarView(
                      controller: tabController,
                      children: getSubCategories(categories)),
                ),
              ),
              Container(
                alignment: Alignment.bottomRight,
                color: Colors.white,
                padding: const EdgeInsets.only(top: 10, right: 24, bottom: 34),
                child: ElevatedButton(
                  onPressed: handleOnContinueButtonPressed,
                  style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      padding: EdgeInsets.all(margin10),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(margin10))),
                  child: Text(CPString.CONTINUE,
                      style:
                          tabStyle.copyWith(fontSize: textsize16sp, color: Colors.white)),
                ),
              ),
            ]),
          ),
        ],
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: const Text(CPString.QUESTIONARIES)),
        body: getQuestionarieWidgets());
  }

  Widget getQuestionarieWidgets() {
    if (isDataLoading) {
      return getLoadingWidget();
    } else {
      return tabCreate();
    }
  }

  getSubCategories(List<Questionarie> categories) {
    List<Widget> widgets = [];
    for (var element in categories) {
      List<SubCategories>? subcategories = element.subcategory;
      var wrap = Container(
          padding: const EdgeInsets.all(20),
          child: Wrap(
            alignment: WrapAlignment.start,
            spacing: 8.0,
            runSpacing: 8.0,
            children: List<Widget>.generate(
                subcategories!.length,
                (subIndex) => QuestionariChipSet(
                      subcategories: subcategories[subIndex],
                    )),
          ));
      widgets.add(wrap);
    }
    return widgets;
  }

  void handleOnContinueButtonPressed() {
    if(CPSessionManager().categoryIds.isEmpty){
      const snackBar = SnackBar(
        content: Text(CPString.ALERT_SELECT_ATLEAST_ONE_CATEGORY),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else {
      showLoaderDialog(context);
      postQuetionarieData();
    }
  }

  void navigateToHomeScreen(){
    Navigator.pushReplacement(
        context,
        PageTransition(
            type: PageTransitionType.bottomToTop,
            child: HomePage(homeRepository: HomeRepository())));
  }

  void postQuetionarieData() async {
    final postData = CPSessionManager().postQuestionarieData;
    var data = <QuestionariePostData>[];
    postData.forEach((key, value) {
      data.add(QuestionariePostData(id: key, subCategories: value.toList()));
    });
    Postquestionarieapi api = Postquestionarieapi(data: data);
    HomeRepository()
        .postQuestionarieData(api)
        .then((value) => handleQuestionResponseData(value))
        .catchError((onError) {
      handleErrorResponseData(onError);
    });
  }

  void handleQuestionResponseData(value) {
    isDataLoading = false;
    if(value is QuestionarieResponse){
    _onCategoriesUpdated(value.questionarie);
    } else if (value is ErrorResponse) {
      showSnackbar(context, value.error?[0].message ?? value.message ?? "");
    } else if(value is SuccessResponse){
      showSnackbar(context, value.message ?? CPString.UPDATED_SUCCESS);
      CPSessionManager().clearAllSelectedCategoryData();
      Future.delayed(
        const Duration(seconds: 1),
            () {
              navigateToHomeScreen();
            } ,
      );
    }
  }

  void handleErrorResponseData(onError) {
    if (onError is ApiException) {
      showSnackbar(context, onError.errorResponse.message ?? "");
    }
  }
}

class QuestionariChipSet extends StatefulWidget {
  final SubCategories subcategories;

  const QuestionariChipSet({Key? key, required this.subcategories})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => QuestionariChipSetState();
}

class QuestionariChipSetState extends State<QuestionariChipSet> {

  QuestionariChipSetState();

  chipNameText(String name, String id) => Text(
        name,
        style: TextStyleUtils.primaryTextRegular.copyWith(
            fontSize: textsize14sp,
            color: CPSessionManager().isCategoryItemsSelected(id)
                ? tabSelectedTextColor
                : tabUnSelectedTextColor),
      );

  @override
  Widget build(BuildContext context) {
    return InputChip(
      label: chipNameText(widget.subcategories.name!, widget.subcategories.id!),
      selectedColor: chipSetBGSelectedColor,
      disabledColor: chipSetBGUnSelectedColor,
      showCheckmark: false,
      selected: CPSessionManager().isCategoryItemsSelected(widget.subcategories.id!),
      onSelected: (bool value) {
        setState(() {
          CPSessionManager().saveSelectedCategoryIds(widget.subcategories.questionnarieId!, widget.subcategories.id!, value);
        });
      },
    );
  }
}
