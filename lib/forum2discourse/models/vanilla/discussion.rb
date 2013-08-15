class Forum2Discourse::Models::Vanilla::Discussion
  include DataMapper::Resource

  storage_names[:default] = 'GDN_Discussion'

  property :id,           Serial, field: 'DiscussionID'
  property :created_at,   DateTime, field: 'DateInserted'
  property :category_id,  Integer, field: 'CategoryID'
  property :subject,      Text, field: 'Name'
  property :body,         Text, field: 'Body'
  property :user_id,       Text, field: 'InsertUserId'

  has n, :comments, 'Forum2Discourse::Models::Vanilla::Comment'
  belongs_to :category, 'Forum2Discourse::Models::Vanilla::Category'

  def to_discourse
    return nil if category.nil?

    bodyComment = Forum2Discourse::Models::Vanilla::Comment.new

    send("created_at=", created_at)
    send("discussion_id=", id)
    send("user_id=", user_id)
    send("body=", body)

    comments.push(bodyComment)

    Forum2Discourse::Models::Discourse::Topic.new({
      title: subject,
      created_at: created_at,
      category: category.name,
      posts: comments.map(&:to_discourse)
    })
  end
end
