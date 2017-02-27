require 'rails_helper'

RSpec.describe TicketsController, type: :controller do
  let(:account){ Account.create!(slug: 'default') }

  describe 'The test the interview candidate needs to complete' do
    describe "GET #related" do
      let!(:ticket)           { account.tickets.create! }
      let!(:related_ticket)   { "add a related ticket" }
      let!(:unrelated_ticket) { "add an unrelated ticket" }

      it "responds successfully with an HTTP 200 status code" do
        get :related, id: ticket.id
        expect(response).to be_success
        expect(response).to have_http_status(200)
      end

      it "loads related ticket" do
        get :related, id: ticket.id

        json_response = JSON.parse(response.body)

        expect(json_response.first['id'].to_i).to eq related_ticket.id
        expect(json_response.size).to eq 1
      end
    end
  end

  describe "GET #index" do
    it "responds successfully with an HTTP 200 status code" do
      get :index
      expect(response).to be_success
      expect(response).to have_http_status(200)
    end

    it "loads all of the tickets into @tickets" do
      tickets = Array.new(2){ account.tickets.create! }
      get :index

      expect(assigns(:tickets)).to match_array(tickets)
    end
  end

  describe "POST #create" do
    it "responds successfully with an HTTP 200 status code" do
      post :create, ticket: { subject: 'foo' }
      expect(response).to be_success
      expect(response).to have_http_status(200)
    end

    it "creates the ticket" do
      expect{
        post :create, ticket: { subject: 'foobar' }
      }.to change { Ticket.count }.by(1)
    end

    it "returns the created ticket" do
      subject = 'This subject is updated now'
      post :create, ticket: { subject: subject }
      expect(@response.body).to match(subject)
    end
  end

  describe "with an existing ticket" do
    let(:ticket){ account.tickets.create! }

    describe "GET #show" do
      it "responds successfully with an HTTP 200 status code" do
        get :show, id: ticket.id
        expect(response).to be_success
        expect(response).to have_http_status(200)
      end

      it "loads the requested ticket into @ticket" do
        get :show, id: ticket.id
        expect(assigns(:ticket)).to match(ticket)
      end
    end

    describe "PUT #update" do
      it "responds successfully with an HTTP 200 status code" do
        put :update, id: ticket.id, ticket: { subject: 'foo' }
        expect(response).to be_success
        expect(response).to have_http_status(200)
      end

      it "updates the ticket with the provided value" do
        subject = 'This subject is updated now'
        put :update, id: ticket.id, ticket: { subject: subject }
        expect(@response.body).to match(subject)
      end
    end

    describe "DELETE #destroy" do
      it "responds successfully with an HTTP 200 status code" do
        delete :destroy, id: ticket.id
        expect(response).to be_success
        expect(response).to have_http_status(200)
      end

      it "deletes the ticket" do
        ticket_id = ticket.id
        expect{
          delete :destroy, id: ticket_id
        }.to change { Ticket.count }.by(-1)
      end
    end
  end
end
