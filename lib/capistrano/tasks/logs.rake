# copied from http://www.talkingquickly.co.uk/2013/12/tailing-log-files-with-capistrano-3/

namespace :logs do
  desc "tail rails logs" 
  task :tail_rails do
    on roles(:app) do
      execute "tail -f #{shared_path}/log/#{fetch(:rails_env)}.log"
    end
  end
end

