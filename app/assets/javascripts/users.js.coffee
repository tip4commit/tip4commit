$(document).ready ()->
  $('.registration_form').bootstrapValidator
    message: "Value is invalid"
    fields:
      "user[email]":
        validators:
          emailAddress:
            message: "Invalid Email Address"
          notEmpty:
            message: 'The Email is required and can\'t be empty' 
          
      "user[password]":
        validators:
          notEmpty:
            message: 'The password is required and can\'t be empty'
          identical:
            field: 'user[password_confirmation]' 
            message: 'The password and its confirmation are not same'
      
      "user[password_confirmation]":
        validators:
          notEmpty:
            message: 'The password confirmation is required and can\'t be empty'
          identical:
            field: 'user[password]' 
            message: 'The password and its confirmation are not same'       
  $('.session_form').bootstrapValidator
    message: "Value is invalid"
    fields:
      "user[email]":
        validators:
          emailAddress:
            message: "Invalid Email Address"
          notEmpty:
            message: 'The Email is required and can\'t be empty' 
          
      "user[password]":
        validators:
          notEmpty:
            message: 'The password is required and can\'t be empty'
      
