class ParticipantsController < ApplicationController
  def index
    @participant_list = Participant.all
  end

  def new
  end

  def create
    unless params[:card_number] or params[:andrewid]
      flash[:error] = "Must provide card number or andrew id"
      redirect_to new_participant_url
    else
      if params[:card_number] != ""
        # There is a card number to lookup

        p = Participant.find_by_card params[:card_number]
        if p.nil? 
          # There is no participant with this card number

          andrewid = CarnegieMellonIDCard.search "#{params[:card_number]}"
          if andrewid.nil?
            
            # There is no andrewid associated with this card
            flash[:error] = "Card lookup failure"
            redirect_to new_participant_url
          else

            # Create a new participant based on the andrewid returned by the
            # card lookup
            Participant.create( :andrewid => andrewid )
            flash[:success] = "Created new participant #{andrewid}"
            redirect_to new_participant_url
          end

        else
          # There is a participant with this card number
          flash[:notice] = "Participant already exists"
          redirect_to new_participant_url
        end # p.nil?
        
      elsif params[:andrewid] != ""
        # There is an andrewid to lookup
        # TODO: verify an andrewid is valid
        Participant.create( :andrewid => params[:andrewid] )
        flash[:success] = "Created new participant #{andrewid}"
        redirect_to new_participant_url
        
      else
        flash[:error] = "Must provide an andrewid or card_number"
        redirect_to new_participant_url

      end #params[:card_number]

    end # unless params[:card_number] or params[:andrewid]
  end

end
