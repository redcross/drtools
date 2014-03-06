ActiveAdmin.register Territory do
  permit_params [:name, :description, :ordinal, territory_scopes_attributes: [:id, :_destroy, :scope_type, :unit_code]]

  belongs_to :environment

  index do
    selectable_column
    id_column
    column :name
    column :ordinal
    actions
  end

  form do |f|
    f.inputs do
      f.input :name
      f.input :description
      f.input :ordinal
    end
    f.inputs do
      f.has_many :territory_scopes, allow_destroy: true, heading: 'Scopes', new_record: true do |ts|
        ts.input :scope_type, as: :assignable_select_admin
        ts.input :unit_code
      end
    end
    f.actions
  end

end
