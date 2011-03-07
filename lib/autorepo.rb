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

module Autorepo
  
  def self.supported_scm
    [:subversion, :git]
  end

  def self.repo_base
    repo_base = Hash.new
    repo_base[:git]        = Setting[:plugin_redmine_autorepo][:repo_path_git]
    repo_base[:subversion] = Setting[:plugin_redmine_autorepo][:repo_path_subversion]
    return repo_base
  end


  def self.create(project, scm)
    begin
      File.umask(0007)
      scm_module = Autorepo::SCM.const_get(scm.to_s.camelize)
      scm_module.create(repo_path(project, scm))
    rescue
      project.logger.error "Autorepo: Unable to create repository"
      project.logger.error "Autorepo: #{error.message}"
    end
  end

  def self.destroy(project, scm)
    begin
      FileUtils.rm_rf(repo_path(project, scm))
    rescue
      project.logger.error "Autorepo: Unable to destroy repository"
      project.logger.error "Autorepo: #{error.message}"
    end
  end

  def self.repo_path(project, scm)
    begin
      scm_module = Autorepo::SCM.const_get(scm.to_s.camelize)
      repo_path = File.join(repo_base[scm], scm_module.basename(project.identifier))
      repo_path = repo_path.gsub(File::SEPARATOR, File::ALT_SEPARATOR || File::SEPARATOR)
    rescue
      project.logger.error "Autorepo: Unable to get repo_path"
      project.logger.error "Autorepo: #{error.message}"
    end
  end

end
