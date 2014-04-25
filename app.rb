require 'rubygems'
require 'sinatra'
require 'json'
require File.expand_path("../num2", __FILE__)

configure do
  set :public_folder, Proc.new { File.join(root, "static") }
  enable :sessions
end

helpers do
  def username
    session[:identity] ? session[:identity] : '访客，您好！'
  end
end

before '/secure/*' do
  if !session[:identity] then
    session[:previous_url] = request.path
    @info = ' 你需要键入昵称后才可以使用～ ' 
    halt erb(:login_form)
  end
end

get '/' do
  
  erb '<div style="height:60px;"></div><div class="hero-unit"><h1>READ ME</h1><p></p><p>使用方法：贴入原文本即可高亮数词，鼠标悬停于高亮文本上即可翻译。<br/>注：本功能采用自动机和简易语法消歧方法实现。</p><a class="btn btn-primary" href="/secure/place">开始使用</a></div>'
end

get '/login/form' do 
  erb :login_form
end

post '/login/attempt' do
  session[:identity] = params['username']
  where_user_came_from = session[:previous_url] || '/'
  redirect to where_user_came_from 
end

get '/logout' do
  session.delete(:identity)
  erb "<div class='alert alert-message'>已退出</div>"
end


get '/secure/place' do
  #erb "<div class ='alert alert-success'>已成功为<%=session[:identity]%>初始化!</div>"
  erb :transer_page

end

post '/secure/transe.json' do
  content_type :json
  request.body.rewind  # 如果已经有人读了它
  data = JSON.parse(request.body.read)
  str = data["text"]
  my_numtranser = Numtranser.new()
  result = my_numtranser.get_transe4web(str)

  { result: "#{result}"}.to_json
end