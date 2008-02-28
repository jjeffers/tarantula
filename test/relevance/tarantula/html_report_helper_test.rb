require File.join(File.dirname(__FILE__), "..", "..", "test_helper.rb")

module HtmlReportHelperSpec
  include Relevance::Tarantula
  
  # Is there an idiom for this?
  def self.included(base)
    base.before do
      @reporter = Object.new
      @reporter.extend Relevance::Tarantula::HtmlReportHelper
    end                                                                   
  end 
end

describe 'Relevance::Tarantula::HtmlReportHelper#wrap_in_line_number_table' do
  include HtmlReportHelperSpec
  it "can wrap text in a line number table" do
    html = @reporter.wrap_in_line_number_table("Line 1\nLine 2")
    html.should == "<table class=\"tablesorter\"><thead><tr><th>Line \#</th><th>Line</th></tr></thead><tr><td>1</td><td>Line 1</td></tr><tr><td>2</td><td>Line 2</td></tr></table>"
  end  
end

describe 'Relevance::Tarantula::HtmlReportHelper#wrap_stack_trace_line' do
  include HtmlReportHelperSpec
  it "can wrap stack trace line in links" do                       
    line = %{/action_controller/filters.rb:697:in `call_filters'}
    @reporter.stubs(:textmate_url).returns("ide_url")
    html = @reporter.wrap_stack_trace_line(line)
    html.should == "<a href='ide_url'>/action_controller/filters.rb:697</a>:in `call_filters'"
  end  
  
  it "converts html entities for non-stack trace lines" do
    line = %{<a href="foo">escape me</a>}
    html = @reporter.wrap_stack_trace_line(line)
    html.should == %{&lt;a href=&quot;foo&quot;&gt;escape me&lt;/a&gt;}
  end

end

describe 'Relevance::Tarantula::HtmlReportHelper IDE help' do
  include HtmlReportHelperSpec
  it "can create a textmate url" do
    @reporter.textmate_url("/etc/somewhere", 100).should ==
        "txmt://open?url=/etc/somewhere&line_no=100"
  end
end