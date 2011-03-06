# repositories_controller_patch.rb
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
        params[:repository] ||= Hash.new  
        params[:repository][:url] = case params[:repository_scm]
          when 'Git' then File.join(Autorepo::Setting[:plugin_redmine_autorepo][:repo_path_git],"#{@project.identifier}",'.git')
          when 'Subversion' then File.join(Autorepo::Setting[:plugin_redmine_autorepo][:repo_path_git],"#{@project.identifier}")
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
