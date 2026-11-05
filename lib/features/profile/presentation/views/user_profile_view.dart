import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:file_picker/file_picker.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:page_ui/config/themes/app_colors.dart';
import 'package:page_ui/config/themes/app_text_style.dart';
import 'package:page_ui/core/helpers/setup_service_locator_getit.dart';
import 'package:page_ui/core/helpers/custom_show_snack_bar.dart';
import 'package:page_ui/features/profile/presentation/cubit/user_profile_cubit.dart';
import 'package:page_ui/features/profile/domain/entities/user_profile.dart';

class UserProfileView extends StatelessWidget {
  const UserProfileView({super.key});

  static const String routeName = "UserProfileView";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.mainBackgroundColor,
      appBar: AppBar(
        title: Text(
          '[ USER PROFILE ]',
          style: AppTextStyles.titleLarge?.copyWith(
            color: AppColors.white,
            letterSpacing: 2.0,
          ),
        ),
        backgroundColor: AppColors.anotherGray.withValues(alpha: 0.8),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: BlocProvider<UserProfileCubit>(
        create: (_) => getit.get<UserProfileCubit>()..fetchProfile(),
        child: BlocConsumer<UserProfileCubit, UserProfileState>(
          listener: (context, state) {
            if (state is UserProfileFailure) {
              showSnackBar(
                context: context,
                message: state.message,
                backgroundColor: AppColors.red,
                textColor: AppColors.white,
              );
            }
          },
          builder: (context, state) {
            return Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40.0),
                child: Skeletonizer(
                  enabled: state is UserProfileLoading,
                  child: Container(
                    constraints: const BoxConstraints(maxWidth: 500),
                    decoration: BoxDecoration(
                      color: AppColors.anotherGray.withValues(alpha: 0.9),
                      borderRadius: BorderRadius.circular(16.0),
                      border: Border.all(
                        color: AppColors.primaryColor.withValues(alpha: 0.3),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.black.withValues(alpha: 0.5),
                          blurRadius: 20.0,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(32.0),
                    child: _buildProfileContent(context, state),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildProfileContent(BuildContext context, UserProfileState state) {
    // Determine profile data to show
    UserProfile? profile;
    UserProfileEditing? editingState;
    bool isEditing = false;
    bool isSaving = state is UserProfileSaving;

    if (state is UserProfileLoaded) {
      profile = state.profile;
    } else if (state is UserProfileEditing) {
      profile = state.originalProfile;
      editingState = state;
      isEditing = true;
    } else if (state is UserProfileLoading) {
      // Mock data for skeleton loader
      profile = const UserProfile(
        id: 'loading',
        name: 'Loading Username',
        birthdate: '1990-01-01',
      );
    }

    if (profile == null) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.error_outline, color: AppColors.lightRed, size: 48),
          const SizedBox(height: 16),
          Text(
            'Failed to load profile details.',
            style: AppTextStyles.bodyMedium?.copyWith(color: AppColors.textGray),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => context.read<UserProfileCubit>().fetchProfile(),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryColor,
            ),
            child: const Text('Retry'),
          ),
        ],
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _buildAvatar(context, profile, editingState, isEditing, isSaving),
        const SizedBox(height: 32),
        _buildFields(context, profile, editingState, isEditing, isSaving),
        const SizedBox(height: 40),
        _buildActions(context, profile, editingState, isEditing, isSaving),
      ],
    );
  }

  Widget _buildAvatar(
    BuildContext context,
    UserProfile profile,
    UserProfileEditing? editingState,
    bool isEditing,
    bool isSaving,
  ) {
    final hasNewPhoto = editingState?.localPhotoBytes != null;
    final isRemoved = editingState?.isPhotoRemoved ?? false;
    final displayUrl = isRemoved ? null : profile.photoUrl;

    Widget avatarImage;
    if (isEditing && hasNewPhoto) {
      avatarImage = Image.memory(
        editingState!.localPhotoBytes!,
        fit: BoxFit.cover,
        width: 120,
        height: 120,
      );
    } else if (displayUrl != null && displayUrl.isNotEmpty) {
      avatarImage = Image.network(
        displayUrl,
        fit: BoxFit.cover,
        width: 120,
        height: 120,
        errorBuilder: (context, error, stackTrace) => _buildInitialsPlaceholder(profile.name),
      );
    } else {
      avatarImage = _buildInitialsPlaceholder(profile.name);
    }

    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: AppColors.primaryColor,
              width: 3.0,
            ),
          ),
          child: ClipOval(child: avatarImage),
        ),
        if (isEditing && !isSaving)
          Positioned(
            right: 0,
            bottom: 0,
            child: Container(
              decoration: const BoxDecoration(
                color: AppColors.primaryColor,
                shape: BoxShape.circle,
              ),
              child: PopupMenuButton<String>(
                icon: const Icon(Icons.camera_alt, color: AppColors.white, size: 20),
                onSelected: (value) async {
                  if (value == 'upload') {
                    final result = await FilePicker.platform.pickFiles(
                      type: FileType.custom,
                      allowedExtensions: ['png', 'jpg', 'jpeg'],
                    );
                    if (result != null && result.files.isNotEmpty) {
                      final file = result.files.first;
                      if (file.bytes != null) {
                        final ext = file.extension?.toLowerCase() ?? 'png';
                        final mime = ext == 'png' ? 'image/png' : 'image/jpeg';
                        
                        if (file.size > 5 * 1024 * 1024) {
                          if (context.mounted) {
                            showSnackBar(
                              context: context,
                              message: 'The file is larger than 5 MB.',
                              backgroundColor: AppColors.red,
                            );
                          }
                          return;
                        }

                        if (context.mounted) {
                          context.read<UserProfileCubit>().selectLocalPhoto(
                                bytes: file.bytes!,
                                name: file.name,
                                contentType: mime,
                              );
                        }
                      }
                    }
                  } else if (value == 'remove') {
                    context.read<UserProfileCubit>().removePhoto();
                  }
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'upload',
                    child: Text('Upload Photo'),
                  ),
                  if (profile.photoUrl != null || hasNewPhoto)
                    const PopupMenuItem(
                      value: 'remove',
                      child: Text('Remove Photo'),
                    ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildInitialsPlaceholder(String name) {
    final initials = name.isNotEmpty
        ? name.trim().split(' ').map((e) => e[0]).take(2).join().toUpperCase()
        : 'U';
    return Container(
      width: 120,
      height: 120,
      color: AppColors.primaryColor.withValues(alpha: 0.5),
      alignment: Alignment.center,
      child: Text(
        initials,
        style: const TextStyle(
          color: AppColors.white,
          fontSize: 36,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildFields(
    BuildContext context,
    UserProfile profile,
    UserProfileEditing? editingState,
    bool isEditing,
    bool isSaving,
  ) {
    if (isEditing) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Full Name',
            style: AppTextStyles.bodySmall?.copyWith(color: AppColors.textGray),
          ),
          const SizedBox(height: 8),
          TextFormField(
            initialValue: editingState?.draftName,
            enabled: !isSaving,
            style: AppTextStyles.bodyMedium?.copyWith(color: AppColors.white),
            decoration: InputDecoration(
              filled: true,
              fillColor: AppColors.darkSurface.withValues(alpha: 0.3),
              hintText: 'Enter your name',
              hintStyle: const TextStyle(color: AppColors.grey),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: const BorderSide(color: AppColors.primaryColor),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: BorderSide(color: AppColors.primaryColor.withValues(alpha: 0.5)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: const BorderSide(color: AppColors.primaryColor, width: 2.0),
              ),
            ),
            onChanged: (val) => context.read<UserProfileCubit>().updateDraftName(val),
          ),
          const SizedBox(height: 24),
          Text(
            'Birthdate',
            style: AppTextStyles.bodySmall?.copyWith(color: AppColors.textGray),
          ),
          const SizedBox(height: 8),
          InkWell(
            onTap: isSaving
                ? null
                : () async {
                    DateTime initialDate = DateTime.now().subtract(const Duration(days: 365 * 20));
                    if (editingState?.draftBirthdate != null) {
                      try {
                        initialDate = DateTime.parse(editingState!.draftBirthdate!);
                      } catch (_) {}
                    }
                    final pickedDate = await showDatePicker(
                      context: context,
                      initialDate: initialDate,
                      firstDate: DateTime(1900),
                      lastDate: DateTime.now(),
                      builder: (context, child) {
                        return Theme(
                          data: Theme.of(context).copyWith(
                            colorScheme: const ColorScheme.dark(
                              primary: AppColors.primaryColor,
                              onPrimary: AppColors.white,
                              surface: AppColors.anotherGray,
                              onSurface: AppColors.white,
                            ),
                          ),
                          child: child!,
                        );
                      },
                    );
                    if (pickedDate != null && context.mounted) {
                      final formattedDate =
                          "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
                      context.read<UserProfileCubit>().updateDraftBirthdate(formattedDate);
                    }
                  },
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
              decoration: BoxDecoration(
                color: AppColors.darkSurface.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(8.0),
                border: Border.all(
                  color: AppColors.primaryColor.withValues(alpha: 0.5),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.between,
                children: [
                  Text(
                    editingState?.draftBirthdate ?? 'Select Birthdate',
                    style: AppTextStyles.bodyMedium?.copyWith(
                      color: editingState?.draftBirthdate != null ? AppColors.white : AppColors.grey,
                    ),
                  ),
                  const Icon(Icons.calendar_today, color: AppColors.primaryColor, size: 20),
                ],
              ),
            ),
          ),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildReadOnlyField('Full Name', profile.name),
        const SizedBox(height: 24),
        _buildReadOnlyField('Birthdate', profile.birthdate ?? 'Not provided'),
      ],
    );
  }

  Widget _buildReadOnlyField(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.bodySmall?.copyWith(color: AppColors.textGray),
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
          decoration: BoxDecoration(
            color: AppColors.darkSurface.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8.0),
            border: Border.all(
              color: AppColors.primaryColor.withValues(alpha: 0.15),
            ),
          ),
          child: Text(
            value,
            style: AppTextStyles.bodyMedium?.copyWith(color: AppColors.white, fontWeight: FontWeight.w500),
          ),
        ),
      ],
    );
  }

  Widget _buildActions(
    BuildContext context,
    UserProfile profile,
    UserProfileEditing? editingState,
    bool isEditing,
    bool isSaving,
  ) {
    if (isSaving) {
      return const CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryColor),
      );
    }

