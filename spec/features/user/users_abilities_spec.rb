require 'spec_helper'

describe "Users abilities", solr: true do

  context "when a user is not logged in" do
    let!(:post) { FactoryGirl.create(:post) }

    context "when on posts_path" do
      before{ visit posts_path }

      describe "show post" do
        it "should have permission to read any posts" do
          #dont know why but it seems that the post is not shown until posts_path is visited again
          visit posts_path
          page.should have_link("Show", href: post_path(post))
          click_link("Show")
          page.should have_content(post.title)
          page.should have_content(post.body)
        end

        context "when accessing directly through url" do
          it "does have permission access post_path" do
            visit post_path(post)
    
            page.should have_content(post.title)
            page.should have_content(post.body)
          end
        end
      end

      describe "new post" do
        it "should not be able to click on a new post link" do
          page.should_not have_link("New Post", href: new_post_path)
        end
        
        context "when accessing directly through url" do
          it "does not have permission to access new_post_path" do
            visit new_post_path
    
            current_path.should eq(root_path)
            page.should have_content("Access denied")
          end
        end
      end
  
      describe "edit post" do
        it "should not be able to click on a edit post link" do
          page.should_not have_link("Edit", href: edit_post_path(post))
        end

        context "when accessing directly through url" do
          it "does not have permission to access edit_post_path" do
            visit edit_post_path(post)
    
            current_path.should eq(root_path)
            page.should have_content("Access denied")
          end
        end
      end

      describe "destroy post" do
        it "should not be able to click on a destroy post link" do
          page.should_not have_link("Destroy")
        end
        
        context "when accessing directly through url" do
          it "does not have permission to access post_path with delete method" do
            page.driver.submit :delete, post_path(post), {}
    
            current_path.should eq(root_path)
            page.should have_content("Access denied")
          end
        end
      end
  
  
    end
  end

  context "when a user is logged in" do
    let!(:user_with_posts) { FactoryGirl.create(:user_with_posts) }
    let!(:other_user_with_posts) { FactoryGirl.create(:user_with_posts) }
    let(:post) { FactoryGirl.build(:post) }
    subject(:other_users_post) { other_user_with_posts.posts.last }
    subject(:users_post) { user_with_posts.posts.first }
    before do
      visit new_user_session_path
      fill_in "user_email", with: user_with_posts.email
      fill_in "user_password", with: user_with_posts.password
      click_button "Sign in"
    end

    context "when on posts_path" do
      before { visit posts_path }

      describe "show post" do
        it "does have permission to read posts he does not own" do
          page.should have_link("Show", href: post_path(other_users_post))
          page.find("a[href=\"#{post_path(other_users_post)}\"]", text: "Show").click
          current_path.should eq(post_path(other_users_post))
          page.should have_content(other_users_post.title)
          page.should have_content(other_users_post.body)
        end
  
        it "does have permission to read posts he own" do
          page.should have_link("Show", href: post_path(users_post))
          page.find("a[href=\"#{post_path(users_post)}\"]", text: "Show").click
          current_path.should eq(post_path(users_post))
          page.should have_content(users_post.title)
          page.should have_content(users_post.body)
        end
  
        context "when accessing directly through url" do
          it "does have permission to access (show) post_path of posts he does not own" do
            visit post_path(other_users_post)
            current_path.should eq(post_path(other_users_post))
    
            page.should have_content(other_users_post.title)
            page.should have_content(other_users_post.body)
          end
    
          it "does have permission to access (show) post_path of posts he owns" do
            visit post_path(users_post)
            current_path.should eq(post_path(users_post))
    
            page.should have_content(users_post.title)
            page.should have_content(users_post.body)
          end
            
        end
          
      end

      describe "new post" do
        it "can click on a new post link" do
          page.should have_link("New Post", href: new_post_path)
        end

        it "can create a new post" do
          click_on "New Post"

          current_path.should eq(new_post_path)
          fill_in "post_title", with: post.title
          fill_in "post_body", with: post.body
          check "post_published"

          click_on "Create Post"
          page.should have_content("Post was successfully created")

          visit posts_path
          page.should have_content(post.title)
          page.should have_content(post.body)

        end
      end
  
      describe "edit post" do
        it "cannot click on a edit post link that he does not own" do
          page.should_not have_link("Edit", href: edit_post_path(other_users_post))
        end

        it "can click on a edit post link that he owns" do
          page.should have_link("Edit", href: edit_post_path(users_post))
        end

        it "can edit a post he owns" do
          page.find("a[href=\"#{edit_post_path(users_post)}\"]").click

          current_path.should eq(edit_post_path(users_post))
          fill_in "post_title", with: post.title
          fill_in "post_body", with: post.body

          click_on "Update Post"
          page.should have_content("Post was successfully updated")

          visit posts_path
          page.should have_content(post.title)
          page.should have_content(post.body)
        end

        context "when accessing directly through url" do
          it "cannot edit a post he does not own" do
            visit edit_post_path(other_users_post)
  
            current_path.should eq(root_path)
            page.should have_content("Access denied")
          end
        end
      end

      describe "destroy post" do
        it "cannot click on a destroy post link that he does not own" do
          page.should_not have_link("Destroy", href: post_path(other_users_post))
        end
  
        it "can click on a destroy post link that he owns" do
          page.should have_link("Destroy", href: post_path(users_post))
        end
        
        context "when accessing directly through url" do
          it "does not have permission to access (destroy) post_path with delete method of posts he does not own" do
            page.driver.submit :delete, post_path(other_users_post), {}
    
            current_path.should eq(root_path)
            page.should have_content("Access denied")
          end
    
          it "does have permission to access (destroy) post_path with delete method of posts he owns" do
            page.driver.submit :delete, post_path(users_post), {}
    
            current_path.should eq(posts_path)
            page.should have_content("Post was successfully deleted")
            page.should_not have_content(users_post.title)
            page.should_not have_content(users_post.body)
          end
        end
      end
    end
  end
end

