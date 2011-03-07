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

require 'fileutils'

class AutorepoProjectObserver < ActiveRecord::Observer
  include Autorepo::SCM
  observe :project

  def after_create(project)
    if Setting[:plugin_redmine_autorepo][:autocreate_repo_subversion]
      project.logger.info "Autorepo: Creating subversion repository"
      create_repository(project, :subversion)
    end
    if Setting[:plugin_redmine_autorepo][:autocreate_repo_git]
      project.logger.info "Autorepo: Creating git repository"
      create_repository(project, :git)
    end
  end
  
  def before_destroy(project)
    if Setting[:plugin_redmine_autorepo][:autodelete_repo_subversion]
      project.logger.info "Autorepo: Deleting subversion repository"
      delete_repository(project, :subversion)
    end
    if Setting[:plugin_redmine_autorepo][:autodelete_repo_git]
      project.logger.info "Autorepo: Deleting git repository"
      delete_repository(project, :git)
    end
  end

  protected

    def create_repository(project, scm)
      begin
        scm_module = Autorepo::SCM.const_get(scm.to_s.camelize)
        repos_path = get_repos_path(project, scm)
        project.logger.info "Autorepo: #{repos_path}"
      rescue => error
        project.logger.error "Autorepo: Unable to create repository (block 1)"
        project.logger.error "Autorepo: #{error.message}"
      end

      begin
        File.umask(0007)
        scm_module.create(repos_path)
      rescue => error
        project.logger.error "Autorepo: Unable to create repository (block 2)"
        project.logger.error "Autorepo: #{error.message}"
      end
    end

    def delete_repository(project, scm)
      begin
        repos_path = get_repos_path(project, scm)
        FileUtils.rm_rf(repos_path)
      rescue => error
        project.logger.error "Autorepo: Unable to delete repository"
        project.logger.error "Autorepo: #{error.message}"
      end
    end

    def get_repos_path(project, scm)
      repos_base = Hash.new
      repos_base[:git] = Setting[:plugin_redmine_autorepo][:repo_path_git]
      repos_base[:subversion] = Setting[:plugin_redmine_autorepo][:repo_path_subversion]

      begin
        scm_module = Autorepo::SCM.const_get(scm.to_s.camelize)
        repos_path = File.join(repos_base[scm], scm_module.basename(project.identifier))
        repos_path = repos_path.gsub(File::SEPARATOR, File::ALT_SEPARATOR || File::SEPARATOR)
      rescue
        project.logger.error "Autorepo: Unable to get repos_path"
        project.logger.error "Autorepo: #{error.message}"
      end

      return repos_path
    end

end
