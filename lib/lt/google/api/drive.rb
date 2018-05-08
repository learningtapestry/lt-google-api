# frozen_string_literal: true

module Lt
  module Google
    module Api
      class Drive
        FOLDER_RE = %r{/drive/(.*/)?folders/([^\/]+)/?}
        MIME_FILE   = 'application/vnd.google-apps.document'
        MIME_FOLDER = 'application/vnd.google-apps.folder'

        attr_reader :service

        class << self
          def build(credentials)
            new(credentials).service
          end

          def file_url_for(file_id)
            "https://drive.google.com/open?id=#{file_id}"
          end

          def folder_id_for(url)
            url.match(FOLDER_RE)[2]
          end
        end

        def initialize(credentials)
          @service = ::Google::Apis::DriveV3::DriveService.new
          @service.authorization = credentials
        end

        def create_folder(name, parent_id = nil)
          if parent_id.present? && (folders = fetch_folders(name, parent_id)).any?
            return folders.first.id
          end

          metadata = ::Google::Apis::DriveV3::File.new(
            name: name,
            mime_type: MIME_FOLDER,
            parents: [parent_id]
          )
          service.create_file(metadata).id
        end

        def list_file_ids_in(folder_id)
          [].tap do |result|
            page_token = nil
            loop do
              response = service.list_files(
                q: "'#{folder_id}' in parents",
                fields: 'files(id, mime_type), nextPageToken',
                page_token: page_token
              )

              response.files.each do |f|
                case f.mime_type
                when MIME_FILE then result << f.id
                when MIME_FOLDER then result.concat list_file_ids_in(f.id)
                end
              end

              page_token = response.next_page_token
              break if page_token.nil?
            end
          end.flatten
        end

        def fetch_folders(name, folder_id)
          service.list_files(
            q: "'#{folder_id}' in parents and name = '#{name}' and mimeType = '#{MIME_FOLDER}' and trashed = false",
            fields: 'files(id)'
          ).files
        end
      end
    end
  end
end
