module AdminHelper
  def url_for_flagged_item(flag_type, type_id)
    truncate_options = { length: 35, separator: '...' }

    if flag_type == 'Post'
      post = Post.find type_id.to_i

      link_to(truncate(post.title, truncate_options),
        spoke_post_path(post.spoke_id, post))
    elsif flag_type == 'Comment'
      comment = Comment.find type_id.to_i

      link_to(truncate(comment.post.title, truncate_options),
        spoke_post_path(comment.post.spoke_id, comment.post.id,
          anchor: "comment-#{comment.id}"))
    end
  end

  def url_for_flagger(flagger_id)
    user = User.find flagger_id.to_i
    link_to(user.email, edit_admin_user_path(user))
  end

  def url_for_flagged_content_creator(flag_type, type_id)
    creator = if flag_type == 'Post'
      post = Post.find type_id.to_i
      post.user
    elsif flag_type == 'Comment'
      comment = Comment.find type_id.to_i
      comment.user
    end

    link_to(creator.email, edit_admin_user_path(creator))
  end
end
