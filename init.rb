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

require 'redmine'
require 'autorepo/patches/repositories_controller_patch'

Rails.configuration.to_prepare do
  ActiveRecord::Base.observers << :autorepo_project_observer
end

Redmine::Plugin.register :redmine_autorepo do
  name 'Redmine Autorepo Plugin'
  author 'Reid Vandewiele'
  description 'Enables automatic repository creation at project creation time.'
  version '0.0.2'
  settings :default => {
    'repo_path_subversion'       => '/www/svn',
    'autocreate_repo_subversion' => 'false',
    'autodelete_repo_subversion' => 'false',
    'repo_path_git'              => '/www/git',
    'autocreate_repo_git'        => 'false',
    'autodelete_repo_git'        => 'false',
  }, :partial => 'settings/redmine_autorepo_settings'
end
