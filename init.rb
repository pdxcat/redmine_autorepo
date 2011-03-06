require 'redmine'

Redmine::Plugin.register :redmine_autorepo do
  name 'Redmine Maseeh College of Engineering and Computer Science Plugin'
  author 'Reid Vandewiele'
  description 'Enables automatic repository creation at project creation time.'
  version '0.0.1'
  settings :default => {
    'repo_path_subversion'       => '/www/svn',
    'autocreate_repo_subversion' => 'false',
    'autodelete_repo_subversion' => 'false',
    'repo_path_git'              => '/www/git',
    'autocreate_repo_git'        => 'false',
    'autodelete_repo_git'        => 'false',
  }, :partial => 'settings/redmine_autorepo_settings'
end

# initialize observer
ActiveRecord::Base.observers = ActiveRecord::Base.observers << AutorepoProjectObserver
