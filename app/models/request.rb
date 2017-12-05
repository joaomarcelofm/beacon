class Request < ApplicationRecord
  belongs_to :user
  belongs_to :receiver, class_name: "User"
  has_one :meeting
  serialize :matches

  after_create :send_slack_request
  after_initialize :init
  after_update :create_meeting, if: :accepted?

  enum status: [ :pending, :accepted, :rejected ]


  def set_reciever
    User.find()
  end

  def init
    self.status = 0
  end

  def create_meeting
    Meeting.create(room_name: 'demo', request: self)
  end

  def send_slack_request
    client = Slack::Web::Client.new
    message = {
      text: "Hello #{receiver.name} :wave: :speech_balloon:!",
      channel: receiver.uid,
      attachments: [
        {
          title: "Chat Request from #{user.name}",
          text: "Because 'TODO' is a skill of yours, they would like to discuss '#{topic}' with you.  \nThey have requested to meet at #{start_time.strftime("%a, %d %b")}.",
          color: "#38B684",
          callback_id: "request",
          attachment_type: "default",
          actions: [
            {
                "name": "accept",
                "text": "Accept",
                "style": "primary",
                "type": "button",
                "value": "#{id}"
            },
            {
                "name": "reject",
                "text": "Reject",
                "style": "danger",
                "type": "button",
                "value": "#{id}"
            }
          ]

        }
      ]
    }
    client.chat_postMessage message
  end
end

