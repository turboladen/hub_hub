require 'spec_helper'

describe 'Posts' do
  describe 'GET /posts' do
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
        get '/posts', ids: post_ids

        expect(response.status).to eq 200
        expect(response.body).to eq JSON(
          posts: [
            {
              id: posts.first.id,
              title: posts.first.title,
              body: posts.first.body,
              created_at: posts.first.created_at.iso8601(3),
              updated_at: posts.first.updated_at.iso8601(3),
              spoke_id: posts.first.spoke.id,
              owner_id: posts.first.owner.id
            },
            {
              id: posts.last.id,
              title: posts.last.title,
              body: posts.last.body,
              created_at: posts.last.created_at.iso8601(3),
              updated_at: posts.last.updated_at.iso8601(3),
              spoke_id: posts.last.spoke.id,
              owner_id: posts.last.owner.id
            }
          ]
        )
      end
    end

    context 'with a mixed array of existent and non-existent IDs' do
      let!(:post) { FactoryGirl.create :post }
      let(:post_ids) { [post.id, 99999] }
      before { allow(Bullet).to receive(:enable?) { false } }
      after { Bullet.unstub(:enable?) }

      it 'returns a 404 with an error message' do
        get '/posts', ids: post_ids

        expect(response.status).to eq 404
        expect(response.body).to eq JSON(
          errors: ["Couldn't find all Posts with IDs (1, 99999) (found 1 results, but was looking for 2)"]
        )
      end
    end
  end

  describe 'GET /posts/:id' do
    context 'non-existent post' do
      it 'returns an error as JSON' do
        get '/posts/123456789.json'

        expect(response.status).to eq 404
        expect(response.body).to eq JSON(
          errors: ["Couldn't find Post with id=123456789"]
        )
      end
    end

    context 'existent post' do
      let!(:post) { FactoryGirl.create :post }

      it 'retrieves the post' do
        get "/posts/#{post.to_param}.json"

        expect(response.status).to eq 200
        expect(response.body).to eq JSON(
          post: {
            id: post.id,
            title: post.title,
            body: post.body,
            created_at: post.created_at.iso8601(3),
            updated_at: post.updated_at.iso8601(3),
            spoke_id: post.spoke.id,
            owner_id: post.owner.id
          }
        )
      end
    end
  end
end
