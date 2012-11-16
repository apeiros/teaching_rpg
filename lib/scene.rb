# encoding: utf-8

class Scene
  def self.run(*args)
    scene = new(*args)
    scene.run
    scene
  end

  def initialize(game)
    @game = game
    @exit = false
  end

  def run
    main until @exit
  end

  def exit
    @exit = true
  end

  def quit
    throw(:quit)
  end

  def expect_input(action_map)
    begin
      input = $stdin.getch
      input.downcase! if input
      action = action_map[input]
      beep unless action
    end until action
    __send__ action
  end

  def flush_input
    $stdin.read_nonblock(1024)
  rescue Errno::EAGAIN
  end

  def get_space
    begin
      char = $stdin.getch
    end until char == ' '
  end

  def debug(*args)
    @screen.debug(*args)
  end
  def debugi(*args)
    @screen.debugi(*args)
  end

  def beep
    $stdout.print "\a"
    $stdout.flush
  end
end
