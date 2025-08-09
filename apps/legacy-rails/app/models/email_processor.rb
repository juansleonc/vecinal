class EmailProcessor
    
    #before_action :method

    def initialize(email)
        @email = email
    end

    def process
        user = User.find_by_email(@email.from[:email])
        if user.present?
            @email.to.each do |to|
                if to[:host] == 'parse.condo-media.com'
                    email_split =  to[:token].split('@')
                    token_split = email_split[0].split('.')
                    commentable_type = Base64.strict_decode64(token_split[1])
                    commentable_id = token_split[0]
                    content = @email.body
                    if commentable_id.present? && commentable_type.present?
                        case commentable_type
                        when "Comment"
                            parent_comment = Comment.find commentable_id
                            if parent_comment.present?
                                Comment.create user_id: user.id, commentable_type: commentable_type, commentable_id: parent_comment.commentable_id, content: content
                            end
                        else
                            if @email.subject.include?('replied to your comment on Condo Media') || @email.subject.include?('respondió a su comentario en Condo Media')
                                parent_comment = Comment.find commentable_id
                                if parent_comment.present?
                                    commentable_id = parent_comment.commentable_id
                                end
                            end
                            Comment.create user_id: user.id, commentable_type: commentable_type, commentable_id: commentable_id, content: content
                        end
                    end
                end
            end
        end
    end
end