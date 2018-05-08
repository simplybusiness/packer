# frozen_string_literal: true

module Packer
  module Helper
    def asset_pack_path(name, **_options)
      Packer.manifest.lookup!(name)
    end

    # TODO: Later
    # alias image_path asset_pack_path

    def javascript_pack_tag(*names, **_options)
      tags = sources_from_pack_manifest(names).map do |name|
        "<script src=\"#{name}\"></script>"
      end.join("\n")
      
      tags.respond_to?(:html_safe) ? tags.html_safe : tags
    end

    def stylesheet_pack_tag(*names, **_options)
      tags = sources_from_pack_manifest(names).map do |name|
        "<link rel=\"stylesheet\" href=\"#{name}\">"
      end.join("\n")
      
      tags.respond_to?(:html_safe) ? tags.html_safe : tags
    end

    private

    def sources_from_pack_manifest(names)
      names.map { |name| Packer.manifest.lookup!(name) }
    end
  end
end
