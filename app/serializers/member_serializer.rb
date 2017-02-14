class MemberSerializer < ActiveModel::Serializer
  attributes :id, :databank_id, :status, :address_1, :address_2, :city,
    :company, :email, :first_name, :home_phone, :last_name, :middle_initial,
    :mobile_phone, :state, :work_phone, :zip
end
