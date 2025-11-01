module Multisync::Definition::Dsl
  # The DSL methods
  def group name, &block
    Multisync::Definition::Entity.new self, name, &block
  end

  def sync name, &block
    Multisync::Definition::Entity.new self, name, &block
  end

  def template name, &block
    Multisync::Definition::Template.new name, &block
  end

  def include name
    template = Multisync::Definition::Template.lookup name
    instance_eval(&template.block)
  end

  def from value, options = {}
    @from_value = value
    # Check source's host or path before sync
    @from_check = options[:check]
    @from_description = options[:description]
  end

  def to value, options = {}
    @to_value = value
    # Check destination's host or path before sync
    @to_check = options[:check]
    @to_description = options[:description]
  end

  def options rsync_options, mode = :append
    @rsync_options_mode = mode
    @rsync_options = Array(rsync_options)
  end

  def default
    @default = true
  end

  # Defines a check, that should pass in order to invoke the sync
  def only_if cmd, options = {}
    @check = {cmd: cmd, message: options.fetch(:message, cmd)}
  end

  # Check source's host or path before sync
  # can also be set as option of "from"
  def check_from flag = true
    @from_check = flag
  end

  # Check destination's host or path before sync
  # can also be set as option of "to"
  def check_to flag = true
    @to_check = flag
  end
end
