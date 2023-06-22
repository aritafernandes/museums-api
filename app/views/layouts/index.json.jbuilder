# Starts a block using the json.museums method, passing @museums as an argument.
# JSON response will contain a section called "museums" that will be populated with data.
# The block defines two variables, postal_code and museums, which will be used to iterate over the contents of @museums.

json.museums @museums do |postal_code, museums|
  # adds a key-value pair to the JSON response.
  # It sets the key as "postal_code" and assigns the value of the postal_code variable obtained from iterating over @museums.
  json.postal_code postal_code
  # adds key-value pair to the JSON response.
  # It sets the key as "museums" and assigns the value of the museums variable obtained from iterating over @museums.
  json.museums museums
end
