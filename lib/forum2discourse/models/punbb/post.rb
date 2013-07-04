class Forum2Discourse::Models::PunBB::Post
  include DataMapper::Resource

  storage_names[:default] = "posts"

  property :id,         Serial
  property :poster,     String
  property :poster_id,  Integer
  property :poster_email, String
  property :message,    Text
  property :posted,     EpochTime
  property :topic_id,   Integer

  belongs_to :topic, 'Forum2Discourse::Models::PunBB::Topic'
  belongs_to :user, 'Forum2Discourse::Models::PunBB::User', child_key: [ :poster_id ]

  def assumed_email
    poster_email.blank? ? 'user@example.com' : poster_email
  end

  def to_discourse
    duser = if user
              user.to_discourse
            else
              Forum2Discourse::Models::Discourse::User.new({username: poster, email: assumed_email, name: poster})
            end

    Forum2Discourse::Models::Discourse::Post.new({
      title: '',
      category: topic.forum.forum_name,
      user: duser,
      raw: message,
      created_at: posted
    })
  end
end
