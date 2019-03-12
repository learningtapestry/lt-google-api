# frozen_string_literal: true

module Lt
  module Google
    module Api
      class Drive
        FOLDER_RE = %r{/drive/(.*/)?folders/([^\/?]+)/?}
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

        def copy(file_ids, folder_id)
          file_ids.each do |id|
            service.get_file(id, fields: 'name') do |f, err|
              if err.present?
                Rails.logger.error "Failed to get file with #{id}, #{err.message}"
              else
                service.copy_file(id, Google::Apis::DriveV3::File.new(name: f.name, parents: [folder_id]))
              end
            end
          end
          folder_id
        end

        def copy_files(folder_id, target_id)
          new_files = list folder_id
          current_files = list target_id

          # delete old files not present on new version
          current_files.each do |file|
            next if new_files.detect { |f| f.name == file.name }

            service.delete_file(file.id)
          end

          new_files.each do |file|
            # skip if the file already exists
            next if current_files.detect { |f| f.name == file.name }

            # copy if it's a new file
            new_file = Google::Apis::DriveV3::File.new(name: file.name, parents: [target_id])
            service.copy_file(file.id, new_file)
          end
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

        def list_file_ids_in(folder_id, mime_type: MIME_FILE, with_subfolders: true)
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
                when mime_type then result << f.id
                when MIME_FOLDER
                  result.concat(list_file_ids_in f.id, mime_type: mime_type) if with_subfolders
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

        private

        def list(folder_id)
          service.list_files(
            q: "'#{folder_id}' in parents and mimeType = '#{MIME_FILE}' and trashed = false",
            fields: 'files(id, name)'
          ).files
        end
      end
    end
  end
end
