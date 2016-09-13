class Base
  def parse(response_body)
    JSON.parse(response_body, symbolize_names: true)
  end
end
