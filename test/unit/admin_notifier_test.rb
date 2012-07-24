require 'test_helper'

class AdminNotifierTest < ActionMailer::TestCase
  tests AdminNotifier
  def test_new_ticket
    @expected.subject = 'AdminNotifier#new_ticket'
    @expected.body    = read_fixture('new_ticket')
    @expected.date    = Time.now

    assert_equal @expected.encoded, AdminNotifier.create_new_ticket(@expected.date).encoded
  end

end
