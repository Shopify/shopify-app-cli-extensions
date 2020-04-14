# frozen_string_literal: true
require 'test_helper'

module ShopifyCli
  class ProjectTypeTest < MiniTest::Test
    def setup
      super
      ProjectType.load_all
    end

    def test_load_type_will_not_raise_for_a_bad_type
      ProjectType.load_type(:nope_not_a_type)
    end

    def test_load_all_will_find_and_load_all_types
      all_types = ProjectType.all_loaded
      assert(all_types.include?(Rails::Project))
      assert(all_types.include?(Node::Project))
    end

    def test_for_app_type_can_find_the_app_by_name
      assert_equal(ProjectType.for_app_type(:rails), Rails::Project)
      assert_equal(ProjectType.for_app_type(:node), Node::Project)
      assert_equal(ProjectType.for_app_type('rails'), Rails::Project)
      assert_equal(ProjectType.for_app_type('node'), Node::Project)
      assert_nil(ProjectType.for_app_type('nope'))
    end

    def test_project_filepath
      assert_equal(
        Rails::Project.project_filepath('myfile'),
        File.join(ShopifyCli::PROJECT_TYPES_DIR, 'rails', 'myfile')
      )
    end
  end
end
