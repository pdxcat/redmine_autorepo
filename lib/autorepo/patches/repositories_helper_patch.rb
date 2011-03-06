# repositories_helper_patch.rb
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
