puts "データベースをクリーンアップ中..."
User.destroy_all

puts "ユーザーを作成中..."

user = User.create!(
  username: "test_user",
  email: "test@example.com",
)

sessions = 3.times.map do |i|
  user.sessions.create!(session_title: "セッション#{i}")
end

sessions.each do |s|
  3.times do |i|
    s.messages.create!(role: :user, body: "ユーザーメッセージ#{i + 1}")
    s.messages.create!(role: :ai, body: "AIのメッセージ#{i + 1}")
  end
end

puts "seeds作成完了"
