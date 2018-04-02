# frozen_string_literal: true

module Packer
  module Helper
    def asset_pack_path(name, **_options)
      Packer.manifest.lookup!(name)
    end

    # TODO: Later
    # alias image_path asset_pack_path

    def javascript_pack_tag(*names, **_options)
      sources_from_pack_manifest(names).map do |name|
        "<script src=\"#{name}\"></script>"
      end.join("\n")
    end

    def stylesheet_pack_tag(*names, **_options)
      sources_from_pack_manifest(names).map do |name|
        "<link rel=\"stylesheet\" href=\"#{name}\">"
      end.join("\n")
    end

    private

    def sources_from_pack_manifest(names)
      names.map { |name| Packer.manifest.lookup!(name) }
    end
  end
end
