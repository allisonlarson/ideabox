class ImageUploader < CarrierWave::Uploader::Base
  storage :file

  def store_dir
    'lib/app/public/uploads'
  end
end
