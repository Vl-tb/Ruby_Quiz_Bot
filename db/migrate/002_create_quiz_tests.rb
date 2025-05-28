class CreateQuizTests < ActiveRecord::Migration[4.2]
  def change
    create_table :quiz_tests, force: true do |t|
      t.integer :current_question, default: 0 # містить поточне запитання тесту
      t.integer :status, default: 0 # 0 - not started; 1 - in_progres; 2 - finish
      t.integer :correct_answers, default: 0 # заповнюэться в кінці для статистики
      t.integer :incorrect_answers, default: 0 # заповнюэться в кінці для статистики
      t.decimal :percent, precision: 10, scale: 2, default: 0 # заповнюэться в кінці для статистики
      t.references :user # формування зовнішнього ключа
      t.timestamps # створення полів created_at, updated_at
    end
  end
end