ActionController::Routing::Routes.draw do |map|
  map.resources :ingredients
  map.resources :users
  map.resources :ratings
  map.resources :recipes, :collection=>{:add_ingredient_to=>:any}, :member=>{:add_tags=>:put} do |recipe|
    recipe.resources :comments
  end
  map.resources :sessions
  map.resources :tags
  map.resources :taggings

  map.forgot_password 'password/forgot', :controller=>'password', :action=>'forgot'
  map.send_new_password 'password/send_new', :controller=>'password',  :action=>'send_new', :conditions=>{:method=>:post}
  map.reset_password 'password/reset', :controller=>'password', :action=>'reset'

  map.search 'search', :controller=>'public', :action=>'search'
  map.cookbook 'cookbook', :controller=>'cookbook'
  map.welcome '' , :controller=>'public'
end
