module Autorepo
  module SCM

    def self.system_or_raise(command)
      raise "\"#{command}\" failed" unless system command
    end

    module Subversion
      def self.create(path)
        Autorepo::SCM::system_or_raise "svnadmin create #{path}"
      end
      def self.basename(identifier)
        return identifier.to_s
      end
    end

    module Git
      def self.create(path)
        Dir.mkdir path
        Dir.chdir(path) do
          Autorepo::SCM::system_or_raise "git --bare init --shared"
          Autorepo::SCM::system_or_raise "git update-server-info"
        end
      end
      def self.basename(identifier)
        return "#{identifier.to_s}.git"
      end
    end

  end
end
