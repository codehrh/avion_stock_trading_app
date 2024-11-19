class UserMailer < ApplicationMailer

    def confirmation_instructions(record, token, opts = {})
    end
    
    def registration_pending(user)
        @user = user
        @confirmation_url = user_confirmation_url(user.confirmation_token)
        mail(to: @user.email, subject: 'Your Registration is Pending Approval')
    end

    def account_approved(user)
        @user = user
        mail(to: @user.email, subject: 'Your Registration has been Approved')
    end

    def account_denied(user)
        @user = user
        mail(to: @user.email, subject: 'Your Registration has been denied.')
    end
end
