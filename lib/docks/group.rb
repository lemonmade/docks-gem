module Docks
  class Grouper

    # Private: the process by which to create group IDs from filenames.
    # Files with the same group ID will be grouped together by ::group.
    #
    # The default ID will be the file's name, excluding extension, with any
    # variant/ state/ subcomponent notation stripped out (so, just the base
    # component name), with leading underscores stripped out and all spaces
    # and hyphens converted to a single underscore.
    #
    # Example
    #   Docks::Grouper.group_identifier('segmented-control.scss')
    #   # => :segmented_control
    #
    #   Docks::Grouper.group_identifier('_expanding_textarea.coffee')
    #   # => :expanding_textarea
    #
    #   Docks::Grouper.group_identifier('foo/bar/forms and associaed-components.html')
    #   # => :forms_and_associated_components

    @@group_identifier = lambda do |filename|
      File.basename(filename).split('.').first.split(/(\-\-|__)/).first.sub(/^_+/, '').gsub(/(\s|\-|_)+/, '_').to_sym
    end


    # Public: Groups together the files identified by the pattern (or patterns).
    # passed in. The pattern can be globs or standard filenames.
    #
    # globs - A String or Array of Strings that represent the files that are to
    # be grouped.
    #
    # Returns a Hash where the keys are the group IDs and the values are
    # Arrays of filenames that are part of that group.

    def self.group(globs)
      globs = Array(globs)
      groups = {}
      return groups if globs.empty?

      globs.each do |glob|
        next unless glob.kind_of?(String)
        filenames = Dir.glob(glob)
        next unless filenames.length > 0

        # Cycle through all files identified by the glob, then assign them to
        # the group matching their group ID.
        filenames.each do |filename|
          if should_include_file?(filename)
            identifier = group_identifier(filename)
            groups[identifier] ||= []
            groups[identifier] << filename
          end
        end
      end

      groups
    end


    # Public: Sets the method by which group IDs are created.
    #
    # group_identifier_block - A lambda or proc that will be called with a filename
    # and should return a group ID.
    #
    # Returns nothing.

    def self.group_identifier=(group_identifier_block)
      @@group_identifier = group_identifier_block
    end


    # Public: Gets the group ID for a given filename.
    #
    # filename - The filename as a String.
    #
    # Returns the result of calling `@@group_identifier` on the filename, or nil
    # if the filename is not a String. By default, this will result in a Symbol.

    def self.group_identifier(filename)
      return nil unless filename.kind_of?(String)
      @@group_identifier.call(filename)
    end



    private

    # Private: Applies the exclusion criteria to a given filename. By default,
    # this will return true for files whose extension is part of the extensions
    # that have been registered with Docks::Languages and that don't have a
    # minified filename (.min.*).
    #
    # filename - The filename as a String.
    #
    # Returns a Boolean where true indicates that the file should be included in
    # a group and false indicates that it shouldn't.

    def self.should_include_file?(filename)
      Docks::Languages.extensions.include?(File.extname(filename)[1..-1]) && !filename.include?('.min.')
    end
  end
end
