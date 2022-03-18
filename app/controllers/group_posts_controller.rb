class GroupPostsController < ApplicationController


  def show
    @group=Group.find(params[:group_id])
    @group_posts=GroupPost.where(group_id:@group.id)
    @group_post=GroupPost.new
  end

  def create
    @group=Group.find(params[:group_id])
    @group_post=GroupPost.new(group_post_params)
    @group_post.user_id=current_user.id
    @group_post.group_id=params[:group_id]
    @group_post.save
    redirect_to request.referer
  end

  def destroy
    @group_post=GroupPost.find(params[:id])
    @group_post.destroy
    redirect_to request.referer
  end

  private

  def group_post_params
    params.require(:group_post).permit(:content)
  end



end
