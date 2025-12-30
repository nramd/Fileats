import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/constants/app_constants.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/community_provider.dart';
import '../../../data/models/community_post_model.dart';

class CommunityScreen extends StatefulWidget {
  const CommunityScreen({super.key});

  @override
  State<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CommunityProvider>().fetchPosts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title:  const Text('Komunitas'),
        backgroundColor: AppColors.white,
        foregroundColor: AppColors.primary900,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: Consumer<CommunityProvider>(
        builder: (context, communityProvider, child) {
          if (communityProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (communityProvider.posts.isEmpty) {
            return _buildEmptyState();
          }

          return RefreshIndicator(
            onRefresh: () => communityProvider.fetchPosts(),
            child: ListView.builder(
              padding: const EdgeInsets.all(AppConstants.paddingScreen),
              itemCount: communityProvider.posts.length,
              itemBuilder: (context, index) {
                return _buildPostCard(communityProvider.posts[index]);
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCreatePostDialog(),
        backgroundColor: AppColors.accent400,
        child: const Icon(Icons.add, color: AppColors.primary900),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.grey100,
              shape: BoxShape. circle,
            ),
            child: const Icon(Icons.forum_outlined, size: 64, color: AppColors.grey400),
          ),
          const SizedBox(height: AppConstants.spacingLg),
          Text(
            'Belum Ada Postingan',
            style: AppTypography.heading6.copyWith(color: AppColors.grey700),
          ),
          const SizedBox(height: 8),
          Text(
            'Jadilah yang pertama berbagi! ',
            style: AppTypography.bodyMedium.copyWith(color: AppColors.grey500),
          ),
        ],
      ),
    );
  }

  Widget _buildPostCard(CommunityPostModel post) {
    final authProvider = context.read<AuthProvider>();
    final communityProvider = context.read<CommunityProvider>();
    final currentUserId = authProvider.currentUser?. uid ?? '';
    final isLiked = post.isLikedBy(currentUserId);

    return Container(
      margin: const EdgeInsets.only(bottom: AppConstants.spacingMd),
      padding: const EdgeInsets.all(AppConstants.paddingCard),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius. circular(AppConstants.radiusMd),
        boxShadow: [
          BoxShadow(
            color: AppColors. grey300.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Author Info
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: AppColors.primary900,
                child: Text(
                  post.authorName.isNotEmpty ? post.authorName[0]. toUpperCase() : 'U',
                  style:  AppTypography.labelLarge.copyWith(color: AppColors.white),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment. start,
                  children: [
                    Row(
                      children: [
                        Text(post.authorName, style: AppTypography.labelMedium),
                        if (post.authorRole == 'seller') ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppColors.accent400,
                              borderRadius:  BorderRadius.circular(4),
                            ),
                            child: Text(
                              'Penjual',
                              style:  AppTypography.caption.copyWith(
                                color: AppColors.primary900,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    Text(
                      _formatTimeAgo(post.createdAt),
                      style: AppTypography.caption.copyWith(color: AppColors.grey500),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Content
          Text(post.content, style: AppTypography.bodyMedium),
          // Image (if any)
          if (post.imageUrl != null && post.imageUrl!.isNotEmpty) ...[
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(AppConstants.radiusSm),
              child: Image. network(
                post.imageUrl!,
                width: double. infinity,
                height: 200,
                fit: BoxFit.cover,
                errorBuilder: (c, e, s) => Container(
                  height: 200,
                  color: AppColors.grey200,
                  child: const Icon(Icons.image, color: AppColors.grey400),
                ),
              ),
            ),
          ],
          const SizedBox(height: 12),
          // Actions
          Row(
            children: [
              GestureDetector(
                onTap: () => communityProvider.toggleLike(post. id, currentUserId),
                child: Row(
                  children: [
                    Icon(
                      isLiked ? Icons.favorite :  Icons.favorite_border,
                      size: 22,
                      color: isLiked ? AppColors.error : AppColors.grey500,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${post.likesCount}',
                      style: AppTypography.labelMedium.copyWith(color: AppColors.grey600),
                    ),
                  ],
                ),
              ),
              const SizedBox(width:  24),
              Row(
                children: [
                  const Icon(Icons.chat_bubble_outline, size: 20, color: AppColors.grey500),
                  const SizedBox(width: 4),
                  Text(
                    '${post.commentsCount}',
                    style: AppTypography.labelMedium.copyWith(color: AppColors.grey600),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 7) {
      return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} hari lalu';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} jam lalu';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} menit lalu';
    } else {
      return 'Baru saja';
    }
  }

  void _showCreatePostDialog() {
    final contentController = TextEditingController();
    final authProvider = context.read<AuthProvider>();
    final communityProvider = context.read<CommunityProvider>();
    final user = authProvider.currentUser;

    showModalBottomSheet(
      context:  context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        decoration: const BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child:  Padding(
          padding: const EdgeInsets.all(AppConstants.paddingScreen),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Buat Postingan', style: AppTypography.heading6),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextField(
                controller: contentController,
                maxLines: 5,
                decoration: InputDecoration(
                  hintText: 'Apa yang ingin kamu bagikan?',
                  hintStyle: AppTypography.bodyMedium.copyWith(color: AppColors.grey400),
                  filled: true,
                  fillColor: AppColors.grey100,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppConstants.radiusMd),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    if (contentController.text.trim().isEmpty) return;

                    await communityProvider.createPost(
                      authorId: user?.uid ?? '',
                      authorName: user?.name ?? 'Anonymous',
                      authorPhotoUrl: user?.photoUrl ?? '',
                      authorRole:  user?.role ?? 'buyer',
                      content: contentController.text. trim(),
                    );

                    if (mounted) Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary900,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppConstants.radiusMd),
                    ),
                  ),
                  child:  Text('Posting', style: AppTypography.buttonMedium),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}