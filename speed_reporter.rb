class SpeedReporter
  def initialize(
    reporting_frequency_in_seconds: 60,
    total_items_to_process: nil
  )
    @reporting_frequency_in_seconds = reporting_frequency_in_seconds
    @total_items_to_process = total_items_to_process
    @items_process = 0
    @start_time = Time.now.utc
    @last_report_time = @start_time
  end

  def track_item_processed_and_report_at_reporting_frequency
    @items_process += 1

    return iterations_per_second unless time_to_report_progres?

    report_on_run_speed
    iterations_per_second
  end

  def report_on_run_speed
    if @total_items_to_process.nil?
      iterations_per_hour = iterations_per_second * 3600
      puts "#{iterations_per_hour} iterations / hour"
    else
      humanized_time = humanize(total_time_to_complete_processing_in_seconds)
      puts "Expected total processing time: #{humanized_time}"
      humanized_time = humanize(remaining_time_until_completion_in_seconds)
      puts "Expected processing time remaining: #{humanized_time}"
    end

    @last_report_time = Time.now.utc
  end

  def time_to_report_progres?
    time_since_last_report_in_seconds >= @reporting_frequency_in_seconds
  end

  def iterations_per_second
    (@items_process / total_time_elapsed_in_seconds)
  end

  def total_time_to_complete_processing_in_seconds
    @total_items_to_process / iterations_per_second
  end

  def remaining_time_until_completion_in_seconds
    @start_time + total_time_to_complete_processing_in_seconds - Time.now.utc
  end

  def time_since_last_report_in_seconds
    Time.now.utc - @last_report_time
  end

  def total_time_elapsed_in_seconds
    Time.now.utc - @start_time
  end

  ##
  # Thanks to https://stackoverflow.com/a/4136485
  def humanize(secs)
    [[60, :seconds], [60, :minutes], [24, :hours], [Float::INFINITY, :days]].map{ |count, name|
      if secs > 0
        secs, n = secs.divmod(count)

        "#{n.to_i} #{name}" unless n.to_i==0
      end
    }.compact.reverse.join(' ')
  end
end

if __FILE__ == $0
  total_items_to_process = 1000
  speed_tester = SpeedReporter.new(
    reporting_frequency_in_seconds: 1,
    total_items_to_process: total_items_to_process
  )
  total_items_to_process.times do |i|
    puts i
    sleep 0.1
    speed_tester.track_item_processed_and_report_at_reporting_frequency
  end
end
