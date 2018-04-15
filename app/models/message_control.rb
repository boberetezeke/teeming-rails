class MessageControl < ApplicationRecord
  belongs_to :member

  CONTROL_SUBSCRIPTION_TYPE_EMAIL = 'email'
  CONTROL_SUBSCRIPTION_TYPE_PHONE = 'phone'
  CONTROL_SUBSCRIPTION_TYPE_TEXT  = 'text'

  CONTROL_TYPE_UNSUBSCRIBE =  'unsubscribe'
  CONTROL_TYPE_NEUTRAL =      'neutral'
  CONTROL_TYPE_AFFIRM =       'affirm'

  CONTROL_TYPES = {
      "Don't contact me" => CONTROL_TYPE_UNSUBSCRIBE,
      "I'm ok with contacts" => CONTROL_TYPE_NEUTRAL,
      "Please keep me up to date" => CONTROL_TYPE_AFFIRM
  }
end