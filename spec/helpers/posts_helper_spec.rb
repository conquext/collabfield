require 'rails_helper'

RSpec.describe PostsHelper, :type => :helper do

  context '#create_new_post_partial_path' do
    it "returns a signed_in partial's path" do
      helper.stub(:user_signed_in?).and_return(true)
      expect(helper.create_new_post_partial_path). to (
        eq 'posts/branch/create_new_post/signed_in'
      )
    end

    it "returns a signed_in partial's path" do
      helper.stub(:user_signed_in?).and_return(false)
      expect(helper.create_new_post_partial_path). to (
        eq 'posts/branch/create_new_post/not_signed_in'
      )
    end
  end

  context '#all_categories_button_partial_path' do
    it "returns an all_selected partial's path" do
      controller.params[:category] = ''
      expect(helper.all_categories_button_partial_path).to (
        eq 'posts/branch/categories/all_selected'
      )
    end

    it "returns an all_not_selected partial's path" do
      controller.params[:category] = 'category'
      expect(helper.all_categories_button_partial_path).to (
        eq 'posts/branch/categories/all_not_selected'
      )
    end
  end

  context '#no_posts_partial_path' do
    it "returns a no_posts partial's path" do
      assign(:posts, [])
      expect(helper.no_posts_partial_path).to (
        eq 'posts/branch/no_posts'
      )
    end

    it "returns an empty partial's path" do
      assign(:posts, [1])
      expect(helper.no_posts_partial_path).to (
        eq 'shared/empty_partial'
      )
    end
  end

  context '#post_format_partial_path' do
    it "returns a home_page partial's path" do
        helper.stub(:current_page?).and_return(true)
        expect(helper.post_format_partial_path).to (
        eq 'posts/post/home_page'
        )
    end

    it "returns a branch_page partial's path" do
        helper.stub(:current_page?).and_return(false)
        expect(helper.post_format_partial_path).to (
        eq 'posts/post/branch_page'
        )
    end
    it 'by_category scope gets posts by particular category' do
        category = create(:category)
        create(:post, category_id: category.id)
        create_list(:post, 10)
        posts = Post.by_category(category.branch, category.name)
        expect(posts.count).to eq 1
        expect(posts[0].category.name).to eq category.name
    end

    it 'by_branch scope gets posts by particular branch' do
        category = create(:category)
        create(:post, category_id: category.id)
        create_list(:post, 10)
        posts = Post.by_branch(category.branch)
        expect(posts.count).to eq 1
        expect(posts[0].category.branch).to eq category.branch
    end

    it 'search finds a matching post' do
        post = create(:post, title: 'awesome title', content: 'great content ' * 5)
        create_list(:post, 10, title: ('a'..'c' * 2).to_a.shuffle.join)
        expect(Post.search('awesome').count).to eq 1
        expect(Post.search('awesome')[0].id).to eq post.id
        expect(Post.search('great').count).to eq 1
        expect(Post.search('great')[0].id).to eq post.id
    end
  end
end