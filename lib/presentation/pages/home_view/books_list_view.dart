import 'package:efapp/presentation/global_widgets/widgets.dart';
import 'package:efapp/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BooksListView extends StatelessWidget {
  final String title;
  final bool isLarge;
  const BooksListView(
      {super.key, this.title = "New Books", this.isLarge = true});

  @override
  Widget build(BuildContext context) {
    return SpacedColumn(
      verticalSpace: 16.h,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Row(
            children: [
              Text(title,
                  style: Theme.of(context)
                      .textTheme
                      .headlineSmall!
                      .copyWith(color: Colors.black)),
              const Spacer(),
              ElevatedButton(onPressed: () {}, child: const Text("See All"))
            ],
          ),
        ),
        _NewBooksListView(isLarge: isLarge),
      ],
    );
  }
}

class _NewBooksListView extends StatelessWidget {
  final bool isLarge;
  const _NewBooksListView({required this.isLarge});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200.h,
      child: ListView.separated(
          padding: EdgeInsets.only(left: 24.w),
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            return BookWidget(isLarge: isLarge);
          },
          separatorBuilder: (context, index) {
            return SizedBox(width: 16.w);
          },
          itemCount: 5),
    );
  }
}

class BookWidget extends StatelessWidget {
  final bool isLarge;
  const BookWidget({super.key, this.isLarge = true});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: isLarge ? 200.h : 138.h,
      width: isLarge ? 136.w : 91.w,
      child: GestureDetector(
        onTap: () {},
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.r),
            color: context.colorScheme.primary,
            // image: DecorationImage(
            //     image: AssetImage("assets/images/book.png"),
            //     onError: (exception, stackTrace) {},
            //     fit: BoxFit.cover)
          ),
        ),
      ),
    );
  }
}
