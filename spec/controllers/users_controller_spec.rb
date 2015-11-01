require 'rails_helper'

describe UsersController, type: :controller do
  let(:user) { create :user, location: 'Shanghai' }
  let(:deleted_user) { create :user, state: User::STATE[:deleted] }

  describe 'Visit deleted user' do
    it 'should 404 with deleted user' do
      get :show, id: deleted_user.login
      expect(response.status).to eq(404)
      get :topics, id: deleted_user.login
      expect(response.status).to eq(404)
      get :notes, id: deleted_user.login
      expect(response.status).to eq(404)
    end
  end

  describe ':index' do
    it 'should have an index action' do
      get :index
      expect(response).to be_success
    end
  end

  describe ':show' do
    it 'should show user' do
      get :show, id: user.login
      expect(response).to be_success
    end
  end

  describe ':topics' do
    it 'should show user topics' do
      get :topics, id: user.login
      expect(response).to be_success
    end
  end

  describe ':replies' do
    it 'should show user replies' do
      get :replies, id: user.login
      expect(response).to be_success
    end
  end

  describe ':favorites' do
    it 'should show user liked stuffs' do
      get :favorites, id: user.login
      expect(response).to be_success
    end
  end

  describe ':notes' do
    it 'should show user notes' do
      get :notes, id: user.login
      expect(response).to be_success
    end

    it 'assigns @notes' do
      note_1 = create(:note, publish: true, user: user)
      create(:note, publish: false, user: user)
      get :notes, id: user.login
      expect(assigns(:notes)).to eq([note_1])
    end
  end

  describe ':city' do
    it 'should render 404 if there is no user in that city' do
      get :city, id: 'Mars'
      expect(response).not_to be_success
      expect(response.status).to eq(404)
    end

    it 'should show user associated with that city' do
      get :city, id: user.location
      expect(response.status).to eq(200)
      expect(assigns[:users]).to include(user)
    end
  end
end
