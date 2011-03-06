module Autorepo
  module SCM

    module Subversion
      def self.create(path)
        system_or_raise "svnadmin create #{path}"
      end
      def self.basename(identifier)
        return identifier.to_s
      end
    end

    module Git
      def self.create(path)
        Dir.mkdir path
        Dir.chdir(path) do
          system_or_raise "git --bare init --shared"
          system_or_raise "git update-server-info"
          system_or_raise "ln -s #{path} #{path}.git"
        end
      end
      def self.basename(identifier)
        return "#{identifier.to_s}.git"
      end
    end

  end
end
