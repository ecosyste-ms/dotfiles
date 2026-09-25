require 'test_helper'

class ProjectsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @project = Project.create!(url: 'https://github.com/test/dotfiles', name: 'test dotfiles', score: 1.0, last_synced_at: Time.now)
  end

  test 'index ignores sort values not in the allowlist' do
    get projects_path(sort: '(SELECT 1 FROM secrets)', order: 'asc')
    assert_response :success
    sql = assigns(:scope).to_sql
    refute_includes sql, 'secrets'
    assert_includes sql, 'ORDER BY last_synced_at ASC'
  end

  test 'index sorts by an allowed column' do
    get projects_path(sort: 'score', order: 'desc')
    assert_response :success
    assert_includes assigns(:scope).to_sql, 'ORDER BY score DESC'
  end
end
