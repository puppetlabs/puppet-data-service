require_relative '../app'

if App.config['use-ssl']
  bind_addr = +"ssl://0.0.0.0:8160"
  bind_addr << "?cert=#{App.config['ssl-cert']}"
  bind_addr << "&key=#{App.config['ssl-key']}"
  bind_addr << "&ca=#{App.config['ssl-ca']}"
else
  bind_addr = +"tcp://0.0.0.0:8160"
end

bind bind_addr
