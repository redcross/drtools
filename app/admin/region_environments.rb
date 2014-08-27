ActiveAdmin.register RegionEnvironment, as: 'Region Affiliation' do
  permit_params [:region_id]

  actions :all, except: [:show, :edit]

  belongs_to :environment

  index do
    selectable_column
    column(:region) { |re| re.region.try :name }
    actions
  end

  controller do
    defaults collection_name: :region_environments
  end

  form do |f|
    f.inputs do
      f.input :region
    end
    f.actions
  end

end
