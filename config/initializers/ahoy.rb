# class Ahoy::Store < Ahoy::Stores::ActiveRecordTokenStore
#   # customize here
#   def user
#     if @controller.params[:landing_page]
#       @user = User.find(@controller.params[:landing_page].split('user=').last)
#     else
#       @user_id = Visit.find_by_visit_token(@controller.params[:visit_token]).user_id
#       @user = User.find(@user_id)
#     end
#     @user
#   end
# end
