class UserLogin
  def initialize(auth)
    @auth = auth
    @client = ARCData::Client.new(auth['credentials']['token'])
  end

  attr_reader :user, :auth, :client

  def login!
    @user = User.find_or_create_by(provider: auth['provider'], uid: auth['uid'])

    update_from_auth
    update_from_api
    update_region_if_needed user.region_id

    user.save!
    user
  end

  def update_from_auth
    @user.token = auth['credentials']['token']

    info = auth['info']
    ['first_name', 'last_name', 'email'].each do |attr|
      @user[attr] = info[attr] unless info[attr].nil?
    end
  end

  def update_from_api
    data = client.person.get_person

    user.member_number = data['vc_member_number']
    user.vc_is_active = data['vc_is_active']
    user.region_id = data['chapter_id']

    update_deployments data['deployments']
  end

  def update_region_if_needed region_id
    region = Region.find_or_initialize_by(id: region_id)
    data = client.region.get region_id
    region.name = data['name']
    region.short_name = data['short_name']
    region.save!
  end

  def update_deployments deployments
    deployments.each do |deployment|
      dep = @user.deployments.find_or_initialize_by dr_number: deployment['dr_number'], gap: deployment['gap']
      dep.dr_name = deployment['name']
      dep.assign_date = deployment['assign_date']
      dep.release_date = deployment['release_date']
    end
  end
end