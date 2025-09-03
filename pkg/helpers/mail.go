package helpers

import (
	"fmt"

	mailjet "github.com/mailjet/mailjet-apiv3-go"

	"github.com/bagasunix/ngewarung/pkg/env"
)

func SendEmail(body *string, to, subject string, s *env.Cfg) error {

	mj := mailjet.NewMailjetClient(
		s.Server.MailJet.ApiKey,
		s.Server.MailJet.ScretKey,
	)

	messages := mailjet.MessagesV31{
		Info: []mailjet.InfoMessagesV31{
			{
				From: &mailjet.RecipientV31{
					Email: "no-reply@bagasunix.com",
					Name:  "Ngewarung",
				},
				To: &mailjet.RecipientsV31{
					mailjet.RecipientV31{Email: to},
				},
				Subject:  "Verifikasi Akun Ngewarung",
				TextPart: "Klik link berikut untuk verifikasi akun Anda.",
				HTMLPart: *body,
			},
		},
	}
	_, err := mj.SendMailV31(&messages)
	if err != nil {
		return fmt.Errorf("gagal kirim email: %w", err)
	}

	// m := gomail.NewMessage()
	// m.SetHeader("From", "Ngewarung <"+s.App.Name+">")
	// m.SetHeader("To", to)

	// m.SetHeader("Subject", subject)

	// m.SetBody("text/html", *body)

	// mailDialer := gomail.NewDialer("in-v3.mailjet.com", 587, s.Server.MailJet.ApiKey, s.Server.MailJet.ScretKey)
	// mailDialer.TLSConfig = &tls.Config{InsecureSkipVerify: true}
	// if err := mailDialer.DialAndSend(m); err != nil {
	// 	return err
	// }

	return nil
}
