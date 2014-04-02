class Users::UploadsController < UsersController
  expose(:uploads){ Upload.order("id DESC").scoped{} }
  expose(:upload, attributes: :upload_params)

  after_filter :process_file, :only => [:create]

  def create
    upload.created_by = current_user.id
    if upload.save
      flash[:notice] = 'Upload was successfully created'
      redirect_to users_uploads_path
    else
      render :new
    end
  end

  private
  def upload_params
    params.require(:upload).permit(
      :file,
      :facility_id,
      :name,
      :file,
    )
  end

  def process_file
    file = File.open("#{Rails.root}/public"+ upload.file_url, 'r+')
    File.read(file).split("\n").each_with_index do |row, index|
      column = row.split("\t")
      if index == 0
        puts column
      else
        purchaser_name = column[0]
        item_description = column[1]
        item_price = column[2]
        purchase_count = column[3]
        merchant_address = column[4]
        merchant_name = column[5]
        Temp.create(purchaser_name: purchaser_name, item_description: item_description, item_price: item_price, purchase_count: purchase_count, merchant_address: merchant_address, merchant_name: merchant_name)
      end
    end
  end
end
