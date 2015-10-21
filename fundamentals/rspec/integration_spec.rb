feature "Video tagging" do

  scenario 'unwatched videos are not tagged' do
    visit('/video/1')
    expect(page).to have_no_selector('.watched-tag')
  end

  scenario 'watched videos are tagged after being watched' do
    visit('/video/1')
    watch_video()

    visit('/video/1')
    expect(page).to have_selector('.watched-tag')
  end
end