    if (isEditing) {
      return Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () {
                final isModified = editingState?.draftName != editingState?.originalProfile.name ||
                    editingState?.draftBirthdate != editingState?.originalProfile.birthdate ||
                    editingState?.localPhotoBytes != null ||
                    editingState?.isPhotoRemoved == true;

                if (isModified) {
                  showDialog(
                    context: context,
                    builder: (dialContext) => AlertDialog(
                      backgroundColor: AppColors.anotherGray,
                      title: const Text('Unsaved Changes', style: TextStyle(color: AppColors.white)),
                      content: const Text(
                        'You have unsaved changes. Are you sure you want to discard them?',
                        style: TextStyle(color: AppColors.textGray),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(dialContext).pop(),
                          child: const Text('Keep Editing', style: TextStyle(color: AppColors.primaryColor)),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(dialContext).pop();
                            context.read<UserProfileCubit>().exitEditMode();
                          },
                          child: const Text('Discard', style: TextStyle(color: AppColors.lightRed)),
                        ),
                      ],
                    ),
                  );
                } else {
                  context.read<UserProfileCubit>().exitEditMode();
                }
              },
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: AppColors.grey),
                padding: const EdgeInsets.symmetric(vertical: 16.0),
              ),
              child: const Text('Cancel', style: TextStyle(color: AppColors.white)),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: ElevatedButton(
              onPressed: () => context.read<UserProfileCubit>().saveProfile(),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryColor,
                padding: const EdgeInsets.symmetric(vertical: 16.0),
              ),
              child: const Text('Save', style: TextStyle(color: AppColors.black, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      );
    }

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () => context.read<UserProfileCubit>().enterEditMode(),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryColor,
          padding: const EdgeInsets.symmetric(vertical: 18.0),
        ),
        child: const Text(
          'Edit Profile',
          style: TextStyle(color: AppColors.black, fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ),
    );
  }
}
