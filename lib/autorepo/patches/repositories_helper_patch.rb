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

require_dependency 'repositories_helper'

module Autorepo
  module Patches
    module RepositoriesHelperPatch

      def git_field_tags_with_disabled_configuration(form, repository) ; '' ; end
      def subversion_field_tags_with_disabled_configuration(form, repository) ; '' ; end

      def self.included(base)
        base.class_eval do
          unloadable
        end
        base.send(:alias_method_chain, :git_field_tags, :disabled_configuration)
        base.send(:alias_method_chain, :subversion_field_tags, :disabled_configuration)
      end

    end
  end
end

RepositoriesHelper.send(:include, Autorepo::Patches::RepositoriesHelperPatch)
