require 'spec_helper'

describe 'Posts' do
  describe 'GET /api/posts' do
    context 'with an array of existent IDs' do
      let(:post_ids) do
        posts.map { |post| post.id }
      end

      let!(:posts) do
        posts = FactoryGirl.create_list(:post, 3)
        posts.delete_at 1

        posts
      end

      it 'gets all of the posts' do
        get '/api/posts', ids: post_ids

        expect(response.status).to eq 200
        expect(response.body).to be_json_eql JSON(
          posts: [
            {
              id: posts.first.id,
              title: posts.first.title,
              body: posts.first.body,
              created_at: posts.first.created_at.iso8601(3),
              updated_at: posts.first.updated_at.iso8601(3),
              spoke_id: posts.first.spoke.id,
              owner_id: posts.first.owner.id,
              response_ids: []
            },
            {
              id: posts.last.id,
              title: posts.last.title,
              body: posts.last.body,
              created_at: posts.last.created_at.iso8601(3),
              updated_at: posts.last.updated_at.iso8601(3),
              spoke_id: posts.last.spoke.id,
              owner_id: posts.last.owner.id,
              response_ids: []
            }
          ],
          responses: [],
          owners: [{
            admin: posts.first.owner.admin?,
            banned: posts.first.owner.banned?,
            email: posts.first.owner.email,
            first_name: posts.first.owner.first_name,
            last_name: posts.first.owner.last_name,
            post_ids: [posts.first.id]
          }, {
            admin: posts.last.owner.admin?,
            banned: posts.last.owner.banned?,
            email: posts.last.owner.email,
            first_name: posts.last.owner.first_name,
            last_name: posts.last.owner.last_name,
            post_ids: [posts.last.id]
          }],
          meta: {
            current_page: 1,
            total_count: 2,
            total_pages: 1
          }
        )
      end
    end

    context 'with a mixed array of existent and non-existent IDs' do
      let!(:post) { FactoryGirl.create :post }
      let(:post_ids) { [post.id, 99999] }
      before { allow(Bullet).to receive(:enable?) { false } }
      after { Bullet.unstub(:enable?) }

      it 'returns a 404 with an error message' do
        get '/api/posts', ids: post_ids

        expect(response.status).to eq 404
        expect(response.body).to be_json_eql JSON(
          errors: {
            'ids' => "Couldn't find all Posts with 'id': (#{post.id}, 99999) (found 1 results, but was looking for 2)"
          }
        )
      end
    end
  end

  describe 'GET /api/posts/:id' do
    context 'non-existent post' do
      it 'returns an error as JSON' do
        get '/api/posts/123456789.json'

        expect(response.status).to eq 404
        expect(response.body).to be_json_eql JSON(
          errors: { 'id' => "Couldn't find Post with id=123456789" }
        )
      end
    end

    context 'existent post' do
      let!(:post) { FactoryGirl.create :post }

      it 'retrieves the post' do
        get "/api/posts/#{post.to_param}.json"

        expect(response.status).to eq 200
        expect(response.body).to be_json_eql JSON(
          post: {
            id: post.id,
            title: post.title,
            body: post.body,
            response_ids: [],
            created_at: post.created_at.iso8601(3),
            updated_at: post.updated_at.iso8601(3),
            spoke_id: post.spoke.id,
            owner_id: post.owner.id
          },
          responses: [],
          owners: [{
            admin: post.owner.admin?,
            banned: post.owner.banned?,
            email: post.owner.email,
            first_name: post.owner.first_name,
            last_name: post.owner.last_name,
            post_ids: [post.id]
          }]
        )
      end
    end
  end
end
