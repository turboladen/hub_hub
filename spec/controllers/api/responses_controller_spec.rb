require 'spec_helper'

describe Api::ResponsesController do
  let(:new_response) { FactoryGirl.create :response }

  describe 'GET index' do
    let(:relation) { double 'Response relation' }

    before do
      expect(Response).to receive(:includes).with(:post, :owner) { relation }
    end

    context 'with ids' do
      it 'assigns responses with the given ids as @responses' do
        expect(relation).to receive(:find).with(%w[1 2]) { relation }
        get :index, ids: %w[1 2], format: :json
        assigns(:responses).should eq(relation)
      end
    end

    context 'without ids' do
      it 'assigns all responses as @responses' do
        get :index, format: :json
        assigns(:responses).should eq(relation)
      end
    end
  end

  describe 'GET show' do
    it 'assigns the requested responses as @responses' do
      get :show, id: new_response.to_param, format: :json
      assigns(:response).should eq(new_response)
    end
  end

  describe 'POST create' do
    before { login user }

    let!(:a_post) { FactoryGirl.create :post }
    let(:user) { FactoryGirl.create :user }
    let(:valid_attributes) do
      FactoryGirl.attributes_for(:response).merge!({
        respondable_id: a_post.id,
        respondable_type: 'Post'
      })
    end

    describe 'with valid params' do
      it 'creates a new Response' do
        expect {
          post :create, response: valid_attributes, format: :json
        }.to change(Response, :count).by(1)
      end

      it 'assigns a newly created post as @response' do
        post :create, response: valid_attributes, format: :json
        assigns(:response).should be_a(Response)
        assigns(:response).should be_persisted
      end

      it 'returns a 201 with Location header and the payload as JSON' do
        post :create, response: valid_attributes, format: :json

        expect(response.status).to eq 201
        expect(response.headers).to include 'Location'
        expect(response.body).to be_json_eql({
          response: {
            body: valid_attributes[:body],
            owner_id: user.id,
            respondable_type: 'Post',
            respondable_id: a_post.id,
            response_ids: []
          },
          responses: []
        }.to_json)
      end
    end

    describe 'with invalid params' do
      let(:respondable) { double 'A respondable thing' }

      before do
        allow(subject).to receive(:set_respondable) { respondable }

        post :create,
          response: { 'not acceptable' => 'invalid value' },
          format: :json
      end

      it 'assigns a newly created but unsaved response as @response' do
        assigns(:response).should be_a_new(Response)
      end

      it 'returns a 422 with errors as JSON' do
        expect(response.status).to eq 422
        expect(response.body).to be_json_eql({
          errors: {
            body: ["can't be blank"],
            respondable: ["can't be blank"]
          }
        }.to_json)
      end
    end
  end

  describe 'PUT update' do
    before { login user }

    let!(:a_post) { FactoryGirl.create :post }
    let(:user) { FactoryGirl.create :user }

    let(:valid_attributes) do
      FactoryGirl.attributes_for(:response).merge!({
        respondable_id: a_post.id,
        respondable_type: 'Post'
      })
    end

    describe 'with valid params' do
      it 'updates the requested response' do
        Response.any_instance.should_receive(:update).with({ 'body' => 'MyString' })

        put :update,
          id: new_response.to_param,
          response: { 'body' => 'MyString' },
          format: :json
      end

      it 'assigns the requested response as @response' do
        put :update,
          id: new_response.to_param,
          response: valid_attributes,
          format: :json

        assigns(:response).should eq(new_response)
      end

      it 'returns a 204' do
        put :update,
          id: new_response.to_param,
          response: valid_attributes,
          format: :json

        expect(response.status).to eq 204
        expect(response.body).to be_empty
      end
    end

    describe 'with invalid params' do
      before do
        put :update,
          id: new_response.to_param,
          response: { 'body' => '' },
          format: :json
      end

      it 'assigns the response as @response' do
        assigns(:response).should eq(new_response)
      end

      it 'returns a 422 with errors as JSON' do
        expect(response.status).to eq 422
        expect(response.body).to be_json_eql JSON(errors: { body: ["can't be blank"] })
      end
    end
  end

  describe 'DELETE destroy' do
    before { new_response }

    it 'destroys the requested response' do
      expect {
        delete :destroy, id: new_response.to_param, format: :json
      }.to change(Response, :count).by(-1)
    end

    it 'returns an empty body with 204' do
      delete :destroy, id: new_response.to_param, format: :json
      expect(response.status).to eq 204
      expect(response.body).to be_empty
    end
  end
end
