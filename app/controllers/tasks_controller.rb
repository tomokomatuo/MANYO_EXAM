class TasksController < ApplicationController
  before_action :set_task, only: [:show, :edit, :destroy, :update]
  def index
    # @tasks = Task.all
    @tasks = Task.page(params[:page]).per(3)
    if params[:sort_expired].present?
    @tasks = @tasks.order(dead_line: :desc).page(params[:page]).per(3)
    else
    @tasks
    end

    if params[:sort_priority].present?
      @tasks = @tasks.order(priority: :asc).page(params[:page]).per(3)
      else
      @tasks
      end
    
    if params[:task].present? && params[:task][:search].present?
      if params[:task][:title].present? && params[:task][:condition].present?
        @tasks = Task.both_search(params[:task][:title],params[:task][:condition]).page(params[:page]).per(3)
      elsif params[:task][:title].present?
        @tasks = Task.title_search(params[:task][:title]).page(params[:page]).per(3)
      elsif params[:task][:condition].present?
        @tasks = Task.condition_search(params[:task][:condition]).page(params[:page]).per(3)
      end
    end
  end
  
  def new
    @task = Task.new
  end

  def create
    @task = Task.new(task_params)
    if @task.save
      redirect_to tasks_path, notice: t('view.create_task')
    else
      render :new
    end
  end

  def show
  end

  def edit
  end

  def update
    if @task.update(task_params)
      redirect_to tasks_path, notice: t('view.update_task')
    else
      render :edit
    end
  end

  def destroy
    @task.destroy
    redirect_to tasks_path, notice: t('view.delete_task')
  end

  

  private

  def task_params
    params.require(:task).permit(:title, :content, :dead_line, :condition, 
                                 :priority, :author, :sort_expired, :search, :sort_priority, :page)
  end

  def set_task
    @task = Task.find(params[:id])
  end
end
