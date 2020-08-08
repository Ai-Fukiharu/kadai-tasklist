class TasksController < ApplicationController
  before_action :set_task, only: [:show, :edit, :update, :destroy]
  before_action :require_user_logged_in
  
  def index
    @tasks = Task.all
  end

  def show
    
  end

  def new
    @task = Task.new
  end

  def create
    @task = current_user.tasks.build(task_params)
    if @task.save
      flash[:success] = 'Taskを追加しました。'
      redirect_to root_url
    else
      @tasks = current_user.tasks.order(id: :desc).page(params[:page])
      flash.now[:danger] = 'Taskの追加に失敗しました。'
      render :new
    end
  end

  def edit
    unless @task.user_id == @current_user.id
      flash[:danger] = "権限がありません"
      redirect_to root_url
    end
  end

  def update
    
    
    if @task.user_id==current_user.id && @task.update(task_params)
      flash[:success] = "Taskは正常に更新されました"
      redirect_to @task
    else
      flash.now[:danger] = "Taskは更新されませんでした"
      render :edit
    end
  end

  def destroy
    
    @task.destroy
    
    flash[:success] = "Taskは正常に削除されました"
    redirect_to tasks_url
  end
  
  private
  
  def set_task
    @task = Task.find(params[:id])
  end
  
  # Strong Parameter
  def task_params
    params.require(:task).permit(:content,:status)
  end
  
  def correct_user
    @task = @current_user.tasks.find_by(id: params[:id])
    unless @task
      redirect_to root_url
    end
  end
end
