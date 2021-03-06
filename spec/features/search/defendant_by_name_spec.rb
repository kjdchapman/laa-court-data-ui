# frozen_string_literal: true

RSpec.feature 'Defendant by name and dob search', type: :feature, js: true do
  let(:user) { create(:user) }

  before do
    sign_in user
  end

  scenario 'with one result', :vcr do
    visit '/'

    choose 'A defendant by name and date of birth'
    click_button 'Continue'
    fill_in 'search-term-field', with: 'Josefa Franecki'
    fill_in 'search_dob_3i', with: '15'
    fill_in 'search_dob_2i', with: '06'
    fill_in 'search_dob_1i', with: '1961'
    click_button 'Search'

    expect(page).to have_text(
      'Search results for "Josefa Franecki, 15 June 1961"'
    )
    expect(page).to have_field('Defendant name', with: 'Josefa Franecki')
    expect(page).to have_field('Day', with: '15')
    expect(page).to have_field('Month', with: '6')
    expect(page).to have_field('Year', with: '1961')

    within 'tbody.govuk-table__body' do
      expect(page).to have_content('Josefa Franecki', minimum: 1)
    end

    expect(page).to be_accessible.within '#main-content'
  end

  scenario 'with no results', :vcr do
    visit '/'

    choose 'A defendant by name and date of birth'
    click_button 'Continue'
    fill_in 'search-term-field', with: 'Fred Bloggs'
    fill_in 'search_dob_3i', with: '28'
    fill_in 'search_dob_2i', with: '11'
    fill_in 'search_dob_1i', with: '1928'
    click_button 'Search'

    expect(page).to have_css('.govuk-body', text: 'There are no matching results')

    expect(page).to be_accessible.within '#main-content'
  end

  scenario 'with no date of birth specified', :vcr do
    visit '/'

    choose 'A defendant by name and date of birth'
    click_button 'Continue'
    fill_in 'search-term-field', with: 'Mickey Mouse'
    click_button 'Search'

    expect(page).not_to have_css('.govuk-body', text: 'There are no matching results')
    expect(page).to have_css('.govuk-error-summary')
    within '.govuk-error-summary' do
      expect(page).to have_content('Defendant date of birth required')
    end

    expect(page).to have_css('#search-dob-error', text: 'Defendant date of birth required')

    expect(page).to be_accessible.within '#main-content'
  end
end
