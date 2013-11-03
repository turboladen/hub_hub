HubHub::Application.routes.draw do
  root 'home#tos'
  get 'tos' => 'home#tos'
  get 'faq' => 'home#faq'
end
