class Shoes
  class AppWindow < Qt::Widget
    slots 'call_back_procs()'
    def initialize parent=nil
      super
      t = Qt::Timer.new
      connect(t, SIGNAL('timeout()'), self, SLOT('call_back_procs()'))
      t.start 100
    end

    def call_back_procs
      Shoes.call_back_procs $app
    end
  end
end

class Shoes
  include Types
  @apps = []

  def self.app args={}, &blk
    args[:width] ||= 600
    args[:height] ||= 500
    args[:title] ||= 'blue shoes'
    args[:left] ||= 0
    args[:top] ||= 0

    app = App.new args
    $app = app
    @apps.push app

    Flow.new app.slot_attributes(app: app, left: 0, top: 0)

    qtmain = Qt::Application.new(ARGV)
    win = AppWindow.new
    win.setWindowIcon Qt::Icon.new(File.join(DIR, "../static/blue_shoes.png"))
    win.setWindowTitle args[:title]
    win.resize args[:width], args[:height]

    app.canvas = win

    class << self; self end.class_eval do
      define_method(:width){600}
      define_method(:height){500}
    end

    app.instance_eval &blk if blk
    
    win.show
    @apps.pop
    qtmain.exec if @apps.empty?
    app
  end
end
