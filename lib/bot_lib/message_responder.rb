class MessageResponder
  attr_reader :message
  attr_reader :bot
  attr_reader :user
  attr_reader :engine_bot

  def initialize(options)
    @bot = options[:bot]
    @message = options[:message]
    @engine_bot = options[:engine_bot]
    @user = User.find_or_create_by(uid: message.from.id)
    @logger = AppConfigurator.new.get_logger
    I18n.locale = @user.locale || :en
  end

  def respond
    @logger.debug "received '#{message}' from #{message.chat.username}"
    
    if message.text == '/start'
    
      answer_with_greeting_message
    
    elsif message.text.start_with?('/lang')
    #   puts 22222222222222222222222222222222222222222222
      begin
        lang_code = message.text.split(' ')[1]
        set_locale_for_user(lang_code)
      rescue => e
        answer_with_message I18n.t('incorrect_lang_format')
      end

    elsif message.text.start_with?('/start_quiz')
    #   puts 23429493024903204902904903294023049023940023490290
      start_quiz_for_user

    elsif message.text == '/stop'
    #   puts 333333333333333333333333333333333333333333333333
      clear_user_state

    elsif message.text.start_with?('/c ')
        # puts 444444444444444444444444444444444444444444444
        begin
          question_number = message.text.split(' ')[1].to_i
          if engine_bot.user_engines[user.uid].nil?
            answer_with_message I18n.t('start')
            return
          end
        
          total_questions = engine_bot.user_engines[user.uid].question_collection.collection[I18n.locale.to_s].size
          if question_number < 0 || question_number > total_questions
            answer_with_message I18n.t('false_question_num', q_num: total_questions)
          else
            engine_bot.user_progress[user.uid][:current_index] = question_number - 1
            send_question(question_number - 1)
          end
        rescue => e
          answer_with_message I18n.t('incorrect_с_format')
        end

    elsif engine_bot.user_engines[user.uid]
        data = message.text
        uid = user.uid
      
        current_index = engine_bot.user_progress[uid][:current_index]

        correct_answer = engine_bot.user_engines[uid]
                             .get_question(current_index)[:correct_answer_letter]
        options = engine_bot.user_engines[uid].get_question(current_index)[:options]
        # puts "--------------------------------"
        # puts engine_bot.user_progress[uid][:progress][current_index]
        # puts "--------------------------------"
        is_correct = engine_bot.user_engines[uid].check(data, correct_answer, options, engine_bot.user_progress[uid][:progress][current_index])
        
        if is_correct.nil?
          answer_with_message I18n.t('press_button')
          return
        end

        engine_bot.user_progress[uid][:progress][current_index] = is_correct
      
        next_index = current_index + 1
        
        progress = engine_bot.user_progress[uid][:progress]
        unanswered = progress.select { |_, v| v.nil? }.keys
        if !unanswered.any?
          results = engine_bot.user_engines[uid].statistics.print_report
          puts engine_bot.user_progress[user.uid]
          answer_clear_buttons(I18n.t('quiz_end', res: results))
          engine_bot.user_engines.delete(uid)
          engine_bot.user_progress.delete(uid)
          return
        end

        if next_index < engine_bot.user_engines[uid].question_collection.collection[I18n.locale.to_s].size
          engine_bot.user_progress[uid][:current_index] = next_index
          send_question(next_index)
        else
          progress = engine_bot.user_progress[uid][:progress]
          unanswered = progress.select { |_, v| v.nil? }.keys
          
          if unanswered.any?
            answer_with_message(
              I18n.t('unanswered_questions', numbers: unanswered.map { |key| key + 1 }.join(', '))
            )
          else
            results = engine_bot.user_engines[uid].statistics.print_report
            answer_clear_buttons(I18n.t('quiz_end', res: results))
            engine_bot.user_engines.delete(uid)
            engine_bot.user_progress.delete(uid)
          end
        end
    else
    #   puts 555555555555555555555555555555555555
      answer_with_message I18n.t('unknown_command')
    end
    if !engine_bot.user_progress[user.uid].nil?
      puts engine_bot.user_progress[user.uid]
    end
  end


  private


  def set_locale_for_user(locale_code)
    supported = %w[ua en]
    if supported.include?(locale_code)
      @user.update(locale: locale_code.to_sym)
      I18n.locale = locale_code.to_sym
      answer_with_message I18n.t('lang_change', code: locale_code)
    else
      answer_with_message I18n.t('incorrect_lang', e_code: locale_code)
    end
  end

  def start_quiz_for_user
    engine_bot.user_engines[user.uid] = QuizProtsenkoVakariuk::Engine.new(user.uid)
    total_questions = engine_bot.user_engines[user.uid].question_collection.collection[I18n.locale.to_s].size
    engine_bot.user_progress[user.uid] = {
        progress: (0...total_questions).to_h { |i| [i, nil] },
        current_index: 0
      }
    send_question(0)
  end

  def clear_user_state
    engine_bot.user_engines.delete(user.uid)
    engine_bot.user_progress.delete(user.uid)
    stop_with_farewell_message
  end

  def answer_with_greeting_message
    answer_with_message I18n.t('greeting_message')
  end

  def answer_with_farewell_message
    answer_with_message I18n.t('farewell_message')
  end

  def stop_with_farewell_message
    answer_clear_buttons I18n.t('farewell_message')
  end

  def answer_with_message(text)
    MessageSender.new(bot: bot, chat: message.chat, text: text).send
  end

  def answer_clear_buttons(text)
    MessageSender.new(bot: bot, chat: message.chat, text: text, clear: true).send
  end

  def send_question(index)
    engine = engine_bot.user_engines[user.uid]
    progress = engine_bot.user_progress[user.uid]
    
    question = engine.get_question(index)
    puts "--------------"
    puts question
    puts "--------------"
    text = "#{I18n.t('question')} #{index + 1}: #{question[:text]}"
    answers = question[:options]
    
    MessageSender.new(bot: bot, chat: message.chat, text: text, answers: answers).send
  end
end