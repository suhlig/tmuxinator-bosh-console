require 'open3'

module TMux
  class Client
    def session?(name)
      Open3.popen3("tmux has-session -t #{name}") do |_, _, _, thread|
        return thread.value.success?
      end
    end
  end
end
