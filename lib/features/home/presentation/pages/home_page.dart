import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:blogapps/core/theme/app_effects.dart';
import 'package:blogapps/features/home/presentation/bloc/home_bloc.dart';
import 'package:blogapps/features/home/presentation/bloc/home_event.dart';
import 'package:blogapps/features/home/presentation/bloc/home_state.dart';
import 'package:blogapps/features/home/presentation/widgets/featured_post_card.dart';
import 'package:blogapps/features/home/presentation/widgets/post_list_card.dart';
import 'package:blogapps/features/home/presentation/widgets/home_shimmer.dart';
import 'package:blogapps/features/home/presentation/widgets/category_tabs.dart';
import 'package:blogapps/features/post_detail/presentation/pages/post_detail_page.dart';
import 'package:blogapps/features/search/presentation/pages/search_page.dart';
import 'package:blogapps/features/bookmarks/presentation/pages/bookmark_page.dart';
import 'package:blogapps/features/settings/presentation/pages/settings_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const HomeView(),
    const BookmarkPage(),
    const SettingsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _BottomNavItem(
                  icon: Icons.grid_view_rounded,
                  label: 'Feed',
                  isSelected: _currentIndex == 0,
                  onTap: () => setState(() => _currentIndex = 0),
                ),
                _BottomNavItem(
                  icon: Icons.bookmark_rounded,
                  label: 'Saved',
                  isSelected: _currentIndex == 1,
                  onTap: () => setState(() => _currentIndex = 1),
                ),
                _BottomNavItem(
                  icon: Icons.settings_rounded,
                  label: 'Settings',
                  isSelected: _currentIndex == 2,
                  onTap: () => setState(() => _currentIndex = 2),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final ScrollController _scrollController = ScrollController();
  bool _showBackToTop = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    // Show/hide back to top button
    if (_scrollController.offset > 400 && !_showBackToTop) {
      setState(() => _showBackToTop = true);
    } else if (_scrollController.offset <= 400 && _showBackToTop) {
      setState(() => _showBackToTop = false);
    }

    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent * 0.8) {
      context.read<HomeBloc>().add(HomeLoadMorePosts());
    }
  }

  void _scrollToTop() {
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      floatingActionButton: _showBackToTop
          ? FloatingActionButton.small(
              onPressed: _scrollToTop,
              backgroundColor: theme.colorScheme.primary,
              foregroundColor: Colors.white,
              child: const Icon(Icons.arrow_upward_rounded),
            )
          : null,
      body: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          return RefreshIndicator(
            onRefresh: () async {
              context.read<HomeBloc>().add(HomeFetchData());
            },
            child: CustomScrollView(
              controller: _scrollController,
              physics: const BouncingScrollPhysics(),
              slivers: [
                SliverAppBar(
                  floating: true,
                  stretch: true,
                  centerTitle: false,
                  title: Image.asset(
                    'assets/BLog.png',
                    height: 32,
                    fit: BoxFit.contain,
                  ).animate().fadeIn(duration: 600.ms).scale(delay: 200.ms),
                  actions: [
                    IconButton(
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const SearchPage()),
                      ),
                      icon: GlassCard(
                        padding: const EdgeInsets.all(8),
                        borderRadius: BorderRadius.circular(12),
                        child: Icon(Icons.search_rounded, color: theme.colorScheme.primary, size: 20),
                      ),
                    ).animate().fadeIn(duration: 800.ms).scale(),
                    const SizedBox(width: 16),
                  ],
                ),
                SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 8),
                      CategoryTabs(
                        categories: state.categories,
                        selectedCategoryId: state.selectedCategoryId,
                        onCategorySelected: (id) {
                          context.read<HomeBloc>().add(HomeFilterByCategory(id));
                        },
                      ).animate().fadeIn(delay: 200.ms),
                      if (state.featuredPosts.isNotEmpty && state.selectedCategoryId == null) ...[
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Featured Stories', style: theme.textTheme.titleLarge),
                              TextButton(onPressed: () {}, child: const Text('See all')),
                            ],
                          ),
                        ).animate().fadeIn(delay: 300.ms),
                        SizedBox(
                          height: 260,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            itemCount: state.featuredPosts.length,
                            itemBuilder: (context, index) {
                              final post = state.featuredPosts[index];
                              return FeaturedPostCard(
                                post: post,
                                onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => PostDetailPage(post: post)),
                                ),
                              ).animate().fadeIn(delay: (400 + (index * 100)).ms).slideX(begin: 0.1);
                            },
                          ),
                        ),
                      ],
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 32, 20, 16),
                        child: Text('Latest Updates', style: theme.textTheme.titleLarge),
                      ).animate().fadeIn(delay: 500.ms),
                    ],
                  ),
                ),
                if (state.status == HomeStatus.loading && state.latestPosts.isEmpty)
                  const SliverFillRemaining(child: HomeShimmer())
                else if (state.status == HomeStatus.failure && state.latestPosts.isEmpty)
                  SliverFillRemaining(
                    child: _ErrorView(
                      message: state.errorMessage ?? 'Gagal memuat data',
                      onRetry: () => context.read<HomeBloc>().add(HomeFetchData()),
                    ),
                  )
                else if (state.status == HomeStatus.success && state.latestPosts.isEmpty)
                  const SliverFillRemaining(child: _EmptyView())
                else
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          if (index >= state.latestPosts.length) {
                            return const Center(child: Padding(padding: EdgeInsets.all(16), child: CircularProgressIndicator()));
                          }
                          final post = state.latestPosts[index];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: PostListCard(
                              post: post,
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => PostDetailPage(post: post)),
                              ),
                            ),
                          ).animate().fadeIn(delay: (600 + (index * 50)).ms).slideY(begin: 0.1);
                        },
                        childCount: state.latestPosts.length + (state.isLoadingMore ? 1 : 0),
                      ),
                    ),
                  ),
                const SliverToBoxAdapter(child: SizedBox(height: 40)),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _BottomNavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _BottomNavItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = isSelected 
        ? theme.colorScheme.primary 
        : theme.colorScheme.onSurface.withValues(alpha: 0.6);

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? theme.colorScheme.primary.withValues(alpha: 0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 24),
            if (isSelected) ...[
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 14),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline_rounded, size: 64, color: theme.colorScheme.error),
          const SizedBox(height: 16),
          Text(
            'Waduh! Ada Masalah',
            style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            message,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurface.withValues(alpha: 0.6)),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh_rounded),
            label: const Text('Coba Lagi'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyView extends StatelessWidget {
  const _EmptyView();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.article_outlined, size: 64, color: theme.colorScheme.primary.withValues(alpha: 0.4)),
          const SizedBox(height: 16),
          Text(
            'Belum Ada Konten',
            style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            'Sepertinya belum ada artikel yang dipublikasikan untuk kategori ini.',
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurface.withValues(alpha: 0.6)),
          ),
        ],
      ),
    );
  }
}
