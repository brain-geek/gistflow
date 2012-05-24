module PostHelper
  def timestamp(post)
    time_tag post.updated_at, post.updated_at.to_date.to_formatted_s(:long)
  end
  
  def post_title(post)
    link_to_post = link_to post.title, post
    link_to_user = link_to post.user, post.user
    "#{link_to_post} <span>by #{link_to_user}</span>".html_safe
  end
  
  def preview(post)
    preview = format(post.preview)
    preview << link_to(post.cut_text, post) if post.cut_text
    preview.html_safe
  end
  
  def body(post)
    format(post.body).html_safe
  end
  
  def comments(post)
    post.comments.includes(:user).to_a.select(&:persisted?)
  end
  
  def usernames(post)
    comments = comments(post)
    [*comments.map { |c| c.user.username }, post.user.username].uniq.sort
  end
  
protected
  
  def format(text)
    Markdown.markdown(begin
      raw = Replaceable.new(text)
      raw.replace_gists!.replace_tags!.replace_usernames!
      raw.to_s
    end)
  end
end
