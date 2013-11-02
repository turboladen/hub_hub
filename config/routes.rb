HubHub::Application.routes.draw do
  get 'tos' => 'home#tos'
  get 'faq' => 'home#faq'
end
