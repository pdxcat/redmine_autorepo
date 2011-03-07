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

require_dependency 'repositories_controller'

module Autorepo
  module Patches
    module RepositoriesControllerPatch

      def show_with_instructions
        # Empty git repos make redmine cry. Hackjob fix for now.
        if @repository.is_a?(Repository::Git) and @repository.entries(@path, @rev).blank?
          render :action => 'git_instructions' 
        else
          show_without_instructions
        end
      end
      
      def edit_with_scm_settings
        if Autorepo::supported_scm.include?(params[:repository])
          params[:repository] ||= Hash.new  
          params[:repository][:url] = Autorepo::repo_path(@project, params[:repository])
        end
        edit_without_scm_settings
      end

      def self.included(base)
        base.class_eval do
          unloadable
        end
        base.send(:alias_method_chain, :show, :instructions)
        base.send(:alias_method_chain, :edit, :scm_settings)
      end

    end
  end
end

RepositoriesController.send(:include, Autorepo::Patches::RepositoriesControllerPatch)
