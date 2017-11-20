task :deploy do
  # Fresh build
  sh "bundle exec jekyll build"

  # Remove extension from all HTML files (s3_website still detects content-type text/html)
  Dir.glob('_site/**/*.html').each do |f|
    comp = File.basename f
    if comp != "index.html" then
      FileUtils.mv f, "#{File.dirname(f)}/#{File.basename(f,'.*')}"
    end
  end

  # Deploy files to S3
  sh "/usr/gem/bin/s3_website push"
end
