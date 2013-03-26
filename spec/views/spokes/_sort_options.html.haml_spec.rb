require 'spec_helper'


describe 'spokes/_sort_options.html.haml' do
  fixtures :spokes

  context 'no spoke_id given' do
    it 'includes each sort option' do
      render partial: 'spokes/sort_options', locals: { sorter: 'most_voted' }

      expect(rendered).to match /#{home_path}?sort=newest/
      expect(rendered).to match /#{home_path}?sort=most_active/
      expect(rendered).to match /#{home_path}?sort=most_positive/
      expect(rendered).to match /#{home_path}?sort=most_negative/
      expect(rendered).to match /#{home_path}?sort=most_voted/
    end
  end

  context 'spoke_id given' do
    it 'includes each sort option' do
      render partial: 'spokes/sort_options',
        locals: { sorter: 'most_voted', spoke_id: spokes(:fresno).id }

      path = spoke_path(id: spokes(:fresno).id)
      expect(rendered).to include("#{path}?sort=newest")
      expect(rendered).to include("#{path}?sort=most_active")
      expect(rendered).to include("#{path}?sort=most_positive")
      expect(rendered).to include("#{path}?sort=most_negative")
      expect(rendered).to include("#{path}?sort=most_voted")
    end
  end
end
