# Darkmouun

## Overview

Darkmouun is the converter from a markdown text enhanced by [kramdown](https://github.com/gettalong/kramdown) to a HTML document.

Darkmouun can define: 
  * Pre-processing (to a markdown document)
  * Extracting templates by Mustache
  * Converting from markdown to HTML by kramdown
  * Post-processing (to a HTML document)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'darkmouun'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install darkmouun

## Usage

Darkmouun.document.new takes 3 arguments.

* 1st arg: Target Markdown file name
* 2nd arg: Kramdown's parser option (cf. [kramdown's usage](https://kramdown.gettalong.org/documentation.html#usage))
* 3rd arg: Kramdown's converter name(ex. if converter class name is ItlHtml, converter name is to_itl_html.)

2nd and 3rd argument has default value. 

* 2nd arg: {}
* 3rd arg: to_html

(Darkmouun instance).convert makes a HTML document from the target markdown document.

You can define pre_process and post_process as a Proc object.

```
dkmn = Darkmouun.document.new("MARKDOWN DOCUMENT", {:auto_ids => false})
dkmn.pre_process = lambda do |i|
  i.gsub!(/MARKDOWN/, "Markdown")
end
dkmn.post_process = lambda do |i|
  i.gsub!(/DOCUMENT/, "Document")
end
dkmn.convert  #=> "<p>Markdown Document</p>
```

You can write the parts that Mustache extracts with templates in your markdown document.
Template is written as Ruby script, and it is made to define as the subclass of Mustache class.

The part of template extacting in the markdown document starts '<<template_name>>'.
Parameters of the template are written below with YAML format.

```
# Template file 'template_a.rb'

class Template_A < Mustache
  Template = <<EOS
'<p>{{fig1}} + {{fig2}}' is {{calc}}.</p>
EOS

def calc
  (fig1.to_i + fig2.to_i).to_s
end
```

```
# converting code

dkmn = Darkmouun.document.new(<<BODY, {:auto_ids => false, :input => 'sekd'}, :se_html)
The calculation:

<<Template_A>>
fig1: 1
fig2: 2
BODY

dkmn.add_templates "#{__dir__}/templates/",  # 1st arg is the directory of templates.
                   'template_a.rb'           # 2nd or later args are the files of templates.

dkmn.convert    #=> <p>The Calculation:</p>
                    <p>1 + 2 is 3.</p>
```

## kramdown extensions

Darkmouun has extended to kramdown. Extensions are below;

1. **Plain Span element form.** `[[spanned phrase]]` is converted to `<span>spanned phrase</span>`.

2. **Style attribute abbreviation form.** `%attritute_name:value;` in IAL is converted to `style="attribute_name:value;"`.<br/>**ex.** `{:%color:#ffffff; %font-weight:bold;}` -> `style="color:#ffffff; font-weight:bold;"`<br/>**ATTENSION:** Every attribute must be started from "`%`" and ended with "`;`".

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Darkmouun project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/darkmouun/blob/master/CODE_OF_CONDUCT.md).
