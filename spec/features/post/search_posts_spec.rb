require 'spec_helper'

describe "Posts" do
  describe "Searching", solr: true do
    subject { page }
    let!(:post_title){ FactoryGirl.create(:post, title: "asdf") }
    let!(:post_body){ FactoryGirl.create(:post, body: "qwer") }
    it "can search for the post's title" do
      visit posts_path

      fill_in "search", with: "asdf"
      click_on "Search"

      should have_content(post_title.title)
      should_not have_content(post_body.title)
    end

    it "can search for the post's body" do
      visit posts_path

      fill_in "search", with: "qwer"
      click_on "Search"

      should have_content(post_body.body)
      should_not have_content(post_title.body)
    end
  end
end
