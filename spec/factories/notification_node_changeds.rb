FactoryGirl.define do
  factory :notification_node_changed, class: Notification::NodeChanged, parent: :notification_base do
    association :topic, factory: :topic
    association :node
  end
end
