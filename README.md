# SecretId

[![Gem Version](https://badge.fury.io/rb/secret_id.svg)](https://badge.fury.io/rb/secret_id)
[![Code Climate](https://codeclimate.com/github/limcross/secret_id/badges/gpa.svg)](https://codeclimate.com/github/limcross/secret_id)

SecretId is a flexible masking identifiers solution for Rails with [Hashids](https://github.com/peterhellberg/hashids.rb).

__This gem does not guarantee the security of masked ids, since Hasids it is reversible.__

## Getting started

You can add it to your `Gemfile`:

```ruby
gem 'secret_id'
```

Run the bundle command to install it.

### Configuring models
After that, extends the model to `SecretId` and add a single line `secret_id` to this, like below.

```ruby
class Post < ActiveRecord::Base
  extend SecretId

  secret_id
end
```

Now you can try it in your `rails console`.

```ruby
> post = Post.create
=> #<Post id: 1, ...>

> post.id
=> 1

> post.secret_id
=> "v40"
```

#### Options

  * __salt__: If you want your identifiers to be different than some other website that are using the same gem, you can use a random string. By default is the name of the model. _Note that this change means that all encoded values will change, therefore any stored url will be invalid_.
  * __min_length__: The smallest possible length of encoded value, by default is set to 3.
  * __alphabet__: Possible characters in what will consist the encoded value, default is a alphanumeric case sensitive string.

```ruby
class Post < ActiveRecord::Base
  extend SecretId

  secret_id salt: 'bring_your_own_salt', min_length: 5,
    alphabet: 'define_your_own_alphabet'
end
```

### Configuring views
In your views, use `@post` or `@post.secret_id` instead of `@post.id` for create links, like below.

```erd
<%= link_to @post %>

<%= link_to @post.secret_id %>
```

And if you want to show the id remember use `secret_id` method.

### Configuring controllers
For controllers, you only can find the resource with the method `find` (At least for now). For example, suppose you have a `before_action` for action `show` to `find_post` method, like below.

```ruby
def find_post
  @post = Post.find(params[:id])
end
```

The above works without problem (even if instead of `params[:id]`, it were a set of ids). But the next example __it will not work__.

```ruby
def find_post
  @post = Post.find_by!(id: params[:id])
end
```

This method, as `find_by`, `where`, and everything like that, its not working for now. But not all is lost. If you want scope your result you can do something like this.

```ruby
def find_post
  @post = Post.where(visible: true).find(params[:id])
end
```

Another good news is that this runs smoothly.

```ruby
current_user.posts.find(params[:id])
```

And now when you access to `post#show`, will be seen in the URL `v40` instead of `1`.
