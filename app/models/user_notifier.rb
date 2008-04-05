class UserNotifier < ActionMailer::Base

  def request_new_password(user)
    @subject    = 'A password reset request'
    @body       = {:user=>user}
    @recipients = user.email
    @from       = "Food Lab <support@foodlab.tv>"
    @sent_on    = Time.now
    @headers    = {}
  end

  def new_password(user, token)
    @subject    = 'Your new password'
    @body       = {:user=>user, :token=>token}
    @recipients = user.email
    @from       = "Food Lab <support@foodlab.tv>"
    @sent_on    = Time.now
    @headers    = {}
  end
  
  def comment(comment)
    @subject    = "#{comment.user.name} left a comment on #{comment.recipe.name}"
    @body       = {:comment=>comment}
    @recipients = comment.recipe.user.email
    @from       = "Food Lab <support@foodlab.tv>"
    @sent_on    = Time.now
    @headers    = {}
  end
end
