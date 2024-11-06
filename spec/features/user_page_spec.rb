require 'rails_helper'

include Helpers

describe "User" do
  let!(:user) { FactoryBot.create :user, username: "Pekka" }
  let!(:other_user) { FactoryBot.create :user, username: "James" }
  let!(:brewery) { FactoryBot.create :brewery, name: "Koff" }
  let!(:beer) { FactoryBot.create :beer, name: "iso 3", brewery: brewery }

  before :each do
    sign_in(username: "Pekka", password: "Foobar1")
  end

  describe "who has signed up" do
    it "can signin with right credentials" do
      sign_in(username: "Pekka", password: "Foobar1")

      expect(page).to have_content 'Welcome back!'
      expect(page).to have_content 'Pekka'
    end

    it "is redirected back to signin form if wrong credentials given" do
      sign_in(username: "Pekka", password: "wrong")

      expect(current_path).to eq(signin_path)
      expect(page).to have_content 'Username and/or password mismatch'
    end
  end

  it "when signed up with good credentials, is added to the system" do
    visit signup_path
    fill_in('user_username', with: 'Brian')
    fill_in('user_password', with: 'Secret55')
    fill_in('user_password_confirmation', with: 'Secret55')

    expect {
      click_button('Create User')
    }.to change { User.count }.by(1)
  end

  it "shows only the user's own ratings on their page" do
    # Create ratings for user and other_user
    user_rating = FactoryBot.create(:rating, score: 15, beer: beer, user: user)
    other_user_rating = FactoryBot.create(:rating, score: 10, beer: beer, user: other_user)

    # Visit user's profile page
    visit user_path(user)

    # Verify only the user's rating is displayed
    expect(page).to have_content "iso 3 15"
    expect(page).not_to have_content "iso 3 10"
  end

  it "can delete their own rating and it is removed from the database" do
    # Create a rating for the user
    rating = FactoryBot.create(:rating, score: 15, beer: beer, user: user)

    # Visit user's profile page where ratings are shown
    visit user_path(user)

    # Ensure the rating is displayed on the page
    expect(page).to have_content "iso 3 15"
    expect(user.ratings.count).to eq(1)

    # Find the specific delete link for the rating
    within("li#rating-#{rating.id}") do
      click_link "Delete"
    end

    # Check that the rating is removed from the database
    expect(user.ratings.count).to eq(0)
    expect(page).not_to have_content "iso 3 15"
  end
end