require 'spec_helper'

describe "Posts" do
  describe "Published posts", solr: true do
    subject { page }
    context "when not logged in" do
      it "cannot access unpublished_posts_path" do
        visit unpublished_posts_path

        current_path.should eq(root_path)
        should have_content("Access denied")
      end
    end

    context "when logged in" do
      let!(:user) { FactoryGirl.create(:user) }
      let!(:unpublished_post) { FactoryGirl.create(:post, published: false, user: user) }
      let!(:published_post) { FactoryGirl.create(:post, user: user) }
      before do
        visit new_user_session_path
        fill_in "user_email", with: user.email
        fill_in "user_password", with: user.password
        click_button "Sign in"
      end
  
      it "cannot see an unpublished post in posts_path" do
        visit posts_path
        should_not have_content unpublished_post.title
        should_not have_content unpublished_post.body
      end
  
      it "cannot see a published post in unpublished_posts_path" do
        visit unpublished_posts_path
  
        should_not have_content(published_post.title)
        should_not have_content(published_post.body)
      end
    end
  end
end
