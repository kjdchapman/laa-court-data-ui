# frozen_string_literal: true

class FeedbackMailer < GovukNotifyRails::Mailer
  def notify(email, rating, comment)
    template = '5fcd84b1-8d05-4b6c-86a8-9fc391efa754'
    set_template(template)
    set_personalisation(
      email: email,
      rating: rating,
      comment: comment
    )
    mail(to: support_email_address)
  end

  private

  def support_email_address
    ENV.fetch('SUPPORT_EMAIL_ADDRESS', nil)
  end
end
