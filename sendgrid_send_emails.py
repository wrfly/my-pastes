#!/usr/bin/python
# coding=utf8
import sendgrid

SENDGRID_API_KEY = ''

def send_email(user_email):
    sg = sendgrid.SendGridClient(SENDGRID_API_KEY)
    message = sendgrid.Mail()
    message.add_to(user_email)
    message.set_from("admin@gov.cn")
    message.set_from_name('Xi Jin Ping')
    message.set_html('Welcome to China')
    message.set_subject('Hello world')
    # Add template (fixed subject and contents)
    message.add_filter('templates', 'enable', '1')
    message.add_filter('templates', 'template_id', '15dd35d5-0f9d-4a52-ae57-6bac921b333c')
    status, msg = sg.send(message)
    return user_email, str(status), msg

if __name__ == '__main__':

    # For emails is a file contents many email address.

    i = 1.0
    with open('emails') as fp:total_no=sum(1 for x in fp)

    emails = open('emails', 'r')
    sent_email = open('sent_emails', 'w+')
    error_email = open('error_emails', 'w+')

    for email_addr in emails:
        try:
            i += 1
            print round(i/total_no * 100, 2) , '%'
            result = send_email(email_addr)
            sent_email.writelines(str(result))
        except Exception:
            error_email.writelines(email_addr)

    emails.close()
    sent_email.close()
    error_email.close()