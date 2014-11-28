require 'faye'
require ::File.expand_path('../../config/environment',  __FILE__)

Faye::WebSocket.load_adapter('thin')

FAYE_CONFIG = YAML.load_file(File.expand_path("../../config/faye.yml", __FILE__))[ENV['RACK_ENV']]
FAYE_TOKEN = FAYE_CONFIG["faye_token"]

app = Faye::RackAdapter.new(:mount => '/push', :timeout => 25)
class FayeAuth
  def incoming(message, callback)
    p message
    # 订阅请求
    if message['channel'] =~ %r{/meta/subscribe}
      m = message['subscription'].match %r{\A/(\w+)/(\d+)}
      p m
      # 用户不存在
      return unless user = User.find_by(subscribe_token: message['ext']['token'])
      # 检查权限
      if m[1] == 'projects'
        return unless user.projects.pluck(:id).include? m[2].to_i
      elsif m[1] == 'todos'
        return unless user.projects.pluck(:id).include? Todo.find(m[2].to_i).project_id
      end
    end
    return callback.call(message) if message['channel'] =~ %r{^/meta/}
    return callback.call(message) unless message["data"]

    # 验证publish的来源
    if message["data"]['token'] != FAYE_TOKEN
      # Setting any 'error' against the message causes Faye to not accept it.
      message['error'] = "Faye authorize faild."
    else
      message["data"].delete('token')
    end
    callback.call(message)
  end
end
app.add_extension(FayeAuth.new)

run app
