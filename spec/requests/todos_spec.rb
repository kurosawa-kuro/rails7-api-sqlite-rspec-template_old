require 'rails_helper'

RSpec.describe "/todos", type: :request do
  let!(:todo) { create(:todo) }
  let(:valid_attributes) { { title: "New Todo" } }
  let(:invalid_attributes) { { title: "" } }

  describe "GET /index" do
    before { get todos_path }

    it "renders a successful response" do
      expect(response).to be_successful
      expect(response.parsed_body).to include(
        {
          "id" => todo.id,
          "title" => todo.title,
          "created_at" => todo.created_at.as_json,
          "updated_at" => todo.updated_at.as_json
        }
      )
    end
  end

  describe "POST /create" do
    context "with valid parameters" do
      it "creates a new Todo" do
        expect {
          post todos_path, params: { todo: valid_attributes }
        }.to change(Todo, :count).by(1)

        expect(response).to have_http_status(:created)
        expect(response.content_type).to match(a_string_including("application/json"))
        expect(response.parsed_body["title"]).to eq("New Todo")
      end
    end

    context "with invalid parameters" do
      it "does not create a new Todo" do
        expect {
          post todos_path, params: { todo: invalid_attributes }
        }.not_to change(Todo, :count)

        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to match(a_string_including("application/json"))
        expect(response.parsed_body["title"]).to include("can't be blank")
      end
    end
  end
end
