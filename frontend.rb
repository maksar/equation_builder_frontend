require 'sinatra'
require 'haml'
require 'equation_builder'

def get_or_post(path, opts={}, &block)
  get(path, opts, &block)
  post(path, opts, &block)
end

get_or_post '/' do
  @numbers = (params[:numbers] || '').split(' ')
  @operators = (params[:operators] || '').split(' ')
  @result = (params[:result] || '').to_i

  @equation = EquationBuilder.new(@numbers, @result, @operators).solve

  haml :index
end

__END__

@@ layout
%html
  = yield

@@ index

.result
  = @equation
%br/

%form{:action => '/', :method => 'POST'}
  %label{:for => 'numbers'}
    Numbers
  %input{:type => 'text', :name => 'numbers', :value => @numbers.join(' ') }
  %br/

  %label{:for => 'operators'}
    Operators
  %input{:type => 'text', :name => 'operators', :value => @operators.join(' ') }
  %br/

  %label{:for => 'result'}
    Result
  %input{:type => 'text', :name => 'result', :value => @result }
  %br/

  %input{:type => 'submit', :value => 'Solve'}
