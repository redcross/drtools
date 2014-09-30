ActiveAdmin.register User do
  permit_params [:region_id, :role_strings => []]

  actions :all

  index do
    selectable_column
    column :full_name
    column :member_number
    column(:region)# { |re| re.region.try :name }
    column :last_sign_in_at
    actions
  end

  controller do
    helper do
      def roles_collection
        Roles.roles.sort_by{|role| role.label}.map{|role| [role.label, role.value]}
      end
    end
  end

  form do |f|
    f.inputs do
      f.input :role_strings, as: :check_boxes, collection: roles_collection, label: 'Global Roles'
    end
    f.actions
  end

end
