Pod::Spec.new do |s|
  s.name         = "CodableSaveLoad"
  s.version      = "1.3"
  s.summary      = "💾 Sample save&load for Codable"
  s.description  = <<-DESC
This micro-framework helps loading & saving Codable data to JSON files.
  DESC
  
  s.homepage     = "https://github.com/MaciejGad/CodableSaveLoad"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author             = { "Maciej Gad" => "https://github.com/MaciejGad" }
  s.social_media_url   = "https://twitter.com/maciej_gad"
  s.platform     = :ios, "10.0"
  s.source       = { :git => "https://github.com/MaciejGad/CodableSaveLoad.git", :tag => 'v1.3' }
  s.source_files  =  "Sources/CodableSaveLoad/*.swift"
  s.swift_version = "4.2"
  s.dependency  "PromiseKit", "~> 6.0"
end