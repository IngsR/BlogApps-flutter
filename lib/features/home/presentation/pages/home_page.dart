import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:blogapps/core/common/widgets/organisms/featured_post_card.dart';
import 'package:blogapps/core/common/widgets/organisms/post_list_card.dart';
import 'package:blogapps/core/common/widgets/organisms/home_shimmer.dart';
import 'package:blogapps/core/common/widgets/organisms/category_tabs.dart';
import 'package:blogapps/core/theme/app_effects.dart';
import 'package:blogapps/features/home/presentation/bloc/home_bloc.dart';
import 'package:blogapps/features/home/presentation/bloc/home_event.dart';
import 'package:blogapps/features/home/presentation/bloc/home_state.dart';
import 'package:blogapps/features/post_detail/presentation/pages/post_detail_page.dart';
import 'package:blogapps/features/search/presentation/pages/search_page.dart';
import 'package:blogapps/features/bookmarks/presentation/pages/bookmark_page.dart';
import 'package:blogapps/features/settings/presentation/pages/settings_page.dart';

import 'package:blogapps/features/home/presentation/widgets/home_bottom_nav.dart';
import 'package:blogapps/features/home/presentation/widgets/home_state_views.dart';

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
      body: IndexedStack(index: _currentIndex, children: _pages),
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
                HomeBottomNavItem(
                  icon: Icons.grid_view_rounded,
                  label: 'Feed',
                  isSelected: _currentIndex == 0,
                  onTap: () => setState(() => _currentIndex = 0),
                ),
                HomeBottomNavItem(
                  icon: Icons.bookmark_rounded,
                  label: 'Saved',
                  isSelected: _currentIndex == 1,
                  onTap: () => setState(() => _currentIndex = 1),
                ),
                HomeBottomNavItem(
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
    if (_scrollController.offset > 400 && !_showBackToTop) {
      setState(() => _showBackToTop = true);
    } else if (_scrollController.offset <= 400 && _showBackToTop) {
      setState(() => _showBackToTop = false);
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
                        MaterialPageRoute(
                          builder: (context) => const SearchPage(),
                        ),
                      ),
                      icon: GlassCard(
                        padding: const EdgeInsets.all(8),
                        borderRadius: BorderRadius.circular(12),
                        child: Icon(
                          Icons.search_rounded,
                          color: theme.colorScheme.primary,
                          size: 20,
                        ),
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
                          context.read<HomeBloc>().add(
                            HomeFilterByCategory(id),
                          );
                        },
                      ).animate().fadeIn(delay: 200.ms),
                      if (state.featuredPosts.isNotEmpty) ...[
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Featured Stories',
                                style: theme.textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              TextButton(
                                onPressed: () {},
                                child: const Text('See all'),
                              ),
                            ],
                          ),
                        ).animate().fadeIn(delay: 300.ms),
                        RepaintBoundary(
                          child: SizedBox(
                            height: 260,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              itemCount: state.featuredPosts.length,
                              itemBuilder: (context, index) {
                                final post = state.featuredPosts[index];
                                return FeaturedPostCard(
                                  post: post,
                                  onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          PostDetailPage(post: post),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 32, 20, 16),
                        child: Text(
                          'Latest Updates',
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ).animate().fadeIn(delay: 500.ms),
                    ],
                  ),
                ),
                if (state.status == HomeStatus.loading &&
                    state.latestPosts.isEmpty)
                  const SliverFillRemaining(child: HomeShimmer())
                else if (state.status == HomeStatus.failure)
                  SliverToBoxAdapter(
                    child: HomeErrorView(
                      message: state.errorMessage ?? 'Gagal memuat data',
                      onRetry: () {
                        context.read<HomeBloc>().add(HomeFetchData());
                      },
                    ),
                  )
                else if (state.latestPosts.isEmpty &&
                    state.status == HomeStatus.success)
                  const SliverToBoxAdapter(
                    child: HomeEmptyView(),
                  )
                else
                  ...[
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate((context, index) {
                          final post = state.latestPosts[index];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: PostListCard(
                              post: post,
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        PostDetailPage(post: post)),
                              ),
                            ),
                          ).animate().fadeIn(delay: (index * 50).ms).slideX(
                                begin: 0.1,
                              );
                        }, childCount: state.latestPosts.length),
                      ),
                    ),
                  ],
                const SliverToBoxAdapter(child: SizedBox(height: 80)),
              ],
            ),
          );
        },
      ),
    );
  }
}
