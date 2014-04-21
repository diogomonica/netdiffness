module ApplicationHelper
  def javascript(*files)
    content_for(:scans) { javascript_include_tag(*files) }
  end
end
