require 'test_helper'

class RecordingTest < ActiveSupport::TestCase
  setup do
    @recording = create(:recording)
    @event = @recording.event
  end

  test "should set initial state" do
    r = Recording.new
    assert r.new?
   end

  test "should not save without event" do
    r = Recording.new
    r.filename = "some.avi"
    assert_raises(ActiveRecord::RecordInvalid) { r.save! }
  end

  test "should not save without filename" do
    r = Recording.new
    r.event = @event
    assert_raises(ActiveRecord::RecordInvalid) { r.save! }
  end

  test "should save" do
    r = Recording.new
    r.event = @event
    r.filename = "some.avi"
    r.mime_type = 'video/webm'
    r.length = '10'
    r.width = 1
    r.height = 1
    r.folder = ''
    assert_nothing_raised(ActiveRecord::RecordInvalid) { r.save! }
  end

  test "should increase counter on event" do
    @event.recordings << create(:recording, state: 'downloaded', filename: 'video2.webm', event: @event)
    @event.reload
    assert_equal 2, @event.downloaded_recordings_count
    @event.recordings.last.destroy
    @event.reload
    assert_equal 1, @event.downloaded_recordings_count
  end
end
