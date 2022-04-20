require 'rails_helper'

describe "Books API", type: :request do
    let(:first_author) {FactoryBot.create(:author, first_name: "George", last_name: "Orwell", age: 46)}
    describe 'GET /books' do
        before do
            FactoryBot.create(:book, title: '1984', author: first_author)
        end
        it "returns all books" do
            get '/api/v1/books'
            expect(response).to have_http_status(:success)
            expect(response_body.size).to be > 0
            expect(response_body).to eq(
                [{
                    "id" => 1,
                    "title" => "1984",
                    "author_name" => "George Orwell",
                    "author_age" => 46
                }]
            )
        end
    end

    describe 'POST /books' do
        it "creates a book" do
            expect{
                post '/api/v1/books', params: { 
                    book: {title: 'The Martian'}, 
                    author: {first_name: "Andy", last_name: "Weir", age: "48"}
                }
            }.to change { Book.count }.from(Book.count).to(Book.count + 1)
            expect(response).to have_http_status(:created)
            expect(Author.count).to eq(1)
            expect(response_body).to eq(
                {
                    "id" => 1,
                    "title" => "The Martian",
                    "author_name" => "Andy Weir",
                    "author_age" => 48
                }
            )
        end
    end

    describe 'DELETE /books/:id' do
        let!(:book) { FactoryBot.create(:book, title: '1984', author: first_author) }
        it "deletes a book" do 
            expect{
                delete "/api/v1/books/#{book.id}"
            }.to change { Book.count }.from(Book.count).to(Book.count - 1)
            expect(response).to have_http_status(:no_content)
        end
    end
end