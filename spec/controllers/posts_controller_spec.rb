require 'spec_helper'


describe PostsController do
  fixtures :spokes
  fixtures :posts
  fixtures :users

  describe '#create' do
    context 'user not logged in' do
      it 'returns a RoutingError' do
        post :create, spoke_id: spokes(:fresno),
          post: { title: 'test', content: 'stuff' }

        expect(response).to redirect_to new_user_session_path
      end
    end

    context 'user logged in' do
      before { sign_in users(:bob) }

      context 'bad spoke ID given' do
        it 'creates a new post' do
          expect {
            post :create, spoke_id: 1231231231231231231,
              post: { title: 'test', content: 'stuff' }
          }.to raise_error ActiveRecord::RecordNotFound
        end
      end

      context 'no post info given' do
        it 'redirects back to the spoke and flashes the errors' do
          expect {
            post :create, spoke_id: spokes(:fresno)
          }.to_not change { Post.count }.by 1

          flash[:error].should ==
            "Title can't be blank; Title is too short (minimum is 2 characters); Content can't be blank"
          expect(response).to redirect_to spokes(:fresno)
        end
      end

      context 'post info given' do
        it 'creates a new post' do
          expect {
            post :create, spoke_id: spokes(:fresno),
              post: { title: 'test', content: 'stuff' }
          }.to change { Post.count }.by 1

          flash[:notice].should == 'Your post was created.'
          response.should render_template 'show'

          post = Post.last
          post.title.should == 'test'
          post.content.should == 'stuff'
          post.spoke_id.should == spokes(:fresno).id
        end
      end
    end
  end
end
