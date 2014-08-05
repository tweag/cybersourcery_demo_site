FactoryGirl.define do
  factory :profile do
    name 'PromptWorks Gem'
    service 'test'
    profile_id 'pwksgem'
    access_key '839d4d3b1cef3e04bd2981997714803b'
    secret_key 'a88c7ea074fb4dea97fe33b2442ed1bed132018e773a4097848039772208de3ddd39b11f74414e709263d76e82fcc9bbef51de4852a643cabd668ba981ff3b137d5b150a352c41c3bd59edcb3ccd11eed06139676d7e44e5ba60a3b44a0a2541236bc5194db4474abba15c991d9bee0a3bc767a3b87d434789cd310da6e3a19c'
    return_url 'http://tranquil-ocean-5865.herokuapp.com/responses'
    transaction_type 'sale'
  end
end
