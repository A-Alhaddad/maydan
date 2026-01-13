import 'package:flutter/rendering.dart';
import 'package:maydan/widgets/my_library.dart';

class SportsTabs extends StatefulWidget {
  final List<Map<String, dynamic>> items;
  final int selectedIndex;
  final bool isLoading;
  final ValueChanged<int> onTap;

  const SportsTabs({
    super.key,
    required this.items,
    required this.selectedIndex,
    this.isLoading = false,
    required this.onTap,
  });

  @override
  State<SportsTabs> createState() => _SportsTabsState();
}

class _SportsTabsState extends State<SportsTabs> {
  final Map<int, GlobalKey> _itemKeys = {};
  final GlobalKey _listKey = GlobalKey();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToSelected());
  }

  @override
  void didUpdateWidget(covariant SportsTabs oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedIndex != oldWidget.selectedIndex) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollToSelected();
      });
    }
  }

  void _scrollToSelected() {
    if (!_scrollController.hasClients) return;
    final key = _itemKeys[widget.selectedIndex];
    if (key == null) return;
    final itemContext = key.currentContext;
    if (itemContext == null) return;

    final renderObject = itemContext.findRenderObject();
    if (renderObject == null) return;
    final viewport = RenderAbstractViewport.of(renderObject);
    if (viewport == null) return;

    final target = viewport.getOffsetToReveal(renderObject, 0.5).offset;
    final clampedOffset = target.clamp(
      _scrollController.position.minScrollExtent,
      _scrollController.position.maxScrollExtent,
    );

    _scrollController.animateTo(
      clampedOffset,
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56.h,
      width: double.infinity,
      child: ListView.separated(
        key: _listKey,
        controller: _scrollController,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        scrollDirection: Axis.horizontal,
        itemCount: widget.items.length,
        separatorBuilder: (_, __) => SizedBox(width: 12.w),
        itemBuilder: (context, index) {
          final item = widget.items[index];
          final bool selected = widget.selectedIndex == index;
          final title = (item["name"] ?? item["key"] ?? "").toString();
          final imageName = (item["image"] ?? "").toString();
          final imageUrl = (item["imageUrl"] ?? "").toString();
          _itemKeys.putIfAbsent(index, () => GlobalKey());

          return KeyedSubtree(
            key: _itemKeys[index],
            child: GestureDetector(
              onTap: () => widget.onTap(index),
              child: ConstrainedBox(
                constraints: BoxConstraints(minWidth: 90.w),
                child: Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
                  decoration: BoxDecoration(
                    color: selected
                        ? AppColors.green
                        : Colors.white.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(25.r),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CustomText(
                        item["key"] != null
                            ? item["key"]!.toString().tr
                            : title,
                        fontSize: 16.sp,
                        color: selected ? Colors.black : Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                      SizedBox(width: 10.w),
                      if (selected && widget.isLoading)
                        SizedBox(
                          width: 22.w,
                          height: 22.w,
                          child: const CircularProgressIndicator(
                            strokeWidth: 2.5,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.black),
                          ),
                        )
                      else if (imageUrl.isNotEmpty)
                        SizedBox(
                          width: 30.w,
                          height: 30.w,
                          child: Center(
                            child: CustomPngImageNetwork(
                              imageUrl: imageUrl,
                              width: 30.w,
                              height: 30.w,
                              boxFit: BoxFit.contain,
                            ),
                          ),
                        )
                      else if (imageName.isNotEmpty)
                        SizedBox(
                          width: 30.w,
                          height: 30.w,
                          child: Center(
                            child: CustomPngImage(
                              imageName: imageName,
                              width: 30.w,
                              height: 30.w,
                              boxFit: BoxFit.contain,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
