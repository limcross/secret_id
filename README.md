# SecretId

[![Build Status](https://travis-ci.org/limcross/secret_id.svg?branch=master)](https://travis-ci.org/limcross/secret_id)
[![Gem Version](https://badge.fury.io/rb/secret_id.svg)](https://badge.fury.io/rb/secret_id)
[![Code Climate](https://codeclimate.com/github/limcross/secret_id/badges/gpa.svg)](https://codeclimate.com/github/limcross/secret_id)

SecretId is a flexible solution for masking the identifiers of ActiveRecord. Using the [Hashids.rb](https://github.com/peterhellberg/hashids.rb) gem we encode the value of your defined primary key to hide the real value to the user.

__This gem does not guarantee the security of masked ids, since Hashids it is reversible.__

## Getting started

You can add it to your `Gemfile`:

```ruby
gem 'secret_id'
```

Run the bundle command to install it.

### Configuring models
After that, extend the model to `SecretId` and add `secret_id` to this, like below.

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

> Post.find("v40")
=> #<Post id: 1, ...>

> Post.find(1, secret_id: false)
=> #<Post id: 1, ...>

> Post.decode_id("v40")
=> 1

> Post.encode_id(1234567890)
=> "xrjlkB1"
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
In your views, use `@post` or `@post.secret_id` instead of `@post.id` for create links, like any of below.

```erb
<%= link_to "Post", @post %>

<%= link_to "Post", post_path(@post) %>

<%= link_to "Post", post_path(@post.secret_id) %>
```

And if you want to show the id remember use `secret_id` method.

### Configuring controllers
For controllers, you only can find the resource with the method `find` (At least for now). For example, suppose you have a `before_action` for action `show` to `find_post` method, like below.

```ruby
def find_post
  @post = Post.find(params[:id])
end
```

Another good news is that this runs smoothly over associations.

```ruby
def find_user_post
  current_user.posts.find(params[:id])
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

But if you are stubborn you can always use the wildcard for decode id manually.

```ruby
def find_post
  @post = Post.find_by!(id: Post.decode_id(params[:id]))
end
```
_I personally do not recommend this, because if the parameter is not a valid encoded id, it will look for the id `nil`._

## Contributing
Any contribution is welcome.

### Reporting issues

Please try to answer the following questions in your bug report:

- What did you do?
- What did you expect to happen?
- What happened instead?

Make sure to include as much relevant information as possible. Ruby version,
SecretId version, OS version and any stack traces you have are very valuable.

### Pull Requests

- __Add tests!__ Your patch won't be accepted if it doesn't have tests.

- __Document any change in behaviour__. Make sure the README and any  relevant documentation are kept up-to-date.

- __Create topic branches__. Please don't ask us to pull from your master branch.

- __One pull request per feature__. If you want to do more than one thing, send multiple pull requests.

- __Send coherent history__. Make sure each individual commit in your pull request is meaningful. If you had to make multiple intermediate commits while developing, please squash them before sending them to us.
