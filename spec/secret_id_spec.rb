require 'spec_helper'
require 'active_record'

silence_warnings do
  ActiveRecord::Migration.verbose = false
  ActiveRecord::Base.logger = Logger.new(nil)
  ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: ':memory:')
end

ActiveRecord::Base.connection.instance_eval do
  create_table :users

  create_table :posts do |t|
    t.references :user, index: true
    t.boolean :visible, default: true
  end
end

class User < ActiveRecord::Base
  has_many :posts
end

class Post < ActiveRecord::Base
  extend SecretId

  secret_id
end

describe SecretId do
  context "Post model with default options" do
    before(:all) do
      @user = User.create
      @post = Post.create(user_id: @user.id)
    end

    describe ".secret_id" do
      it { expect(@post.secret_id).to eq("v40") }
    end

    describe ".to_param" do
      it { expect(@post.to_param).to eq("v40") }
    end

    describe ".decode_id" do
      it { expect(Post.decode_id("v40")).to eq(1) }
      it { expect{Post.decode_id("invalid_secret_id")}.to raise_error(SecretId::NotDecodable) }
    end

    describe ".encode_id" do
      it { expect(Post.encode_id(1)).to eq("v40") }
    end

    describe ".find" do
      it { expect(Post.find("v40")).to eq(@post) }
      it { expect{Post.find("invalid_secret_id")}.to raise_error(ActiveRecord::RecordNotFound) }

      describe "with secret_id: false" do
        it { expect(Post.find(1, secret_id: false)).to eq(@post) }
      end

      describe "in relation context" do
        it { expect(@user.posts.find("v40")).to eq(@post) }

        describe "with secret_id: false" do
          it { expect(@user.posts.find(1, secret_id: false)).to eq(@post) }
        end
      end
    end

    describe ".where" do
      it { expect(Post.where(visible: true).find("v40")).to eq(@post) }
    end
  end
end
