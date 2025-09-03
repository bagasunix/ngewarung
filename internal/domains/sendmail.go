package domains

type SendEmailRegistrationCustome struct {
	TextJudul string `json:"textJudul"`
	Name      string `json:"customerName"`
	UserName  string `json:"userName"`
	Url       string `json:"url"`
}
