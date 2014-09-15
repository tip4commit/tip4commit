load_bootstrap_validator = ->
  $('.registration_form').bootstrapValidator
    message: I18n.t('js.errors.value.invalid')
    fields:
      "user[email]":
        validators:
          emailAddress:
            message: I18n.t('js.errors.email.invalid')
          notEmpty:
            message: I18n.t('js.errors.email.blank')

      "user[password]":
        validators:
          notEmpty:
            message: I18n.t('js.errors.password.blank')
          identical:
            field: 'user[password_confirmation]'
            message: I18n.t('js.errors.password.invalid')

      "user[password_confirmation]":
        validators:
          notEmpty:
            message: I18n.t('js.errors.password_confirmation.blank')
          identical:
            field: 'user[password]'
            message: I18n.t('js.errors.password_confirmation.invalid')
  $('.session_form').bootstrapValidator
    message: I18n.t('js.errors.value.invalid')
    fields:
      "user[email]":
        validators:
          emailAddress:
            message: I18n.t('js.errors.email.invalid')
          notEmpty:
            message: I18n.t('js.errors.email.blank')

      "user[password]":
        validators:
          notEmpty:
            message: I18n.t('js.errors.password_confirmation.blank')

$(document).on "ready page:load", load_bootstrap_validator
