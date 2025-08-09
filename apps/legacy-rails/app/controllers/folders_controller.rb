class FoldersController < ApplicationController

  load_and_authorize_resource
  skip_load_resource only: :index

  def index
    if current_user.resident? || current_user.board_member? || current_user.tenant?  || current_user.agent? 
      redirect_to folder_path(current_user.root_folders.first)
    elsif current_user.admin? || current_user.collaborator?
      params[:order] ||= 'asc'
      #@folders = set_pagination current_user.root_folders, Folder::PER_PAGE, order_by: :name
      if params[:order] == 'last'
        @folders = current_user.root_folders.order(:id => 'DESC').paginate(page: params[:page], per_page: Folder::PER_PAGE)
      elsif params[:order] == 'oldest'
        @folders = current_user.root_folders.order(:id => 'ASC').paginate(page: params[:page], per_page: Folder::PER_PAGE)
      else
        @folders = current_user.root_folders.order(:name => params[:order]).paginate(page: params[:page], per_page: Folder::PER_PAGE)
      end
      @total = @folders.count
      @order = %w[asc desc last oldest].include?(params[:order]) ? params[:order].to_sym : :desc

      load_more_at_bottom_respond_to @folders
    else
      @folders = set_pagination Folder.none, Folder::PER_PAGE, order_by: :name
    end
  end

  def show
    params[:order] ||= 'asc'
    @sub_folders = @folder.sub_folders.order(name: params[:order].to_sym)
    @attachments = set_pagination @folder.attachments, Folder::PER_PAGE, order_by: :file_attachment_file_name
    load_more_at_bottom_respond_to @attachments, partial: 'folders/attachment'
  end

  def create
    @folder.save
  end

  def update
    @folder.update update_params
  end

  def destroy
    @folder.father.update_sizes @folder.size, :rem if @folder.destroy
  end

  def add_attachments
    if add_attachment_params[:file_attachments].size > Attachment::MAX_FILES
      @error = t 'folders.errors.limit_files', number: Attachment::MAX_FILES
    else
      @attachments = []
      total_size = 0
      add_attachment_params[:file_attachments].each do |file|
        attachment = Attachment.new(file_attachment: file, created_by: current_user, attachmentable: @folder)
        total_size += attachment.file_attachment_file_size if attachment.save
        @attachments << attachment
      end
      @folder.update_sizes total_size
    end
  end

  def update_attachment
    @attachment = @folder.attachments.find params[:attachment_id]
    @attachment.update update_attachment_params
  end

  def destroy_attachment
    @attachment = @folder.attachments.find params[:attachment_id]
    attachment_size = @attachment.file_attachment_file_size
    @folder.update_sizes attachment_size, :rem if @attachment.destroy
  end

  def search
    
    if params[:b].present?
      @folders = @folders.where(folderable_id: params[:b])
    elsif params[:c].present?
      @folders = @folders.where(folderable_id: params[:c])
    end
    
    @attachments = set_pagination(Attachment.where(attachmentable: @folders).search_by(params[:query]),
      Attachment::PER_PAGE, order_by: :file_attachment_file_name
    )
    @folders = @folders.search_by(params[:query])

    @total_invites = 0
    list_accountables  = []

    @folders.each do |folder|
      list_accountables.push(folder.folderable_type + '-' + folder.folderable_id.to_s)
    end
    @attachments.each do |attachment|
      list_accountables.push(attachment.attachmentable.folderable_type + '-' + attachment.attachmentable.folderable_id.to_s)
    end
    
    
    
    @contacts_by_accountable = []
    if current_user.accountable.class.name == 'Company'
      
      data = 'Company-' + current_user.accountable.id.to_s
      qty = 0
      list_accountables.each do |accountable|
        if data == accountable
          qty += 1
        end
      end
      @contacts_by_accountable.push(data => qty);
      
    end
    current_user.buildings.each do |building|
      data = 'Building-' + building.id.to_s
      qty = 0
      list_accountables.each do |accountable|
        if data == accountable
          qty += 1
        end
      end
      @contacts_by_accountable.push(data => qty);
    end
    
    

    

    

    load_more_at_bottom_respond_to @attachments, html: 'search_results', partial: 'folders/attachment'
  end

private

  def create_params
    params.require(:folder).permit(:name, :father_id).merge(created_by: current_user)
  end

  def update_params
    params.require(:folder).permit(:name)
  end

  def add_attachment_params
    params.require(:attachment).permit(file_attachments: [])
  end

  def update_attachment_params
    params.require(:attachment).permit(:file_attachment_file_name)
  end

end
