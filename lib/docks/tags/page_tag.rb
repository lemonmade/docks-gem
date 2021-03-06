# @page
# The title of the page, that's all!
#
# Only one allowed.

register :page do
  one_per_file

  process do |content|
    Docks::Processors::JoinWithBlanks.process(content)
  end
end
