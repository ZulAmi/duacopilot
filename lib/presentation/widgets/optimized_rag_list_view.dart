import 'dart:io';
import 'package:flutter/material.dart';
import '../../core/performance/arabic_scroll_physics.dart';
import '../../domain/entities/rag_response.dart';

/// Memory-efficient ListView builder optimized for large RAG response lists
class OptimizedRagListView extends StatefulWidget {
  const OptimizedRagListView({
    super.key,
    required this.responses,
    required this.itemBuilder,
    this.onRefresh,
    this.onLoadMore,
    this.isLoading = false,
    this.hasMore = true,
    this.loadingThreshold = 5,
    this.cacheExtent = 250.0,
    this.itemExtent,
    this.enableVirtualization = true,
    this.isRTL = false,
  });

  final List<RagResponse> responses;
  final Widget Function(BuildContext context, RagResponse response, int index)
      itemBuilder;
  final Future<void> Function()? onRefresh;
  final Future<void> Function()? onLoadMore;
  final bool isLoading;
  final bool hasMore;
  final int loadingThreshold;
  final double cacheExtent;
  final double? itemExtent;
  final bool enableVirtualization;
  final bool isRTL;

  @override
  State<OptimizedRagListView> createState() => _OptimizedRagListViewState();
}

/// _OptimizedRagListViewState class implementation
class _OptimizedRagListViewState extends State<OptimizedRagListView>
    with AutomaticKeepAliveClientMixin {
  late ScrollController _scrollController;
  final Set<int> _visibleItems = <int>{};
  bool _isLoadingMore = false;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _visibleItems.clear();
    super.dispose();
  }

  void _onScroll() {
    // Trigger load more when approaching the end
    if (!_isLoadingMore &&
        widget.hasMore &&
        widget.onLoadMore != null &&
        _scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200) {
      _loadMore();
    }

    // Update visible items for memory optimization
    _updateVisibleItems();
  }

  void _updateVisibleItems() {
    if (!widget.enableVirtualization) return;

    final viewport = _scrollController.position.viewportDimension;
    final offset = _scrollController.offset;
    final itemHeight = widget.itemExtent ?? 80.0;

    final startIndex = (offset / itemHeight).floor().clamp(
          0,
          widget.responses.length - 1,
        );
    final endIndex = ((offset + viewport) / itemHeight).ceil().clamp(
          0,
          widget.responses.length - 1,
        );

    // Update visible items set
    _visibleItems.clear();
    for (int i = startIndex; i <= endIndex; i++) {
      _visibleItems.add(i);
    }
  }

  Future<void> _loadMore() async {
    if (_isLoadingMore) return;

    setState(() {
      _isLoadingMore = true;
    });

    try {
      await widget.onLoadMore!();
    } finally {
      if (mounted) {
        setState(() {
          _isLoadingMore = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    if (widget.responses.isEmpty && !widget.isLoading) {
      return _buildEmptyState();
    }

    return ArabicScrollUtils.wrapWithArabicScrolling(
      isRTL: widget.isRTL,
      isLargeDataset: widget.responses.length > 100,
      child: RefreshIndicator(
        onRefresh: widget.onRefresh ?? () async {},
        child: _buildOptimizedListView(),
      ),
    );
  }

  Widget _buildOptimizedListView() {
    // Choose the most appropriate ListView based on platform and data size
    if (Platform.isIOS && widget.responses.length > 1000) {
      return _buildCupertinoOptimizedList();
    } else if (widget.enableVirtualization && widget.itemExtent != null) {
      return _buildFixedExtentList();
    } else {
      return _buildStandardList();
    }
  }

  Widget _buildStandardList() {
    return ListView.builder(
      controller: _scrollController,
      physics: ArabicScrollUtils.getOptimalPhysics(
        isRTL: widget.isRTL,
        isLargeDataset: widget.responses.length > 100,
        isArabicText: true,
      ),
      cacheExtent: widget.cacheExtent,
      itemCount: widget.responses.length + (widget.hasMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == widget.responses.length) {
          return _buildLoadingIndicator();
        }

        // Memory optimization: only build visible items when virtualization is enabled
        if (widget.enableVirtualization && !_visibleItems.contains(index)) {
          return SizedBox(
            height: widget.itemExtent ?? 80.0,
            child: const SizedBox.shrink(),
          );
        }

        return _buildOptimizedItem(context, widget.responses[index], index);
      },
    );
  }

  Widget _buildFixedExtentList() {
    return ListView.builder(
      controller: _scrollController,
      physics: ArabicScrollUtils.getOptimalPhysics(
        isRTL: widget.isRTL,
        isLargeDataset: widget.responses.length > 100,
        isArabicText: true,
      ),
      cacheExtent: widget.cacheExtent,
      itemExtent: widget.itemExtent,
      itemCount: widget.responses.length + (widget.hasMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == widget.responses.length) {
          return _buildLoadingIndicator();
        }

        return _buildOptimizedItem(context, widget.responses[index], index);
      },
    );
  }

  Widget _buildCupertinoOptimizedList() {
    // iOS-specific optimizations for very large lists
    return CustomScrollView(
      controller: _scrollController,
      physics: ArabicScrollUtils.getOptimalPhysics(
        isRTL: widget.isRTL,
        isLargeDataset: true,
        isArabicText: true,
      ),
      cacheExtent: widget.cacheExtent * 0.5, // Reduced cache for iOS
      slivers: [
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              if (index == widget.responses.length) {
                return _buildLoadingIndicator();
              }

              return _buildOptimizedItem(
                context,
                widget.responses[index],
                index,
              );
            },
            childCount: widget.responses.length + (widget.hasMore ? 1 : 0),
            addAutomaticKeepAlives:
                false, // Disable automatic keep alives for memory efficiency
            addRepaintBoundaries:
                true, // Enable repaint boundaries for performance
          ),
        ),
      ],
    );
  }

  Widget _buildOptimizedItem(
    BuildContext context,
    RagResponse response,
    int index,
  ) {
    // Wrap item in RepaintBoundary for better performance
    return RepaintBoundary(
      key: ValueKey('rag_${response.id}'),
      child: _OptimizedRagItem(
        response: response,
        index: index,
        builder: widget.itemBuilder,
        isRTL: widget.isRTL,
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    if (!widget.hasMore) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      alignment: Alignment.center,
      child: widget.isLoading || _isLoadingMore
          ? _buildPlatformLoadingIndicator()
          : const SizedBox.shrink(),
    );
  }

  Widget _buildPlatformLoadingIndicator() {
    if (Platform.isIOS) {
      return const SizedBox(
        height: 20,
        width: 20,
        child: CircularProgressIndicator.adaptive(),
      );
    } else {
      return const CircularProgressIndicator();
    }
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 64,
            color: Theme.of(context).disabledColor,
          ),
          const SizedBox(height: 16),
          Text(
            'No responses available',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Theme.of(context).disabledColor,
                ),
          ),
        ],
      ),
    );
  }
}

