#  Copyright (C) 2011 Reid Vandewiele
#  ALL RIGHTS RESERVED
#
#  This file is part of redmine_autorepo.
#
#  redmine_autorepo is free software: you can redistribute it and/or 
#  modify it under the terms of the GNU General Public License as 
#  published by the Free Software Foundation, either version 3 of the 
#  License, or (at your option) any later version.
#
#  redmine_autorepo is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#
#  You should have received a copy of the GNU General Public License
#  along with redmine_autorepo.  If not, see 
#  <http://www.gnu.org/licenses/>.

module Autorepo
  module SCM

    def self.system_or_raise(command)
      raise "\"#{command}\" failed" unless system command
    end

    module Subversion
      def self.create(path)
        Autorepo::SCM::system_or_raise "svnadmin create #{path}"
      end
      def self.destroy(path)
        FileUtils.rm_rf(path)
      end
      def self.basename(identifier)
        return identifier.to_s
      end
      def self.url(path)
        # There comes a certain point where compatibility with Windows
        # can go DIAF.
        "file://#{path}" 
      end
    end

    module Git
      def self.create(path)
        Dir.mkdir path
        Dir.chdir(path) do
          Autorepo::SCM::system_or_raise "git --bare init --shared"
          Autorepo::SCM::system_or_raise "git update-server-info"
          Autorepo::SCM::system_or_raise "ln -s #{path} #{path}.git"
        end
      end
      def self.destroy(path)
        FileUtils.rm_rf(path)
        FileUtils.rm_rf("#{path}.git")
      end
      def self.basename(identifier)
        return "#{identifier.to_s}"
      end
      def self.url(path)
        path
      end
    end

  end
end
