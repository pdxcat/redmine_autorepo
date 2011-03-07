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

require_dependency 'autorepo'

class AutorepoProjectObserver < ActiveRecord::Observer
  observe :project

  def after_create(project)
    if Setting[:plugin_redmine_autorepo][:autocreate_repo_subversion]
      project.logger.info "Autorepo: Creating subversion repository"
      Autorepo::create(project, :subversion)
    end
    if Setting[:plugin_redmine_autorepo][:autocreate_repo_git]
      project.logger.info "Autorepo: Creating git repository"
      Autorepo::create(project, :git)
    end
  end
  
  def before_destroy(project)
    if Setting[:plugin_redmine_autorepo][:autodelete_repo_subversion]
      project.logger.info "Autorepo: Deleting subversion repository"
      Autorepo::destroy(project, :subversion)
    end
    if Setting[:plugin_redmine_autorepo][:autodelete_repo_git]
      project.logger.info "Autorepo: Deleting git repository"
      Autorepo::destroy(project, :git)
    end
  end

end
