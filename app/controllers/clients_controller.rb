class ClientsController < ApplicationController
  before_action :set_client, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @clients = Client.all
    respond_with(@clients)
  end

  def show
    respond_with(@client)
  end

  def new
    @client = Client.new
    respond_with(@client)
  end

  def edit
  end

  def create
    @client = Client.new(client_params)
    if @client.save
      #respond_with(@client)

      redirect_to clients_path
      flash[:notice]=" Client Successfully Created"
    else
      render "new"
    end
  end  

  def update
    if @client.update(client_params)
      redirect_to clients_path
       #respond_with(@client)
       flash[:notice]="Client Successfully Updated"
    else
     render "new"
    end  
  end

  def destroy
    @client.destroy
    respond_with(@client)
    flash[:notice]="Client Successfully Deleted"
  end

  def sample_csv
     respond_to do |format|
      format.html
      format.csv { send_data Client.file_generate }
     end
  end  

  private
    def set_client
      @client = Client.find(params[:id])
    end

    def client_params
      params.require(:client).permit(:name, :street, :pincode, :city, :state, :country, contacts_attributes: [:id,:name,:designation,:email,:telephone_number,:mobile_number,:client_id, :_destroy])
    end
end















    


