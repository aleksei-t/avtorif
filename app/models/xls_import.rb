class XlsImport < ActiveRecord::Base
  has_one :import_job, :as => :importable
end
