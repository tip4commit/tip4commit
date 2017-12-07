var I18n = I18n || {};
I18n.translations = {
  "en": {
    "date": {
      "formats": {
        "default": "%Y-%m-%d",
        "short": "%b %d",
        "long": "%B %d, %Y"
      },
      "day_names": ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"],
      "abbr_day_names": ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"],
      "month_names": [null, "January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"],
      "abbr_month_names": [null, "Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"],
      "order": ["year", "month", "day"]
    },
    "time": {
      "formats": {
        "default": "%a, %d %b %Y %H:%M:%S %z",
        "short": "%d %b %H:%M",
        "long": "%B %d, %Y %H:%M"
      },
      "am": "am",
      "pm": "pm"
    },
    "support": {
      "array": {
        "words_connector": ", ",
        "two_words_connector": " and ",
        "last_word_connector": ", and "
      }
    },
    "number": {
      "format": {
        "separator": ".",
        "delimiter": ",",
        "precision": 3,
        "significant": false,
        "strip_insignificant_zeros": false
      },
      "currency": {
        "format": {
          "format": "%u%n",
          "unit": "$",
          "separator": ".",
          "delimiter": ",",
          "precision": 2,
          "significant": false,
          "strip_insignificant_zeros": false
        }
      },
      "percentage": {
        "format": {
          "delimiter": "",
          "format": "%n%"
        }
      },
      "precision": {
        "format": {
          "delimiter": ""
        }
      },
      "human": {
        "format": {
          "delimiter": "",
          "precision": 3,
          "significant": true,
          "strip_insignificant_zeros": true
        },
        "storage_units": {
          "format": "%n %u",
          "units": {
            "byte": {
              "one": "Byte",
              "other": "Bytes"
            },
            "kb": "KB",
            "mb": "MB",
            "gb": "GB",
            "tb": "TB"
          }
        },
        "decimal_units": {
          "format": "%n %u",
          "units": {
            "unit": "",
            "thousand": "Thousand",
            "million": "Million",
            "billion": "Billion",
            "trillion": "Trillion",
            "quadrillion": "Quadrillion"
          }
        }
      }
    },
    "errors": {
      "format": "%{attribute} %{message}",
      "messages": {
        "inclusion": "is not included in the list",
        "exclusion": "is reserved",
        "invalid": "is invalid",
        "confirmation": "doesn't match %{attribute}",
        "accepted": "must be accepted",
        "empty": "can't be empty",
        "blank": "can't be blank",
        "present": "must be blank",
        "too_long": "is too long (maximum is %{count} characters)",
        "too_short": "is too short (minimum is %{count} characters)",
        "wrong_length": "is the wrong length (should be %{count} characters)",
        "not_a_number": "is not a number",
        "not_an_integer": "must be an integer",
        "greater_than": "must be greater than %{count}",
        "greater_than_or_equal_to": "must be greater than or equal to %{count}",
        "equal_to": "must be equal to %{count}",
        "less_than": "must be less than %{count}",
        "less_than_or_equal_to": "must be less than or equal to %{count}",
        "other_than": "must be other than %{count}",
        "odd": "must be odd",
        "even": "must be even",
        "taken": "has already been taken",
        "already_confirmed": "was already confirmed, please try signing in",
        "confirmation_period_expired": "needs to be confirmed within %{period}, please request a new one",
        "expired": "has expired, please request a new one",
        "not_found": "not found",
        "not_locked": "was not locked",
        "not_saved": {
          "one": "1 error prohibited this %{resource} from being saved:",
          "other": "%{count} errors prohibited this %{resource} from being saved:"
        }
      },
      "project_not_found": "Project not found.",
      "access_denied": "You are not authorized to perform this action!",
      "can_assign_more_tips": "You can't assign more than 100% of available funds.",
      "wrong_bitcoin_address": "Error updating bitcoin address",
      "user_not_found": "User not found"
    },
    "activerecord": {
      "errors": {
        "messages": {
          "record_invalid": "Validation failed: %{errors}",
          "restrict_dependent_destroy": {
            "one": "Cannot delete record because a dependent %{record} exists",
            "many": "Cannot delete record because dependent %{record} exist"
          }
        }
      },
      "attributes": {
        "user": {
          "email": "E-mail",
          "bitcoin_address": "Bitcoin address",
          "password": "Password",
          "password_confirmation": "Password confirmation"
        }
      }
    },
    "datetime": {
      "distance_in_words": {
        "half_a_minute": "half a minute",
        "less_than_x_seconds": {
          "one": "less than 1 second",
          "other": "less than %{count} seconds"
        },
        "x_seconds": {
          "one": "1 second",
          "other": "%{count} seconds"
        },
        "less_than_x_minutes": {
          "one": "less than a minute",
          "other": "less than %{count} minutes"
        },
        "x_minutes": {
          "one": "1 minute",
          "other": "%{count} minutes"
        },
        "about_x_hours": {
          "one": "about 1 hour",
          "other": "about %{count} hours"
        },
        "x_days": {
          "one": "1 day",
          "other": "%{count} days"
        },
        "about_x_months": {
          "one": "about 1 month",
          "other": "about %{count} months"
        },
        "x_months": {
          "one": "1 month",
          "other": "%{count} months"
        },
        "about_x_years": {
          "one": "about 1 year",
          "other": "about %{count} years"
        },
        "over_x_years": {
          "one": "over 1 year",
          "other": "over %{count} years"
        },
        "almost_x_years": {
          "one": "almost 1 year",
          "other": "almost %{count} years"
        }
      },
      "prompts": {
        "year": "Year",
        "month": "Month",
        "day": "Day",
        "hour": "Hour",
        "minute": "Minute",
        "second": "Seconds"
      }
    },
    "helpers": {
      "select": {
        "prompt": "Please select"
      },
      "submit": {
        "create": "Create %{model}",
        "update": "Update %{model}",
        "submit": "Save %{model}"
      },
      "page_entries_info": {
        "one_page": {
          "display_entries": {
            "zero": "No %{entry_name} found",
            "one": "Displaying \u003Cb\u003E1\u003C/b\u003E %{entry_name}",
            "other": "Displaying \u003Cb\u003Eall %{count}\u003C/b\u003E %{entry_name}"
          }
        },
        "more_pages": {
          "display_entries": "Displaying %{entry_name} \u003Cb\u003E%{first}\u0026nbsp;-\u0026nbsp;%{last}\u003C/b\u003E of \u003Cb\u003E%{total}\u003C/b\u003E in total"
        }
      },
      "actions": "Actions",
      "links": {
        "back": "Back",
        "cancel": "Cancel",
        "confirm": "Are you sure?",
        "destroy": "Delete",
        "new": "New",
        "edit": "Edit"
      },
      "titles": {
        "edit": "Edit %{model}",
        "save": "Save %{model}",
        "new": "New %{model}",
        "delete": "Delete %{model}"
      }
    },
    "views": {
      "pagination": {
        "first": "\u0026laquo; First",
        "last": "Last \u0026raquo;",
        "previous": "\u0026lsaquo; Prev",
        "next": "Next \u0026rsaquo;",
        "truncate": "\u0026hellip;"
      }
    },
    "devise": {
      "confirmations": {
        "confirmed": "Your account was successfully confirmed. Please sign in.",
        "send_instructions": "You will receive an email with instructions about how to confirm your account in a few minutes.",
        "send_paranoid_instructions": "If your email address exists in our database, you will receive an email with instructions about how to confirm your account in a few minutes.",
        "confirmed_and_signed_in": "Your account was successfully confirmed. You are now signed in.",
        "new": {
          "title": "Resend confirmation instructions",
          "submit": "Resend confirmation instructions"
        }
      },
      "failure": {
        "already_authenticated": "You are already signed in.",
        "inactive": "Your account is not activated yet.",
        "invalid": "Invalid email or password.",
        "locked": "Your account is locked.",
        "last_attempt": "You have one more attempt before your account will be locked.",
        "not_found_in_database": "Invalid email or password.",
        "timeout": "Your session expired. Please sign in again to continue.",
        "unauthenticated": "You need to sign in or sign up before continuing.",
        "unconfirmed": "You have to confirm your account before continuing.",
        "invalid_token": "Invalid authentication token."
      },
      "mailer": {
        "confirmation_instructions": {
          "subject": "Confirmation instructions"
        },
        "reset_password_instructions": {
          "subject": "Reset password instructions"
        },
        "unlock_instructions": {
          "subject": "Unlock Instructions"
        }
      },
      "omniauth_callbacks": {
        "failure": "Could not authenticate you from %{kind} because \"%{reason}\".",
        "success": "Successfully authenticated from %{kind} account."
      },
      "passwords": {
        "no_token": "You can't access this page without coming from a password reset email. If you do come from a password reset email, please make sure you used the full URL provided.",
        "send_instructions": "You will receive an email with instructions about how to reset your password in a few minutes.",
        "send_paranoid_instructions": "If your email address exists in our database, you will receive a password recovery link at your email address in a few minutes.",
        "updated": "Your password was changed successfully. You are now signed in.",
        "updated_not_active": "Your password was changed successfully.",
        "new": {
          "title": "Forgot your password?",
          "submit": "Send me reset password instructions"
        },
        "edit": {
          "title": "Change your password",
          "submit": "Change my password"
        }
      },
      "registrations": {
        "destroyed": "Bye! Your account was successfully cancelled. We hope to see you again soon.",
        "signed_up": "Welcome! You have signed up successfully.",
        "signed_up_but_inactive": "You have signed up successfully. However, we could not sign you in because your account is not yet activated.",
        "signed_up_but_locked": "You have signed up successfully. However, we could not sign you in because your account is locked.",
        "signed_up_but_unconfirmed": "A message with a confirmation link has been sent to your email address. Please open the link to activate your account.",
        "update_needs_confirmation": "You updated your account successfully, but we need to verify your new email address. Please check your email and click on the confirm link to finalize confirming your new email address.",
        "updated": "You updated your account successfully.",
        "new": {
          "title": "Sign up",
          "submit": "Sign up"
        }
      },
      "sessions": {
        "signed_in": "Signed in successfully.",
        "signed_out": "Signed out successfully.",
        "new": {
          "title": "Sign in",
          "remember_me": "Remember me",
          "submit": "Sign in"
        }
      },
      "unlocks": {
        "send_instructions": "You will receive an email with instructions about how to unlock your account in a few minutes.",
        "send_paranoid_instructions": "If your account exists, you will receive an email with instructions about how to unlock it in a few minutes.",
        "unlocked": "Your account has been unlocked successfully. Please sign in to continue."
      },
      "links": {
        "sign_in": "Sign in",
        "sign_up": "Sign up",
        "recover": "Forgot your password?",
        "confirm": "Didn't receive confirmation instructions?",
        "sign_in_with": "Sign in with %{provider}"
      },
      "errors": {
        "primary_email": "your primary email address should be verified.",
        "onmiauth_info": "we were unable to fetch your information."
      }
    },
    "tip4commit": "Tip4Commit",
    "meta": {
      "title": "Contribute to Open Source",
      "description": "Donate bitcoins to open source projects or make commits and get tips for it."
    },
    "menu": {
      "home": "Home",
      "projects": "Supported Projects"
    },
    "footer": {
      "text": "Source code is available at %{github_link} and you can also %{support_link} its development.",
      "github_link": "GitHub",
      "support_link": "support",
      "follow_link": "Follow @tip4commit"
    },
    "links": {
      "sign_in": "Sign in",
      "sign_out": "Sign Out"
    },
    "notices": {
      "project_updated": "The project settings have been updated",
      "tips_decided": "The tip amounts have been defined",
      "user_updated": "Your information saved!",
      "user_unsubscribed": "You unsubscribed! Sorry for bothering you. Although, you still can leave us your bitcoin address to get your tips."
    },
    "tip_amounts": {
      "undecided": "Undecided",
      "free": "Free: 0%",
      "tiny": "Tiny: 0.1%",
      "small": "Small: 0.5%",
      "normal": "Normal: 1%",
      "big": "Big: 2%",
      "huge": "Huge: 5%"
    },
    "home": {
      "index": {
        "see_projects": "See projects",
        "how_does_it_work": {
          "title": "How does it work?",
          "text": "People donate bitcoins to projects. When someone's commit is accepted into the project repository, we automatically tip the author.",
          "button": "Learn about Bitcoin"
        },
        "donate": {
          "title": "Donate",
          "text": "Find a project you like and deposit bitcoins into it. Your donation will be accumulated with the funds of other donators to give as tips for new commits.",
          "button": "Find or add a project"
        },
        "contribute": {
          "title": "Contribute",
          "text": "Go and fix something! If your commit is accepted by the project maintainer, you will get a tip!",
          "sign_in_text": "Just check your email or %{sign_in_link}.",
          "button": "Supported projects"
        }
      }
    },
    "projects": {
      "index": {
        "find_project": {
          "placeholder": "Enter GitHub project URL to find or add a project e.g. rails/rails",
          "button": "Find or add project"
        },
        "repository": "Repository",
        "description": "Description",
        "watchers": "Watchers",
        "balance": "Balance",
        "forked_from": "forked from",
        "support": "Support"
      },
      "show": {
        "title": "Contribute to %{project}",
        "edit_project": "Change project settings",
        "decide_tip_amounts": "Decide tip amounts",
        "project_sponsors": "Project Sponsors",
        "fee": "%{percentage} of deposited funds will be used to tip for new commits.",
        "balance": "Balance",
        "custom_tip_size": "(each new commit receives a percentage of available balance)",
        "default_tip_size": "(each new commit receives %{percentage} of available balance)",
        "unconfirmed_amount": "(%{amount} unconfirmed)",
        "tipping_policies": "Tipping policies",
        "updated_by_user": "(Last updated by %{name} on %{date})",
        "updated_by_unknown": "(Last updated on %{date})",
        "tips_paid": "Tips Paid",
        "unclaimed_amount": "(%{amount} of this is unclaimed, and will be refunded to the project after being unclaimed for 1 month.)",
        "last_tips": "Last Tips",
        "see_all": "see all",
        "received": "received %{amount}",
        "will_receive": "will receive a tip",
        "for_commit": "for commit",
        "when_decided": "when its amount is decided",
        "next_tip": "Next Tip",
        "contribute_and_earn": "Contribute and Earn",
        "cocontribute_and_earn_description": "Donate bitcoins to this project or %{make_commits_link} and get tips for it. If your commit is accepted by the project maintainer and there are bitcoins on its balance, you will get a tip!",
        "make_commits_link": "make commits",
        "tell_us_bitcoin_address": "Just %{tell_us_link} your bitcoin address.",
        "tell_us_link": "tell us",
        "sign_in": "Just check your email or %{sign_in_link}.",
        "promote_project": "Promote %{project}",
        "embedding": "Embedding",
        "image_url": "Image URL:",
        "shield_title": "tip for next commit"
      },
      "edit": {
        "project_settings": "%{project} project settings",
        "tipping_policies": "Tipping policies",
        "hold_tips": "Do not send the tips immediatly. Give collaborators the ability to modify the tips before they're sent",
        "save": "Save the project settings"
      },
      "decide_tip_amounts": {
        "commit": "Commit",
        "author": "Author",
        "message": "Message",
        "tip": "Tip (relative to the project balance)",
        "submit": "Send the selected tip amounts"
      }
    },
    "tips": {
      "index": {
        "tips": "Tips",
        "project_tips": "%{project} tips",
        "user_tips": "%{user} tips",
        "created_at": "Created At",
        "commiter": "Commiter",
        "project": "Project",
        "commit": "Commit",
        "amount": "Amount",
        "refunded": "Refunded to project's deposit",
        "undecided": "The amount of the tip has not been decided yet",
        "no_bitcoin_address": "User didn't specify withdrawal address",
        "below_threshold": "User's balance is below withdrawal threshold",
        "waiting": "Waiting for withdrawal",
        "error": "(error sending transaction)"
      }
    },
    "users": {
      "index": {
        "title": "Top Contributors",
        "name": "Name",
        "commits_count": "Commits tipped",
        "withdrawn": "Withdrawn"
      },
      "show": {
        "balance": "Balance",
        "threshold": "You will get your money when your balance hits the threshold of %{threshold}",
        "see_all": "see all",
        "received": "%{time} received %{amount} for commit %{commit} in %{project}",
        "bitcoin_address_placeholder": "Your bitcoin address",
        "notify": "Notify me about new tips (no more than one email per month)",
        "submit_bitcoin_address": "Update Bitcoin address",
        "change_password": "Change your password",
        "submit_password": "Change my password"
      }
    },
    "withdrawals": {
      "index": {
        "title": "Last Withdrawals",
        "created_at": "Created At",
        "transaction": "Transaction",
        "result": "Result",
        "error": "Error",
        "success": "Success"
      }
    }
  }
};
