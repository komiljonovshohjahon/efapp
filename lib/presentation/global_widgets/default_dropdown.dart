import 'package:collection/collection.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:equatable/equatable.dart';
import 'package:efapp/utils/global_extensions.dart';
import 'package:flutter/material.dart';
import 'package:efapp/presentation/global_widgets/widgets.dart';
import 'package:efapp/utils/global_constants.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

//Dropdown features
// - label
// - width
// - height
// - value
// - onChanged  ss
// - items
// - has search box
// - has subtitle
// - close on select
class DefaultDropdown extends StatefulWidget {
  final List<DefaultMenuItem> items;
  final ValueChanged<DefaultMenuItem>? onChanged;
  final int? valueId;
  final String? valueAdditionalId;
  final double? width;
  final double? height;
  final String? label;
  final bool hasSearchBox;

  const DefaultDropdown(
      {super.key,
      required this.items,
      this.onChanged,
      this.valueId,
      this.valueAdditionalId,
      this.hasSearchBox = false,
      this.label,
      this.width,
      this.height});

  @override
  State<DefaultDropdown> createState() => _DefaultDropdownState();
}

class _DefaultDropdownState extends State<DefaultDropdown> {
  final TextEditingController searchController = TextEditingController();

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButton2<DefaultMenuItem>(
        value: widget.valueId != null
            ? widget.items.firstWhereOrNull(
                (element) => element.id == widget.valueId,
              )
            : widget.valueAdditionalId != null
                ? widget.items.firstWhereOrNull(
                    (element) =>
                        element.additionalId == widget.valueAdditionalId,
                  )
                : null,
        isExpanded: true,
        dropdownSearchData: widget.hasSearchBox
            ? DropdownSearchData(
                searchController: searchController,
                searchInnerWidgetHeight: 48.h,
                searchInnerWidget: Padding(
                  padding: EdgeInsets.only(top: 10.h, right: 8.w, left: 8.w),
                  child: DefaultTextField(
                      width: double.infinity,
                      label: "Search",
                      controller: searchController),
                ),
                searchMatchFn: (item, searchValue) {
                  bool found = false;
                  if (item.value?.title
                          .toLowerCase()
                          .contains(searchValue.toLowerCase()) ??
                      false) {
                    found = true;
                  } else {
                    if (item.value?.subtitle
                            ?.toLowerCase()
                            .contains(searchValue.toLowerCase()) ??
                        false) {
                      found = true;
                    }
                  }
                  return found;
                },
              )
            : null,
        dropdownStyleData: DropdownStyleData(
          offset: const Offset(0, -12),
          maxHeight: widget.hasSearchBox ? 300.h : null,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(
                  color: context.colorScheme.primary.withOpacity(.2))),
        ),
        buttonStyleData: ButtonStyleData(
          decoration: BoxDecoration(
            // color: widget.onChanged == null ? Colors.grey[200] : null,
            borderRadius: BorderRadius.circular(16.r),
            border:
                Border.all(color: context.colorScheme.primary.withOpacity(.5)),
          ),
          width: widget.width?.w,
          height: widget.height?.h,
        ),
        iconStyleData: IconStyleData(
          iconEnabledColor: Theme.of(context).colorScheme.primary,
        ),
        hint: widget.label != null
            ? Text(
                widget.label!,
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    color: context.colorScheme.primary.withOpacity(.44)),
              )
            : null,
        menuItemStyleData: MenuItemStyleData(
          selectedMenuItemBuilder: (context, child) {
            return DecoratedBox(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
              ),
              child: child,
            );
          },
        ),
        underline: const SizedBox(),
        selectedItemBuilder: (context) {
          return widget.items
              .map((e) => SizedBox(
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: RichText(
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          softWrap: true,
                          text: TextSpan(children: [
                            if (widget.label != null)
                              TextSpan(
                                  text: "${widget.label}\n",
                                  style: const TextStyle(color: Colors.grey)),
                            TextSpan(
                                text: e.title,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary
                                            .withOpacity(.8))),
                            if (e.subtitle != null)
                              TextSpan(
                                  text: " / ${e.subtitle}",
                                  style: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primary
                                          .withOpacity(.8))),
                          ])),
                    ),
                  ))
              .toList();
        },
        items: getItems(),
        onChanged: widget.onChanged == null
            ? null
            : (value) {
                if (value != null) {
                  widget.onChanged?.call(value);
                }
              });
  }

  List<DropdownMenuItem<DefaultMenuItem>> getItems() {
    return widget.items.map<DropdownMenuItem<DefaultMenuItem>>((e) {
      return DropdownMenuItem<DefaultMenuItem>(
        value: e,
        child: SpacedColumn(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "${GlobalConstants.enableDebugCodes ? "[${e.id}] - " : ""}${e.title}",
              softWrap: false,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: context.colorScheme.primary),
            ),
            if (e.subtitle != null)
              Text(e.subtitle!,
                  style: TextStyle(
                      fontSize: 14.sp, color: context.colorScheme.primary),
                  softWrap: false,
                  overflow: TextOverflow.ellipsis),
          ],
        ),
      );
    }).toList();
  }
}

final class DefaultMenuItem extends Equatable {
  final int id;
  final String? additionalId;
  final String title;
  final String? subtitle;

  const DefaultMenuItem(
      {required this.id,
      required this.title,
      this.subtitle,
      this.additionalId});

  @override
  List<Object?> get props => [id, title, subtitle, additionalId];
}
