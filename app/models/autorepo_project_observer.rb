# autorepo_project_observer.rb
require 'fileutils'

class AutorepoProjectObserver < ActiveRecord::Observer
  include Autorepo::SCM
  observe :project

  def initialize
    @repos_base = Hash.new
    @repos_base[:git] = Setting[:plugin_redmine_autorepo][:repository_path_git]
    @repos_base[:subversion] = Setting[:plugin_redmine_autorepo][:repository_path_subversion]
  end
  
  def after_create(project)
    if Setting[:plugin_redmine_autorepo][:autocreate_repo_subversion]
      create_repository(project, :subversion)
    end
    if Setting[:plugin_redmine_autorepo][:autocreate_repo_git]
      create_repository(project, :git)
    end
  end
  
  def after_destroy(project)
    if Setting[:plugin_redmine_autorepo][:autodelete_repo_subversion]
      delete_repository(project, :subversion)
    end
    if Setting[:plugin_redmine_autorepo][:autodelete_repo_git]
      delete_repository(project, :git)
    end
  end
  
  protected
  
    def create_repository(project, scm)
      begin
        scm_module = Autorepo::SCM.const_get(scm)  
        repos_path = get_repos_path(project, scm)
      rescue
        # like, log & error or something
      end 

      begin
        File.umask(0007)
        scm_module.create(repos_path) 
      rescue
        # like, log & error or something
      end
     
      begin
        #assoc repos
      rescue
        # like, log & error or something
      end 
    end
  
    def delete_repository(project, scm)
      repos_path = get_repos_path(project, scm)
      FileUtils.rm_rf(repos_path)
    end

    def get_repos_path(project, scm)
      begin
        scm_module = Autorepo::SCM.const_get(scm)  
        repos_path = File.join(@repos_base[scm], scm_module.basename(project.identifier))
        repos_path = repos_path.gsub(File::SEPARATOR, File::ALT_SEPARATOR || File::SEPARATOR)
      rescue
        # like, log & error or something
      end 
    end

end
