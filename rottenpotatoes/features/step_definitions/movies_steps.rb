
Given /the following movies exist/ do |movies_table|
  movies_table.hashes.each do |movie|
    Movie.create movie
  end
end

Then /I should see "(.*)" before "(.*)"/ do |e1, e2|
  #  ensure that that e1 occurs before e2.
  #  page.body is the entire content of the page as a string.
  expect(page.body.index(e1) < page.body.index(e2))
end

When /I (un)?check the following ratings: "(.*)"/ do |uncheck, rating_list|
  # HINT: use String#split to split up the rating_list, then
  #   iterate over the ratings and reuse the "When I check..." or
  #   "When I uncheck..." steps in lines 89-95 of web_steps.rb

  ratings_arr = rating_list.split
  ratings_arr.each do |rating|
    if uncheck
      uncheck("ratings_#{rating}")
    else
      check("ratings_#{rating}")
    end
  # fail "Unimplemented"
  end
end

Then /I should see all the movies/ do
  # Make sure that all the movies in the app are visible in the table
  Movie.all.each do |movie|
    step %{I should see "#{movie.title}"}
  end
end

Then /the director of "([^"]*)" should be "([^"]*)"/ do |movie, director|

  if page.respond_to? :should
    page.should have_content("Details about "+movie)
    page.should have_content("Director: "+director)
  else
    assert page.has_content?("Details about "+movie)
    assert page.has_content?("Director: "+director)
  end
end

Then /I should (not )?see movies of following ratings: "(.*)"/ do |no,rating_list|
  ratings_arr = rating_list.split
  map = ratings_arr.map{ |rating| [rating, 1] }.to_h
  custom_path = "//table[@id='movies']/tbody//td[2]"
  page.all(:xpath, custom_path).each do |element|
    if !no && !map.key?(element.text)
      fail "Not filtered properly"
    elsif no && map.key?(element.text)
      fail "Not filtered properly"
    end
  end
end
