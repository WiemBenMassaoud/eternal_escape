import 'package:flutter/material.dart';
import '../utils/theme.dart';

enum LoadingType { circular, dots, shimmer, skeleton }

class LoadingWidget extends StatelessWidget {
  final LoadingType type;
  final String? message;
  final double size;
  final Color? color;

  const LoadingWidget({
    Key? key,
    this.type = LoadingType.circular,
    this.message,
    this.size = 40,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildLoader(),
          if (message != null) ...[
            SizedBox(height: AppTheme.marginXL),
            Text(
              message!,
              style: AppTheme.textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildLoader() {
    switch (type) {
      case LoadingType.circular:
        return SizedBox(
          width: size,
          height: size,
          child: CircularProgressIndicator(
            strokeWidth: 3,
            valueColor: AlwaysStoppedAnimation<Color>(
              color ?? AppTheme.primary,
            ),
          ),
        );
      case LoadingType.dots:
        return DotsLoadingIndicator(size: size, color: color);
      case LoadingType.shimmer:
        return ShimmerLoading(width: size * 3, height: size);
      case LoadingType.skeleton:
        return SkeletonLoader();
    }
  }
}

class DotsLoadingIndicator extends StatefulWidget {
  final double size;
  final Color? color;

  const DotsLoadingIndicator({Key? key, required this.size, this.color})
      : super(key: key);

  @override
  State<DotsLoadingIndicator> createState() => _DotsLoadingIndicatorState();
}

class _DotsLoadingIndicatorState extends State<DotsLoadingIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1200),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size * 3,
      height: widget.size / 2,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(3, (index) {
          return AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              final value = (_controller.value - (index * 0.2)) % 1.0;
              final scale = (1 + (0.5 * (1 - (value * 2 - 1).abs())));
              return Transform.scale(
                scale: scale,
                child: Container(
                  width: widget.size / 4,
                  height: widget.size / 4,
                  decoration: BoxDecoration(
                    color: widget.color ?? AppTheme.primary,
                    shape: BoxShape.circle,
                  ),
                ),
              );
            },
          );
        }),
      ),
    );
  }
}

class ShimmerLoading extends StatefulWidget {
  final double width;
  final double height;
  final BorderRadius? borderRadius;

  const ShimmerLoading({
    Key? key,
    required this.width,
    required this.height,
    this.borderRadius,
  }) : super(key: key);

  @override
  State<ShimmerLoading> createState() => _ShimmerLoadingState();
}

class _ShimmerLoadingState extends State<ShimmerLoading>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1500),
    )..repeat();
    _animation = Tween<double>(begin: -2, end: 2).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            borderRadius: widget.borderRadius ?? BorderRadius.circular(AppTheme.radiusSM),
            gradient: LinearGradient(
              begin: Alignment(_animation.value, 0),
              end: Alignment(1, 0),
              colors: [
                AppTheme.backgroundAlt,
                AppTheme.borderLight,
                AppTheme.backgroundAlt,
              ],
              stops: [0.0, 0.5, 1.0],
            ),
          ),
        );
      },
    );
  }
}

class SkeletonLoader extends StatelessWidget {
  const SkeletonLoader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ShimmerLoading(width: double.infinity, height: 200),
        SizedBox(height: AppTheme.marginMD),
        ShimmerLoading(width: double.infinity, height: 20),
        SizedBox(height: AppTheme.marginSM),
        ShimmerLoading(width: 200, height: 20),
      ],
    );
  }
}
