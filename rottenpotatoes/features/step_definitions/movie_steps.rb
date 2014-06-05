# Add a declarative step here for populating the DB with movies.

Given /the following movies exist/ do |movies_table|
  movies_table.hashes.each do |movie|
    # each returned element will be a hash whose key is the table header.
    # you should arrange to add that movie to the database here.
    if !Movie.exists?(title: movie[:title])
        @movie = Movie.create!(movie)
        # May need this instead
        # new_movie = Movie.new
        # new_movie.title = movie[:title].squish
        # new_movie.rating = movie[:rating].squish
        # new_movie.release_date = movie[:release_date].squish
        # new_movie.save!
    end
  end
end

# Make sure that one string (regexp) occurs before or after another one
#   on the same page

Then /I should see "(.*)" before "(.*)"/ do |e1, e2|
  #  ensure that that e1 occurs before e2.
  #  page.body is the entire content of the page as a string.
#  flunk "Unimplemented"
end

# Make it easier to express checking or unchecking several boxes at once
#  "When I uncheck the following ratings: PG, G, R"
#  "When I check the following ratings: G"

When /I (un)?check the following ratings: (.*)/ do |uncheck, rating_list|
  # HINT: use String#split to split up the rating_list, then
  #   iterate over the ratings and reuse the "When I check..." or
  #   "When I uncheck..." steps in lines 89-95 of web_steps.rb
  if uncheck
    rating_list.split(', ').each {|rating|
      steps %Q{
        Given I am on the RottenPotatoes home page
        When I uncheck "ratings[#{rating}]"
        And   I press "Refresh"
      }
    }
  else
    rating_list.split(', ').each {|rating|
      steps %Q{
        Given I am on the RottenPotatoes home page
        When I check "ratings[#{rating}]"
        And   I press "Refresh"
      }
    } 
  end  
#  flunk "Unimplemented"
end

Then /I should see all the movies/ do
  # Make sure that all the movies in the app are visible in the table
  page.should have_css('table#movies tr', :count => Movie.count + 1)
end
Then /I should (not )?see the following ratings: (.*)/ do |shouldnot, rating_list|
  # Make sure that all the movies in the app are visible in the table
  if shouldnot
    rating_list.split(', ').each {|rating|
      steps %Q{
        Given I am on the RottenPotatoes home page
        Then I should not see the movies rated "#{rating}"
      }
    }
  else
    rating_list.split(', ').each{|rating|
      steps %Q{
        Given I am on the RottenPotatoes home page
        Then I should see the movies rated "#{rating}"
      }
    }
  end
#  flunk "Unimplemented"
end

Then /I should (not )?see the movies rated (.*)/ do |shouldnot, rating|
  if shouldnot
      page.find('#movies').has_no_text?("#{rating}")
  else
    @rating_count = Movie.find_all_by_rating("#{rating}").count
    @table_rating = page.all('table#movies', text: "#{rating}").count
    @rating_count == @table_rating
  end
end