/// Optimized individual RAG item widget
class _OptimizedRagItem extends StatefulWidget {
  const _OptimizedRagItem({
    required this.response,
    required this.index,
    required this.builder,
    required this.isRTL,
  });

  final RagResponse response;
  final int index;
  final Widget Function(BuildContext context, RagResponse response, int index)
      builder;
  final bool isRTL;

  @override
  State<_OptimizedRagItem> createState() => _OptimizedRagItemState();
}

/// _OptimizedRagItemState class implementation
class _OptimizedRagItemState extends State<_OptimizedRagItem>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive =>
      false; // Don't keep alive by default for memory efficiency

  @override
  Widget build(BuildContext context) {
    super.build(context);

    // Platform-specific optimizations
    return AnimatedBuilder(
      animation: Listenable.merge([]), // Empty animation for optimization
      builder: (context, child) {
        return Directionality(
          textDirection: widget.isRTL ? TextDirection.rtl : TextDirection.ltr,
          child: widget.builder(context, widget.response, widget.index),
        );
      },
    );
  }
}

/// Grid view for RAG responses when appropriate
class OptimizedRagGridView extends StatelessWidget {
  const OptimizedRagGridView({
    super.key,
    required this.responses,
    required this.itemBuilder,
    this.crossAxisCount = 2,
    this.childAspectRatio = 1.0,
    this.mainAxisSpacing = 8.0,
    this.crossAxisSpacing = 8.0,
    this.padding,
    this.isRTL = false,
  });

