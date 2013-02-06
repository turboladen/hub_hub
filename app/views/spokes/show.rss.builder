xml.instruct! :xml, version: "1.0"
xml.rss version: "2.0" do
  xml.channel do
    xml.title "MindHub - Posts in Spoke '#{@spoke.name}'"
    xml.description "All posts from spoke '#{@spoke.name}'"
    xml.link spoke_url(@spoke)

    @spoke.posts.each do |post|
      xml.item do
        xml.title post.title
        xml.description post.content
        xml.pubDate post.created_at.to_s(:rfc822)
        xml.link spoke_post_url(@spoke.id, post.id)
        xml.guid spoke_post_url(@spoke.id, post.id)
      end
    end
  end
end
