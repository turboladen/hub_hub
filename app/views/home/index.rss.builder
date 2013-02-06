xml.instruct! :xml, version: "1.0"
xml.rss version: "2.0" do
  xml.channel do
    xml.title "MindHub - All Posts"
    xml.description "All posts from all spokes"
    xml.link root_url

    @posts.each do |post|
      xml.item do
        xml.title post.title
        xml.description post.content
        xml.pubDate post.created_at.to_s(:rfc822)
        xml.link spoke_post_url(post.spoke_id, post.id)
        xml.guid spoke_post_url(post.spoke_id, post.id)
      end
    end
  end
end