  final List<RagResponse> responses;
  final Widget Function(BuildContext context, RagResponse response, int index)
      itemBuilder;
  final int crossAxisCount;
  final double childAspectRatio;
  final double mainAxisSpacing;
  final double crossAxisSpacing;
  final EdgeInsetsGeometry? padding;
  final bool isRTL;

  @override
  Widget build(BuildContext context) {
    return ArabicScrollUtils.wrapWithArabicScrolling(
      isRTL: isRTL,
      isLargeDataset: responses.length > 100,
      child: GridView.builder(
        physics: ArabicScrollUtils.getOptimalPhysics(
          isRTL: isRTL,
          isLargeDataset: responses.length > 100,
          isArabicText: true,
        ),
        padding: padding,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          childAspectRatio: childAspectRatio,
          mainAxisSpacing: mainAxisSpacing,
          crossAxisSpacing: crossAxisSpacing,
        ),
        itemCount: responses.length,
        itemBuilder: (context, index) {
          return RepaintBoundary(
            key: ValueKey('rag_grid_${responses[index].id}'),
            child: Directionality(
              textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
              child: itemBuilder(context, responses[index], index),
            ),
          );
        },
      ),
    );
  }
}

/// Sliver list for more complex scroll views
class OptimizedRagSliverList extends StatelessWidget {
  const OptimizedRagSliverList({
    super.key,
    required this.responses,
    required this.itemBuilder,
    this.itemExtent,
    this.isRTL = false,
  });

  final List<RagResponse> responses;
  final Widget Function(BuildContext context, RagResponse response, int index)
      itemBuilder;
  final double? itemExtent;
  final bool isRTL;

  @override
  Widget build(BuildContext context) {
    if (itemExtent != null) {
      return SliverFixedExtentList(
        itemExtent: itemExtent!,
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            return RepaintBoundary(
              key: ValueKey('rag_sliver_${responses[index].id}'),
              child: Directionality(
                textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
                child: itemBuilder(context, responses[index], index),
              ),
            );
          },
          childCount: responses.length,
          addAutomaticKeepAlives: false,
          addRepaintBoundaries: false, // We're adding them manually
        ),
      );
    }

    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          return RepaintBoundary(
            key: ValueKey('rag_sliver_${responses[index].id}'),
            child: Directionality(
              textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
              child: itemBuilder(context, responses[index], index),
            ),
          );
        },
        childCount: responses.length,
        addAutomaticKeepAlives: false,
        addRepaintBoundaries: false, // We're adding them manually
      ),
    );
  }
}

/// Utility functions for list optimization
class RagListOptimization {
  /// Calculate optimal cache extent based on device and data size
  static double calculateOptimalCacheExtent({
    required int itemCount,
    required double itemHeight,
    required double screenHeight,
  }) {
    if (Platform.isIOS) {
      // iOS can handle larger cache extents
      return (screenHeight * 2).clamp(250.0, 1000.0);
    } else if (Platform.isAndroid) {
      // Android needs more conservative cache extents
      return (screenHeight * 1.5).clamp(200.0, 800.0);
    } else {
      // Web/Desktop default
      return screenHeight.clamp(250.0, 600.0);
    }
  }

  /// Determine if fixed extent should be used
  static bool shouldUseFixedExtent({
    required int itemCount,
    required bool hasUniformHeight,
  }) {
    return hasUniformHeight && itemCount > 50;
  }

  /// Get optimal cross axis count for grid views
  static int getOptimalCrossAxisCount(double screenWidth) {
    if (screenWidth > 1200) return 4; // Large screens
    if (screenWidth > 800) return 3; // Tablets
    if (screenWidth > 600) return 2; // Large phones
    return 1; // Small phones
  }
}
