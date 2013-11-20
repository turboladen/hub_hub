ActiveAdmin.register Post do
  permit_params do
    %i[title body]
  end
end
