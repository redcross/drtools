ActiveAdmin.register UserEnvironment, as: 'UserEnvironment' do
  permit_params [:member_number, role_strings: []]

  actions :all, except: [:show]

  belongs_to :environment

  index do
    selectable_column
    column :member_number
    column(:user) { |ue| ue.user.try :full_name }
    column(:roles) { |ue| ue.roles_string }
    actions
  end

  controller do
    defaults collection_name: :user_environments

    helper do
      def roles_collection
        Roles.roles.sort_by{|role| role.label}.map{|role| [role.label, role.value]}
      end
    end
  end

  form do |f|
    f.inputs do
      f.input :member_number
      f.input :role_strings, as: :check_boxes, collection: roles_collection, label: 'Roles'
    end
    f.actions
  end

end
