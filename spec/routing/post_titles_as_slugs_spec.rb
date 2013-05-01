require 'spec_helper'


describe 'Spoke names as slugs', type: :routing do
  fixtures :spokes

  let(:spoke) { spokes(:fresno) }

  it 'routes if the post ID is used' do
    expect(get: "/spokes/#{spoke.id}").
      to route_to(
        action: 'show',
        controller: 'spokes',
        id: spoke.id.to_s
      )
  end

  it 'routes if the post slug is used' do
    expect(get: "/spokes/#{spoke.slug}").
      to route_to(
      action: 'show',
      controller: 'spokes',
      id: spoke.slug,
    )
  end
end
