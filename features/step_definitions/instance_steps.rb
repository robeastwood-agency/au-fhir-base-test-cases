Given('extension {string} is not present') do |extension_url|
  expect(@testfile).not_to have_extension(extension_url)
end

Given('extension {string} is present') do |extension_url|
  expect(@testfile).to have_extension(extension_url)
end

Given('its element {string} has value {string}') do |element, value|
  expect(@testfile).to have_element_with_value(element, value)
end

Given('valueDateTime extension {string} has value {string}') do |extension_url, value|
  expect(@testfile).to have_valueDateTime_extension_with_value(extension_url, value)
end